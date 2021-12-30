import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:sample/src/router.dart';

import '../api.dart';
import '../auth.dart';
import '../model.dart';
import '../store.dart';

class UserView extends StatefulWidget {
  const UserView({
    Key? key,
  }) : super(key: key);

  @override
  _UserViewState createState() => _UserViewState();
}

class _UserViewState extends State<UserView>
    with SingleTickerProviderStateMixin {
  late Future<List<User>> _users;

  @override
  void initState() {
    super.initState();
    _users = Future<List<User>>.value(List<User>.empty());
  }

  @override
  Widget build(BuildContext context) => StoreConnector<AppState, Session>(
      converter: (store) => store.state.session,
      builder: (context, Session session) {
        try {
          if (session.cookies == null) {
            throw Exception('session not found');
          }
          _users = IamAPI.getUsers(session);
        } catch (e) {
          debugPrint(e.toString());
          AuthScope.of(context).signOut();
        }
        return FutureBuilder<List<User>>(
            future: _users,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.separated(
                  itemCount: snapshot.data!.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return const ListTile(title: Text('Users'));
                    }
                    return ListTile(
                        leading: const Icon(Icons.person),
                        title: Text(snapshot.data![index - 1].name),
                        subtitle:
                            Text("type: ${snapshot.data![index - 1].type}"),
                        onTap: () => {
                              RouteStateScope.of(context)
                                  .go('/user/${snapshot.data![index - 1].seq}')
                            },
                        trailing: const Icon(Icons.arrow_right));
                  },
                  separatorBuilder: (context, index) {
                    if (index == 0) {
                      const SizedBox.shrink();
                    }
                    return const Divider();
                  },
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            });
      });
}
