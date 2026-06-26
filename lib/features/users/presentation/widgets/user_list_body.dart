import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/common/common.dart';
import '../bloc/user_bloc.dart';
import '../bloc/user_event.dart';
import '../bloc/user_state.dart';
import 'user_card.dart';
import 'user_card_shimmer.dart';
import 'user_search_bar.dart';

// User list body widget - handles search, pagination scroll listener, loading state shimmers, error retries, and loaded user list views.
class UserListBody extends StatefulWidget {
  const UserListBody({super.key});

  @override
  State<UserListBody> createState() => _UserListBodyState();
}

class _UserListBodyState extends State<UserListBody> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<UserBloc>().add(const GetUsersEvent());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9); // fetch next page when scrolled 90% down
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 800),
        child: Column(
          children: [
            const OfflineBanner(),
            UserSearchBar(
              onChanged: (query) {
                context.read<UserBloc>().add(SearchUsersEvent(query));
              },
            ),
            Expanded(
              child: BlocConsumer<UserBloc, UserState>(
                listener: (context, state) {
                  if (state is UserLoaded && state.paginationError != null) {
                    context.showSnackBar(state.paginationError!, isError: true);
                  }
                },
                builder: (context, state) {
                  if (state is UserLoading) {
                    return ListView.builder(
                      itemCount: 6,
                      itemBuilder: (context, index) {
                        return const UserCardShimmer();
                      },
                    );
                  } else if (state is UserError) {
                    return AppErrorWidget(
                      errorMessage: state.message,
                      onRetry: () {
                        context.read<UserBloc>().add(const GetUsersEvent(isRefresh: true));
                      },
                    );
                  } else if (state is UserLoaded) {
                    final users = state.filteredUsers;
                    if (users.isEmpty && state.searchQuery.isNotEmpty) {
                      return EmptyView(
                        title: 'No results found',
                        message: "We couldn't find matches for '${state.searchQuery}'.",
                      );
                    }

                    if (users.isEmpty) {
                      return EmptyView(
                        title: 'No users loaded',
                        message: 'Pull down to refresh or try again.',
                        onAction: () {
                          context.read<UserBloc>().add(const GetUsersEvent(isRefresh: true));
                        },
                        actionLabel: 'Load Users',
                      );
                    }

                    return RefreshIndicator(
                      onRefresh: () async {
                        context.read<UserBloc>().add(const GetUsersEvent(isRefresh: true));
                      },
                      child: ListView.builder(
                        controller: _scrollController,
                        itemCount: users.length + (state.isLoadingMore ? 1 : 0),
                        physics: const BouncingScrollPhysics(
                          parent: AlwaysScrollableScrollPhysics(),
                        ),
                        itemBuilder: (context, index) {
                          if (index < users.length) {
                            final user = users[index];
                            return UserCard(
                              user: user,
                              onTap: () {
                                context.push('/user-detail', extra: user.id);
                              },
                            );
                          } else {
                            // Bottom loading indicator for pagination
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 24),
                              child: Center(
                                child: SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    );
                  }
                  return const EmptyView();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
