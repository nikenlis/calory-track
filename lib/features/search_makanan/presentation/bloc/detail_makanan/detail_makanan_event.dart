part of 'detail_makanan_bloc.dart';

sealed class DetailMakananEvent extends Equatable {
  const DetailMakananEvent();

  @override
  List<Object> get props => [];
}

class GetDetailMakanan extends DetailMakananEvent {
  final String name;

  const GetDetailMakanan({required this.name});

  @override
  List<Object> get props => [name];
}
