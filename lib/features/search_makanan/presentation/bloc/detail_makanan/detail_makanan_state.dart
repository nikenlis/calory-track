part of 'detail_makanan_bloc.dart';

sealed class DetailMakananState extends Equatable {
  const DetailMakananState();
  
  @override
  List<Object> get props => [];
}

final class DetailMakananInitial extends DetailMakananState {}
final class DetailMakananLoading extends DetailMakananState {}
final class DetailMakananFailed extends DetailMakananState {
  final String message;

  const DetailMakananFailed(this.message);

  @override
  List<Object> get props => [message];
}
final class DetailMakananLoaded extends DetailMakananState {
  final UploadMakananEntity data;

  const DetailMakananLoaded(this.data);

  @override
  List<Object> get props => [data];
}