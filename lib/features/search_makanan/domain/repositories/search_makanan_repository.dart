import 'package:dartz/dartz.dart';
import 'package:rasa/core/error/failures.dart';
import 'package:rasa/features/upload_makanan/domain/entities/upload_makanan_entity.dart';

abstract class SearchMakananRepository {
  Future<Either<Failures, List<String>>> searchMakanan({required String query});

  Future<Either<Failures, UploadMakananEntity>> getMakananDetail(
      {required String name});
}
