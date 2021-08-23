import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:provider/provider.dart';
import 'package:social_start/controllers/auth_controller.dart';
import 'package:social_start/controllers/user_controller.dart';
import 'package:social_start/models/user.dart';
import 'package:social_start/pages/purchase_products_page.dart';
import 'package:social_start/pages/purchase_socialpoint.dart';
import 'package:social_start/services/firebase_services.dart';
import 'package:social_start/utils/constants.dart';
import 'package:social_start/utils/utility.dart';
import 'package:social_start/viewmodels/theme_viewmodel.dart';
import 'package:social_start/viewmodels/user_viewmodel.dart';
import 'package:social_start/widgets/custom_appbar.dart';
import 'package:path/path.dart' as path;
import 'edit_profile_page.dart';
import 'change_password_page.dart';
import 'login_page.dart';
import 'package:hive/hive.dart';

class SettingsPage extends StatefulWidget {
  static final pageName = "settings";

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  AuthController _authController = AuthController();
  FirebaseServices _firebaseServices = FirebaseServices();
  UserController userController = UserController();
  List<String> _relationShipStatus = [
    "single",
    "In a relationship",
    "Engaged",
    "Married",
    "Separated",
    "Divorced",
    "Widowed",
    "Complicated"
  ];
  bool nightMode;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: _buildSettingsWidget(),
        ),
      ),
    );
  }

  _buildSettingItems({IconData icon, String title, Function() onPressed}) {
    return GestureDetector(
      onTap: () {
        onPressed();
      },
      child: Container(
        padding: EdgeInsets.all(10.0),
        child: Row(
          children: [
            Icon(
              icon,
            ),
            SizedBox(
              width: 10.0,
            ),
            Text(
              "$title",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  _buildSettingsWidget() {
    return Consumer<UserViewModel>(builder: (context, userVM, child) {
      User user = userVM.user;
      print(user.firstName);
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            _buildEditableTextField(
                "First name",
                user.firstName,
                () =>
                    _updateField(user.firstName, "First name", context, user)),
            SizedBox(height: 10),
            _buildEditableTextField("Last name", user.lastName,
                () => _updateField(user.lastName, "Last name", context, user)),
            SizedBox(height: 10),
            _buildPPSection(user.profileUrl, context),
            SizedBox(height: 10),
            _buildBannerSection(user.bannerUrl, context),
            SizedBox(height: 10),
            _buildEditableTextField("Relationship status",
                user.relationShipStatus, () => _updateRelationShipStatus(user)),
            SizedBox(height: 10),
            _buildEditableTextField("Bio", user.bio,
                () => _updateField(user.bio, "Bio", context, user)),
            SizedBox(height: 10),
            _buildEditableTextField("Password", "**********", () {
              Navigator.pushNamed(context, ChangePasswordPage.pageName);
            }),
            SizedBox(
              height: 10,
            ),
            PurchaseProductsPage()
          ],
        ),
      );
    });
  }

  _updateField(String currentValue, String fieldName, mContext, User user) {
    TextEditingController _controller = TextEditingController();
    _controller.text = currentValue;
    showDialog(
      context: mContext,
      builder: (lContext) {
        return AlertDialog(
            title: Text("Update $fieldName"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _controller,
                )
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(mContext).pop();
                  },
                  child: Text(
                    "Cancel",
                    style: TextStyle(
                        color: Theme.of(context).textTheme.bodyText2.color),
                  )),
              TextButton(
                  onPressed: () async {
                    switch (fieldName.toLowerCase()) {
                      case "first name":
                        user.firstName = _controller.text;
                        break;
                      case "last name":
                        user.lastName = _controller.text;
                        break;
                      case "bio":
                        user.bio = _controller.text;
                        break;
                      default:
                        break;
                    }
                    try {
                      Utility.showProgressAlertDialog(mContext, "Updating");
                      await userController.updateUser(user);
                      Utility.showSnackBar(
                          context, "$fieldName updated successfully");
                      Navigator.of(mContext).pop();
                      Navigator.of(mContext).pop();
                      Provider.of<UserViewModel>(context, listen: false)
                          .updateUser(user);
                    } catch (error, stk) {
                      print(error);
                      print(stk);
                      Navigator.of(mContext).pop();
                      Utility.showSnackBar(context, "$fieldName update failed");
                    }
                  },
                  child: Text("Update")),
            ]);
      },
    );
  }

  _buildEditableTextField(String title, String value, onEdit) {
    print(value);
    print("value");
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(title),
            SizedBox(
              width: 10,
            ),
            GestureDetector(
              onTap: () {
                onEdit();
              },
              child: Text(
                'Edit',
                style: TextStyle(color: kAccentColor),
              ),
            )
          ],
        ),
        SizedBox(height: 10),
        Text(value),
        Divider(),
        // TextFormField(
        //   enabled: false,
        //   initialValue: value,
        // )
      ],
    );
  }

  _buildPPSection(String imageUrl, context) {
    return Column(
      children: [
        Row(
          children: [
            Text("Profile picture"),
            SizedBox(
              width: 10,
            ),
            GestureDetector(
              onTap: () {
                _updateProfileImage(context);
              },
              child: Text(
                'Edit',
                style: TextStyle(color: kAccentColor),
              ),
            )
          ],
        ),
        SizedBox(height: 10),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            imageUrl != null
                ? Image.network(
                    imageUrl,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  )
                : Image.asset(
                    'assets/images/sample_profile_pic.jpg',
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
          ],
        ),
      ],
    );
  }

  _buildBannerSection(String imageUrl, context) {
    return Column(
      children: [
        Row(
          children: [
            Text("Banner picture"),
            SizedBox(
              width: 10,
            ),
            GestureDetector(
              onTap: () {
                _updateBannerImage(context);
              },
              child: Text(
                'Edit',
                style: TextStyle(color: kAccentColor),
              ),
            )
          ],
        ),
        SizedBox(height: 10),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            imageUrl != null
                ? Image.network(
                    imageUrl,
                    width: kScreenWidth(context) - 16,
                    height: 120,
                    fit: BoxFit.cover,
                  )
                : Image.asset(
                    'assets/images/sample_banner.jpg',
                    width: kScreenWidth(context) - 16,
                    height: 120,
                    fit: BoxFit.cover,
                  ),
          ],
        ),
      ],
    );
  }

  _updateBannerImage(mContext) async {
    var file = await Utility.selectImage(mContext);
    Utility.showProgressAlertDialog(mContext, "Uploading banner image");
    String newImageUrl = await _firebaseServices.uploadImage(
        file, path.extension(file.path), "user_profiles");
    var userId = Utility.getUserId();
    FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .update({"banner_url": newImageUrl}).then((value) {
      Navigator.of(mContext).pop();
      Utility.showSnackBar(mContext, "Banner picture updated");
      var user = Provider.of<UserViewModel>(context, listen: false).user;
      user.bannerUrl = newImageUrl;
      Provider.of<UserViewModel>(context, listen: false).updateUser(user);
    }).onError((error, stackTrace) {
      // Navigator.of(mContext).pop();
      Utility.showSnackBar(mContext, "Failed setting banner image");
    });
  }

  _updateProfileImage(mContext) async {
    var file = await Utility.selectImage(mContext);
    Utility.showProgressAlertDialog(mContext, "Uploading profile image");
    String newImageUrl = await _firebaseServices.uploadImage(
        file, path.extension(file.path), "user_profiles");
    await userController
        .updateUserProfilePic(
            userId: Utility.getUserId(), imageUrl: newImageUrl)
        .then((value) {
      Navigator.pop(mContext);
      Utility.showSnackBar(mContext, "Profile image updated");
      var user = Provider.of<UserViewModel>(context, listen: false).user;
      user.profileUrl = newImageUrl;
      Provider.of<UserViewModel>(context, listen: false).updateUser(user);
    }).onError((error, stackTrace) {
      print(error);
      print(stackTrace);
      // Navigator.pop(context);
      Utility.showSnackBar(mContext, "Failed updating profile image");
    });
  }

  _updateRelationShipStatus(User user) {
    showDialog(
        context: context,
        builder: (mContext) {
          return AlertDialog(
            title: Text("Update relationship status"),
            content: ListView.builder(
              shrinkWrap: true,
              itemCount: _relationShipStatus.length,
              itemBuilder: (mContext, index) => ListTile(
                onTap: () async {
                  try {
                    user.relationShipStatus = _relationShipStatus[index];
                    Utility.showProgressAlertDialog(mContext, "Updating");
                    await userController.updateUser(user);
                    Utility.showSnackBar(
                        context, "Relationship status updated successfully");
                    Navigator.of(mContext).pop();
                    Navigator.of(mContext).pop();
                    Provider.of<UserViewModel>(context, listen: false)
                        .updateUser(user);
                  } catch (error, stk) {
                    print(error);
                    print(stk);
                    Navigator.of(mContext).pop();
                    Utility.showSnackBar(
                        context, "Relationship status update failed");
                  }
                },
                title: Text(_relationShipStatus[index]),
              ),
            ),
          );
        });
  }
}
