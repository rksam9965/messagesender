import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:messagesender/widget/Textfield.dart';
import 'package:messagesender/widget/custome_alert.dart';

class MailPage extends StatefulWidget {
  const MailPage({super.key});

  @override
  State<MailPage> createState() => _MailPageState();
}

class _MailPageState extends State<MailPage> {
  final TextEditingController receiverController = TextEditingController();
  final TextEditingController subjectController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  late SmtpServer smtpServer;

  @override
  void initState() {
    super.initState();
    initializeSmtp();
  }

  void initializeSmtp() {
    final email = dotenv.env["MAIL"];
    final password = dotenv.env["MAIL_PASSWORD"];
    if (email == null || password == null) {
      debugPrint("Error: SMTP credentials missing in .env file.");
      return;
    }
    smtpServer = gmail(email, password);
  }

  Future<void> sendMail(String receiver, String subject, String body) async {
    if (dotenv.env["MAIL"] == null || dotenv.env["MAIL_PASSWORD"] == null) {
      showSnackbar("SMTP credentials not found.");
      return;
    }

    final message = Message()
      ..from = Address(dotenv.env["MAIL"]!, 'Task Mailer')
      ..recipients.add(receiver)
      ..subject = subject
      ..text = body;

    displayProgress(context); // Show progress before starting the task

    try {
      await send(message, smtpServer);
      showSnackbar("Email sent successfully!");
    } on MailerException catch (e) {
      debugPrint('Message not sent. Error: ${e.toString()}');
      showSnackbar("Failed to send email.");
    } finally {
      hideProgress(context); // Hide progress regardless of success or failure
    }
  }

  void showSnackbar(String message) {
    if (message == "Email sent successfully!") {
      Get.snackbar("Success", message, colorText: Colors.green);
    } else {
      Get.snackbar("Failed", message, colorText: Colors.green);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            "Task",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFieldForm(
                controller: receiverController,
                label: "Receiver Mail Id",
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Email is required";
                  }
                  if (!RegExp(
                          r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
                      .hasMatch(value)) return "Enter a valid email";
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFieldForm(
                controller: subjectController,
                label: "Subject",
                validator: (value) => value == null || value.isEmpty
                    ? "Subject is required"
                    : null,
              ),
              const SizedBox(height: 10),
              TextFieldForm(
                maxLines: 6,
                controller: contentController,
                label: "Content",
                validator: (value) => value == null || value.isEmpty
                    ? "Content is required"
                    : null,
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      sendMail(
                        receiverController.text.trim(),
                        subjectController.text.trim(),
                        contentController.text.trim(),
                      );
                    }
                  },
                  child: const Text("Send Mail"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
