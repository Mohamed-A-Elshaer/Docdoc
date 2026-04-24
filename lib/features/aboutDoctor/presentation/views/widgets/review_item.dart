import 'package:docdoc/core/utils/app_text_styles.dart';
import 'package:docdoc/core/utils/assets.dart';
import 'package:docdoc/core/utils/backend_endpoint.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ReviewItem extends StatelessWidget{
  const ReviewItem({super.key, required this.doctorId});
  final int doctorId;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _loadReviews(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Failed to load reviews',
              style: TextStyles.regular12.copyWith(color: const Color(0xff757575)),
            ),
          );
        }
        final reviews = snapshot.data ?? [];
        if (reviews.isEmpty) {
          return Center(
            child: Text(
              'No reviews yet',
              style: TextStyles.regular12.copyWith(color: const Color(0xff757575)),
            ),
          );
        }
        return ListView.builder(
          itemCount: reviews.length,
          itemBuilder: (BuildContext context, int index) {
            final review = reviews[index];
            final rating = review['rating'];
            final ratingValue = rating is int ? rating : int.tryParse(rating.toString()) ?? 0;
            final stars = ratingValue.clamp(0, 5);
            return Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: AssetImage(Assets.imagesDefaultAvatar),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                review['reviewer_name'] as String? ?? 'Patient',
                                style: TextStyles.semiBold16.copyWith(color: const Color(0xff242424)),
                              ),
                              Text(
                                _formatReviewDate(review['created_at']),
                                style: TextStyles.regular12.copyWith(color: const Color(0xff9E9E9E)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: List.generate(
                              5,
                              (i) => Icon(
                                Icons.star,
                                color: i < stars ? const Color(0xffFFD600) : const Color(0xffE0E0E0),
                                size: 20,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            (review['review']?.toString().trim().isNotEmpty ?? false)
                                ? review['review'].toString()
                                : 'No review available for this rating',
                            style: TextStyles.regular12.copyWith(color: const Color(0xff757575)),
                          )
                        ],
                      ),
                    )
                  ],
                ),
                if (index < reviews.length - 1) const SizedBox(height: 16),
              ],
            );
          },
        );
      },
    );
  }

  String _formatReviewDate(dynamic createdAtRaw) {
    if (createdAtRaw == null) return '';
    final raw = createdAtRaw.toString().trim();
    if (raw.isEmpty) return '';

    final parsed = DateTime.tryParse(raw) ??
        DateTime.tryParse(raw.contains('T') ? raw : raw.replaceFirst(' ', 'T'));
    if (parsed == null) return raw;

    final createdAt = parsed.toLocal();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final reviewDay = DateTime(createdAt.year, createdAt.month, createdAt.day);
    final dayDiff = today.difference(reviewDay).inDays;

    if (dayDiff == 0) return 'Today';
    if (dayDiff == 1) return 'Yesterday';
    return DateFormat('dd MMM yyyy').format(createdAt);
  }

  Future<List<Map<String, dynamic>>> _loadReviews() async {
    final response = await Supabase.instance.client
        .from('ratings')
        .select('rating, review, user_uid, created_at')
        .eq('api_doctor_id', doctorId)
        .not('user_uid', 'is', null)
        .order('created_at', ascending: false);
    final reviews = (response as List)
        .map((e) => Map<String, dynamic>.from(e as Map))
        .toList();

    final uids = reviews
        .map((r) => r['user_uid']?.toString())
        .whereType<String>()
        .toSet()
        .toList();
    if (uids.isEmpty) return reviews;

    final usersResponse = await Supabase.instance.client
        .from(BackendEndpoint.addUserData)
        .select('uid, name')
        .inFilter('uid', uids);

    final nameByUid = <String, String>{};
    for (final row in usersResponse as List) {
      final m = Map<String, dynamic>.from(row as Map);
      final uid = m['uid']?.toString();
      final rawName = m['name'];
      if (uid == null || uid.isEmpty) continue;
      if (rawName is String && rawName.trim().isNotEmpty) {
        nameByUid[uid] = rawName.trim();
      }
    }

    return reviews.map((r) {
      final uid = r['user_uid']?.toString();
      final merged = Map<String, dynamic>.from(r);
      merged['reviewer_name'] =
          (uid != null && nameByUid.containsKey(uid)) ? nameByUid[uid]! : 'Patient';
      return merged;
    }).toList();
  }

}