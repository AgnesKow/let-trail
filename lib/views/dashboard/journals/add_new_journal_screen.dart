import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:letstrail/models/models_exporter.dart';
import 'package:letstrail/utils/utils_exporter.dart';

class AddNewJournalScreen extends StatefulWidget {
  final JournalModel? journal;

  const AddNewJournalScreen({
    Key? key,
    this.journal,
  }) : super(key: key);

  @override
  State<AddNewJournalScreen> createState() => _AddNewJournalScreenState();
}

class _AddNewJournalScreenState extends State<AddNewJournalScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  XFile? image;
  bool _isLoading = false;

  @override
  void initState() {
    populateEditJournalDataIfAvailable();
    super.initState();
  }

  void populateEditJournalDataIfAvailable() {
    if (widget.journal != null) {
      _titleController.text = widget.journal!.title;
      _descriptionController.text = widget.journal!.description;
    }
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.ashWhiteColor,
      appBar: AppBar(
        title: const Text("Spread the word"),
      ),
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 20.0,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Align(
                          alignment: Alignment.topRight,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15.0),
                            child: Image.asset(
                              "${Common.assetsIcons}application_icon.jpg",
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10.0),
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              "${widget.journal == null ? "Publish" : "Update"} Journal",
                              style: TextStyle(
                                color: AppColors.appBlackColor,
                                fontSize: 24.0,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            SizedBox(height: 4.0),
                            Text(
                              "Share your wonderful experience of exploring locations with people.",
                              style: TextStyle(
                                color: AppColors.textColor,
                                fontSize: 16.0,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 10,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.appWhiteColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(80.0),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.appGreyColor.withOpacity(0.15),
                        offset: const Offset(1, 2),
                        spreadRadius: 20,
                        blurRadius: 20,
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Expanded(
                        flex: 1,
                        child: SizedBox(),
                      ),
                      Expanded(
                        flex: 8,
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              InkWell(
                                onTap: () => _pickImage(),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color:
                                        AppColors.appGreyColor.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  height: 180.0,
                                  child: image == null
                                      ? (widget.journal != null)
                                          ? Image.network(
                                              widget.journal!.thumbnail,
                                            )
                                          : const Center(
                                              child: Text(
                                                "Click To Upload Image",
                                              ),
                                            )
                                      : Image.file(
                                          File(image!.path),
                                          fit: BoxFit.fill,
                                        ),
                                ),
                              ),
                              const SizedBox(height: 10.0),
                              LabelAndInputField(
                                fieldController: _titleController,
                                label: "Journal Title",
                              ),
                              const SizedBox(height: 15.0),
                              LabelAndInputField(
                                fieldController: _descriptionController,
                                label: "Journal Description",
                              ),
                              const SizedBox(height: 15.0),
                              PrimaryButton(
                                onPressed: () => _processJournal(),
                                buttonText: "Publish Journal",
                              ),
                              const SizedBox(height: 15.0),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          _isLoading ? LoadingOverlay() : const SizedBox.shrink(),
        ],
      ),
    );
  }

  void _pickImage() async {
    _isLoading = true;
    setState(() {});

    final ImagePicker _picker = ImagePicker();
    // Pick an image
    image = await _picker.pickImage(source: ImageSource.gallery);
    _isLoading = false;
    setState(() {});
  }

  void _processJournal() async {
    String title = _titleController.text.toString().trim();
    String description = _descriptionController.text.toString().trim();

    if (image == null && widget.journal == null) {
      Common.showErrorTopSnack(context, "Please select image and try again");
      return;
    } else if (title.isEmpty) {
      Common.showErrorTopSnack(context, "Please enter title and try again");
      return;
    } else if (description.isEmpty) {
      Common.showErrorTopSnack(
          context, "Please enter description and try again");
      return;
    } else if (widget.journal != null &&
        image == null &&
        title == widget.journal?.title &&
        description == widget.journal?.description) {
      Common.showErrorTopSnack(context, "Cannot about journal with no changes");
      return;
    } else {
      _isLoading = true;
      setState(() {});

      String? journalThumbnailURL;
      if (image != null) {
        journalThumbnailURL = await ApiRequests.uploadSelectedImage(
            File(image!.path),
            subDirectory: Common.JOURNALS_PICTURES);
      }
      await ApiRequests.publishOrUpdateJournal(
        title,
        description,
        journalThumbnailURL == null
            ? widget.journal!.thumbnail
            : journalThumbnailURL,
        journal: widget.journal,
      );
      _isLoading = false;
      if (mounted) setState(() {});
      Common.showSuccessTopSnack(context, "Journal update posted");
      Navigator.pop(context);
    }
  }
}
