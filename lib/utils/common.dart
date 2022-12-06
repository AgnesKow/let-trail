import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:letstrail/models/models_exporter.dart';
import 'package:letstrail/models/places_colors_model.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:url_launcher/url_launcher.dart';

import 'utils_exporter.dart';

class Common {
  // firebase constants
  static const String HERITAGE_TRAILS_COLLECTION = "HeritageTrails";
  static const String THEMES_COLLECTION = "Themes";
  static const String PLACES_COLLECTION = "Places";
  static const String VISITED_BY_COLLECTION = "VisitedBy";
  static const String LIKED_BY_COLLECTION = "LikedBy";
  static const String USERS_COLLECTION = "Users";
  static const String JOURNALS_COLLECTION = "Journals";
  static const String PROFILE_PICTURES = "ProfilePictures";
  static const String JOURNALS_PICTURES = "JournalsPictures";

  // persistent constants
  static const String PersistentLoggedUser = "PersistentLoggedUser";

  static String applicationName = "Let's Trail";

  static int NearbyPlacesDistanceInKilometers = 10;
  static double mapDefaultZoom = 15.0746;
  static List<PlacesAndColorsModel> placesAndColors = [
    PlacesAndColorsModel(
      markerColor: BitmapDescriptor.hueViolet,
      polylineColor: Colors.purple,
      themeId: "2t0jd1JZxZ6sq2mZaVDJ",
    ),
    PlacesAndColorsModel(
      markerColor: BitmapDescriptor.hueOrange,
      polylineColor: Colors.brown,
      themeId: "gnaQTGgNjG1Gr8pU5Z80",
    ),
    PlacesAndColorsModel(
      markerColor: BitmapDescriptor.hueBlue,
      polylineColor: Colors.blueAccent,
      themeId: "r4saq3rugBr0eB6kMLkB",
    ),
  ];

  // themes so we can get random theme for recommendation // theme ids from firestore hardcoded
  static List<String> themes = [
    "2t0jd1JZxZ6sq2mZaVDJ",
    "gnaQTGgNjG1Gr8pU5Z80",
    "r4saq3rugBr0eB6kMLkB",
  ];

  // assets locations
  static String assetsImages = "assets/images/";
  static String assetsIcons = "assets/icons/";
  static String assetsAnimations = "assets/animations/";

  // google map api key
  static String googleMapAPIKey = "AIzaSyAvHnRDi9zPniQ6oemuhQyFdoNo3qzoy5o";

  static final GlobalKey<ScaffoldState> drawerScaffoldKey =
      GlobalKey<ScaffoldState>();

  static List<EmojiFlag> flags = [
    EmojiFlag(value: "germany", emoji: "🇩🇪"),
    EmojiFlag(value: "peranakan", emoji: "🇨🇳"),
  ];

  static List<LocationInsights> locationInsights = [
    LocationInsights(
      title: "(2.2km): 40 min; on foot or 30 min; walk and bus",
      color: Colors.green,
      image: "${Common.assetsIcons}distance.png",
    ),
    LocationInsights(
      title: "Present in community of Germany",
      color: Colors.red,
      image: "${Common.assetsIcons}community.png",
    ),
    LocationInsights(
      title:
          "Checkout the official website with the details of the location and history",
      color: const Color(0XFF57CEFB),
      image: "${Common.assetsIcons}web.png",
    ),
    LocationInsights(
      title: "Was discovered/Renovated in the year 2000 and open for public",
      color: const Color(0XFFE6497E),
      image: "${Common.assetsIcons}year.png",
    ),
  ];

  static String SELF = "SELF";
  static String ALL = "ALL";

  static List<FilterJournals> journalFilters = [
    FilterJournals(key: SELF, value: "My Publications only"),
    FilterJournals(key: ALL, value: "All publishers"),
  ];

  static String getEmojiFromCountryName(String _country) {
    String _emoji = "";
    for (var flag in Common.flags) {
      if (flag.value.toLowerCase() == _country.toLowerCase()) {
        _emoji = flag.emoji;
      }
    }
    return _emoji;
  }

  static showOnePrimaryButtonDialog({
    required BuildContext context,
    String? title,
    String? dialogMessage,
    Widget? child,
    bool isDismissible = true,
    String primaryButtonText = "Okay",
    VoidCallback? onPressed,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: isDismissible,
      builder: (context) => AlertDialog(
        title: Text(
          title ?? Common.applicationName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        content: child ?? Text(dialogMessage!),
        actions: <Widget>[
          PrimaryButton(
            onPressed: onPressed ?? () => Navigator.pop(context),
            buttonText: primaryButtonText,
            fontSize: 14.0,
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 8.0,
            ),
          ),
        ],
      ),
    );
  }

  static showTwoButtonDialog({
    required BuildContext context,
    String? dialogMessage,
    Widget? child,
    bool isDismissible = true,
    String primaryButtonText = "Accept",
    String secondaryButtonText = "Decline",
    VoidCallback? onPressed,
    VoidCallback? secondaryOnPressed,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: isDismissible,
      builder: (context) => AlertDialog(
        title: Text(
          Common.applicationName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        content: child ?? Text(dialogMessage!),
        actions: <Widget>[
          InkWell(
            onTap: secondaryOnPressed ?? () => Navigator.pop(context),
            child: Text(
              secondaryButtonText,
              style: const TextStyle(
                color: AppColors.textColor,
                fontSize: 14.0,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 8.0),
          PrimaryButton(
            onPressed: onPressed ?? () => Navigator.pop(context),
            buttonText: primaryButtonText,
            fontSize: 14.0,
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 8.0,
            ),
          ),
        ],
      ),
    );
  }

  // navigation functions
  static void push(BuildContext context, Widget toScreen) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => toScreen));
  }

  static void pushAndRemoveUntil(BuildContext context, Widget toScreen) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => toScreen),
      (route) => false,
    );
  }

  static void pop(BuildContext context) {
    Navigator.of(context).pop();
  }

  static void showErrorTopSnack(BuildContext context, String message) {
    showTopSnackBar(
      context,
      CustomSnackBar.error(
        message: message,
      ),
    );
  }

  static void showSuccessTopSnack(BuildContext context, String message) {
    showTopSnackBar(
      context,
      CustomSnackBar.info(
        message: message,
      ),
    );
  }

  static String memberSince() {
    List<String> months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];

    DateTime? createdAt =
        FirebaseAuth.instance.currentUser?.metadata.creationTime;
    if (createdAt != null) {
      return "${months.elementAt(createdAt.month)} ${createdAt.year}";
    } else
      return "";
  }

  static Future<void> launchURL(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw 'Could not launch';
    }
  }

  static Future<void> openMap(
      BuildContext context, double lat, double lng) async {
    String url = '';
    String urlAppleMaps = '';
    if (Platform.isAndroid) {
      url = 'https://www.google.com/maps/search/?api=1&query=$lat,$lng';
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url));
      } else {
        throw 'Could not launch $url';
      }
    } else {
      urlAppleMaps = 'https://maps.apple.com/?q=$lat,$lng';
      url = 'comgooglemaps://?saddr=&daddr=$lat,$lng&directionsmode=driving';
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url));
      } else if (await canLaunchUrl(Uri.parse(urlAppleMaps))) {
        await launchUrl(Uri.parse(urlAppleMaps));
      } else {
        throw 'Could not launch $url';
      }
    }
  }

  // print -- log in debug mode only
  // static void print(dynamic message) {
  //   if (kDebugMode) {
  //     print(message);
  //   }
  // }
}
