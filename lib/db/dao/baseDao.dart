abstract class BaseDao<T> {
  Future<void> open();

  Future<int> insert(T object);

  Future<int> deleteAt(T object);

  Future<int> update(dynamic object);

  Future<List<dynamic>> queryAll();

  Future<dynamic> queryById(int id);

  Future<int> deleteAll();

  Future<int> count();

  Future<List<dynamic>> queryByPage(int page, int pageSize);
}
