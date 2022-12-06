import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:letstrail/models/models_exporter.dart';
import 'package:letstrail/utils/utils_exporter.dart';
import 'package:letstrail/views/views_exporter.dart';

class CustomDrawer extends StatefulWidget {
  CustomDrawer({
    Key? key,
  }) : super(key: key);

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  UserModel user = Persistent.getUser;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.appWhiteColor,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                InkWell(
                  onTap: () => Common.pop(context),
                  child: const Icon(
                    Icons.clear,
                    size: 30.0,
                    color: AppColors.textColor,
                  ),
                ),
                const SizedBox(width: 15.0),
                const Text(
                  "Menu Navigation",
                  style: TextStyle(
                    color: AppColors.appBlackColor,
                    fontSize: 22.0,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15.0),
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("${Common.assetsImages}drawer_bg.jpg"),
                  fit: BoxFit.fill,
                ),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: GlassmorphismedWidget(
                sigmaY: 10.0,
                sigmaX: 10.0,
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    children: [
                      CircleAvatar(
                        backgroundImage: AssetImage(
                          "${Common.assetsImages}user.jpg",
                        ),
                        radius: 60.0,
                      ),
                      const SizedBox(height: 2.5),
                      Text(
                        "Adil Mehmood",
                        style: TextStyle(
                          color: AppColors.appWhiteColor,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        "\"Passionate traveller\"",
                        style: TextStyle(
                          color: AppColors.appWhiteColor,
                          fontSize: 14.0,
                        ),
                      ),
                      const SizedBox(height: 15.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TileCard(
                            onPressed: () => Common.push(
                              context,
                              ProfileScreen(),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  CupertinoIcons.profile_circled,
                                  color:
                                      AppColors.appWhiteColor.withOpacity(0.8),
                                  size: 22.0,
                                ),
                                const SizedBox(width: 10.0),
                                Text(
                                  "My profile",
                                  style: TextStyle(
                                    color: AppColors.appWhiteColor,
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 20.0),
                          TileCard(
                            onPressed: () async {
                              await ApiRequests.logout();
                              Common.pushAndRemoveUntil(context, Login());
                            },
                            bgColor: AppColors.appWhiteColor,
                            child: Row(
                              children: [
                                Icon(
                                  CupertinoIcons.settings,
                                  color:
                                      AppColors.appBlueColor.withOpacity(0.8),
                                  size: 22.0,
                                ),
                                const SizedBox(width: 10.0),
                                const Text(
                                  "Logout",
                                  style: TextStyle(
                                    color: AppColors.appBlueColor,
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  PrimaryButton(
                    onPressed: () =>
                        Common.push(context, const AllJournalsScreen()),
                    buttonColor: AppColors.appWhiteColor,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 15.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.orange,
                          ),
                          padding: const EdgeInsets.all(10.0),
                          child: const Icon(
                            CupertinoIcons.news_solid,
                            color: Colors.white,
                            size: 22.0,
                          ),
                        ),
                        const Text(
                          "All published journals",
                          style: TextStyle(
                            color: AppColors.textColor,
                            fontSize: 18.0,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const Icon(CupertinoIcons.right_chevron),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15.0),
                  PrimaryButton(
                    onPressed: () =>
                        Common.push(context, const AddNewJournalScreen()),
                    buttonColor: AppColors.appWhiteColor,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 15.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.primaryColor,
                          ),
                          padding: const EdgeInsets.all(10.0),
                          child: const Icon(
                            CupertinoIcons.book_fill,
                            color: Colors.white,
                            size: 22.0,
                          ),
                        ),
                        const Text(
                          "Post new journals",
                          style: TextStyle(
                            color: AppColors.textColor,
                            fontSize: 18.0,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const Icon(CupertinoIcons.right_chevron),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15.0),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  "Let\'s Trail ©2022",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.primaryColor,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      "Designed and developed with ",
                      style: TextStyle(
                        color: AppColors.textColor,
                        fontSize: 14.0,
                      ),
                    ),
                    Icon(
                      CupertinoIcons.heart_fill,
                      color: AppColors.primaryColor,
                      size: 14.0,
                    ),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
