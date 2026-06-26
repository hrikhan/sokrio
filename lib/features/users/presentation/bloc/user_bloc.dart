import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/users_domain.dart';
import 'user_event.dart';
import 'user_state.dart';

//user bloc
class UserBloc extends Bloc<UserEvent, UserState> {
  final GetUsers getUsers;
  final SearchUsers searchUsers;
  // constructer
  UserBloc({required this.getUsers, required this.searchUsers})
    : super(const UserInitial()) {
    on<GetUsersEvent>(_onGetUsers);
    on<SearchUsersEvent>(_onSearchUsers);
  }

  Future<void> _onGetUsers(GetUsersEvent event, Emitter<UserState> emit) async {
    final currentState = state;

    // Check if it's initial load or refresh
    if (currentState is! UserLoaded || event.isRefresh) {
      emit(const UserLoading());

      // Load 10 users initially (page 1, perPage = 10)
      final result = await getUsers(1, perPage: 10);
      result.fold((failure) => emit(UserError(failure.message)), (data) {
        final hasReachedMax = 1 >= data.totalPages;
        emit(
          UserLoaded(
            users: data.users,
            filteredUsers: data.users,
            searchQuery: '',
            isLoadingMore: false,
            hasReachedMax: hasReachedMax,
            nextPage: 2, // nextPage is page 2 (size 10)
          ),
        );
      });
    } else {
      // If we are already loaded, check if we can load more
      if (currentState.hasReachedMax || currentState.isLoadingMore) return;

      emit(currentState.copyWith(isLoadingMore: true, paginationError: null));

      final result = await getUsers(currentState.nextPage, perPage: 10);
      result.fold(
        (failure) {
          emit(
            currentState.copyWith(
              isLoadingMore: false,
              paginationError: failure.message,
            ),
          );
        },
        (data) {
          final updatedUsers = List<User>.from(currentState.users)
            ..addAll(data.users);

          // Under perPage = 10, total_pages is 2. So when page >= 2, we have reached max.
          final hasReachedMax = currentState.nextPage >= data.totalPages;

          emit(
            currentState.copyWith(
              users: updatedUsers,
              filteredUsers: searchUsers(
                users: updatedUsers,
                query: currentState.searchQuery,
              ),
              isLoadingMore: false,
              hasReachedMax: hasReachedMax,
              nextPage: currentState.nextPage + 1,
            ),
          );
        },
      );
    }
  }
  //onsearch users

  void _onSearchUsers(SearchUsersEvent event, Emitter<UserState> emit) {
    final currentState = state;
    if (currentState is UserLoaded) {
      final filtered = searchUsers(
        users: currentState.users,
        query: event.query,
      );
      emit(
        currentState.copyWith(
          filteredUsers: filtered,
          searchQuery: event.query,
        ),
      );
    }
  }
}
