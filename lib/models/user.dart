import 'package:hive/hive.dart';

part 'user.g.dart';

@HiveType(typeId: 1)
class User{
  @HiveField(0)
  String uid;
  @HiveField(1)
  String firstName;
  @HiveField(2)
  String lastName;
  @HiveField(3)
  String email;
  @HiveField(4)
  String password;
  @HiveField(5)
  String bio;
  @HiveField(6)
  String paymentMethod;
  String bannerUrl;
  String profileUrl;
  String relationShipStatus;

  User({this.uid, this.firstName, this.lastName, this.email, this.password, this.bio, this.paymentMethod, this.bannerUrl, this.profileUrl, this.relationShipStatus});

  factory User.fromJson(Map<String, dynamic> json){
    return User(
      firstName: json['first_name'],
      lastName: json['last_name'],
      email: json['email'],
      bio: json['bio'],
      paymentMethod: json['payment_method'],
      bannerUrl: json['banner_url'],
      profileUrl: json['profile_url'],
      relationShipStatus: json['relationship_status']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'first_name': this.firstName,
      'last_name': this.lastName,
      'email': this.email,
      'bio': this.bio,
      'payment_method': this.paymentMethod,
      'banner_url': this.bannerUrl,
      'profile_url': this.profileUrl,
      'relationship_status': this.relationShipStatus
    };
  }
}