class SearchEntryEntity {
  const SearchEntryEntity({
    required this.query,
    required this.searchedAt,
  });

  final String query;
  final DateTime searchedAt;

  factory SearchEntryEntity.fromJson(Map<String, dynamic> json) {
    final rawDate = json['searchedAt']?.toString();
    return SearchEntryEntity(
      query: json['query']?.toString() ?? '',
      searchedAt: DateTime.tryParse(rawDate ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'query': query,
      'searchedAt': searchedAt.toIso8601String(),
    };
  }
}
