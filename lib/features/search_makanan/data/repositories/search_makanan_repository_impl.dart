import 'dart:async';
import 'dart:io';

import 'package:dartz/dartz.dart';

import 'package:rasa/core/error/exceptions.dart';
import 'package:rasa/core/error/failures.dart';
import 'package:rasa/features/search_makanan/data/datasources/search_makanan_remote_datasource.dart';
import 'package:rasa/features/search_makanan/domain/repositories/search_makanan_repository.dart';
import 'package:rasa/features/upload_makanan/domain/entities/upload_makanan_entity.dart';

class SearchMakananRepositoryImpl implements SearchMakananRepository {
  final SearchMakananRemoteDatasource remoteDatasource;

  SearchMakananRepositoryImpl(this.remoteDatasource);

  @override
  Future<Either<Failures, List<String>>> searchMakanan(
      {required String query}) async {
    try {
      final result = await remoteDatasource.searchMakanan(query: query);
      return Right(result);
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

  @override
  Future<Either<Failures, UploadMakananEntity>> getMakananDetail(
      {required String name}) async {
    try {
      final result = await remoteDatasource.getMakananDetail(name: name);
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
