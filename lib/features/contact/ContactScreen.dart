import 'package:afronika/common/SocialButtonsRow.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../common/ContactCard.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.teal),
          onPressed: () {
            HapticFeedback.lightImpact();
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Contact Us',
          style: TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 40),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.teal.withOpacity(0.1),
                    Colors.white,
                  ],
                ),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.headset_mic,
                      size: 40,
                      color: Colors.teal,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Get in Touch',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'We\'re here to help and answer any questions',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            ContactCard(
              icon: Icons.email,
              title: "Email",
              subtitle: "support@afronika.com",
              color: Colors.red,
              onTap: () {
                _launchEmail();
                debugPrint("Email tapped");
              },
            ),
            ContactCard(
              icon: Icons.phone,
              title: "Phone",
              subtitle: "+234 07032280605",
              color: Colors.green,
              onTap: () {
                _launchPhone();
                debugPrint("Phone tapped");
              },
            ),
            ContactCard(
              icon: Icons.location_on,
              title: "Location",
              subtitle: "Suite C2 Justice John Tsoho Street,",
              color: Colors.blue,
              onTap: () {
                _openMaps();
                debugPrint("Location tapped");
              },
            ),


            const SizedBox(height: 30),

            // Social Media Section
            Column(
              children: [
                Text(
                  'Follow Us',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 20),

                SocialButtonsRow()
              ],
            ),

            const SizedBox(height: 40),

            // Quick Message Form

          ],
        ),
      ),
    );
  }




  // Launch methods
  void _launchEmail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',

      path: 'support@afronika.com',
      queryParameters: {
        'subject': 'Support Request',
      },
    );
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    }
  }

  void _launchPhone() async {
    final Uri phoneUri = Uri(scheme: 'tel', path: '+23407032280605');
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    }
  }


  void _openMaps() async {
    final Uri mapsUri = Uri.parse('https://www.google.com/maps/place/Fatima+Plaza+Wuye/@9.0532702,7.4404187,17z/data=!3m1!4b1!4m6!3m5!1s0x104e0b0c42f18e4d:0xaa5ac00883418368!8m2!3d9.0532702!4d7.4429936!16s%2Fg%2F11ht5z06mf?entry=ttu&g_ep=EgoyMDI1MDkxNy4wIKXMDSoASAFQAw%3D%3D ');
    if (await canLaunchUrl(mapsUri)) {
      await launchUrl(mapsUri);
    }
  }

}