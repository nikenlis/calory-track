import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:rasa/core/common/network_info.dart';
import 'package:rasa/features/search_makanan/data/datasources/search_makanan_remote_datasource.dart';
import 'package:rasa/features/search_makanan/data/repositories/search_makanan_repository_impl.dart';
import 'package:rasa/features/search_makanan/domain/repositories/search_makanan_repository.dart';
import 'package:rasa/features/search_makanan/domain/usecases/get_detail_makanan_usecase.dart';
import 'package:rasa/features/search_makanan/domain/usecases/search_makanan_usecase.dart';
import 'package:rasa/features/search_makanan/presentation/bloc/detail_makanan/detail_makanan_bloc.dart';
import 'package:rasa/features/search_makanan/presentation/bloc/search_makanan/search_makanan_bloc.dart';
import 'package:rasa/features/upload_makanan/data/datasources/upload_makanan_remote_datasource.dart';
import 'package:rasa/features/upload_makanan/data/repositories/upload_makanan_repository_impl.dart';
import 'package:rasa/features/upload_makanan/domain/repositories/upload_makanan_repository.dart';
import 'package:rasa/features/upload_makanan/domain/usecases/scan_makanan_usecase.dart';
import 'package:rasa/features/upload_makanan/presentation/bloc/upload_makanan_bloc.dart';

final locator = GetIt.instance;

Future<void> initLocator() async {
  //Upload makanan
  //bloc
  locator.registerFactory(() => UploadMakananBloc(locator()));

  //usecase
  locator.registerLazySingleton(() => ScanMakananUsecase(locator()));

  //repository
  locator.registerLazySingleton<UploadMakananRepository>(
      () => UploadMakananRepositoryImpl(
            locator(),
          ));

  //datasource
  locator.registerLazySingleton<UploadMakananRemoteDatasource>(
      () => UploadMakananRemoteDatasourceImpl(locator()));

  //search makanan
  //bloc
  locator.registerFactory(() => SearchMakananBloc(locator()));
  locator.registerFactory(() => DetailMakananBloc(locator()));

  //usecase
  locator
      .registerLazySingleton(() => SearchMakananUsecase(repository: locator()));
  locator.registerLazySingleton(() => GetDetailMakananUsecase(locator()));

  //repository
  locator.registerLazySingleton<SearchMakananRepository>(
      () => SearchMakananRepositoryImpl(
            locator(),
          ));

  //datasource
  locator.registerLazySingleton<SearchMakananRemoteDatasource>(
      () => SearchMakananRemoteDatasourceImpl(locator()));

  //platform
  locator.registerLazySingleton<NetworkInfo>(
      () => NetworkInfoImpl(connectivity: locator()));

  //external
  locator.registerLazySingleton(() => http.Client());
  locator.registerLazySingleton(() => Connectivity());
}
