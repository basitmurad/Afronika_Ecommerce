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
                  const Icon(Icons.privacy_tip, color: Colors.teal, size: 40),
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
                          'Last updated: September 2025',
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
              content:
              'We collect personal information you provide during account creation or when placing an order. This includes:\n\n'
                  '- Full Name (required)\n'
                  '- Email Address (required)\n'
                  '- Phone Number (optional, for delivery updates or support)\n'
                  '- Shipping and Billing Addresses (only when placing orders)\n'
                  '- Payment Information (processed securely, never stored)\n'
                  '- Login Credentials (for account security)\n\n'
                  'We may also collect technical data such as device type, IP address (for fraud prevention), and anonymized usage statistics to improve app performance.',
            ),

            _buildSection(
              title: '2. How We Use Your Information',
              content:
              'We use your information strictly for:\n\n'
                  '- Account creation and order processing\n'
                  '- Customer communication (order updates, support)\n'
                  '- Optional marketing (only with your consent)\n'
                  '- Improving app performance\n'
                  '- Fraud prevention and legal compliance\n\n'
                  'We do not use your information for advertising tracking.',
            ),

            _buildSection(
              title: '3. Cookies and Similar Technologies',
              content:
              'Our app uses cookies only to:\n\n'
                  '- Remember your login status\n'
                  '- Save your shopping cart\n'
                  '- Store your preferences (currency, language)\n'
                  '- Improve app functionality\n\n'
                  '⚠️ We do NOT track you across other websites or apps, and we do NOT share cookies with advertisers or data brokers.',
            ),

            _buildSection(
              title: '4. App Tracking Transparency (iOS)',
              content:
              'On iOS, if you select "Ask App Not to Track", we will not collect any tracking data. '
                  'App functionality will remain the same. If you allow tracking, only anonymized analytics are used for app improvements. '
                  'We do not share personal data with advertisers.',
            ),

            _buildSection(
              title: '5. Information Sharing',
              content:
              'We do not sell or rent your personal information.\n\n'
                  'We only share your data with:\n'
                  '- Payment processors\n'
                  '- Delivery partners\n'
                  '- Customer support providers\n\n'
                  'All under strict data protection agreements. Data may also be shared with legal authorities if required by law.',
            ),

            _buildSection(
              title: '6. Your Rights',
              content:
              'You have the right to:\n\n'
                  '- Access, update, or delete your personal information\n'
                  '- Opt out of marketing anytime\n'
                  '- Control location and tracking permissions in your device settings\n'
                  '- Request a copy of your data\n\n'
                  'iOS users can also manage tracking permissions in Settings > Privacy & Security > Tracking.',
            ),

            _buildSection(
              title: '7. Data Security',
              content:
              'We use industry-standard security measures:\n\n'
                  '- SSL/TLS encryption\n'
                  '- Secure storage with restricted access\n'
                  '- Regular audits and vulnerability testing\n\n'
                  'While we take strong precautions, no method of transmission is 100% secure.',
            ),

            _buildSection(
              title: '8. Data Retention',
              content:
              '- Account data is kept until you delete your account\n'
                  '- Order history is retained as required by law (typically 7 years)\n'
                  '- Marketing data is retained until you unsubscribe\n'
                  '- Analytics data is anonymized for long-term app improvement',
            ),

            _buildSection(
              title: '9. Children\'s Privacy',
              content:
              'Our app is not intended for children under 13. We do not knowingly collect data from children. '
                  'If we learn we have collected such data, it will be deleted immediately.',
            ),

            _buildSection(
              title: '10. Contact Us',
              content:
              'Afronika E-commerce Team\n\n'
                  '📧 Email: contact@afronika.com\n'
                  '📧 Data Protection Officer: contact@afronika.com\n'
                  '🏢 Address: TORKYAA STREET, NORTH BANK, MAKURDI, BENUE STATE, NIGERIA\n'
                  '📧 iOS Privacy Concerns: support@afronika.com',
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
