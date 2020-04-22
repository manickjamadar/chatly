import 'dart:io';

import 'package:chatly/models/profile.dart';
import 'package:chatly/providers/profile_provider.dart';
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class EditProfileScreen extends StatefulWidget {
  static const String routeName = "/edit-profile-screen";

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  TextEditingController _nameController;
  bool isExistingValueUsed = false;
  File avatarFile;
  String oldAvatarUrl;

  @override
  void initState() {
    _nameController = TextEditingController();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (!isExistingValueUsed) {
      final ProfileProvider profileProvider =
          Provider.of<ProfileProvider>(context, listen: false);
      final Profile profile = profileProvider.profile;
      _nameController.text = profile.name ?? "";
      oldAvatarUrl = profile.avatarUrl;
      isExistingValueUsed = true;
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void alertSnackBar(BuildContext context, String message) {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(message),
    ));
  }

  Dialog getLoadingDialog(String message) {
    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: <Widget>[
            CircularProgressIndicator(),
            SizedBox(
              width: 30,
            ),
            Text(message ?? 'Loading...')
          ],
        ),
      ),
    );
  }

  void _pickAvatar(BuildContext ctx) async {
    try {
      final ImageSource source = await showModalBottomSheet<ImageSource>(
          context: ctx,
          builder: (c) {
            return Container(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.camera),
                    onPressed: () =>
                        Navigator.pop<ImageSource>(c, ImageSource.camera),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  IconButton(
                    icon: Icon(Icons.wallpaper),
                    onPressed: () =>
                        Navigator.pop<ImageSource>(c, ImageSource.gallery),
                  ),
                ],
              ),
            );
          });
      final imageFile =
          await ImagePicker.pickImage(source: source ?? ImageSource.gallery);
      File croppedFile = await ImageCropper.cropImage(
          sourcePath: imageFile.path,
          maxWidth: 50,
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
          ],
          androidUiSettings: AndroidUiSettings(
              toolbarTitle: 'Cropper',
              toolbarColor: Colors.blue,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.square,
              lockAspectRatio: true),
          iosUiSettings: IOSUiSettings(
            minimumAspectRatio: 1.0,
          ));
      setState(() {
        avatarFile = croppedFile;
      });
    } catch (error) {
      Scaffold.of(ctx).showSnackBar(SnackBar(
        content: Text("Picking image failed"),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Edit Profile Screen")),
        body: Center(
            child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              Builder(
                builder: (ctx) => GestureDetector(
                  onTap: () => _pickAvatar(ctx),
                  child: CircleAvatar(
                    radius: 40,
                    backgroundImage: avatarFile != null
                        ? FileImage(avatarFile)
                        : (oldAvatarUrl != null
                            ? NetworkImage(oldAvatarUrl)
                            : null),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                  controller: _nameController,
                  decoration: InputDecoration(hintText: "Enter Your name")),
              SizedBox(
                height: 20,
              ),
              Builder(builder: (ctx) {
                return CupertinoButton(
                  color: Colors.blue,
                  child: Text("Update Profile"),
                  onPressed: () async {
                    final String newName = _nameController.text;
                    if (newName.isEmpty) {
                      return alertSnackBar(ctx, "Name should not be empty");
                    }
                    final ProfileProvider profileProvider =
                        Provider.of<ProfileProvider>(context, listen: false);
                    bool isAnythingUpdated =
                        newName != profileProvider.profile.name ||
                            avatarFile != null;
                    if (!isAnythingUpdated) {
                      Navigator.pop(context);
                    } else {
                      showDialog(
                          context: ctx,
                          child: getLoadingDialog("Updating User Profile"));
                      final response = await profileProvider.updateUserProfile(
                          name: newName, avatarFile: avatarFile);
                      if (response.error) {
                        alertSnackBar(ctx, response.message);
                      } else {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      }
                    }
                  },
                );
              })
            ],
          ),
        )));
  }
}
