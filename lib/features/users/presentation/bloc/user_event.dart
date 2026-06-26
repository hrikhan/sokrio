import 'package:equatable/equatable.dart';

//user event abstract class
abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object?> get props => [];
}

//get users event
class GetUsersEvent extends UserEvent {
  final bool isRefresh;
  const GetUsersEvent({this.isRefresh = false});

  @override
  List<Object?> get props => [isRefresh];
}

//search users event
class SearchUsersEvent extends UserEvent {
  final String query;

  const SearchUsersEvent(this.query);

  @override
  List<Object?> get props => [query];
}
