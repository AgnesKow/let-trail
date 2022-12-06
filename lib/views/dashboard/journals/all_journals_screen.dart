import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:letstrail/models/models_exporter.dart';
import 'package:letstrail/utils/utils_exporter.dart';
import 'package:letstrail/views/views_exporter.dart';

class AllJournalsScreen extends StatefulWidget {
  const AllJournalsScreen({Key? key}) : super(key: key);

  @override
  State<AllJournalsScreen> createState() => _AllJournalsScreenState();
}

class _AllJournalsScreenState extends State<AllJournalsScreen> {
  String journalsKey = Common.SELF;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("All Journals"),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: const [
                      Text(
                        "Filter journals",
                        style: TextStyle(
                          color: AppColors.appBlackColor,
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Easily toggle between journals from other publishers and check your postings at one place",
                        style: TextStyle(
                          color: AppColors.textColor,
                          fontSize: 14.0,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 5.0),
                const Divider(),
                const SizedBox(height: 5.0),
                SizedBox(
                  height: 35.0,
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.only(left: 15.0),
                    physics: const BouncingScrollPhysics(),
                    itemCount: Common.journalFilters.length,
                    itemBuilder: (BuildContext context, int index) {
                      FilterJournals _filterJournals =
                          Common.journalFilters[index];
                      return Container(
                        margin: const EdgeInsets.only(right: 10.0),
                        child: TileCard(
                          onPressed: () =>
                              _toggleJournalFilter(_filterJournals.key),
                          title: _filterJournals.value,
                          bgColor: (_filterJournals.key == journalsKey)
                              ? AppColors.primaryColor
                              : AppColors.appGreyColor,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 10.0),
                Expanded(
                  child: StreamBuilder<dynamic>(
                      stream: ApiRequests.getJournals(journalsKey),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData)
                          return Center(child: CupertinoActivityIndicator());
                        if (snapshot.data.docs.length == 0)
                          return NoRecordsAvailable();
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          itemCount: snapshot.data.docs.length,
                          padding: const EdgeInsets.symmetric(horizontal: 5.0),
                          itemBuilder: (BuildContext context, int index) {
                            JournalModel journal = JournalModel.fromJson(
                                snapshot.data.docs[index].data());
                            return InkWell(
                              onTap: () => Common.push(
                                context,
                                JournalDetailScreen(journal: journal),
                              ),
                              child: Container(
                                height: 200.0,
                                margin: const EdgeInsets.only(
                                  left: 5.0,
                                  right: 5.0,
                                  bottom: 10.0,
                                ),
                                child: GlassmorphicBGImageCard(
                                  imageURL: journal.thumbnail,
                                  isAssetImage: false,
                                  childOnly: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      (journal.publisherId ==
                                              Persistent.getUser.id)
                                          ? InkWell(
                                              onTap: () => Common.push(
                                                  context,
                                                  AddNewJournalScreen(
                                                    journal: journal,
                                                  )),
                                              child: Align(
                                                alignment:
                                                    Alignment.centerRight,
                                                child: Wrap(
                                                  children: [
                                                    Text(
                                                      "Edit Journal",
                                                      style: TextStyle(
                                                        color: AppColors
                                                            .appBlackColor,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        fontSize: 14.0,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 5.0),
                                                    Icon(
                                                      Icons.edit,
                                                      color: AppColors
                                                          .appBlackColor
                                                          .withOpacity(0.6),
                                                      size: 16.0,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )
                                          : const SizedBox.shrink(),
                                      Text(
                                        journal.title,
                                        style: TextStyle(
                                          color: AppColors.appBlackColor,
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        journal.description,
                                        style: TextStyle(
                                          color: AppColors.appBlackColor,
                                          fontSize: 14.0,
                                        ),
                                        maxLines: 4,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      }),
                ),
              ],
            ),
          ),
          _isLoading ? LoadingOverlay() : const SizedBox.shrink(),
        ],
      ),
    );
  }

  void _toggleJournalFilter(String key) {
    journalsKey = key;
    setState(() {});
  }
}
