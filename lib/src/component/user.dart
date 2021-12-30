import 'package:flutter/material.dart';

import '../model.dart';

class UserList extends StatelessWidget {
  final List<User> users;
  final ValueChanged<User>? onTap;

  const UserList({
    required this.users,
    this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) => ListTile(
          title: Text(
            users[index].email,
          ),
          subtitle: Text(
            users[index].name,
          ),
          onTap: onTap != null ? () => onTap!(users[index]) : null,
        ),
      );
}
