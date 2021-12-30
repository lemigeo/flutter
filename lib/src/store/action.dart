import '../model.dart';

class SetSession {
  final String cookies;
  final User user;

  SetSession(this.user, this.cookies);
}

class RemoveSession {
  RemoveSession();
}

class AddUser {
  final User user;

  AddUser(this.user);
}

class AddUsers {
  final List<User> users;

  AddUsers(this.users);
}

class SetUsers {
  final List<User> users;

  SetUsers(this.users);
}

class AddAccount {
  final Account account;
  AddAccount(this.account);
}

class AddAccounts {
  final List<Account> accounts;

  AddAccounts(this.accounts);
}

class SetAccounts {
  final List<Account> accounts;

  SetAccounts(this.accounts);
}
