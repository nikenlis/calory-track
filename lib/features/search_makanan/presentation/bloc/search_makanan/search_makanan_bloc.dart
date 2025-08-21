import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rasa/features/search_makanan/domain/usecases/search_makanan_usecase.dart';

part 'search_makanan_event.dart';
part 'search_makanan_state.dart';

class SearchMakananBloc extends Bloc<SearchMakananEvent, SearchMakananState> {
  final SearchMakananUsecase _searchMakananUsecase;
  SearchMakananBloc(this._searchMakananUsecase)
      : super(SearchMakananInitial()) {
    on<GetSearchMakanan>((event, emit) async {
      emit(SearchMakananLoading());
      final result = await _searchMakananUsecase.execute(query: event.query);
      result.fold(
        (failure) => emit(SearchMakananFailed(failure.message)),
        (data) => emit(SearchMakananLoaded(data)),
      );
    });
  }
}
