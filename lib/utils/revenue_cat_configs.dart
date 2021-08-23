class RevenueCatConfigs {
  static const Map<String, dynamic> packagesInfo = {
    "10 social points": {"isSubscription": false, "socialPoints": 10},
    "20 social points": {
      "isSubscription": false,
      "socialPoints": 20,
    },
    "50 social points": {
      "isSubscription": false,
      "socialPoints": 50,
    },
    "100 social points": {
      "isSubscription": false,
      "socialPoints": 100,
    },
    "200 social points": {
      "isSubscription": false,
      "socialPoints": 200,
    },
    "15 social points a month": {
      "isSubscription": true,
      "socialPoints": 15,
      "entitlement_id": "level 1"
    },
    "30 social points a month": {
      "isSubscription": true,
      "socialPoints": 30,
      "entitlement_id": "level 2"

    },
    "75 social points a month": {
      "isSubscription": true,
      "socialPoints": 75,
      "entitlement_id": "level 3"

    },
    "150 social points a month": {
      "isSubscription": true,
      "socialPoints": 150,
      "entitlement_id": "level 4"
    },
    "300 social points a month": {
      "isSubscription": true,
      "socialPoints": 300,
      "entitlement_id": "level 5"
    },
  };

  static const entitlementInfo = {
    "level 1" : "15 social points a month",
    "level 2" : "30 social points a month",
    "level 3" : "75 social points a month",
    "level 4" : "150 social points a month",
    "level 5" : "300 social points a month"
  };
}
