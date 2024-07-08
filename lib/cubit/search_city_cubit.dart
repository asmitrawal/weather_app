// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:weather_app/repository/supabase_repository.dart';

class SearchState {}

class SearchSuccessState<T> extends SearchState {
  final T item;

  SearchSuccessState({required this.item});
}

class SearchErrorState extends SearchState {
  final String? message;

  SearchErrorState({required this.message});
}

class SearchLoadingState extends SearchState {}

class SearchInitialState extends SearchState {}

class SearchEmptyState extends SearchState {}

class SearchCityCubit extends Cubit<SearchState> {
  SupabaseRepository repository;
  SearchCityCubit({
    required this.repository,
  }) : super(SearchInitialState());

  searchCity({required String query}) async {
    emit(SearchLoadingState());
    final res = await repository.searchCity(query: query);
    res.fold(
      (err) {
        emit(SearchErrorState(message: err));
      },
      (data) {
        emit(SearchSuccessState(item: data));
      },
    );
  }

  emptySuggestions() {
    emit(SearchEmptyState());
  }
}
