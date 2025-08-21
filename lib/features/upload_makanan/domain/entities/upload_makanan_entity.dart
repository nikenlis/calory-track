import 'package:equatable/equatable.dart';


class NutritionInfoEntity extends Equatable {
  final String kalori;
  final String lemak;
  final String karbohidrat;
  final String protein;

  const NutritionInfoEntity({
    required this.kalori,
    required this.lemak,
    required this.karbohidrat,
    required this.protein,
  });

  @override
  List<Object?> get props => [kalori, lemak, karbohidrat, protein];
}

class VolumeEntity extends Equatable {

  final String volume;
  final NutritionInfoEntity nutritionInfo;

  const VolumeEntity({

    required this.volume,
    required this.nutritionInfo,
  });

  @override
  List<Object?> get props => [volume, nutritionInfo];
}

class UploadMakananEntity extends Equatable {
  final String foodName;
  final double? confidence;
  final String volume;
  final NutritionInfoEntity nutritionInfo;
  final List<VolumeEntity> volumeList;

  const UploadMakananEntity({
    required this.foodName,
    this.confidence,
    required this.volume,
    required this.nutritionInfo,
    required this.volumeList,
  });

  @override
  List<Object?> get props => [foodName, confidence, volume, nutritionInfo, volumeList];
}
