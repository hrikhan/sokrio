import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/common/common.dart';
import '../../../../injection_container.dart';
import '../bloc/user_bloc.dart';
import '../bloc/user_event.dart';
import '../widgets/user_list_body.dart';

// User list screen page widget - registers UserBloc and renders UserListBody widget
class UserListPage extends StatelessWidget {
  const UserListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colorScheme.background,

      //appbar
      appBar: AppBar(
        title: RichText(
          text: TextSpan(
            text: 'Sokrio ',
            style: context.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
              color: context.colorScheme.primary,
            ),
            children: [
              TextSpan(
                text: 'Users',
                style: context.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: context.colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ),

      //body
      body: BlocProvider(
        create: (_) => sl<UserBloc>()..add(const GetUsersEvent()),
        child: const UserListBody(),
      ),
    );
  }
}
