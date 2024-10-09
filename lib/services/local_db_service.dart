import 'package:hive/hive.dart';

class LocalDbService {
  static void addBoxWithSpecificKey<T>(
      String boxName, String objectKey, T item) async {
    if (Hive.isBoxOpen(boxName)) {
      Box box = Hive.box(boxName);
      await box.put(objectKey, item);
      print("BODY ASSETS ARE SET: " + item.toString());
    } else {
      Box box = await Hive.openBox(boxName);
      await box.put(objectKey, item);
      print("BODY ASSETS ARE SET: " + item.toString());
    }
  }

  static void addToBoxWithAutoIncrementKey<T>(String boxName, T item) async {
    await Hive.box(boxName).add(item);
  }

  static Object? getItem(String boxName, dynamic itemKey) {
    return Hive.box(boxName).get(itemKey);
  }

  static void deleteItem(String boxName, dynamic itemKey) async {
    await Hive.box(boxName).delete(itemKey);
  }

  static void deleteAllItems(String boxName) async {
    await Hive.box(boxName).clear();
  }

  
}
