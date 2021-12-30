import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:photo_gallery/photo_gallery.dart';
import 'package:redux/redux.dart';

import '../auth.dart';
import '../store.dart';
import '../api.dart';

class SettingView extends StatefulWidget {
  const SettingView({Key? key}) : super(key: key);

  @override
  SettingViewState createState() => SettingViewState();
}

class SettingViewState extends State<SettingView>
    with TickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<BorderRadius?> _borderAnimation;

  @override
  void initState() {
    super.initState();

    _animationController =
        AnimationController(duration: const Duration(seconds: 1), vsync: this);

    _borderAnimation = BorderRadiusTween(
            begin: BorderRadius.circular(100.0),
            end: BorderRadius.circular(0.0))
        .animate(_animationController);

    _animationController.repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _SessionModel>(
        converter: (store) => _SessionModel.create(store),
        builder: (context, _SessionModel model) {
          return Container(
              alignment: Alignment.bottomCenter,
              padding: const EdgeInsets.only(top: 150),
              child: Column(children: [
                Center(
                  child: AnimatedBuilder(
                    animation: _borderAnimation,
                    builder: (context, child) {
                      return Container(
                        child: const FlutterLogo(
                          size: 200,
                        ),
                        alignment: Alignment.bottomCenter,
                        width: 350,
                        height: 200,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            colors: [
                              Colors.blueAccent,
                              Colors.redAccent,
                            ],
                          ),
                          borderRadius: _borderAnimation.value,
                        ),
                      );
                    },
                  ),
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                          child: const Text('Alert'),
                          style: ElevatedButton.styleFrom(elevation: 8.0),
                          onPressed: () {
                            _showAlert();
                          }),
                      ElevatedButton(
                          child: const Text('Gallery'),
                          style: ElevatedButton.styleFrom(elevation: 8.0),
                          onPressed: () async {
                            _handleGallery();
                          })
                    ]),
                ElevatedButton(
                    child: const Text('Logout'),
                    style: ElevatedButton.styleFrom(elevation: 8.0),
                    onPressed: () async {
                      model.logout();
                      await AuthScope.of(context).signOut();
                    })
              ]));
        });
  }

  void _showAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: const Text("Alert Dialog title"),
          content: const Text("Alert Dialog body"),
          actions: <Widget>[
            TextButton(
                child: const Text("Close"),
                onPressed: () {
                  Navigator.pop(context);
                }),
          ],
        );
      },
    );
  }

  void _handleGallery() async {
    final List<Album> albums = await PhotoGallery.listAlbums(
      mediumType: MediumType.image,
    );
    for (Album album in albums) {
      MediaPage mediaPage = await album.listMedia();
      for (Medium medium in mediaPage.items) {
        _showImage(context, medium);
        break;
      }
    }
  }

  Future<void> _showImage(BuildContext context, Medium medium) async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return ImageDialog(
            medium: medium,
          );
        });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}

class _SessionModel {
  final Function() logout;

  _SessionModel({required this.logout});

  factory _SessionModel.create(Store<AppState> store) {
    _logout() async {
      await BillingAPI.logout(store.state.session);
      store.dispatch(RemoveSession());
    }

    return _SessionModel(logout: _logout);
  }
}

class ImageDialog extends StatefulWidget {
  final Medium medium;

  const ImageDialog({Key? key, required this.medium}) : super(key: key);

  @override
  _ImageDialogState createState() => _ImageDialogState();
}

class _ImageDialogState extends State<ImageDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
        child: Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(
          image: DecorationImage(
              image: ThumbnailProvider(
                mediumId: widget.medium.id,
                mediumType: widget.medium.mediumType,
                highQuality: true,
              ),
              fit: BoxFit.fill)),
    ));
  }
}
