import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:markme_teacher/core/utils/app_utils.dart';
import 'package:markme_teacher/features/lesson_plan/models/lesson_plan.dart';
import 'package:markme_teacher/features/lesson_plan/models/lesson_topic.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../../core/models/teacher.dart';

class LessonPlanDetailsScreen extends StatelessWidget {
  final LessonPlan lessonPlan;
  final Teacher teacher;
  const LessonPlanDetailsScreen({super.key, required this.lessonPlan,required this.teacher});
  Future<void> _downloadPDF(BuildContext context) async {
    final pdf = pw.Document();
    final subjectParts = lessonPlan.subjectId.split("_");
    final section =
        "${subjectParts[0].toUpperCase()} ${subjectParts[1]}-${subjectParts[2]}";
    final logoBytes = await rootBundle.load("assets/images/gita_without_bg.png");
    final logo = pw.MemoryImage(logoBytes.buffer.asUint8List());

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(24),
        build: (pw.Context context) => [
          // Header with logo + title
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              pw.Image(logo, width: 60, height: 60),
              pw.Text(
                "Lesson Plan Status",
                style: pw.TextStyle(
                  fontSize: 22,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ],
          ),
          pw.SizedBox(height: 16),

          // Subject & Section
          pw.Text(
            lessonPlan.subjectName,
            style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
          ),
          pw.Text(
            section,
            style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 16),

          // Teacher Details
          pw.Text("Teacher Details",
              style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 6),
          pw.Table(
            border: pw.TableBorder.all(),
            columnWidths: {
              0: const pw.FlexColumnWidth(3),
              1: const pw.FlexColumnWidth(7),
            },
            children: [
              _buildRow("Name", teacher.teacherName),
              _buildRow("Id",teacher.teacherId ),
              _buildRow("Branch", teacher.branchId),
              _buildRow("Email", teacher.email),
              _buildRow("Phone", teacher.phoneNumber,)
            ],
          ),
          pw.SizedBox(height: 16),

          // Lesson Topics
          pw.Text("Lesson Topics",
              style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 8),
          pw.Table(
            border: pw.TableBorder.all(),
            columnWidths: {
              0: const pw.FlexColumnWidth(1), // S.No
              1: const pw.FlexColumnWidth(2), // Module No
              2: const pw.FlexColumnWidth(2), // Topic No
              3: const pw.FlexColumnWidth(5), // Topic Name
              4: const pw.FlexColumnWidth(2), // Status
              5: const pw.FlexColumnWidth(3), // Date
            },
            children: [
              // Header Row
              pw.TableRow(
                decoration: const pw.BoxDecoration(color: PdfColors.grey300),
                children: [
                  _cell("S.No", bold: true),
                  _cell("Module", bold: true),
                  _cell("Topic No", bold: true),
                  _cell("Topic", bold: true),
                  _cell("Status", bold: true),
                  _cell("Date of Completion", bold: true),
                ],
              ),
              // Data Rows
              ...lessonPlan.topics.asMap().entries.map((entry) {
                final i = entry.key;
                final topic = entry.value;
                final moduleNo = topic.number.contains(".")
                    ? topic.number.split(".").first
                    : topic.number;

                return pw.TableRow(
                  children: [
                    _cell("${i + 1}"),
                    _cell(moduleNo),
                    _cell(topic.number), // full number like 1.1, 1.2
                    _cell(topic.name),
                    pw.Center(
                      child: pw.Container(
                        width: 12,
                        height: 12,
                        decoration: pw.BoxDecoration(
                          shape: pw.BoxShape.rectangle,
                          color: topic.isCompleted ? PdfColors.green : PdfColors.red,
                        ),
                      ),
                    ),
                    _cell(topic.isCompleted
                        ? (topic.dateOfCompletion ?? "-")
                        : "-"),
                  ],
                );
              }),
            ],
          ),
        ],
      ),
    );

    await Printing.layoutPdf(onLayout: (format) async => pdf.save());
  }

// Helper for teacher details
  pw.TableRow _buildRow(String key, String value) {
    return pw.TableRow(
      children: [
        pw.Padding(
          padding: const pw.EdgeInsets.all(6),
          child: pw.Text(key, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.all(6),
          child: pw.Text(value),
        ),
      ],
    );
  }

// Helper for table cell
  pw.Widget _cell(String text, {bool bold = false, PdfColor? color}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(6),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
          color: color,
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final subjectParts = lessonPlan.subjectId.split("_");
    final section = lessonPlan.sectionId.split("_").join("-").toUpperCase();
    return Scaffold(
      appBar: AppBar(
        title: Text(lessonPlan.subjectName),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              AppUtils.showCustomSnackBar(context, "Downloading...");
              _downloadPDF(context);
            },
            icon: const Icon(Icons.download_for_offline, size: 27),
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  section,
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold),
                ),
              ),


            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: lessonPlan.topics.length,
              itemBuilder: (context, index) {
                final topic = lessonPlan.topics[index];
                final isCompleted = topic.isCompleted;

                return Card(
                  color: isCompleted ? Colors.green.shade100 : Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 2,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: isCompleted
                          ? Colors.green
                          : Colors.blue.shade100,
                      child: Text(
                        topic.number,
                        style: const TextStyle(color: Colors.black),
                      ),
                    ),
                    title: Text(
                      topic.name,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        decoration: isCompleted
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                    trailing: isCompleted
                        ? const Icon(Icons.check_circle, color: Colors.green)
                        : null,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
