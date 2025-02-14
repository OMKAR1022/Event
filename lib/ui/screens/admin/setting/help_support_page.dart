import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpSupportPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Help & Support'),
        backgroundColor: Colors.purple[400],
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          _buildSupportOption(
            context,
            icon: Icons.email_outlined,
            title: 'Email Support',
            subtitle: 'Get in touch with our support team',
            onTap: () => _launchEmail('support@mitevent.com'),
          ),
          _buildSupportOption(
            context,
            icon: Icons.chat_bubble_outline,
            title: 'Live Chat',
            subtitle: 'Chat with a support representative',
            onTap: () => _showComingSoonDialog(context, 'Live Chat'),
          ),
          _buildSupportOption(
            context,
            icon: Icons.phone_outlined,
            title: 'Phone Support',
            subtitle: 'Call our support hotline',
            onTap: () => _launchPhone('+1234567890'),
          ),
          _buildSupportOption(
            context,
            icon: Icons.question_answer_outlined,
            title: 'FAQs',
            subtitle: 'Find answers to common questions',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => FAQPage()),
            ),
          ),
          _buildSupportOption(
            context,
            icon: Icons.feedback_outlined,
            title: 'Submit Feedback',
            subtitle: 'Help us improve our app',
            onTap: () => _showFeedbackDialog(context),
          ),
        ],
      ),
    );
  }

  Widget _buildSupportOption(
      BuildContext context, {
        required IconData icon,
        required String title,
        required String subtitle,
        required VoidCallback onTap,
      }) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(icon, color: Colors.purple[400], size: 28),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }

  void _launchEmail(String email) async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: email,
      query: encodeQueryParameters(<String, String>{
        'subject': 'Support Request from MIT Event App'
      }),
    );
    if (await canLaunch(emailLaunchUri.toString())) {
      await launch(emailLaunchUri.toString());
    } else {
      print('Could not launch $emailLaunchUri');
    }
  }

  void _launchPhone(String phoneNumber) async {
    final Uri phoneLaunchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    if (await canLaunch(phoneLaunchUri.toString())) {
      await launch(phoneLaunchUri.toString());
    } else {
      print('Could not launch $phoneLaunchUri');
    }
  }

  void _showComingSoonDialog(BuildContext context, String feature) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Coming Soon'),
          content: Text('$feature will be available in a future update.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showFeedbackDialog(BuildContext context) {
    final TextEditingController _feedbackController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Submit Feedback'),
          content: TextField(
            controller: _feedbackController,
            decoration: InputDecoration(
              hintText: 'Enter your feedback here',
              border: OutlineInputBorder(),
            ),
            maxLines: 5,
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Submit'),
              onPressed: () {
                // TODO: Implement feedback submission
                print('Feedback submitted: ${_feedbackController.text}');
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Thank you for your feedback!')),
                );
              },
            ),
          ],
        );
      },
    );
  }

  String? encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }
}

class FAQPage extends StatelessWidget {
  final List<Map<String, String>> faqs = [
    {
      'question': 'How do I create an event?',
      'answer': 'To create an event, go to the "Events" tab and tap the "+" button. Fill in the event details and tap "Create".'
    },
    {
      'question': 'Can I edit an event after creating it?',
      'answer': 'Yes, you can edit an event by going to the event details page and tapping the "Edit" button.'
    },
    {
      'question': 'How do I register for an event?',
      'answer': 'To register for an event, go to the event details page and tap the "Register" button. Follow the prompts to complete your registration.'
    },
    {
      'question': 'Can I cancel my event registration?',
      'answer': 'Yes, you can cancel your registration by going to "My Events" and tapping "Cancel Registration" for the specific event.'
    },
    {
      'question': 'How do I contact the event organizer?',
      'answer': 'You can contact the event organizer by going to the event details page and tapping the "Contact Organizer" button.'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Frequently Asked Questions'),
        backgroundColor: Colors.purple[400],
      ),
      body: ListView.builder(
        itemCount: faqs.length,
        itemBuilder: (context, index) {
          return ExpansionTile(
            title: Text(
              faqs[index]['question']!,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            children: [
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(faqs[index]['answer']!),
              ),
            ],
          );
        },
      ),
    );
  }
}

