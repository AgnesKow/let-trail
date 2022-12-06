import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:letstrail/models/models_exporter.dart';
import 'package:letstrail/utils/utils_exporter.dart';

class JournalDetailScreen extends StatefulWidget {
  final JournalModel journal;
  const JournalDetailScreen({
    Key? key,
    required this.journal,
  }) : super(key: key);

  @override
  State<JournalDetailScreen> createState() => _JournalDetailScreenState();
}

class _JournalDetailScreenState extends State<JournalDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Journal Insights"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 12.0,
          vertical: 10.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: Image.network(
                widget.journal.thumbnail,
                height: 300.0,
                fit: BoxFit.fill,
              ),
            ),
            const SizedBox(height: 10.0),
            Text(
              widget.journal.title,
              style: TextStyle(
                color: AppColors.appBlackColor,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              widget.journal.description,
              style: TextStyle(
                color: AppColors.appGreyColor,
                fontSize: 14.0,
              ),
            ),
            const SizedBox(height: 20.0),
            const Text(
              "About Publisher",
              style: TextStyle(
                color: AppColors.appBlackColor,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 10.0),
            StreamBuilder<DocumentSnapshot>(
                stream: ApiRequests.getUserByID(widget.journal.publisherId),
                builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (!snapshot.hasData)
                    return Center(
                      child: CupertinoActivityIndicator(),
                    );
                  Map<String, dynamic> user =
                      (snapshot.data?.data() as Map<String, dynamic>);
                  return Container(
                    decoration: BoxDecoration(
                      color: AppColors.appWhiteColor,
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.appGreyColor.withOpacity(0.15),
                          offset: const Offset(1, 2),
                          spreadRadius: 20,
                          blurRadius: 20,
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15.0,
                      vertical: 10.0,
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: user['image_url'] == ""
                              ? AssetImage(
                                  "${Common.assetsImages}user.jpg",
                                )
                              : NetworkImage(user['image_url'])
                                  as ImageProvider,
                          radius: 35.0,
                        ),
                        const SizedBox(width: 10.0),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                "${user['username']}",
                                style: TextStyle(
                                  color: AppColors.appBlackColor,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                "Passionate traveler and publisher",
                                style: TextStyle(
                                  color: AppColors.appGreyColor,
                                  fontSize: 14.0,
                                ),
                              ),
                              SizedBox(height: 10.0),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }),
          ],
        ),
      ),
    );
  }
}
