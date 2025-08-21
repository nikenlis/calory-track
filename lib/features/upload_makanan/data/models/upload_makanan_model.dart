import 'package:rasa/features/upload_makanan/domain/entities/upload_makanan_entity.dart';

class NutritionInfoModel extends NutritionInfoEntity {
  const NutritionInfoModel({
    required super.kalori,
    required super.lemak,
    required super.karbohidrat,
    required super.protein,
  });

  factory NutritionInfoModel.fromJson(Map<String, dynamic> json) {
    return NutritionInfoModel(
      kalori: json['Kalori'] as String,
      lemak: json['Lemak'] as String,
      karbohidrat: json['Karbohidrat'] as String,
      protein: json['Protein'] as String,
    );
  }

  NutritionInfoEntity toEntity() {
    return NutritionInfoEntity(
      kalori: kalori,
      lemak: lemak,
      karbohidrat: karbohidrat,
      protein: protein,
    );
  }
}

class VolumeModel extends VolumeEntity {
  const VolumeModel({
    required super.volume,
    required super.nutritionInfo,
  });

  factory VolumeModel.fromJson(Map<String, dynamic> json) {
    return VolumeModel(
      volume: json['volume'] as String,
      nutritionInfo: NutritionInfoModel.fromJson(json['nutrition_info']),
    );
  }

  VolumeEntity toEntity() {
    return VolumeEntity(
      volume: volume,
      nutritionInfo: (nutritionInfo as NutritionInfoModel).toEntity(),
    );
  }
}

class UploadMakananModel extends UploadMakananEntity {
  const UploadMakananModel({
    required super.foodName,
    super.confidence,
    required super.volume,
    required super.nutritionInfo,
    required super.volumeList,
  });

  factory UploadMakananModel.fromJson(Map<String, dynamic> json) {
    return UploadMakananModel(
      foodName: json['food_name'] as String,
      confidence: json['confidence'] != null
          ? (json['confidence'] as num).toDouble()
          : null,
      volume: json['volume'] as String,
      nutritionInfo: NutritionInfoModel.fromJson(json['nutrition_info']),
      volumeList: (json['volume_list'] as List<dynamic>)
          .map((e) => VolumeModel.fromJson(e))
          .toList(),
    );
  }

  UploadMakananEntity toEntity() {
    return UploadMakananEntity(
      foodName: foodName,
      confidence: confidence,
      volume: volume,
      nutritionInfo: (nutritionInfo as NutritionInfoModel).toEntity(),
      volumeList: volumeList.map((e) => (e as VolumeModel).toEntity()).toList(),
    );
  }
}
