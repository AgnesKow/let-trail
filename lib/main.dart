import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:letstrail/views/views_exporter.dart';

import 'utils/utils_exporter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: Common.applicationName,
      home: Splash(),
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.appWhiteColor,
        appBarTheme: const AppBarTheme(
          color: AppColors.primaryColor,
          titleTextStyle: TextStyle(
            fontSize: 18.0,
          ),
        ),
        textTheme: GoogleFonts.notoSansTextTheme(Theme.of(context).textTheme),
        primaryColor: AppColors.primaryColor,
      ),
    );
  }
}
