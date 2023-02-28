import 'package:intl/intl.dart';

//class of the alcol item
class AlcolItem {
  dynamic id;
  String itemName;
  DateTime createdAt;
  double? latitude;
  double? longitude;
  AlcolItem(
      {this.id,
      required this.itemName,
      required this.createdAt,
      required this.latitude,
      required this.longitude});

  static List<AlcolItem> convertToAlcolItemList(
      List<Map<String, dynamic>> maps) {
    List<AlcolItem> alcolItems = [];
    for (Map<String, dynamic> map in maps) {
      AlcolItem alcolItem = AlcolItem(
          id: map["id"],
          itemName: map["data"],
          createdAt: StringToDate(map["createdAt"]),
          latitude: map["latitude"],
          longitude: map["longitude"]);
      alcolItems.add(alcolItem);
    }
    return alcolItems;
  }

  static DateTime StringToDate(String dateString) {
    DateTime date = DateFormat("yyyy-MM-dd hh:mm:ss").parse(dateString);
    return date;
  }
}
