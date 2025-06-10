class VideoUtil {
  //tag格式化
  static String formatTag(String tag) {
    //如果传进来的格式满足 2018-04-07(韩国) 将日期提取出来
    String date = tag;
    String text = '高清';
    try {
      if (tag.contains("-")) {
        if (tag.contains("(")) {
          date = tag.substring(0, tag.indexOf("("));
        }
        //判断date 举例当前时间差多少天
        if (date.isNotEmpty) {
          DateTime now = DateTime.now();
          DateTime dateTime = DateTime.parse(date);
          int days = now.difference(dateTime).inDays;
          if (days < 30) {
            text = '最新';
          }
        }
      }
    } catch (e) {
      return text;
    }
    return text;
  }
}
