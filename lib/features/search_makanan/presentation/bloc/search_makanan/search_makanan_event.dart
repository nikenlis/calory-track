part of 'search_makanan_bloc.dart';

abstract class SearchMakananEvent extends Equatable {
  const SearchMakananEvent();

  @override
  List<Object> get props => [];
}

class GetSearchMakanan extends SearchMakananEvent {
  final String query;

  const GetSearchMakanan({required this.query });

  @override
  List<Object> get props => [query];
}