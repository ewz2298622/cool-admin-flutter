//实现一个数据库管理器
import 'SearchHistoryDatabaseHelper.dart';
import 'TokenDatabaseHelper.dart';
import 'UserDatabaseHelper.dart';

class Helper {
  static final searchHistory = SearchHistoryDatabaseHelper();
  static final TokenDatabaseHelper tokenDatabaseHelper = TokenDatabaseHelper();
  static final UserDatabaseHelper userDatabaseHelper = UserDatabaseHelper();
  //删除所有
  static void deleteAll() async {
    searchHistory.deleteAll();
    tokenDatabaseHelper.deleteAll();
    userDatabaseHelper.deleteAll();
  }
}
