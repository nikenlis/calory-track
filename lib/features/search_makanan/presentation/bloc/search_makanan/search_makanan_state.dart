part of 'search_makanan_bloc.dart';

abstract class SearchMakananState extends Equatable {
  const SearchMakananState();  

  @override
  List<Object> get props => [];
}
class SearchMakananInitial extends SearchMakananState {}
class SearchMakananLoading extends SearchMakananState {}
class SearchMakananFailed extends SearchMakananState {
  final String message;

  const SearchMakananFailed(this.message);

  @override
  List<Object> get props => [message];
}
class SearchMakananLoaded extends SearchMakananState {
  final List<String> data;

  const SearchMakananLoaded(this.data);

  @override
  List<Object> get props => [data];
}