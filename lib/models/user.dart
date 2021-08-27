import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

part 'user.g.dart';

@HiveType(typeId: 1)
class User {
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
  int totalFollowing;
  int totalFollowers;
  bool blocked = false;
  List<dynamic> likedPosts;
  List<dynamic> following;
  List<dynamic> followers;
  SocialPoint socialPoint = SocialPoint(
    permanent: 0,
    daily: 0,
  );
  Map<String, SubscriptionDetail> subscriptions = {};
  int likes = 0;
  int views = 0;
  double balance = 0.0;

  User({
    this.uid,
    this.firstName,
    this.lastName,
    this.email,
    this.password,
    this.bio,
    this.paymentMethod,
    this.bannerUrl,
    this.profileUrl,
    this.relationShipStatus,
    this.likedPosts = const [],
    this.totalFollowers = 0,
    this.totalFollowing = 0,
    this.followers = const [],
    this.following = const [],
    this.socialPoint,
    this.blocked = false,
    this.subscriptions = const {},
    this.likes = 0,
    this.views = 0,
    this.balance = 0.0,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        firstName: json['first_name'],
        lastName: json['last_name'],
        email: json['email'],
        bio: json['bio'],
        paymentMethod: json['payment_method'],
        bannerUrl: json['banner_url'],
        profileUrl: json['profile_url'],
        relationShipStatus: json['relationship_status'],
        likedPosts: json['liked_posts'],
        totalFollowers: json['total_followers'],
        totalFollowing: json['total_following'],
        followers: json['followers'],
        following: json['following'],
        socialPoint: SocialPoint.fromJson(json['social_point']),
        blocked: json['blocked'],
        subscriptions: json['subscriptions'] != null
            ? (json['subscriptions'] as Map<String, dynamic>).map(
                (key, value) => MapEntry(
                    key,
                    SubscriptionDetail(
                        entitlementId: value['entitlement_id'],
                        socialPoint: value['social_point'],
                        subscribedAt: value['subscribed_at'],
                        updatedAt: value['updated_at'])))
            : null,
        likes: json['likes'],
        views: json['views'],
        balance: double.parse(json['balance'].toString()));
  }

  factory User.forPost(Map<String, dynamic> json) {
    return User(
      firstName: json['first_name'],
      lastName: json['last_name'],
      email: json['email'],
      bio: json['bio'],
      paymentMethod: json['payment_method'],
      bannerUrl: json['banner_url'],
      profileUrl: json['profile_url'],
      relationShipStatus: json['relationship_status'],
      likedPosts: json['liked_posts'],
      totalFollowers: json['total_followers'],
      totalFollowing: json['total_following'],
      followers: json['followers'],
      following: json['following'],
    );
  }

  Map<String, dynamic> toJsonForPost() {
    return {
      'first_name': this.firstName,
      'last_name': this.lastName,
      'email': this.email,
      'bio': this.bio,
      'payment_method': this.paymentMethod,
      'banner_url': this.bannerUrl,
      'profile_url': this.profileUrl,
      'relationship_status': this.relationShipStatus,
      'total_followers': this.totalFollowers,
      'total_following': this.totalFollowing,
      'followers': this.followers,
      'following': this.following,
      'liked_posts': this.likedPosts,
      'blocked': this.blocked,
    };
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
      'relationship_status': this.relationShipStatus,
      'total_followers': this.totalFollowers,
      'total_following': this.totalFollowing,
      'followers': this.followers,
      'following': this.following,
      'liked_posts': this.likedPosts,
      'social_point': this.socialPoint.toJson(),
      'blocked': this.blocked,
      'first_name_lowercase': this.firstName.toLowerCase(),
      'last_name_lowercase': this.lastName.toLowerCase(),
      'subscriptions':
          this.subscriptions.map((key, value) => MapEntry(key, value.toJson())),
      'likes': this.likes,
      'views': this.views,
      'balance': this.balance,
    };
  }
}

class SocialPoint {
  int daily = 0;
  int permanent = 0;

  SocialPoint({this.daily = 0, this.permanent = 0});

  Map<String, dynamic> toJson() {
    return {
      "daily": daily,
      "total": permanent,
    };
  }

  factory SocialPoint.fromJson(Map<String, dynamic> json) {
    print("socialPointJson: $json");
    return SocialPoint(
      daily: json['daily'],
      permanent: json['total'],
    );
  }
}

class SubscriptionDetail {
  final int socialPoint;
  final String entitlementId;
  final Timestamp subscribedAt;
  final Timestamp updatedAt;

  const SubscriptionDetail(
      {@required this.socialPoint,
      @required this.subscribedAt,
      @required this.updatedAt,
      @required this.entitlementId});

  Map<String, dynamic> toJson() {
    return {
      "social_point": socialPoint,
      "subscribed_at": subscribedAt,
      "updated_at": updatedAt,
      "entitlement_id": entitlementId,
    };
  }

  factory SubscriptionDetail.fromJson(Map<String, dynamic> json) {
    return SubscriptionDetail(
        entitlementId: json['entitlement_id'],
        socialPoint: json['social_point'],
        subscribedAt: json['subscribed_at'],
        updatedAt: json['updated_at']);
  }
}
