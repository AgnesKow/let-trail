import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:letstrail/models/models_exporter.dart';
import 'package:letstrail/utils/utils_exporter.dart';
import 'package:letstrail/views/views_exporter.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserModel user = Persistent.getUser;
  XFile? image;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Text(
              "${user.username}'s profile",
              style: TextStyle(
                color: AppColors.appWhiteColor,
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "\"Passionate traveller\"",
              style: TextStyle(
                color: AppColors.appWhiteColor,
                fontSize: 16.0,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Column(
                children: [
                  const SizedBox(height: 20.0),
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 100.0,
                        backgroundImage: user.imageUrl == ""
                            ? AssetImage(
                                "${Common.assetsImages}user.jpg",
                              )
                            : NetworkImage(user.imageUrl) as ImageProvider,
                        backgroundColor: AppColors.textColor.withOpacity(0.5),
                      ),
                      Positioned(
                        right: 10,
                        bottom: 15,
                        child: InkWell(
                          onTap: () => _pickImage(),
                          child: GlassmorphismedWidget(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.camera,
                              size: 30.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10.0),
                  const Divider(),
                  SizedBox(
                    height: 220.0,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: GlassmorphicBGImageCard(
                        imageURL:
                            "${Common.assetsImages}travel_profile_banner.jpg",
                        cardTitle: "Take your first step now.",
                        cardDescription:
                            "Life is too short to wait and world is too wide to explore. Let the journey of thousand miles start now",
                        belowChild: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            SizedBox(height: 10.0),
                            TileCard(
                              title: "Start Exploration",
                              bgColor: Colors.yellow,
                              textColor: AppColors.appBlackColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 20.0,
                      right: 20.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ProfileCard(
                          onPressed: () async {
                            await ApiRequests.logout();
                            Common.pushAndRemoveUntil(context, Login());
                          },
                          title: "Logout",
                          description:
                              "Hope to see you back soon. Keep enjoying and exploring the beautiful sites.",
                        ),
                        const SizedBox(height: 100.0),
                      ],
                    ),
                  ),
                ],
              ),
              _isLoading ? LoadingOverlay() : const SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }

  void _pickImage() async {
    _isLoading = true;
    setState(() {});

    final ImagePicker _picker = ImagePicker();
    // Pick an image
    image = await _picker.pickImage(source: ImageSource.gallery);
    print("image picked");
    if (image != null) {
      String imageURL = await ApiRequests.uploadSelectedImage(
        File(image!.path),
      );

      print("image uploaded");
      UserModel _user = await ApiRequests.updateUser(imageURL);
      print("image updated");

      Persistent.persistUser(_user);
      print("user refreshed");
    }

    _isLoading = false;
    setState(() {});
  }
}

class ProfileCard extends StatelessWidget {
  final String title, description;
  final VoidCallback? onPressed;

  const ProfileCard({
    Key? key,
    required this.title,
    required this.description,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        margin: const EdgeInsets.only(bottom: 4.0),
        padding: const EdgeInsets.symmetric(
          horizontal: 20.0,
          vertical: 10.0,
        ),
        decoration: BoxDecoration(
          color: AppColors.appGreyColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: AppColors.appBlackColor.withOpacity(0.65),
                      fontSize: 18.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 40.0),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16.0,
                  color: AppColors.appGreyColor.withOpacity(0.5),
                ),
              ],
            ),
            const SizedBox(height: 6.0),
            Text(
              description,
              style: const TextStyle(
                color: AppColors.appGreyColor,
                fontSize: 12.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
