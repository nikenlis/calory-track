import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:rasa/core/error/failures.dart';
import 'package:rasa/features/upload_makanan/domain/entities/upload_makanan_entity.dart'
    show UploadMakananEntity;

abstract class UploadMakananRepository {
  Future<Either<Failures, UploadMakananEntity>> uploadMakanan(
      {required File file});
}
