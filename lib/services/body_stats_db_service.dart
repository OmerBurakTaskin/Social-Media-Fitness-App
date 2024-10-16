import 'package:hive/hive.dart';

const BODYSTATSBOX = "body-stats";

enum BodyComposition { MUSCLE, WATER, FAT }

class BodyStatsDbService {
  Future<Map<DateTime, double>?> getWeightData() async {
    final box = await Hive.openBox(BODYSTATSBOX);
    try {
      return Map<DateTime, double>.from(await box.get("weight-data"));
    } catch (e) {
      print("ERROR!: COULDNT GET WEIGHT DATA");
      return null;
    }
  }

  Future<void> addOrSetWeightData(DateTime recordDate, double weight) async {
    final box = await Hive.openBox(BODYSTATSBOX);
    final weightData = await getWeightData();
    if (weightData == null) {
      await box.put("weight-data", {recordDate, weight});
    } else {
      weightData[recordDate] = weight;
      await box.put("weight-data", weightData);
    }
  }

  Future<Map<BodyComposition, Map<DateTime, double>>?>
      getBodyCompositionData() async {
    final box = await Hive.openBox(BODYSTATSBOX);
    try {
      return Map<BodyComposition, Map<DateTime, double>>.from(
          await box.get("body-composition-data"));
    } catch (e) {
      print("ERROR!: COULDNT GET BODY COMPOSITION DATA");
      return null;
    }
  }

  Future<void> addOrSetBodyCompositionData(DateTime recordDate,
      double compositionPercentage, BodyComposition bodyComposition) async {
    final box = await Hive.openBox(BODYSTATSBOX);
    final bodyCompostionData = await getBodyCompositionData();
    if (bodyCompostionData == null) {
      await box.put("body-composition-data", {
        bodyComposition: {recordDate, compositionPercentage}
      });
    } else {
      bodyCompostionData[bodyComposition]![recordDate] = compositionPercentage;
      await box.put("body-composition-data", bodyCompostionData);
    }
  }
  
}
