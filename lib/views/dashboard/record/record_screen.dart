import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:letstrail/models/models_exporter.dart';
import 'package:letstrail/utils/utils_exporter.dart';
import 'package:letstrail/views/views_exporter.dart';
import 'package:timeago/timeago.dart' as timeago;

class RecordScreen extends StatelessWidget {
  const RecordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Records",
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: const [
                  SizedBox(height: 15.0),
                  Text(
                    "Your timeline and journals postings available at one place and easy access for you",
                    style: TextStyle(
                      color: AppColors.textColor,
                      fontSize: 15.0,
                    ),
                  ),
                  Divider(),
                ],
              ),
            ),
            const SizedBox(height: 10.0),
            const Padding(
              padding: EdgeInsets.only(left: 15.0),
              child: Text(
                "Timeline",
                style: TextStyle(
                  color: AppColors.appBlackColor,
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10.0),
            FutureBuilder<List<VisitedByModel>>(
                future: ApiRequests.getAllVisitedPlaces(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData)
                    return Center(child: CupertinoActivityIndicator());
                  if (snapshot.data!.length == 0)
                    return NoRecordsAvailable(
                      title: "No Timeline records",
                      description:
                          "Start navigating to places and your visited locations will appear here",
                    );
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data!.length,
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    scrollDirection: Axis.vertical,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      VisitedByModel visitedBy = snapshot.data![index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 5.0),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 35.0,
                              backgroundColor:
                                  AppColors.primaryColor.withOpacity(0.4),
                              backgroundImage:
                                  NetworkImage(visitedBy.placeImage),
                            ),
                            const SizedBox(width: 10.0),
                            Expanded(
                              child: TileCard(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Text(
                                      visitedBy.placeTagLine,
                                      style: TextStyle(
                                        color: AppColors.appWhiteColor,
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 1.5),
                                    Text(
                                      timeago
                                          .format(visitedBy.createdAt.toDate()),
                                      style: TextStyle(
                                        color: AppColors.appWhiteColor,
                                        fontSize: 10.0,
                                      ),
                                    ),
                                    SizedBox(height: 2.5),
                                    Text(
                                      visitedBy.placeDescription,
                                      style: TextStyle(
                                        color: AppColors.appWhiteColor,
                                        fontSize: 12.0,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }),
            const SizedBox(height: 2.5),
            const Divider(),
            const SizedBox(height: 2.5),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "My Journals",
                    style: TextStyle(
                      color: AppColors.appBlackColor,
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  InkWell(
                    onTap: () =>
                        Common.push(context, const AllJournalsScreen()),
                    child: const Text(
                      "View all",
                      style: TextStyle(
                        color: AppColors.primaryColor,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10.0),
            SizedBox(
              height: 180.0,
              child: StreamBuilder<dynamic>(
                  stream: ApiRequests.getJournals(Common.SELF),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData)
                      return Center(child: CupertinoActivityIndicator());
                    if (snapshot.data.docs.length == 0)
                      return NoRecordsAvailable();
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data.docs.length + 1,
                      padding: const EdgeInsets.only(left: 15.0),
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        if (index == 0) {
                          return Container(
                            width: 110.0,
                            margin:
                                const EdgeInsets.only(left: 5.0, right: 5.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              image: DecorationImage(
                                image: AssetImage(
                                    "${Common.assetsImages}journal.jpg"),
                                fit: BoxFit.fill,
                              ),
                            ),
                            child: GlassmorphismedWidget(
                              sigmaX: 4.0,
                              sigmaY: 4.0,
                              child: InkWell(
                                onTap: () => Common.push(
                                  context,
                                  const AddNewJournalScreen(),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    CircleAvatar(
                                      radius: 25.0,
                                      backgroundColor: AppColors.appWhiteColor,
                                      child: Icon(
                                        Icons.add,
                                      ),
                                    ),
                                    SizedBox(height: 10.0),
                                    Text(
                                      "Post new journal",
                                      style: TextStyle(
                                        color: AppColors.appBlackColor,
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        } else {
                          JournalModel journal = JournalModel.fromJson(
                              snapshot.data.docs[index - 1].data());
                          return Container(
                            width: 200.0,
                            margin:
                                const EdgeInsets.only(left: 5.0, right: 5.0),
                            child: GlassmorphicBGImageCard(
                              onPressed: () => Common.push(
                                context,
                                JournalDetailScreen(journal: journal),
                              ),
                              imageURL: journal.thumbnail,
                              isAssetImage: false,
                              cardTitle: journal.title,
                              titleSize: 14.0,
                              cardDescription: journal.description,
                              descriptionSize: 12.0,
                            ),
                          );
                        }
                      },
                    );
                  }),
            ),
            const SizedBox(height: 100.0),
          ],
        ),
      ),
    );
  }
}
