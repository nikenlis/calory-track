import 'package:dartz/dartz.dart';
import 'package:rasa/core/error/failures.dart';
import 'package:rasa/features/search_makanan/domain/repositories/search_makanan_repository.dart';
import 'package:rasa/features/upload_makanan/domain/entities/upload_makanan_entity.dart';

class GetDetailMakananUsecase {
  final SearchMakananRepository repository;

  GetDetailMakananUsecase(this.repository);

  Future<Either<Failures, UploadMakananEntity>> execute(
      {required String name}) {
    return repository.getMakananDetail(name: name);
  }
}
