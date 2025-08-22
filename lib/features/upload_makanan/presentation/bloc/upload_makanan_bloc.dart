import 'dart:io' show File;

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rasa/features/upload_makanan/domain/entities/upload_makanan_entity.dart';
import 'package:rasa/features/upload_makanan/domain/usecases/scan_makanan_usecase.dart';

part 'upload_makanan_event.dart';
part 'upload_makanan_state.dart';

class UploadMakananBloc extends Bloc<UploadMakananEvent, UploadMakananState> {
  final ScanMakananUsecase scanMakananUsecase;
  UploadMakananBloc(this.scanMakananUsecase) : super(UploadMakananInitial()) {
    on<ScanUploadMakanan>((event, emit) async {
      emit(UploadMakananPhotoCaptured(event.file));
      emit(UploadMakananUploading(event.file));
      final result = await scanMakananUsecase.execute(file: event.file);
      result.fold(
        (failure) => emit(UploadMakananFailure(failure.message)),
        (data) => emit(UploadMakananSuccess(data)),
      );
    });
    on<ResetUploadMakanan>((event, emit) => emit(UploadMakananInitial()));
  }
}
