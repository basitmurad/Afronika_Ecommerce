import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({Key? key}) : super(key: key);

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
          'Privacy Policy',
          style: TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.teal.withOpacity(0.1),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.privacy_tip,
                    color: Colors.teal,
                    size: 40,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Your Privacy Matters',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Last updated: January 2025',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            _buildSection(
              title: '1. Information We Collect',
              content: 'We collect information you provide directly to us, such as when you create an account, '
                  'make a purchase, or contact us for support. This may include your name, email address, '
                  'phone number, and payment information.',
            ),

            _buildSection(
              title: '2. How We Use Your Information',
              content: 'We use the information we collect to provide, maintain, and improve our services, '
                  'process transactions, send you technical notices and support messages, and respond to '
                  'your comments and questions.',
            ),

            _buildSection(
              title: '3. Information Sharing',
              content: 'We do not sell, trade, or otherwise transfer your personal information to third parties '
                  'without your consent, except as necessary to provide our services or as required by law.',
            ),

            _buildSection(
              title: '4. Data Security',
              content: 'We implement appropriate technical and organizational measures to protect your personal '
                  'information against unauthorized access, alteration, disclosure, or destruction.',
            ),

            _buildSection(
              title: '5. Your Rights',
              content: 'You have the right to access, update, or delete your personal information. You may also '
                  'opt-out of certain communications from us. To exercise these rights, please contact us.',
            ),

            _buildSection(
              title: '6. Cookies',
              content: 'We use cookies and similar tracking technologies to track activity on our service and '
                  'hold certain information. You can instruct your browser to refuse all cookies or to '
                  'indicate when a cookie is being sent.',
            ),

            _buildSection(
              title: '7. Children\'s Privacy',
              content: 'Our service is not directed to children under 13. We do not knowingly collect personal '
                  'information from children under 13. If you are a parent and believe your child has '
                  'provided us with personal information, please contact us.',
            ),

            _buildSection(
              title: '8. Changes to This Policy',
              content: 'We may update our Privacy Policy from time to time. We will notify you of any changes '
                  'by posting the new Privacy Policy on this page and updating the "Last updated" date.',
            ),

            _buildSection(
              title: '9. Contact Us',
              content: 'If you have any questions about this Privacy Policy, please contact us at:\n\n'
                  'Email: support@afronika.com\n'
                  'Phone: +234 816 005 239 0\n'
                  'Address: Suite C2 Justice John Tsoho Street, 2nd Floor Fatima Plaza, Wuye Abuja, Federal Capital Territory 902101,Nigeria',
            ),

            const SizedBox(height: 40),

            // Accept button
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ElevatedButton(
                onPressed: () {
                  HapticFeedback.lightImpact();
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                child: const Text(
                  'I Understand',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required String content}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              content,
              style: TextStyle(
                fontSize: 14,
                height: 1.6,
                color: Colors.grey[700],
              ),
            ),
          ),
        ],
      ),
    );
  }
}