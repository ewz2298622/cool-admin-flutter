import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';

import '../entity/searchEntity.dart';
import 'baseDao.dart';

class SearchDao extends BaseDao<SearchHistoryEntity> {
  late Box<SearchHistoryEntity> searchHistoryEntity;

  @override
  Future<void> open() async {
    debugPrint('Opening search history box...');
    try {
      searchHistoryEntity = await Hive.openBox<SearchHistoryEntity>('SearchHistoryEntity');
    } catch (e) {
      debugPrint('Failed to open search history box: $e');
      throw Exception('Failed to open search history box: $e');
    }
  }

  @override
  Future<int> count() async {
    return searchHistoryEntity.length;
  }

  @override
  Future<int> deleteAll() async {
    await searchHistoryEntity.clear();
    return searchHistoryEntity.length;
  }

  @override
  Future<int> deleteAt(dynamic object) async {
    if (object == null) {
      throw ArgumentError('The object parameter cannot be null.');
    }

    if (object is! SearchHistoryEntity) {
      throw ArgumentError(
        'The object parameter must be of type SearchHistoryEntity.',
      );
    }

    final key = searchHistoryEntity.keyAt(
      searchHistoryEntity.values.toList().indexOf(object),
    );
    await searchHistoryEntity.delete(key);
    return searchHistoryEntity.length;
  }

  @override
  Future<int> insert(SearchHistoryEntity object) async {
    try {
      return await searchHistoryEntity.add(object);
    } catch (e) {
      throw Exception('Failed to insert search history: $e');
    }
  }

  @override
  Future<List<SearchHistoryEntity>> queryAll() async {
    return searchHistoryEntity.values.toList();
  }

  @override
  Future<SearchHistoryEntity?> queryById(int id) async {
    return searchHistoryEntity.get(id);
  }

  @override
  Future<List<SearchHistoryEntity>> queryByPage(int page, int pageSize) async {
    final start = (page - 1) * pageSize;
    final end = start + pageSize;
    return searchHistoryEntity.values.toList().sublist(
      start,
      end > searchHistoryEntity.length ? searchHistoryEntity.length : end,
    );
  }

  @override
  Future<int> update(dynamic object) async {
    if (object == null) {
      throw ArgumentError('The object parameter cannot be null.');
    }

    if (object is! SearchHistoryEntity) {
      throw ArgumentError(
        'The object parameter must be of type SearchHistoryEntity.',
      );
    }

    final key = searchHistoryEntity.keyAt(
      searchHistoryEntity.values.toList().indexOf(object),
    );
    await searchHistoryEntity.put(key, object);
    return key;
  }
}
