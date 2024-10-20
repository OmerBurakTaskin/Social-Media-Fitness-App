import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';

const BODYSTATSKEY = "body-stats";

enum BodyComposition { MUSCLE, WATER, FAT }

class BodyStatsDbService {
  static Future<void> openUserStatBox() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    await Hive.openBox(userId);
  }

  Future<Map<DateTime, double>?> getWeightData() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final box = await Hive.openBox(userId);
    try {
      final bodyStatsMap = box.get(BODYSTATSKEY) as Map?;
      if (bodyStatsMap != null && bodyStatsMap.containsKey("weight-data")) {
        return Map<DateTime, double>.from(bodyStatsMap["weight-data"]);
      }
      return null;
    } catch (e) {
      print("ERROR!: COULDNT GET WEIGHT DATA");
      return null;
    }
  }

  Future<void> addOrSetWeightData(DateTime recordDate, double weight) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final box = await Hive.openBox(userId);
    final weightData = await getWeightData() ?? {};
    weightData[recordDate] = weight;

    final bodyStatsMap = box.get(BODYSTATSKEY) as Map? ?? {};
    bodyStatsMap["weight-data"] = weightData;
    await box.put(BODYSTATSKEY, bodyStatsMap);
  }

  Future<void> addBodyCompositionData(
      BodyComposition type, double value) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final box = await Hive.openBox(userId);
    final bodyStatsMap = box.get(BODYSTATSKEY) as Map? ?? {};
    bodyStatsMap[type.toString()] = value;
    await box.put(BODYSTATSKEY, bodyStatsMap);
  }

  Future<double?> getBodyCompositionData(BodyComposition type) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final box = await Hive.openBox(userId);
    final bodyStatsMap = box.get(BODYSTATSKEY) as Map?;
    if (bodyStatsMap != null && bodyStatsMap.containsKey(type.toString())) {
      return bodyStatsMap[type.toString()] as double?;
    }
    return null;
  }
}
