import 'dart:convert';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:markme_teacher/core/utils/app_utils.dart';
import 'package:markme_teacher/features/lesson_plan/bloc/lesoon_bloc.dart';
import 'package:markme_teacher/features/lesson_plan/bloc/lesson_event.dart';
import 'package:markme_teacher/features/lesson_plan/bloc/lesson_state.dart';
import 'package:markme_teacher/features/lesson_plan/models/lesson_plan.dart';
import 'package:open_file/open_file.dart' as open_file;

import 'package:csv/csv.dart';
import 'package:dartz/dartz.dart' hide State;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide State;
import 'package:flutter/services.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:markme_teacher/core/models/subject.dart';
import 'package:markme_teacher/core/models/teacher.dart';
import 'package:markme_teacher/features/lesson_plan/models/lesson_topic.dart';
import 'package:path_provider/path_provider.dart';

class AddLessonPlan extends StatefulWidget {
  final Teacher teacher;
  const AddLessonPlan({super.key, required this.teacher});

  @override
  State<AddLessonPlan> createState() => _AddLessonPlanState();
}

class _AddLessonPlanState extends State<AddLessonPlan> {
  Future<List<LessonTopic>> pickCSVFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );
    if (result != null) {
      File file = File(result.files.single.path!);
      final input = file.openRead();
      final fields = await input
          .transform(utf8.decoder)
          .transform(const CsvToListConverter())
          .toList();
      return fields.skip(1).map((row) {
        final number = row.isNotEmpty ? row[0].toString() : "";
        final name = row.length > 1 ? row[1].toString() : "";
        return LessonTopic(number: number, name: name);
      }).toList();
    }
    return [];
  }

  Future<void> downloadCsvFormat() async {
    try {
      final csvData = await rootBundle.loadString(
        "assets/documents/lesson_format.csv",
      );

      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/lesson_format.csv';

      final file = File(filePath);
      await file.writeAsString(csvData);

      await open_file.OpenFile.open(filePath);
    } catch (e) {
      debugPrint("error:$e");
    }
  }

  Subject? selectedSubject;
  String? selectedSection;
  List<LessonTopic> lessonTopics = [];
  @override
  Widget build(BuildContext context) {
    final subjects = widget.teacher.subjects;
    return BlocListener<LessonBloc, LessonState>(
      listener: (context, state) {
        if (state is LessonLoading) {
          AppUtils.showCustomLoading(context);
        } else {
          AppUtils.hideCustomLoading(context);
        }
        if (state is LessonFailure) {
          AppUtils.showDialogMessage(context, state.message, "Sorry!");
        } else if (state is LessonAddedForSubject) {
          AppUtils.showCustomSnackBar(context, "Lesson Added");
          context.pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(title: Text("Add lesson plan")),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade400),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<Subject>(
                        isExpanded: true,
                        hint: Text(
                          "Select Subject",
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        value: selectedSubject,
                        icon: Icon(
                          MaterialCommunityIcons.arrow_down_drop_circle,
                          color: Colors.black,
                        ),
                        items: subjects.map((Subject subject) {
                          final parts=subject.subjectId.split("_");
                          final subjectName=parts.join("-").toUpperCase();
                          return DropdownMenuItem<Subject>(
                            value: subject,
                            child: Text(
                              subjectName,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (Subject? newValue) {
                          setState(() {
                            selectedSubject = newValue;
                          });
                        },
                      ),
                    ),
                  ) ,
                  const SizedBox(height: 16,),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade400),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        hint: Text(
                          "Select Section",
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        value: selectedSection,
                        icon: Icon(
                          MaterialCommunityIcons.arrow_down_drop_circle,
                          color: Colors.black,
                        ),
                        items: widget.teacher.assignedClasses.map((String section) {
                          final parts=section.split("_");
                          final subjectName=parts.join("-").toUpperCase();
                          return DropdownMenuItem<String>(
                            value: section,
                            child: Text(
                              subjectName,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedSection = newValue;
                          });
                        },
                      ),
                    ),
                  ) ,//Dropdown button
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () async {
                          final topics = await pickCSVFile();
                          setState(() {
                            lessonTopics = topics;
                          });
                        },
                        label: Text("Upload csv lesson file"),
                        icon: Icon(MaterialCommunityIcons.cloud_upload),
                      ),
                      ElevatedButton.icon(
                        onPressed: () async {
                          AppUtils.showCustomSnackBar(
                            context,
                            "Downloading...",
                          );
                          await downloadCsvFormat();
                          AppUtils.showCustomSnackBar(
                            context,
                            "Format CSV downloaded ✅",
                          );
                        },
                        label: Text("Format"),
                        icon: Icon(MaterialCommunityIcons.download),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  if (lessonTopics.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Lesson Topics:",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: lessonTopics.length,
                          itemBuilder: (context, index) {
                            final topic = lessonTopics[index];
                            return Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              elevation: 2,
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Colors.blue.shade100,
                                  child: Text(
                                    topic.number,
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                                title: Text(
                                  topic.name,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                if (selectedSubject != null && lessonTopics.isNotEmpty && selectedSection != null) {
                  final lessonPlan = LessonPlan(
                    sectionId: selectedSection!,
                    subjectId: selectedSubject!.subjectId,
                    subjectName: selectedSubject!.subjectName,
                    topics: lessonTopics,
                    createdAt: DateTime.now(),
                  );
                  context.read<LessonBloc>().add(
                    AddLessonForSubjectEvent(
                      lessonPlan,
                      widget.teacher.teacherId,
                    ),
                  );
                } else if (selectedSubject == null) {
                  AppUtils.showDialogMessage(
                    context,
                    "Please select a subject",
                    "Subject!!!",
                  );
                }
                else if (lessonTopics.isEmpty) {
                  AppUtils.showDialogMessage(
                    context,
                    "Please upload a correct csv file",
                    "CSV file!!!",
                  );
                }
              },
              label: Text(
                "Save Lesson Plan",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              icon: Icon(Icons.save),
            ),
          ),
        ),
      ),
    );
  }
}
