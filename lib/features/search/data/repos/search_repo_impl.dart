import 'dart:convert';

import 'package:docdoc/core/services/shared_preferences_singelton.dart';
import 'package:docdoc/features/search/domain/entities/search_entry_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SearchRepoImpl {
  static const String _recentSearchesKeyPrefix = 'recent_searches_v1';

  String get _recentSearchesKey {
    final uid = Supabase.instance.client.auth.currentUser?.id;
    if (uid == null || uid.trim().isEmpty) {
      return '${_recentSearchesKeyPrefix}_guest';
    }
    return '${_recentSearchesKeyPrefix}_$uid';
  }

  Future<List<SearchEntryEntity>> getRecentSearches() async {
    final raw = Prefs.getString(_recentSearchesKey);
    if (raw == null || raw.trim().isEmpty) return [];

    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List) return [];
      return decoded
          .whereType<Map>()
          .map((item) => SearchEntryEntity.fromJson(
                Map<String, dynamic>.from(item as Map),
              ))
          .toList()
        ..sort((a, b) => b.searchedAt.compareTo(a.searchedAt));
    } catch (_) {
      return [];
    }
  }

  Future<void> saveSearchQuery(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return;

    final current = await getRecentSearches();

    // No duplicates: remove existing query then re-add on top.
    current.removeWhere(
      (entry) => entry.query.toLowerCase() == trimmed.toLowerCase(),
    );
    current.insert(
      0,
      SearchEntryEntity(query: trimmed, searchedAt: DateTime.now()),
    );

    // Max 4 items.
    if (current.length > 4) {
      current.removeRange(4, current.length);
    }

    await _persist(current);
  }

  Future<void> removeSearchQuery(String query) async {
    final current = await getRecentSearches();
    current.removeWhere(
      (entry) => entry.query.toLowerCase() == query.trim().toLowerCase(),
    );
    await _persist(current);
  }

  Future<void> clearAll() async {
    await Prefs.remove(_recentSearchesKey);
  }

  Future<void> _persist(List<SearchEntryEntity> entries) async {
    final encoded = jsonEncode(entries.map((e) => e.toJson()).toList());
    await Prefs.setString(_recentSearchesKey, encoded);
  }
}
