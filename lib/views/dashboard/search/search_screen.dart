import 'dart:math';

import 'package:flutter/material.dart';
import 'package:letstrail/utils/utils_exporter.dart';
import 'package:lottie/lottie.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String searchFor = "";

  SpeechToText _speechToText = SpeechToText();
  String _lastWords = '';

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  /// This has to happen only once per app
  void _initSpeech() async {
    await _speechToText.initialize().then((value) {
      print("PASSED:" + value.toString());
    }).onError((error, stackTrace) {
      print("Error:" + error.toString());
    });
    setState(() {});
  }

  /// Each time to start a speech recognition session
  void _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult);
    setState(() {});
  }

  @override
  void dispose() {
    _stopListening();
    super.dispose();
  }

  /// Manually stop the active speech recognition session
  /// Note that there are also timeouts that each platform enforces
  /// and the SpeechToText plugin supports setting timeouts on the
  /// listen method.
  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  void _onSpeechResult(SpeechRecognitionResult result) {
    print(result.recognizedWords);
    setState(() {
      _lastWords = result.recognizedWords;
      searchFor = _lastWords;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 5.0,
                horizontal: 15.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Wrap(
                        direction: Axis.vertical,
                        children: [
                          Text(
                            "Discover Heritage\nPlaces",
                            style: TextStyle(
                              color: AppColors.appBlackColor,
                              fontSize: 28.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            width: 90.0,
                            child: Divider(
                              color: AppColors.appGreyColor,
                              thickness: 1.5,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      RoundIconButton(
                        customChild: Lottie.asset(
                          "${Common.assetsAnimations}loading.json",
                          width: 60.0,
                        ),
                        padding: EdgeInsets.zero,
                      ),
                    ],
                  ),
                  const SizedBox(height: 15.0),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.appWhiteColor,
                      borderRadius: BorderRadius.circular(15.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.25),
                          blurRadius: 8.0,
                          spreadRadius: 8.0,
                          offset: const Offset(1, 0),
                        ),
                      ],
                      border: Border.all(
                        width: 0.25,
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: TextFormField(
                      controller: _searchController,
                      keyboardType: TextInputType.text,
                      autocorrect: false,
                      enableSuggestions: true,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        focusedErrorBorder: InputBorder.none,
                        isDense: true,
                        labelText: "Search for places",
                        labelStyle: const TextStyle(
                          fontSize: 15.0,
                          color: AppColors.appBlackColor,
                        ),
                        suffixIcon: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(
                              height: 30.0,
                              child: VerticalDivider(
                                thickness: 1,
                                color: AppColors.appGreyColor,
                              ),
                            ),
                            const SizedBox(width: 5.0),
                            InkWell(
                              onTap: () =>
                                  _search(_searchController.text.trim()),
                              child: Icon(
                                Icons.search,
                                size: 22.0,
                                color: Colors.grey.withOpacity(0.90),
                              ),
                            ),
                            const SizedBox(width: 5.0),
                            InkWell(
                              onTap: () => _startListening(),
                              child: Icon(
                                Icons.mic_none,
                                size: 22.0,
                                color: AppColors.appGreyColor.withOpacity(0.85),
                              ),
                            ),
                          ],
                        ),
                      ),
                      style: const TextStyle(
                        color: AppColors.appBlackColor,
                        fontSize: 18.0,
                        // fontFamily: "DINNextLTPro_Medium",
                      ),
                      textAlign: TextAlign.start,
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 5.0),
            Expanded(
              flex: 4,
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            (searchFor == "")
                                ? const SizedBox.shrink()
                                : Text(
                                    "Showing results for \"$searchFor\"",
                                    style: TextStyle(
                                      color: AppColors.textColor,
                                      fontSize: 14.0,
                                    ),
                                  ),
                            const Divider(),
                            searchFor == ""
                                ? const SizedBox.shrink()
                                : SizedBox(
                                    height: 350.0,
                                    child: FuturePlaceWithShimmerLoading(
                                      future:
                                          ApiRequests.getPlaceByName(searchFor),
                                    ),
                                  ),
                            searchFor == ""
                                ? const SizedBox.shrink()
                                : const SizedBox(height: 20.0),
                            SizedBox(
                              height: 210.0,
                              child: GlassmorphicBGImageCard(
                                imageURL:
                                    "${Common.assetsImages}singapore_banner.jpg",
                                cardTitle:
                                    "Explore Heritage Sites of\nSingapore",
                                cardDescription:
                                    "A concerted effort to preserve our heritage is a vital link to our cultural, educational and aesthetics.",
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            "My Wishlist",
                            style: TextStyle(
                              color: AppColors.appBlackColor,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 15.0),
                          SizedBox(
                            height: 350.0,
                            child: FuturePlaceWithShimmerLoading(
                              future: ApiRequests.getLikedPlaces(),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            "Recommendations",
                            style: TextStyle(
                              color: AppColors.appBlackColor,
                              fontSize: 20.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 5.0),
                          SizedBox(
                            height: 280.0,
                            child: FuturePlaceWithShimmerLoading(
                              themeID: getRandomThemeID(),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String getRandomThemeID() {
    Random random = Random();
    int randomTheme = random.nextInt(3); // from 0 - 2
    return Common.themes[randomTheme];
  }

  void _search(String search) {
    searchFor = search;
    setState(() {});
  }
}
