import 'package:textomize/core/exports.dart';
class HelpSupportView extends StatelessWidget {
  const HelpSupportView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Help & Support',centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Frequently Asked Questions', 
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),

            // FAQ List
            ExpansionTile(
              title: const Text('How to scan a document?'),
              children: [Padding(
                padding: const EdgeInsets.all(10),
                child: const Text('Open the app, tap on "Scan", and capture the document.'),
              )],
            ),
            ExpansionTile(
              title: const Text('How to export a PDF?'),
              children: [Padding(
                padding: const EdgeInsets.all(10),
                child: const Text('After scanning, tap "Export" and choose PDF format.'),
              )],
            ),

            const SizedBox(height: 20),
            const Divider(),

            // Contact Support
            const Text('Contact Support', 
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),

            ListTile(
              leading: const Icon(Icons.email, color: Colors.blueAccent),
              title: const Text('Email Us'),
              subtitle: const Text('support@example.com'),
              onTap: () {
                // Handle email support
              },
            ),
            ListTile(
              leading: const Icon(Icons.phone, color: Colors.green),
              title: const Text('Call Us'),
              subtitle: const Text('+123 456 789'),
              onTap: () {
                // Handle phone support
              },
            ),

            const SizedBox(height: 20),
            const Divider(),

           CustomButton(title: 'Send feedback', 
           fillColor: true,
           onTap: () {
            }),
          ],
        ),
      ),
    );
  }
}
