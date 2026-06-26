import 'package:flutter/material.dart';
import 'package:dartz/dartz.dart' as dartz;
import '../../../../core/common/common.dart';
import '../../../../core/error/error.dart';
import '../../../../injection_container.dart';
import '../../domain/users_domain.dart';
import '../widgets/user_detail_body.dart';
import '../widgets/user_detail_shimmer.dart';

// User detail screen page widget - displays details of a user by loading data via UserRepository and rendering UserDetailBody
class UserDetailPage extends StatefulWidget {
  final int userId;

  const UserDetailPage({super.key, required this.userId});

  @override
  State<UserDetailPage> createState() => _UserDetailPageState();
}

// user detail page state
class _UserDetailPageState extends State<UserDetailPage> {
  late Future<dartz.Either<Failure, User>> _userDetailFuture;

  @override
  void initState() {
    super.initState();
    _loadUserDetail();
  }

  void _loadUserDetail() {
    setState(() {
      _userDetailFuture = sl<UserRepository>().getUserDetail(widget.userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<dartz.Either<Failure, User>>(
        future: _userDetailFuture,
        builder: (context, snapshot) {
          //shimmer
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const UserDetailShimmer();
          }
          //error
          if (snapshot.hasError) {
            return AppErrorWidget(
              errorMessage: snapshot.error.toString(),
              onRetry: _loadUserDetail,
            );
          }

          final data = snapshot.data;
          if (data == null) {
            return const AppErrorWidget(errorMessage: 'No data retrieved.');
          }

          return data.fold(
            (failure) => AppErrorWidget(
              errorMessage: failure.message,
              onRetry: _loadUserDetail,
            ),
            //users detail body
            (user) => UserDetailBody(user: user),
          );
        },
      ),
    );
  }
}
