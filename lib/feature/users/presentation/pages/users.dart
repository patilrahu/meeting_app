import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meeting_app/core/helper/toast_helper.dart';
import 'package:meeting_app/feature/users/presentation/bloc/user_bloc.dart';
import 'package:meeting_app/feature/users/presentation/bloc/user_event.dart';
import 'package:meeting_app/feature/users/presentation/bloc/user_state.dart';

class Users extends StatefulWidget {
  const Users({super.key});

  @override
  State<Users> createState() => _UsersState();
}

class _UsersState extends State<Users> {
  @override
  void initState() {
    super.initState();
    context.read<UserBloc>().add(GetUsers());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.white),
      body: SafeArea(
        child: BlocConsumer<UserBloc, UserState>(
          builder: (context, state) {
            if (state is UserLoading) {
              return Center(child: CircularProgressIndicator());
            }
            if (state is UserSuccess) {
              final users = state.data.data;
              return ListView.builder(
                padding: EdgeInsets.only(left: 20, right: 20),
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];
                  return ListTile(
                    contentPadding: EdgeInsets.only(top: 30),
                    leading: CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.grey[300],
                      child: ClipOval(
                        child: CachedNetworkImage(
                          imageUrl: user.avatar,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              const CircularProgressIndicator(),
                          errorWidget: (context, url, error) => const Icon(
                            Icons.person,
                            size: 30,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    title: Text(
                      "${user.firstName} ${user.lastName}",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    subtitle: Text(
                      user.email,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  );
                },
              );
            }
            if (state is UserFailed) {
              return Center(child: Text(state.error));
            }

            return const Center(child: Text("Press button to fetch users"));
          },
          listener: (context, state) {
            if (state is UserFailed) {
              ToastHelper.error(context, state.error);
            }
          },
        ),
      ),
    );
  }
}
