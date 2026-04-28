import 'package:docdoc/features/search/presentation/views/widgets/search_view_body.dart';
import 'package:flutter/material.dart';

class SearchView extends StatelessWidget {
  static const String routeName = 'search';

  const SearchView({super.key, this.initialQuery});

  final String? initialQuery;

  @override
  Widget build(BuildContext context) {
    return SearchViewBody(initialQuery: initialQuery);
  }
}
