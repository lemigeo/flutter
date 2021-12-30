import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../api.dart';
import '../store.dart';
import '../model.dart';

class AccountView extends StatefulWidget {
  const AccountView({
    Key? key,
  }) : super(key: key);

  @override
  _AccountViewState createState() => _AccountViewState();
}

class _AccountViewState extends State<AccountView>
    with SingleTickerProviderStateMixin {
  late Future<List<Account>> _accounts;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) => StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (context, state) {
        _accounts = BillingAPI.getAccounts(state.session);
        return FutureBuilder<List<Account>>(
            future: _accounts,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.separated(
                  itemCount: snapshot.data!.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return ListTile(
                          title: Container(
                        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                        child: const Text('Accounts',
                            style: TextStyle(fontSize: 20)),
                      ));
                    }
                    return ListTile(
                        leading: const Icon(Icons.account_box),
                        title: Text(snapshot.data![index - 1].name),
                        subtitle: Text(
                            "desc: ${snapshot.data![index - 1].description}"),
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
