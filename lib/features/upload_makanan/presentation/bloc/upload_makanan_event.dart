part of 'upload_makanan_bloc.dart';

abstract class UploadMakananEvent extends Equatable {
  const UploadMakananEvent();

  @override
  List<Object> get props => [];
}

class ScanUploadMakanan extends UploadMakananEvent {
  final File file;

  const ScanUploadMakanan({required this.file});
}

class ResetUploadMakanan extends UploadMakananEvent {}

