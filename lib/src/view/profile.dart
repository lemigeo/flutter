import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:sample/src/router/route_state.dart';

import '../api.dart';
import '../model.dart';
import '../store.dart';

class ProfileView extends StatefulWidget {
  final int seq;
  const ProfileView({
    Key? key,
    required this.seq,
  }) : super(key: key);

  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  late Future<User> _user;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) => StoreConnector<AppState, Session>(
      converter: (store) => store.state.session,
      builder: (context, Session session) {
        _user = IamAPI.getUser(session, widget.seq);
        return FutureBuilder<User>(
            future: _user,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return RefreshIndicator(
                    onRefresh: () async {
                      User user = await IamAPI.getUser(session, widget.seq);
                      setState(() {
                        _user = Future.value(user);
                      });
                    },
                    child: Scaffold(
                        body: Container(
                            color: Colors.white,
                            child: ListView(children: <Widget>[
                              Column(children: <Widget>[
                                Container(
                                  height: 250.0,
                                  color: Colors.white,
                                  child: Column(children: <Widget>[
                                    Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10.0, top: 10.0),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Row(children: [
                                              IconButton(
                                                  iconSize: 20.0,
                                                  icon: const Icon(
                                                    Icons.arrow_back_ios,
                                                    color: Colors.black,
                                                  ),
                                                  onPressed: () => {
                                                        RouteStateScope.of(
                                                                context)
                                                            .go('/users')
                                                      }),
                                              const Padding(
                                                padding:
                                                    EdgeInsets.only(left: 1.0),
                                                child: Text('USER',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 18.0,
                                                        fontFamily:
                                                            'sans-serif-light',
                                                        color: Colors.black)),
                                              )
                                            ])
                                          ],
                                        )),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 20.0),
                                      child: Stack(
                                          fit: StackFit.loose,
                                          children: <Widget>[
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                Container(
                                                    width: 140.0,
                                                    height: 140.0,
                                                    decoration:
                                                        const BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      image: DecorationImage(
                                                        image: ExactAssetImage(
                                                            'image/profile.png'),
                                                        fit: BoxFit.cover,
                                                      ),
                                                    )),
                                              ],
                                            ),
                                            Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 90.0, right: 100.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: const <Widget>[
                                                    CircleAvatar(
                                                      backgroundColor:
                                                          Colors.red,
                                                      radius: 25.0,
                                                      child: Icon(
                                                        Icons.camera_alt,
                                                        color: Colors.white,
                                                      ),
                                                    )
                                                  ],
                                                )),
                                          ]),
                                    )
                                  ]),
                                )
                              ]),
                              Container(
                                  color: const Color(0xffFFFFFF),
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 25.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Padding(
                                            padding: const EdgeInsets.only(
                                                left: 25.0,
                                                right: 25.0,
                                                top: 25.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              mainAxisSize: MainAxisSize.max,
                                              children: <Widget>[
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: const <Widget>[
                                                    Text(
                                                      'Parsonal Information',
                                                      style: TextStyle(
                                                          fontSize: 18.0,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ],
                                                ),
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: <Widget>[
                                                    Container()
                                                  ],
                                                )
                                              ],
                                            )),
                                        Padding(
                                            padding: const EdgeInsets.only(
                                                left: 25.0,
                                                right: 25.0,
                                                top: 25.0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: <Widget>[
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: const <Widget>[
                                                    Text(
                                                      'Name',
                                                      style: TextStyle(
                                                          fontSize: 16.0,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            )),
                                        Padding(
                                            padding: const EdgeInsets.only(
                                                left: 25.0,
                                                right: 25.0,
                                                top: 2.0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: <Widget>[
                                                Flexible(
                                                  child:
                                                      Text(snapshot.data!.name),
                                                ),
                                              ],
                                            )),
                                        Padding(
                                            padding: const EdgeInsets.only(
                                                left: 25.0,
                                                right: 25.0,
                                                top: 25.0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: <Widget>[
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: const <Widget>[
                                                    Text(
                                                      'Email',
                                                      style: TextStyle(
                                                          fontSize: 16.0,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            )),
                                        Padding(
                                            padding: const EdgeInsets.only(
                                                left: 25.0,
                                                right: 25.0,
                                                top: 2.0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: <Widget>[
                                                Flexible(
                                                  child: Text(
                                                      snapshot.data!.email),
                                                ),
                                              ],
                                            )),
                                        Padding(
                                            padding: const EdgeInsets.only(
                                                left: 25.0,
                                                right: 25.0,
                                                top: 25.0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: <Widget>[
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: const <Widget>[
                                                    Text(
                                                      'Type',
                                                      style: TextStyle(
                                                          fontSize: 16.0,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            )),
                                        Padding(
                                            padding: const EdgeInsets.only(
                                                left: 25.0,
                                                right: 25.0,
                                                top: 2.0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: <Widget>[
                                                Flexible(
                                                  child:
                                                      Text(snapshot.data!.type),
                                                ),
                                              ],
                                            )),
                                        Padding(
                                            padding: const EdgeInsets.only(
                                                left: 25.0,
                                                right: 25.0,
                                                top: 25.0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: const <Widget>[
                                                Expanded(
                                                  child: Text(
                                                    'Pin Code',
                                                    style: TextStyle(
                                                        fontSize: 16.0,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  flex: 2,
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    'State',
                                                    style: TextStyle(
                                                        fontSize: 16.0,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  flex: 2,
                                                ),
                                              ],
                                            )),
                                        Padding(
                                            padding: const EdgeInsets.only(
                                                left: 25.0,
                                                right: 25.0,
                                                top: 2.0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: const <Widget>[
                                                Flexible(
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                        right: 10.0),
                                                    child: TextField(
                                                      decoration: InputDecoration(
                                                          hintText:
                                                              "Enter Pin Code"),
                                                      enabled: true,
                                                    ),
                                                  ),
                                                  flex: 2,
                                                ),
                                                Flexible(
                                                  child: TextField(
                                                    decoration: InputDecoration(
                                                        hintText:
                                                            "Enter State"),
                                                    enabled: true,
                                                  ),
                                                  flex: 2,
                                                ),
                                              ],
                                            )),
                                      ],
                                    ),
                                  )),
                            ]))));
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            });
      });
}
