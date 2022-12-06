import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:letstrail/utils/utils_exporter.dart';
import 'package:letstrail/views/views_exporter.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;
  PageController _pageController = PageController();

  List<Widget> _screens = [
    MapScreen(),
    const SearchScreen(),
    const RecordScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    // update page controller from start if needed
    _pageController = PageController();
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Persistent.printUserObject();
    return Scaffold(
      key: Common.drawerScaffoldKey,
      drawer: CustomDrawer(),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          _screens[_currentIndex],
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: SafeArea(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: BottomNavyBar(
                  backgroundColor: AppColors.primaryColor,
                  selectedIndex: _currentIndex,
                  showElevation: true,
                  onItemSelected: (index) {
                    setState(() => _currentIndex = index);
                    _pageController.jumpToPage(index);
                  },
                  items: <BottomNavyBarItem>[
                    BottomNavyBarItem(
                      activeColor: AppColors.appWhiteColor,
                      inactiveColor: Colors.red[900],
                      title: const Text(
                        'Maps',
                        textAlign: TextAlign.center,
                      ),
                      icon: const Icon(Icons.map_outlined),
                    ),
                    BottomNavyBarItem(
                      activeColor: AppColors.appWhiteColor,
                      inactiveColor: Colors.red[900],
                      title: const Text(
                        "Search",
                        textAlign: TextAlign.center,
                      ),
                      icon: const Icon(Icons.search),
                    ),
                    BottomNavyBarItem(
                      activeColor: AppColors.appWhiteColor,
                      inactiveColor: Colors.red[900],
                      title: const Text(
                        "Record",
                        textAlign: TextAlign.center,
                      ),
                      icon: const Icon(Icons.file_copy_outlined),
                    ),
                    BottomNavyBarItem(
                      activeColor: AppColors.appWhiteColor,
                      inactiveColor: Colors.red[900],
                      title: const Text(
                        'Profile',
                        textAlign: TextAlign.center,
                      ),
                      icon: const Icon(Icons.account_circle_outlined),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
