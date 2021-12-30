import 'package:flutter/material.dart';
import 'package:redux/redux.dart';

import '../model.dart';
import 'action.dart';

// class AppState {
//   final Session session;
//   final List<User> users;
//   final List<Account> accounts;
//   AppState(this.session, this.users, this.accounts);
// }

class AppState {
  final Session session;
  AppState({required this.session});

  AppState.initialState() : session = Session(null, null);
}

final Reducer<Session> sessionReducer = combineReducers<Session>([
  TypedReducer<Session, SetSession>(setSessionReducer),
  TypedReducer<Session, RemoveSession>(removeSessionReducer),
]);

Session setSessionReducer(Session state, action) {
  return Session(action.user, action.cookies);
}

Session removeSessionReducer(Session state, action) {
  return Session(null, null);
}

// Session sessionReducer(Session session, action) {
//   switch (action) {
//     case SetSession:
//       session.cookies = action.cookies;
//       session.user = action.user;
//       debugPrint('reducer set session ' + session.cookies.toString());
//       return session;
//     default:
//       return session;
//   }
// }

List<User> userReducer(List<User> users, action) {
  switch (action) {
    case AddUser:
      return List.from(users)..add(action.user);
    case AddUsers:
      return List.from(users)..addAll(action.users);
    case SetUsers:
      return List.from(action.users);
    default:
      return users;
  }
}

List<Account> accountReducer(List<Account> accounts, action) {
  switch (action) {
    case AddAccount:
      return List.from(accounts)..add(action.account);
    case AddAccounts:
      return List.from(accounts)..addAll(action.accounts);
    case SetAccounts:
      return List.from(action.accounts);
    default:
      return accounts;
  }
}

AppState appStateReducer(AppState state, action) =>
    AppState(session: sessionReducer(state.session, action)
        // userReducer(state.users, action),
        // accountReducer(state.accounts, action));
        );
