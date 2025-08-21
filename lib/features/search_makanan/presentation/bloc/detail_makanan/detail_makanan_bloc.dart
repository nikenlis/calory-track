import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rasa/features/search_makanan/domain/usecases/get_detail_makanan_usecase.dart';
import 'package:rasa/features/upload_makanan/domain/entities/upload_makanan_entity.dart';

part 'detail_makanan_event.dart';
part 'detail_makanan_state.dart';

class DetailMakananBloc extends Bloc<DetailMakananEvent, DetailMakananState> {
  final GetDetailMakananUsecase _getDetailMakananUsecase;
  DetailMakananBloc(this._getDetailMakananUsecase)
      : super(DetailMakananInitial()) {
    on<GetDetailMakanan>((event, emit) async {
      emit(DetailMakananLoading());
      final result = await _getDetailMakananUsecase.execute(name: event.name);
      result.fold(
        (failure) => emit(DetailMakananFailed(failure.message)),
        (data) => emit(DetailMakananLoaded(data)),
      );
    });
  }
}
