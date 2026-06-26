import 'package:equatable/equatable.dart';
import '../../domain/entities/user.dart';

//State classes for the user
abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object?> get props => [];
}

//initial state
class UserInitial extends UserState {
  const UserInitial();
}

//loading state
class UserLoading extends UserState {
  const UserLoading();
}

//loaded state
class UserLoaded extends UserState {
  final List<User> users;
  final List<User> filteredUsers;
  final String searchQuery;
  final bool isLoadingMore;
  final bool hasReachedMax;
  final int nextPage;
  final String? paginationError;

  //user loaded state with copywith method and props method
  const UserLoaded({
    required this.users,
    required this.filteredUsers,
    this.searchQuery = '',
    this.isLoadingMore = false,
    this.hasReachedMax = false,
    this.nextPage = 2,
    this.paginationError,
  });

  UserLoaded copyWith({
    List<User>? users,
    List<User>? filteredUsers,
    String? searchQuery,
    bool? isLoadingMore,
    bool? hasReachedMax,
    int? nextPage,
    String? paginationError,
  }) {
    return UserLoaded(
      users: users ?? this.users,
      filteredUsers: filteredUsers ?? this.filteredUsers,
      searchQuery: searchQuery ?? this.searchQuery,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      nextPage: nextPage ?? this.nextPage,
      paginationError: paginationError, // allow clearing it
    );
  }

  //props method
  @override
  List<Object?> get props => [
    users,
    filteredUsers,
    searchQuery,
    isLoadingMore,
    hasReachedMax,
    nextPage,
    paginationError,
  ];
}

//error state
class UserError extends UserState {
  final String message;

  const UserError(this.message);

  @override
  List<Object?> get props => [message];
}
