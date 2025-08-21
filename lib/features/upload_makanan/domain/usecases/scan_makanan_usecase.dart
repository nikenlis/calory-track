import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:rasa/core/error/failures.dart';
import 'package:rasa/features/upload_makanan/domain/entities/upload_makanan_entity.dart'
    show UploadMakananEntity;
import 'package:rasa/features/upload_makanan/domain/repositories/upload_makanan_repository.dart';

class ScanMakananUsecase {
  final UploadMakananRepository repository;

  ScanMakananUsecase(this.repository);

  Future<Either<Failures, UploadMakananEntity>> execute({required File file}) {
    return repository.uploadMakanan(file: file);
  }
}
