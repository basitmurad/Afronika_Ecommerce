import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AfronikaWebView extends StatefulWidget {
  const AfronikaWebView({super.key});

  @override
  State<AfronikaWebView> createState() => _AfronikaWebViewState();
}

class _AfronikaWebViewState extends State<AfronikaWebView> {
  late final WebViewController _controller;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            _injectJavaScript();
          },
          onPageFinished: (String url) {
            _injectJavaScript();
          },
        ),
      )
      ..addJavaScriptChannel(
        'FlutterBridge',
        onMessageReceived: (JavaScriptMessage message) {
          _handleJavaScriptMessage(message.message);
        },
      )
      ..loadRequest(Uri.parse('https://www.afronika.com/'));
  }

  void _injectJavaScript() {
    // Hide the mobile header navigation and add padding for bottom nav
    _controller.runJavaScript('''
      function hideWebNavigation() {
        const mobileHeader = document.querySelector('.theme-mobile-header-icon-wrapper');
        if (mobileHeader) {
          mobileHeader.style.display = 'none';
        }
        
        // Hide other navigation elements but keep their functionality accessible
        const navElements = document.querySelectorAll('.theme-mobile-header-icon-wrapper');
        navElements.forEach(element => {
          element.style.display = 'none';
        });
        
        // Add bottom padding to body to prevent content being hidden by bottom nav
        document.body.style.paddingBottom = '70px';
        
        // Ensure content doesn't go under the bottom navigation
        const main = document.querySelector('main') || document.body;
        main.style.paddingBottom = '70px';
      }
      
      // Function to send messages to Flutter
      function sendToFlutter(action, data) {
        FlutterBridge.postMessage(JSON.stringify({
          action: action,
          data: data
        }));
      }
      
      // Override navigation functions
      window.openMenu = function() {
        sendToFlutter('openMenu', {});
      };
      
      window.openProfile = function() {
        sendToFlutter('openProfile', {});
      };
      
      window.openCart = function() {
        sendToFlutter('openCart', {});
      };
      
      window.goHome = function() {
        sendToFlutter('goHome', {});
      };
      
      // Hide navigation when page loads
      if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', hideWebNavigation);
      } else {
        hideWebNavigation();
      }
      
      // Also hide navigation after any dynamic content loads
      setTimeout(hideWebNavigation, 1000);
    ''');
  }

  void _handleJavaScriptMessage(String message) {
    try {
      if (message.contains('openMenu')) {
        _openDrawer();
      } else if (message.contains('openProfile')) {
        _openProfile();
      } else if (message.contains('openCart')) {
        _openCart();
      } else if (message.contains('goHome')) {
        _goHome();
      }
    } catch (e) {
      print('Error handling JS message: $e');
    }
  }

  void _openDrawer() {
    _controller.runJavaScript('''
      const menuButton = document.querySelector('[data-zs-mobile-header-slide-open][data-zs-drawer-open-button="navigation"]');
      if (menuButton) {
        menuButton.click();
      }
    ''');
  }

  void _openCart() {
    setState(() {
      _selectedIndex = 1;
    });
    _controller.runJavaScript('''
      const cartButton = document.querySelector('[data-zs-view-cart]');
      if (cartButton) {
        cartButton.click();
      }
    ''');
  }

  void _openProfile() {
    setState(() {
      _selectedIndex = 2;
    });
    _controller.runJavaScript('''
      const profileButton = document.querySelector('[data-zs-drawer-open-button="portal"]');
      if (profileButton) {
        profileButton.click();
      }
    ''');
  }

  void _goHome() {
    setState(() {
      _selectedIndex = 0;
    });
    _controller.loadRequest(Uri.parse('https://www.afronika.com/'));
  }

  void _onNavTap(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        _goHome();
        break;
      case 1:
        _openCart();
        break;
      case 2:
        _openProfile();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Afronika'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(2),
            child: const Icon(
              Icons.menu,
              size: 24,
            ),
          ),
          onPressed: _openDrawer,
          tooltip: 'Open Menu',
        ),
      ),
      body: WebViewWidget(controller: _controller),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Container(
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildNavItem(
                  icon: Icons.home_rounded,
                  label: 'Home',
                  index: 0,
                  isSelected: _selectedIndex == 0,
                ),
                _buildNavItem(
                  icon: Icons.shopping_cart_rounded,
                  label: 'Cart',
                  index: 1,
                  isSelected: _selectedIndex == 1,
                ),
                _buildNavItem(
                  icon: Icons.person_rounded,
                  label: 'Profile',
                  index: 2,
                  isSelected: _selectedIndex == 2,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
    required bool isSelected,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: () => _onNavTap(index),
        behavior: HitTestBehavior.opaque,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.blue.withOpacity(0.1) : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  size: 22,
                  color: isSelected ? Colors.blue : Colors.grey[600],
                ),
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: isSelected ? Colors.blue : Colors.grey[600],
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}