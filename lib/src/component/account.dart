import 'package:flutter/material.dart';

import '../model.dart';

class AccountList extends StatelessWidget {
  final List<Account> accounts;
  final ValueChanged<Account>? onTap;

  const AccountList({
    required this.accounts,
    this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => ListView.builder(
        itemCount: accounts.length,
        itemBuilder: (context, index) => ListTile(
          title: Text(
            accounts[index].id,
          ),
          subtitle: Text(
            accounts[index].name,
          ),
          onTap: onTap != null ? () => onTap!(accounts[index]) : null,
        ),
      );
}
