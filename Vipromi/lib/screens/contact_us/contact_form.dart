import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'contact_field.dart'; // Make sure this exists and contains ContactField widget

class ContactFormScreen extends StatelessWidget {
  ContactFormScreen({super.key});

  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final subjectController = TextEditingController();
  final messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange[300],
        title: Text(
          "Contact Us",
          style: GoogleFonts.lato(fontSize: 22, fontWeight: FontWeight.w700),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(Icons.contact_page, color: Colors.deepPurple),
                  Text(
                    "Enquiry Form",
                    style: GoogleFonts.lato(
                      fontSize: 22,
                      color: Colors.deepPurple,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              ContactField(controller: nameController, label: "Name"),
              ContactField(
                controller: emailController,
                label: "Email",
                validator: emailValidator,
              ),
              ContactField(controller: phoneController, label: "Mobile No"),
              ContactField(controller: subjectController, label: "Subject"),
              ContactField(
                controller: messageController,
                label: "Message",
                maxLines: 4,
              ),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange[200],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {}
                },
                child: const Text(
                  "Submit",
                  style: TextStyle(fontSize: 16, color: Colors.deepPurple),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Icon(Icons.phone, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    "Mobile No: ",
                    style: GoogleFonts.lato(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    "+91-9122144611",
                    style: GoogleFonts.lato(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.email, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    "Email: ",
                    style: GoogleFonts.lato(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    "pbaba.agro@gmail.com",
                    style: GoogleFonts.lato(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.location_pin, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    "Address: ",
                    style: GoogleFonts.lato(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    "Karam Tikra Tand, Tender Bagicha",
                    style: GoogleFonts.lato(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                child: Text(", Ratu, Ranchi-835222"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String? emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Enter Email';
    }

    // Basic email pattern check
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Enter a valid email';
    }

    return null;
  }
}
