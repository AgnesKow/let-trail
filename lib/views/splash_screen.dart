import 'package:flutter/material.dart';
import 'package:letstrail/utils/utils_exporter.dart';
import 'package:letstrail/views/views_exporter.dart';
import 'package:lottie/lottie.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    processSplash();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appWhiteColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(),
          Column(
            children: [
              Image.asset(
                "${Common.assetsIcons}application_icon.jpg",
              ),
              Lottie.asset(
                "${Common.assetsAnimations}loading.json",
                height: 140.0,
                width: 140.0,
              ),
            ],
          ),
          const SizedBox(),
        ],
      ),
    );
  }

  void processSplash() async {
    //check firebase auth logged in status
    bool isLoggedIn = await ApiRequests.isLoggedIn;

    Future.delayed(
      const Duration(seconds: 5),
      () {
        isLoggedIn
            ? Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => DashboardScreen(),
                ),
                (route) => false)
            : Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => Login(),
                ),
                (route) => false);
      },
    );
  }
}
