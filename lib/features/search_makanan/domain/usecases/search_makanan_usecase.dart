import 'package:dartz/dartz.dart';
import 'package:rasa/core/error/failures.dart';
import 'package:rasa/features/search_makanan/domain/repositories/search_makanan_repository.dart';

class SearchMakananUsecase {
  final SearchMakananRepository repository;

  SearchMakananUsecase({required this.repository});

  Future<Either<Failures, List<String>>> execute({required String query}) {
    return repository.searchMakanan(query: query);
  }
}
