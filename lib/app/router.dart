import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../features/users/users.dart';

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      //list screen
      GoRoute(
        path: '/',
        name: 'user-list',
        builder: (context, state) => const UserListPage(),
      ),

      //details screen
      GoRoute(
        path: '/user-detail',
        name: 'user-detail',
        builder: (context, state) {
          // Extra payload will contain the userId or user object
          final userId = state.extra as int?;
          return UserDetailPage(userId: userId ?? 0);
        },
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(child: Text('No route defined for ${state.uri.toString()}')),
    ),
  );
}
