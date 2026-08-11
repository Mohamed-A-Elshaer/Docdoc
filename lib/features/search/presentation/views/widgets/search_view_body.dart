import 'package:docdoc/core/utils/app_colors.dart';
import 'package:docdoc/core/utils/app_text_styles.dart';
import 'package:docdoc/core/widgets/custom_app_bar.dart';
import 'package:docdoc/core/widgets/custom_tab_button.dart';
import 'package:docdoc/features/doctor_discovery/domain/entities/doctor_filter_entity.dart';
import 'package:docdoc/features/doctor_discovery/presentation/widgets/doctor_filter_button.dart';
import 'package:docdoc/features/doctor_discovery/presentation/widgets/doctor_search_bar.dart';
import 'package:docdoc/features/doctor_discovery/presentation/widgets/doctors_sliver_list.dart';
import 'package:docdoc/features/search/data/repos/search_repo_impl.dart';
import 'package:docdoc/features/search/domain/entities/search_entry_entity.dart';
import 'package:docdoc/features/search/presentation/views/search_view.dart';
import 'package:docdoc/features/speciality/presentation/views/widgets/doctor_speciality_view_body.dart';
import 'package:flutter/material.dart';

import '../../../../doctor_discovery/data/models/doctor_discovery_query.dart';

class SearchViewBody extends StatefulWidget {
  const SearchViewBody({
    super.key,
    this.initialQuery,
    this.showBackButton = true,
    this.useInTabShell = false,
  });

  final String? initialQuery;
  final bool showBackButton;
  final bool useInTabShell;

  @override
  State<SearchViewBody> createState() => _SearchViewBodyState();
}

class _SearchViewBodyState extends State<SearchViewBody> {
  final TextEditingController searchController = TextEditingController();
  final SearchRepoImpl searchRepo = SearchRepoImpl();

  DoctorDiscoveryQuery query = const DoctorDiscoveryQuery();
  List<SearchEntryEntity> recentSearches = [];
  bool isLoadingRecentSearches = true;
  bool isResultsScreen = false;
  int foundDoctorsCount = 0;
  int selectedSpecialityIndex = -1;

  @override
  void initState() {
    super.initState();
    _initScreenState();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> _initScreenState() async {
    final initialQuery = widget.initialQuery?.trim() ?? '';
    if (initialQuery.isNotEmpty) {
      isResultsScreen = true;
      query = query.copyWith(searchQuery: initialQuery);
      searchController.text = initialQuery;
    }
    await _loadRecentSearches();
  }

  Future<void> _loadRecentSearches() async {
    final entries = await searchRepo.getRecentSearches();
    if (!mounted) return;
    setState(() {
      recentSearches = entries;
      isLoadingRecentSearches = false;
    });
  }

  Future<void> _onSearchSubmitted(String value) async {
    final submittedQuery = value.trim();
    if (submittedQuery.isEmpty) return;

    await searchRepo.saveSearchQuery(submittedQuery);
    if (!mounted) return;

    if (isResultsScreen || widget.useInTabShell) {
      setState(() {
        isResultsScreen = true;
        query = query.copyWith(searchQuery: submittedQuery);
      });
      await _loadRecentSearches();
      return;
    }

    Navigator.pushNamed(
      context,
      SearchView.routeName,
      arguments: submittedQuery,
    );
  }

  Future<void> _clearAllHistory() async {
    await searchRepo.clearAll();
    if (!mounted) return;
    setState(() {
      recentSearches = [];
    });
  }

  Future<void> _removeRecentQuery(String queryText) async {
    await searchRepo.removeSearchQuery(queryText);
    if (!mounted) return;
    setState(() {
      recentSearches.removeWhere(
        (entry) => entry.query.toLowerCase() == queryText.toLowerCase(),
      );
    });
  }

  Widget _buildSearchAndFilterRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
      child: Row(
        children: [
          Expanded(
            child: DoctorSearchBar(
              controller: searchController,
              onChanged: (value) {
                setState(() {
                  query = query.copyWith(searchQuery: value);
                });
              },
              onSubmitted: _onSearchSubmitted,
            ),
          ),
          const SizedBox(width: 12),
          DoctorFilterButton(
            onDone: (speciality, rating) {
              setState(() {
                // Apply filters and immediately show search results.
                isResultsScreen = true;
                selectedSpecialityIndex = -1;
                query = query.copyWith(
                  filter: DoctorFilterEntity(
                    selectedSpeciality: speciality,
                    selectedRating: rating,
                  ),
                );
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRecentSearchHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Recent Search',
            style:
                TextStyles.semiBold18.copyWith(color: const Color(0xff242424)),
          ),
          TextButton(
            onPressed: recentSearches.isEmpty ? null : _clearAllHistory,
            child: Text(
              'Clear All History',
              style:
                  TextStyles.regular12.copyWith(color: AppColors.primaryColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentSearchItem(SearchEntryEntity entry) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          const Icon(Icons.access_time, color: Color(0xff9E9E9E), size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: GestureDetector(
              onTap: () => _onSearchSubmitted(entry.query),
              child: Text(
                entry.query,
                style: TextStyles.regular14
                    .copyWith(color: const Color(0xff9E9E9E)),
              ),
            ),
          ),
          IconButton(
            onPressed: () => _removeRecentQuery(entry.query),
            icon: const Icon(Icons.close, color: Color(0xff9E9E9E), size: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecialityTabs() {
    final specialities = DoctorSpecialityViewBody.specialities;
    return SizedBox(
      height: 51,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: specialities.length,
        itemBuilder: (context, index) {
          final speciality = specialities[index]['speciality'] as String;
          return Padding(
            padding: EdgeInsets.only(
                right: index < specialities.length - 1 ? 12 : 0),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  selectedSpecialityIndex = index;
                  query = query.copyWith(
                    filter: DoctorFilterEntity(
                      selectedSpeciality: speciality,
                      selectedRating: query.filter.selectedRating,
                    ),
                  );
                });
              },
              child: CustomTabButton(
                containerHeight: 51,
                containerWidth: 145,
                buttonRadius: 34,
                isActive: selectedSpecialityIndex == index,
                isRatingTab: false,
                tabTitle: speciality,
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        onTap: widget.showBackButton ? () => Navigator.of(context).pop() : null,
        showLeading: widget.showBackButton,
        title: 'Search',
        leftPadding: widget.showBackButton ? 78 : 144,
      ),
      body:
          isResultsScreen ? _buildResultsScreen() : _buildRecentSearchScreen(),
    );
  }

  Widget _buildRecentSearchScreen() {
    return Column(
      children: [
        _buildSearchAndFilterRow(),
        const SizedBox(height: 12),
        _buildRecentSearchHeader(),
        const SizedBox(height: 12),
        if (isLoadingRecentSearches)
          const Expanded(child: Center(child: CircularProgressIndicator()))
        else if (recentSearches.isEmpty)
          Expanded(
            child: Center(
              child: Text(
                'No recent search available',
                style: TextStyles.regular14
                    .copyWith(color: const Color(0xff9E9E9E)),
              ),
            ),
          )
        else
          Expanded(
            child: ListView.separated(
              itemCount: recentSearches.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) =>
                  _buildRecentSearchItem(recentSearches[index]),
            ),
          ),
      ],
    );
  }

  Widget _buildResultsScreen() {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: _buildSearchAndFilterRow()),
        SliverToBoxAdapter(child: _buildSpecialityTabs()),
        const SliverToBoxAdapter(child: SizedBox(height: 20)),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '$foundDoctorsCount founds',
                style: TextStyles.semiBold18
                    .copyWith(color: const Color(0xff151515)),
              ),
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 16)),
        DoctorsSliverList(
          isRecommendedView: true,
          query: query,
          onFilteredCountChanged: (count) {
            if (foundDoctorsCount == count || !mounted) return;
            setState(() {
              foundDoctorsCount = count;
            });
          },
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 24)),
      ],
    );
  }
}
