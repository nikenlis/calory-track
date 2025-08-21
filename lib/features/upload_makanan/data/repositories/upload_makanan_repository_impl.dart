import 'dart:async';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:rasa/core/error/exceptions.dart';
import 'package:rasa/core/error/failures.dart';
import 'package:rasa/features/upload_makanan/data/datasources/upload_makanan_remote_datasource.dart';
import 'package:rasa/features/upload_makanan/domain/entities/upload_makanan_entity.dart';
import 'package:rasa/features/upload_makanan/domain/repositories/upload_makanan_repository.dart';

class UploadMakananRepositoryImpl implements UploadMakananRepository {
  final UploadMakananRemoteDatasource remoteDatasource;

  UploadMakananRepositoryImpl(this.remoteDatasource);

  @override
  Future<Either<Failures, UploadMakananEntity>> uploadMakanan(
      {required File file}) async {
    try {
      final result = await remoteDatasource.uploadMakanan(file: file);
      return Right(result.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on ClientException catch (e) {
      return Left(ClientFailure(e.message));
    } on TimeoutException catch (e) {
      return Left(TimeoutFailure(e.message!));
    } on SocketException catch (e) {
      return Left(NetworkFailure(e.message));
    } on UnexpectedException catch (e) {
      return Left(UnexpectedFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure("Terjadi kesalahan tak terduga: $e"));
    }
  }
}
