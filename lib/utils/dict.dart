//实现一个工具类传入 id 匹配并返回 对应的字典

class Dict {
  static String getDictName(int id, List<dynamic> list) {
    for (var item in list) {
      if (item.id == id) {
        return item.name!;
      }
    }
    return '';
  }
}
