import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:letstrail/utils/utils_exporter.dart';

class TrailDetailScreen extends StatefulWidget {
  const TrailDetailScreen({Key? key}) : super(key: key);

  @override
  State<TrailDetailScreen> createState() => _TrailDetailScreenState();
}

class _TrailDetailScreenState extends State<TrailDetailScreen> {
  @override
  Widget build(BuildContext context) {
    Orientation _orientation = MediaQuery.of(context).orientation;
    Size _size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Exploring heritage trail"),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 10.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      "Orchard Heritage Trail",
                      style: TextStyle(
                        color: AppColors.appBlackColor,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5.0),
                    const Text(
                      "The Orchard Road area has transformed from a countryside retreat in the 1800s to the heart of Singapore’s tourism and retail scene today. Through the Orchard Heritage Trail, discover the communities, institutions, businesses and natural heritage that contribute to this area’s rich history.",
                      style: TextStyle(
                        color: AppColors.textColor,
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: TileCard(
                            bgColor: Colors.green.withOpacity(0.1),
                            padding: const EdgeInsets.symmetric(
                              vertical: 6.0,
                              horizontal: 10.0,
                            ),
                            child: Row(
                              children: [
                                Image.asset(
                                  "${Common.assetsIcons}web.png",
                                  width: 30.0,
                                  height: 30.0,
                                ),
                                const SizedBox(width: 20.0),
                                Expanded(
                                  child: Text(
                                    "Checkout the official website",
                                    style: const TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12.0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 5.0),
                        Expanded(
                          child: TileCard(
                            bgColor: const Color(0XFFE6497E).withOpacity(0.1),
                            padding: const EdgeInsets.symmetric(
                              vertical: 6.0,
                              horizontal: 10.0,
                            ),
                            child: Row(
                              children: [
                                Image.asset(
                                  "${Common.assetsIcons}year.png",
                                  width: 30.0,
                                  height: 30.0,
                                ),
                                const SizedBox(width: 20.0),
                                const Expanded(
                                  child: Text(
                                    "Year 1970",
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12.0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20.0),
                    const Text(
                      "Themes",
                      style: TextStyle(
                        color: AppColors.appBlackColor,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2.5),
                    const Text(
                      "Themes of the trails are mentioned below. you can select any of these and see the places of selected theme.",
                      style: TextStyle(
                        color: AppColors.textColor,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 185.0,
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.only(left: 15.0),
                  physics: const BouncingScrollPhysics(),
                  itemCount: Common.journalFilters.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      width: 340.0,
                      decoration: BoxDecoration(
                        color: AppColors.appWhiteColor,
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.appGreyColor.withOpacity(0.15),
                            blurRadius: 3,
                            spreadRadius: 3,
                            offset: const Offset(1, 1),
                          ),
                        ],
                      ),
                      margin: const EdgeInsets.only(
                        right: 10.0,
                        top: 5.0,
                        bottom: 5.0,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10.0,
                        vertical: 10.0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            "From Orchard to Garden",
                            style: TextStyle(
                              color: AppColors.appBlackColor,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5.0),
                          Text(
                            "The Orchard Road area has transformed from a countryside retreat in the 1800s to the heart of Singapore’s tourism and retail scene today. Through the Orchard Heritage Trail, discover the communities, institutions, businesses and natural heritage that contribute to this area’s rich history.",
                            style: TextStyle(
                              color: AppColors.textColor,
                              fontSize: 12.0,
                            ),
                            maxLines: 3,
                          ),
                          const SizedBox(height: 5.0),
                          Text(
                            "4 places",
                            style: TextStyle(
                              color: AppColors.appBlackColor.withOpacity(0.8),
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 50.0,
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: 4,
                              padding: EdgeInsets.zero,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (BuildContext context, int index) {
                                return CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      "https://www.roots.gov.sg/-/media/Roots/Images/landmarks/orchard-heritage-trail/royal_thai_embassy_2.jpg"),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 10.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: const Text(
                  "Places:",
                  style: TextStyle(
                    color: AppColors.appBlackColor,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 5.0),
              ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                itemCount: 3,
                scrollDirection: Axis.vertical,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    // onTap: () => Common.push(context, PlaceDetailScreen()),
                    child: Container(
                      height: 320.0,
                      margin: const EdgeInsets.only(bottom: 10.0),
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20.0),
                              child: Image.network(
                                "https://www.roots.gov.sg/-/media/Roots/Images/landmarks/orchard-heritage-trail/goodwood_park_2.jpg",
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          const Positioned(
                            top: 20.0,
                            left: 20.0,
                            child: TileCard(title: "Business"),
                          ),
                          Positioned(
                            right: 20.0,
                            top: 10.0,
                            child: Column(
                              children: const [
                                GlassmorphismedWidget(
                                  padding: EdgeInsets.all(10.0),
                                  child: Icon(
                                    Icons.info,
                                    color: AppColors.appWhiteColor,
                                    size: 24.0,
                                  ),
                                ),
                                SizedBox(height: 5.0),
                                GlassmorphismedWidget(
                                  padding: EdgeInsets.all(10.0),
                                  child: Icon(
                                    Icons.directions,
                                    color: AppColors.appWhiteColor,
                                    size: 24.0,
                                  ),
                                ),
                                SizedBox(height: 5.0),
                                GlassmorphismedWidget(
                                  padding: EdgeInsets.all(10.0),
                                  child: Icon(
                                    Icons.pin_drop,
                                    color: AppColors.appWhiteColor,
                                    size: 24.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            right: 10,
                            left: 10,
                            bottom: 10,
                            child: GlassmorphismedWidget(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  const Text(
                                    "Goodwood Park Hotel",
                                    style: TextStyle(
                                      color: AppColors.appWhiteColor,
                                      fontSize: 16.0,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 1.5),
                                  Text(
                                    "The earliest club in Orchard Road was the German Teutonia Club.",
                                    style: TextStyle(
                                      color: AppColors.appWhiteColor
                                          .withOpacity(0.85),
                                      fontSize: 13.0,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Row(
                                    children: [
                                      const Text(
                                        "Cultural Style:",
                                        style: TextStyle(
                                          color: AppColors.appWhiteColor,
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(width: 10.0),
                                      Text(
                                        "Germany " +
                                            Common.getEmojiFromCountryName(
                                                "germany"),
                                        style: TextStyle(
                                          color: AppColors.appWhiteColor
                                              .withOpacity(0.85),
                                          fontSize: 14.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
