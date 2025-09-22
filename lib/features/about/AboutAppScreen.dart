import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({Key? key}) : super(key: key);

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
          'About App',
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
            const SizedBox(height: 40),

            // App Logo
            Center(
              child: RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                  children: [
                    TextSpan(text: 'Afr', style: TextStyle(color: Color(0xFFF44336))),
                    TextSpan(text: 'o', style: TextStyle(color: Colors.black)),
                    TextSpan(text: 'n', style: TextStyle(color: Color(0xFFFF9800))),
                    TextSpan(text: 'ika', style: TextStyle(color: Color(0xFF00BCD4))),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.teal.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'Version 1.0.5',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.teal,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Description
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                'Your gateway to the Afronika ecosystem. Browse, shop, and connect with African culture and commerce.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  height: 1.5,
                  color: Colors.grey[600],
                ),
              ),
            ),

            const SizedBox(height: 40),

            // Features
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  _buildFeatureCard(
                    icon: Icons.speed,
                    title: 'Fast & Secure',
                    description: 'Optimized browsing experience with enhanced security features',
                    color: Colors.blue,
                  ),
                  _buildFeatureCard(
                    icon: Icons.shopping_bag,
                    title: 'Easy Shopping',
                    description: 'Seamless e-commerce experience with secure payment options',
                    color: Colors.orange,
                  ),
                  _buildFeatureCard(
                    icon: Icons.language,
                    title: 'Multi-Cultural',
                    description: 'Supporting African businesses and cultural exchange',
                    color: Colors.green,
                  ),
                  _buildFeatureCard(
                    icon: Icons.support_agent,
                    title: '24/7 Support',
                    description: 'Round-the-clock customer support for all your needs',
                    color: Colors.purple,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // Company Info
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  Text(
                    'Developed by',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Afronika Technologies',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.copyright, size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        '2025 All Rights Reserved',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Social Links

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: color,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

}