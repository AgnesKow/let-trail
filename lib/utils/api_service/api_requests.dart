import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:letstrail/models/models_exporter.dart';
import 'package:letstrail/utils/utils_exporter.dart';

class ApiRequests {
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static final FirebaseFirestore _firebaseFirestore =
      FirebaseFirestore.instance;

  static bool get isLoggedIn =>
      (_firebaseAuth.currentUser == null) ? false : true;

  static Future<UserModel> getLoggedInUser() async {
    UserModel? _user;
    await _firebaseFirestore
        .collection(Common.USERS_COLLECTION)
        .doc(_firebaseAuth.currentUser?.uid)
        .get()
        .then((user) {
      _user = UserModel.fromJson(user.data() as Map<String, dynamic>);
    });
    return _user!;
  }

  static Future<bool> loginUser(
      BuildContext context, String email, String uid) async {
    bool loginResponse = await _firebaseAuth
        .signInWithEmailAndPassword(email: email, password: uid)
        .then(
      (value) async {
        Persistent.persistUser(await getLoggedInUser());
        Common.showSuccessTopSnack(context, "Successfully logged in");
        return true;
      },
    ).onError((error, stackTrace) {
      return false;
    });
    return loginResponse;
  }

  static Future<void> registerUser(
      BuildContext context, String username, String email, String uid) async {
    _firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: uid)
        .then((value) async {
      await storeUserRecord(value.user!.uid, username, email, uid);
    }).onError((error, stackTrace) => throw (error!));
  }

  static Future<void> storeUserRecord(
      String id, String username, String email, String uid) async {
    DocumentReference usersReference =
        _firebaseFirestore.collection(Common.USERS_COLLECTION).doc(id);
    UserModel _user = UserModel(
      id: id,
      username: username,
      emailAddress: email,
      imageUrl: "",
    );
    Persistent.persistUser(_user);
    await usersReference.set(_user.toJson());
  }

  static Future<void> logout() async {
    if (_firebaseAuth.currentUser!.providerData[0].providerId == "google.com") {
      final googleSignIn = GoogleSignIn();
      try {
        await googleSignIn.disconnect();
      } on PlatformException catch (e) {
        // Common.print(e);
        await _firebaseAuth.signOut();
      }
    } else {
      await _firebaseAuth.signOut();
    }
  }

  static Future<void> sendResetPasswordCode(
      BuildContext context, String email) async {
    _firebaseAuth
        .sendPasswordResetEmail(email: email)
        .then(
          (value) => Common.showSuccessTopSnack(context,
              "Password reset email sent to your account. please open your mail-service to proceed"),
        )
        .onError(
          (error, stackTrace) => Common.showSuccessTopSnack(context,
              "No used with the associated Email Address found, please create account"),
        );
  }

  static Future<List<PlaceModel>> getAllPlaces() async {
    List<PlaceModel> places = [];
    await _firebaseFirestore
        .collectionGroup(Common.PLACES_COLLECTION)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        places.add(PlaceModel.fromJson(element.data()));
      });
    });
    return places;
  }

  static Future<List<PlaceModel>> getNearbyPlaces(LatLng currentLatLng) async {
    List<PlaceModel> nearbyPlaces = [];
    List<PlaceModel> places = await getAllPlaces();
    places.forEach((place) {
      double distanceInMeters = Geolocator.distanceBetween(
        currentLatLng.latitude,
        currentLatLng.longitude,
        place.coordinate.latitude,
        place.coordinate.longitude,
      );
      double distanceInKilometers = distanceInMeters / 1000;

      if (distanceInKilometers <= Common.NearbyPlacesDistanceInKilometers) {
        nearbyPlaces.add(place);
      }
    });
    return nearbyPlaces;
  }

  static Future<Position> determinePosition(BuildContext context) async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      Common.showTwoButtonDialog(
        context: context,
        dialogMessage:
            "Location services are disabled. Grant location permissions for this app to function properly, otherwise app will not function properly",
        primaryButtonText: "Okay",
        onPressed: () => Geolocator.openLocationSettings(),
        secondaryButtonText: "Not now",
      );
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        Common.showTwoButtonDialog(
          context: context,
          dialogMessage:
              "Grant location permissions for this app to function properly, otherwise app will not function properly",
          primaryButtonText: "Okay",
          onPressed: () => Geolocator.openLocationSettings(),
          secondaryButtonText: "Not now",
        );
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      Common.showTwoButtonDialog(
        context: context,
        dialogMessage:
            "Location permissions are permanently denied, we cannot request permissions. grant permission from settings, otherwise app will not function properly",
        primaryButtonText: "Okay",
        onPressed: () => Geolocator.openLocationSettings(),
        secondaryButtonText: "Not now",
      );
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  static Future<ThemeModel> getThemeByID(String id) async {
    return await _firebaseFirestore
        .collectionGroup(Common.THEMES_COLLECTION)
        .where("id", isEqualTo: id)
        .orderBy("title")
        .get()
        .then(
          (value) => ThemeModel.fromJson(
            value.docs.first.data(),
          ),
        );
  }

  // static getFavouriteItems(String userID) {
  //   return _firebaseFirestore
  //       .collection(Common.FOOD_ITEMS_COLLECTION)
  //       .where("is_favourite_by", arrayContains: userID)
  //       .orderBy("created_at", descending: true)
  //       .snapshots();
  // }
  //
  // static getFavouriteItemByUser(String userID, String itemID) {
  //   return _firebaseFirestore
  //       .collection(Common.FOOD_ITEMS_COLLECTION)
  //       .where("is_favourite_by", arrayContains: userID)
  //       .where("id", isEqualTo: itemID)
  //       .snapshots();
  // }
  //
  // static Future<void> processFavourite(
  //   String foodItemID,
  //   String userID,
  //   bool isFavourite,
  // ) async {
  //   _firebaseFirestore
  //       .collection(Common.FOOD_ITEMS_COLLECTION)
  //       .doc(foodItemID)
  //       .update({
  //     "is_favourite_by": isFavourite
  //         ? FieldValue.arrayRemove([userID])
  //         : FieldValue.arrayUnion([userID]),
  //   });
  // }

  // static Future<void> postFoodItem(
  //     String userID,
  //     String title,
  //     String category,
  //     double discountedPrice,
  //     double originalPrice,
  //     String description,
  //     String address,
  //     double latitude,
  //     double longitude,
  //     String imageURL,
  //     {required BuildContext context}) async {
  //   DocumentReference foodItemReference =
  //       _firebaseFirestore.collection(Common.FOOD_ITEMS_COLLECTION).doc();
  //   LocationModal _location = new LocationModal(
  //     address: address,
  //     latitude: latitude,
  //     longitude: longitude,
  //   );
  //   FoodItemModal foodItem = new FoodItemModal(
  //     title: title,
  //     category: category,
  //     createdAt: Timestamp.now(),
  //     lastActivityAt: Timestamp.now(),
  //     discountedPrice: discountedPrice,
  //     foodPostedBy: userID,
  //     id: foodItemReference.id,
  //     imageUrl: imageURL,
  //     originalPrice: originalPrice,
  //     description: description,
  //     location: _location,
  //   );
  //   await foodItemReference.set(foodItem.toJson());
  // }
  //
  // static Future<void> updateFoodItem(
  //     String userID,
  //     String foodItemID,
  //     String title,
  //     String category,
  //     double discountedPrice,
  //     double originalPrice,
  //     String description,
  //     String address,
  //     double latitude,
  //     double longitude,
  //     String imageURL,
  //     {required BuildContext context}) async {
  //   DocumentReference foodItemReference = _firebaseFirestore
  //       .collection(Common.FOOD_ITEMS_COLLECTION)
  //       .doc(foodItemID);
  //   LocationModal _location = new LocationModal(
  //     address: address,
  //     latitude: latitude,
  //     longitude: longitude,
  //   );
  //   FoodItemModal foodItem = new FoodItemModal(
  //     title: title,
  //     category: category,
  //     createdAt: Timestamp.now(),
  //     lastActivityAt: Timestamp.now(),
  //     discountedPrice: discountedPrice,
  //     foodPostedBy: userID,
  //     id: foodItemID,
  //     imageUrl: imageURL,
  //     originalPrice: originalPrice,
  //     description: description,
  //     location: _location,
  //   );
  //   await foodItemReference.update(foodItem.toJson());
  // }
  //
  static Future<String> uploadSelectedImage(File _image,
      {String subDirectory = Common.PROFILE_PICTURES}) async {
    Reference ref = FirebaseStorage.instance
        .ref()
        .child(Common.USERS_COLLECTION)
        .child(subDirectory)
        .child(UniqueKey().toString());

    UploadTask uploadTask = ref.putFile(_image);
    String imageURL = "";
    await uploadTask.then((value) async {
      imageURL = await value.ref.getDownloadURL();
    });
    return imageURL;
  }

  // static Future<void> deleteProduct(FoodItemModal foodItem,
  //     {required BuildContext context}) async {
  //   if (await ApiRequests.canDeleteFoodItem(foodItem)) {
  //     // deleting main product from FoodItems collection
  //     await _firebaseFirestore
  //         .collection(Common.FOOD_ITEMS_COLLECTION)
  //         .doc(foodItem.id)
  //         .delete();
  //
  //     // deleting orders with this product
  //     await _firebaseFirestore
  //         .collection(Common.ORDERS_COLLECTION)
  //         .where("food_item_id", isEqualTo: foodItem.id)
  //         .where("status", isEqualTo: Common.COMPLETED)
  //         .get()
  //         .then((value) {
  //       value.docs.forEach((order) async {
  //         OrderModal _order = OrderModal.fromJson(order.data());
  //         await _firebaseFirestore
  //             .collection(Common.ORDERS_COLLECTION)
  //             .doc(_order.id)
  //             .delete();
  //       });
  //     });
  //   } else
  //     Common.showErrorTopSnack(
  //       context,
  //       "Order is already in progress with this food item, after completing the order you can proceed with it.",
  //     );
  //   return;
  // }

  static Future<void> updateUserProfilePicture(
    UserModel user,
    String imageURL,
  ) async {
    DocumentReference userReference =
        _firebaseFirestore.collection(Common.USERS_COLLECTION).doc(user.id);
    await userReference.update({"image_url": imageURL});
    return;
  }

  static Future<void> markPlaceAsVisited(
      String heritageTrailID,
      String themeID,
      String placeImage,
      String placeID,
      String placeTagLine,
      String placeDescription,
      BuildContext context) async {
    DocumentReference visitedByReference = _firebaseFirestore
        .collection(Common.HERITAGE_TRAILS_COLLECTION)
        .doc(heritageTrailID)
        .collection(Common.THEMES_COLLECTION)
        .doc(themeID)
        .collection(Common.PLACES_COLLECTION)
        .doc(placeID)
        .collection(Common.VISITED_BY_COLLECTION)
        .doc();
    VisitedByModel visitedByModel = new VisitedByModel(
      id: visitedByReference.id,
      userId: Persistent.getUser.id,
      heritageTrailId: heritageTrailID,
      themeId: themeID,
      placeId: placeID,
      placeImage: placeImage,
      placeTagLine: placeTagLine,
      placeDescription: placeDescription,
      createdAt: Timestamp.now(),
    );
    await visitedByReference.set(visitedByModel.toJson());
    Common.showSuccessTopSnack(context, "Places marked as visited");
  }

  static Future<void> markPlaceAsLiked(String heritageTrailID, String themeID,
      String placeID, BuildContext context) async {
    DocumentReference likedByReference = _firebaseFirestore
        .collection(Common.HERITAGE_TRAILS_COLLECTION)
        .doc(heritageTrailID)
        .collection(Common.THEMES_COLLECTION)
        .doc(themeID)
        .collection(Common.PLACES_COLLECTION)
        .doc(placeID)
        .collection(Common.LIKED_BY_COLLECTION)
        .doc();
    LikedByModel likedByModel = new LikedByModel(
      id: likedByReference.id,
      userId: Persistent.getUser.id,
      heritageTrailId: heritageTrailID,
      themeId: themeID,
      placeId: placeID,
      createdAt: Timestamp.now(),
    );
    await likedByReference.set(likedByModel.toJson());
    ;
  }

  static Future<void> markPlaceAsUnLiked(String heritageTrailID, String themeID,
      String placeID, String likedDocID, BuildContext context) async {
    DocumentReference likedByReference = _firebaseFirestore
        .collection(Common.HERITAGE_TRAILS_COLLECTION)
        .doc(heritageTrailID)
        .collection(Common.THEMES_COLLECTION)
        .doc(themeID)
        .collection(Common.PLACES_COLLECTION)
        .doc(placeID)
        .collection(Common.LIKED_BY_COLLECTION)
        .doc(likedDocID);
    await likedByReference.delete();
  }

  static Future<List<PlaceModel>> getPlacesOfTheme(String id) async {
    List<PlaceModel> _places = [];
    await _firebaseFirestore
        .collectionGroup(Common.PLACES_COLLECTION)
        .where("theme_id", isEqualTo: id)
        .orderBy("name")
        .get()
        .then((places) {
      places.docs.forEach(
        (place) {
          _places.add(
            PlaceModel.fromJson(
              place.data(),
            ),
          );
        },
      );
    });
    return _places;
  }

  static Future<bool> isPlaceAlreadyVisited(String placeID) async {
    bool isPlaceAlreadyVisited = false;

    await _firebaseFirestore
        .collectionGroup(Common.VISITED_BY_COLLECTION)
        .where("user_id", isEqualTo: Persistent.getUser.id)
        .where("place_id", isEqualTo: placeID)
        .get()
        .then((value) {
      isPlaceAlreadyVisited = value.size == 1;
    });
    return isPlaceAlreadyVisited;
  }

  static Future<List<VisitedByModel>> getAllVisitedPlaces() async {
    List<VisitedByModel> visitedPlaces = [];
    await _firebaseFirestore
        .collectionGroup(Common.VISITED_BY_COLLECTION)
        .where("user_id", isEqualTo: Persistent.getUser.id)
        .orderBy("created_at")
        .get()
        .then((places) {
      places.docs.forEach((place) {
        visitedPlaces.add(
          VisitedByModel.fromJson(place.data()),
        );
      });
    });
    return visitedPlaces;
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> isPlaceAlreadyLiked(
      String placeID) {
    return _firebaseFirestore
        .collectionGroup(Common.LIKED_BY_COLLECTION)
        .where("user_id", isEqualTo: Persistent.getUser.id)
        .where("place_id", isEqualTo: placeID)
        .snapshots();
  }

  static Future<List<PlaceModel>> getLikedPlaces() async {
    List<PlaceModel> places = [];
    await _firebaseFirestore
        .collectionGroup(Common.LIKED_BY_COLLECTION)
        .where("user_id", isEqualTo: Persistent.getUser.id)
        .orderBy("created_at")
        .get()
        .then((_likedBys) async {
      await Future.forEach(_likedBys.docs,
          (QueryDocumentSnapshot<Map<String, dynamic>> _likedBy) async {
        LikedByModel likedBy = LikedByModel.fromJson(_likedBy.data());
        PlaceModel place = await getPlaceByID(likedBy.placeId);
        places.add(place);
      });
    });
    return places;
  }

  static Future<PlaceModel> getPlaceByID(String placeID) async {
    PlaceModel? place;
    await _firebaseFirestore
        .collectionGroup(Common.PLACES_COLLECTION)
        .where("id", isEqualTo: placeID)
        .orderBy("name")
        .get()
        .then((_places) {
      PlaceModel _place = PlaceModel.fromJson(_places.docs.first.data());
      place = _place;
    });
    return place!;
  }

  static Future<void> publishOrUpdateJournal(
      String title, String description, String journalThumbnailURL,
      {JournalModel? journal}) async {
    DocumentReference journalReference = _firebaseFirestore
        .collection(Common.USERS_COLLECTION)
        .doc(Persistent.getUser.id)
        .collection(Common.JOURNALS_COLLECTION)
        .doc(journal?.id);

    JournalModel _journal = new JournalModel(
      id: journalReference.id,
      title: title,
      description: description,
      thumbnail: journalThumbnailURL,
      createdAt: journal != null ? journal.createdAt : Timestamp.now(),
      lastActivityAt: Timestamp.now(),
      publisherId: Persistent.getUser.id,
    );

    await journalReference.set(_journal.toJson());
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getJournals(
      String journalsKey) {
    if (journalsKey == Common.ALL) {
      return _firebaseFirestore
          .collectionGroup(Common.JOURNALS_COLLECTION)
          .orderBy("title")
          .orderBy("last_activity_at")
          .snapshots();
    } else {
      return _firebaseFirestore
          .collection(Common.USERS_COLLECTION)
          .doc(Persistent.getUser.id)
          .collection(Common.JOURNALS_COLLECTION)
          .snapshots();
    }
  }

  static getUserByID(String publisherId) {
    return _firebaseFirestore
        .collection(Common.USERS_COLLECTION)
        .doc(publisherId)
        .snapshots();
  }

  static Future<UserModel> updateUser(String imageURL) async {
    UserModel user = UserModel(
      id: Persistent.getUser.id,
      username: Persistent.getUser.username,
      emailAddress: Persistent.getUser.emailAddress,
      imageUrl: imageURL,
    );
    await _firebaseFirestore
        .collection(Common.USERS_COLLECTION)
        .doc(Persistent.getUser.id)
        .update(user.toJson());
    return user;
  }

  static Future<List<PlaceModel>> getPlaceByName(String searchFor) async {
    List<PlaceModel> places = [];
    await _firebaseFirestore
        .collectionGroup(Common.PLACES_COLLECTION)
        .where("name", isGreaterThanOrEqualTo: searchFor)
        .orderBy("name")
        .get()
        .then((_places) {
      _places.docs.forEach((_place) {
        places.add(PlaceModel.fromJson(_place.data()));
      });
    }).onError((error, stackTrace) {
      print(error.toString());
    });
    return places;
  }

  // static Future<bool> googleLogin() async {
  //   try {
  //     GoogleSignInAccount? googleSignInAccount = await GoogleSignIn().signIn();
  //     GoogleSignInAuthentication googleSignInAuthentication =
  //         await googleSignInAccount!.authentication;
  //     AuthCredential authCredential = GoogleAuthProvider.credential(
  //       idToken: googleSignInAuthentication.idToken,
  //       accessToken: googleSignInAuthentication.accessToken,
  //     );
  //     await _firebaseAuth.signInWithCredential(authCredential);
  //     if (!await ApiRequests.userRecordExistInFirestore(
  //         Common.USERS_COLLECTION, _firebaseAuth.currentUser!.uid)) {
  //       User currentUser = _firebaseAuth.currentUser!;
  //       UserModel UserModel = UserModel(
  //         id: currentUser.uid,
  //         username: googleSignInAccount.displayName!,
  //         emailAddress: googleSignInAccount.email,
  //         imageUrl: googleSignInAccount.photoUrl,
  //       );
  //
  //       await _firebaseFirestore
  //           .collection(Common.USERS_COLLECTION)
  //           .doc(currentUser.uid)
  //           .set(UserModel.toJson());
  //     }
  //     return true;
  //   } catch (e) {
  //     throw (e);
  //   }
  // }

  // static userRecordExistInFirestore(String collection, String userID) async {
  //   try {
  //     var reference =
  //         await _firebaseFirestore.collection(collection).doc(userID).get();
  //     return reference.exists;
  //   } catch (e) {
  //     throw (e);
  //   }
  // }
}
