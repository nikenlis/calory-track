part of 'upload_makanan_bloc.dart';

abstract class UploadMakananState extends Equatable {
  const UploadMakananState();  

  @override
  List<Object> get props => [];
}
// class UploadMakananInitial extends UploadMakananState {}
// class UploadMakananLoading extends UploadMakananState {}
// class UploadMakananFailed extends UploadMakananState {
//   final String message;

//   const UploadMakananFailed({required this.message});
// }
// class UploadMakananLoaded extends UploadMakananState {
//   final UploadMakananEntity uploadMakanan;

//   const UploadMakananLoaded({required this.uploadMakanan});
// }



class UploadMakananInitial extends UploadMakananState {}

class UploadMakananPhotoCaptured extends UploadMakananState {
  final File file;
  const UploadMakananPhotoCaptured(this.file);

  @override
  List<Object> get props => [file];
}

class UploadMakananUploading extends UploadMakananState {
  final File file;
  const UploadMakananUploading(this.file);

  @override
  List<Object> get props => [file];
}

class UploadMakananSuccess extends UploadMakananState {
  final UploadMakananEntity data;
  const UploadMakananSuccess(this.data);

  @override
  List<Object> get props => [data];
}

class UploadMakananFailure extends UploadMakananState {
  final String error;
  const UploadMakananFailure(this.error);

  @override
  List<Object> get props => [error];
}
