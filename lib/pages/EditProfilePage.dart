import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_start/controllers/user_controller.dart';
import 'package:social_start/models/user.dart' as usr;
import 'package:social_start/services/firebase_services.dart';
import 'package:social_start/utils/constants.dart';
import 'package:social_start/utils/utility.dart';
import 'package:path/path.dart' as path;

class EditProfilePage extends StatefulWidget {
  static final String pageName = "editProfile";

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final Stream<DocumentSnapshot> _userStream = FirebaseFirestore.instance
      .collection("users")
      .doc(Utility.getUserId())
      .snapshots();

  FirebaseServices _firebaseServices = FirebaseServices();

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

  List<String> _paymentOptions = [
    "Paypal",
    "Visa",
  ];
  usr.User  user = usr.User();
  // usr.User user = usr.User();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  UserController userController = new UserController();
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        titleTextStyle: TextStyle(color: Colors.white),
        title: Text("Edit Profile"),
        centerTitle: true,
        actions: [IconButton(icon: Icon(Icons.check), onPressed: () {
          if(_formKey.currentState.validate()){
            print(user.toJson());
            Utility.showProgressAlertDialog(context, "Updating...");
            FirebaseFirestore.instance.collection("users")
                .doc(Utility.getUserId())
                .update(
                user.toJson()
            ).then((value) {
              Navigator.of(context).pop();
              Utility.showSnackBar(context, "Profile updated");
              userController.updateUserPosts(Utility.getUserId(), user);
            }).onError((error, stackTrace) {
              Navigator.of(context).pop();
              Utility.showSnackBar(context, "Failed try again");
            });
          }
        })],
      ),
      body: SingleChildScrollView(
        child: StreamBuilder(
            stream: _userStream,
            builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Something went wrong');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Text("Loading");
              }

              var userDoc = snapshot.data;

              print(FirebaseAuth.instance.currentUser.uid);
              print(userDoc);


              user = usr.User(
                    firstName: userDoc.get("first_name"),
                    lastName: userDoc.get("last_name"),
                    bio: userDoc.get("bio"),
                    email: userDoc.get("email"),
                    paymentMethod: userDoc.get("payment_method"),
                    bannerUrl: userDoc.get("banner_url"),
                    profileUrl: userDoc.get("profile_url"),
                    relationShipStatus: userDoc.get("relationship_status")
                );
              print(user.toJson());
              return Column(
                children: [
                  Container(
                    color: Colors.white,
                    width: kScreenWidth(context),
                    height: 210,
                    child: Stack(
                      children: [
                        Stack(
                          children: [
                            user.bannerUrl != null ?
                                CachedNetworkImage(imageUrl: user.bannerUrl,
                                  fit: BoxFit.cover,
                                  height: 150,
                                  width: kScreenWidth(context),
                                ):
                            Image.asset(
                              'assets/images/sample_banner.jpg',
                              fit: BoxFit.cover,
                              height: 150,
                              width: kScreenWidth(context),
                            ),
                            Container(
                              alignment: Alignment.topCenter,
                              width: kScreenWidth(context),
                              height: 150,
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(.4),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(top: 30.0),
                                child: GestureDetector(
                                  onTap: () async {
                                    var file =
                                        await Utility.selectImage(context);
                                    Utility.showProgressAlertDialog(context, "Uploading banner image");
                                    String newImageUrl = await _firebaseServices.uploadImage(file, path.extension(file.path), "user_profiles");
                                    FirebaseFirestore.instance.collection("users").doc(Utility.getUserId()).update(
                                        {
                                          "banner_url": newImageUrl
                                        })
                                    .then((value) {
                                      Navigator.of(context).pop();
                                      Utility.showSnackBar(context, "Banner image updated");
                                    })
                                    .onError((error, stackTrace){
                                      Navigator.of(context).pop();
                                      Utility.showSnackBar(context, "Failed updating banner image");
                                    });
                                  },
                                  child: Icon(
                                    Icons.camera_alt,
                                    color: Colors.white54,
                                    size: 30.0,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Stack(
                            children: [
                              Container(
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(100)),
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 5,
                                    )),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child:
                                  user.profileUrl != null ?
                                  CachedNetworkImage(imageUrl: user.profileUrl,
                                    fit: BoxFit.cover,
                                    height: 150,
                                    width: kScreenWidth(context),
                                  ):Image.asset(
                                    'assets/images/sample_profile_pic.jpg',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Container(
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(.4),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(100)),
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 5,
                                    )),
                                child: GestureDetector(
                                  onTap: ()async{
                                    var file =
                                        await Utility.selectImage(context);
                                    Utility.showProgressAlertDialog(context, "Uploading profile image");
                                    String newImageUrl = await _firebaseServices.uploadImage(file, path.extension(file.path), "user_profiles");
                                    FirebaseFirestore.instance.collection("users").doc(Utility.getUserId()).update(
                                        {
                                          "profile_url": newImageUrl
                                        })
                                        .then((value) {
                                      Navigator.of(context).pop();
                                      Utility.showSnackBar(context, "Profile picture updated");
                                    })
                                        .onError((error, stackTrace){
                                      Navigator.of(context).pop();
                                      Utility.showSnackBar(context, "Failed setting profile image");
                                    });
                                  },
                                  child: Icon(
                                    Icons.camera_alt,
                                    color: Colors.white54,
                                    size: 40.0,
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: "First name",
                              enabledBorder: _enabledBorder(),
                              focusedBorder: _focusedBorder(),
                              errorBorder: _errorBorder(),
                                focusedErrorBorder: _focusedBorder()
                            ),
                            maxLines: 1,
                            onChanged: (value){
                                user.firstName = value;
                                print(user.toJson());
                            },
                            initialValue: user.firstName,
                            validator: _requiredValidator()
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: "Last name",
                              enabledBorder: _enabledBorder(),
                              focusedBorder: _focusedBorder(),
                              errorBorder: _errorBorder(),
                              focusedErrorBorder: _focusedBorder()
                            ),
                            maxLines: 1,
                            onChanged: (value){
                                user.lastName = value;
                            },
                            validator: _requiredValidator(),
                            initialValue: user.lastName,
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: "Bio",
                              enabledBorder: _enabledBorder(),
                              focusedBorder: _focusedBorder(),
                                errorBorder: _errorBorder(),
                                focusedErrorBorder: _focusedBorder()

                            ),
                            maxLength: 150,
                            onChanged: (value){
                                user.bio = value;
                            },
                            validator: _requiredValidator(),
                            initialValue: user.bio,
                          ),
                          SizedBox(height: 10.0),
                          DropdownButtonFormField<String>(
                            items: _relationShipStatus
                                .map((e) => DropdownMenuItem(
                                      child:  Text(e),
                                      value: e,
                                    ))
                                .toList(),
                            decoration: InputDecoration(
                              labelText: "Relationship status",
                              enabledBorder: _enabledBorder(),
                              focusedBorder: _focusedBorder(),
                              errorBorder: _errorBorder(),
                                focusedErrorBorder: _focusedBorder()

                            ),
                            value: user.relationShipStatus,
                            onChanged: (value) {
                                user.relationShipStatus = value;
                            },
                            validator: (value){
                              if(value.isEmpty || value == null){
                                return "Field required";
                              }
                              return null;
                            },

                          ),
                          SizedBox(height: 20),
                          DropdownButtonFormField<String>(
                            items: _paymentOptions
                                .map((e) => DropdownMenuItem(
                                      child: Text(e),
                                      value: e,
                                    ))
                                .toList(),
                            decoration: InputDecoration(
                              labelText: "Payment method",
                              enabledBorder: _enabledBorder(),
                              focusedBorder: _focusedBorder(),
                              errorBorder: _errorBorder(),
                                focusedErrorBorder: _focusedBorder()

                            ),
                            value: user.paymentMethod,
                            onChanged: (value) {
                                user.paymentMethod = value;
                            },
                          )
                        ],
                      ),
                    ),
                  )
                ],
              );
            }),
      ),
    );
  }

  _enabledBorder() {
    return OutlineInputBorder(borderSide: BorderSide(color: kBorderColor));
  }

  _focusedBorder() {
    return OutlineInputBorder(
        borderSide: BorderSide(color: kPrimaryColor, width: 2.0));
  }

  _errorBorder() {
    return OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red, width: 2.0));
  }
  _requiredValidator(){
    return (value){
      if(value.isEmpty){
        return "Field required";
      }
      return null;
    };
  }
}
