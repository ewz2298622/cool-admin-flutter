//实现一个数据库管理器
import 'aldult_database_helper.dart';
import 'search_history_database_helper.dart';
import 'token_database_helper.dart';
import 'user_database_helper.dart';
import 'video_player_settings_database_helper.dart';

class Helper {
  static final searchHistory = SearchHistoryDatabaseHelper();
  static final tokenDatabaseHelper = TokenDatabaseHelper();
  static final userDatabaseHelper = UserDatabaseHelper();
  static final aldultDatabaseHelper = AldultDatabaseHelper();
  static final videoPlayerSettings = VideoPlayerSettingsDatabaseHelper();

  static void deleteAll() async {
    searchHistory.deleteAll();
    tokenDatabaseHelper.deleteAll();
    userDatabaseHelper.deleteAll();
    aldultDatabaseHelper.deleteAll();
    videoPlayerSettings.deleteAll();
  }
}
