import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/services.dart';

class AfronikaBrowserApp extends StatefulWidget {
  @override
  _AfronikaBrowserAppState createState() => _AfronikaBrowserAppState();
}

class _AfronikaBrowserAppState extends State<AfronikaBrowserApp> {
  late WebViewController webViewController;
  String currentUrl = "https://www.afronika.com/";
  bool isLoading = true;
  int loadingProgress = 0;

  // Optimized JavaScript code to inject
  String get injectedJavaScript => '''
    (function() {
        'use strict';
        
        // Throttle function to reduce excessive calls
        function throttle(func, limit) {
            let inThrottle;
            return function() {
                const args = arguments;
                const context = this;
                if (!inThrottle) {
                    func.apply(context, args);
                    inThrottle = true;
                    setTimeout(() => inThrottle = false, limit);
                }
            }
        }
        
        let bridgeInitialized = false;
        
        function addHamburgerToAppBar() {
            // Check if already exists
            if (document.querySelector('.app-bar-hamburger')) return;
            
            const hamburgerIcon = document.createElement('div');
            hamburgerIcon.className = 'app-bar-hamburger';
            
            hamburgerIcon.style.cssText = `
                position: fixed;
                top: 70px;
                left: 15px;
                z-index: 9999;
                background: rgba(255, 255, 255, 0.95);
                border-radius: 50%;
                padding: 12px;
                box-shadow: 0 4px 12px rgba(0,0,0,0.15);
                cursor: pointer;
                width: 48px;
                height: 48px;
                display: flex;
                align-items: center;
                justify-content: center;
                border: 1px solid rgba(0,0,0,0.1);
                transition: transform 0.2s ease;
            `;
            
            hamburgerIcon.innerHTML = `
                <svg width="24px" height="24px" fill="#000000" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">
                    <path d="M 2 5 L 2 7 L 22 7 L 22 5 L 2 5 z M 2 11 L 2 13 L 22 13 L 22 11 L 2 11 z M 2 17 L 2 19 L 22 19 L 22 17 L 2 17 z"></path>
                </svg>
            `;
            
            hamburgerIcon.addEventListener('click', function(e) {
                e.preventDefault();
                e.stopPropagation();
                
                // Find and click original navigation
                const originalButton = document.querySelector('[data-zs-drawer-open-button="navigation"]:not(.app-bar-hamburger)') ||
                                     document.querySelector('[data-zs-mobile-header-slide-open]:not(.app-bar-hamburger)');
                
                if (originalButton) {
                    originalButton.click();
                }
                
                // Notify Flutter
                try {
                    window.postMessage(JSON.stringify({type: 'hamburger_clicked'}), '*');
                } catch(e) {}
            });
            
            // Simple hover effect
            hamburgerIcon.addEventListener('mousedown', function() {
                this.style.transform = 'scale(0.95)';
            });
            
            hamburgerIcon.addEventListener('mouseup', function() {
                this.style.transform = 'scale(1)';
            });
            
            document.body.appendChild(hamburgerIcon);
        }
        
        function hideBottomNavHamburgers() {
            // Only hide hamburgers that are NOT in the top app bar area
            const selectors = [
                '[data-zs-drawer-open-button="navigation"]',
                '[data-zs-mobile-header-slide-open]',
                '.theme-mobile-header-slide-open'
            ];
            
            selectors.forEach(selector => {
                try {
                    const elements = document.querySelectorAll(selector);
                    elements.forEach(el => {
                        if (el) {
                            const rect = el.getBoundingClientRect();
                            const windowHeight = window.innerHeight;
                            
                            // Only hide if it's in the bottom area (bottom navigation)
                            // Keep the ones in top area (app bar)
                            if (rect.top > windowHeight * 0.8) {
                                el.style.display = 'none';
                                console.log('Hidden bottom nav hamburger');
                            }
                        }
                    });
                } catch(e) {}
            });
        }
        
        // Throttled function to avoid excessive operations
        const throttledHide = throttle(hideBottomNavHamburgers, 1000);
        
        function initializeBridge() {
            if (bridgeInitialized) return;
            bridgeInitialized = true;
            
            // Remove logo and enhance original hamburger
            modifyAppBarElements();
            
            // Hide bottom navigation hamburgers only
            hideBottomNavHamburgers();
            setTimeout(hideBottomNavHamburgers, 1000);
            
            // Setup minimal observer for dynamic content
            const observer = new MutationObserver(throttledHide);
            observer.observe(document.body, {
                childList: true,
                subtree: false
            });
            
            // Notify Flutter
            setTimeout(() => {
                try {
                    window.postMessage(JSON.stringify({type: 'bridge_ready'}), '*');
                } catch(e) {}
            }, 1500);
        }
        
        // Initialize when ready
        if (document.readyState === 'loading') {
            document.addEventListener('DOMContentLoaded', initializeBridge);
        } else {
            setTimeout(initializeBridge, 100);
        }
        
    })();
  ''';

  @override
  void initState() {
    super.initState();

    // Initialize the WebView controller
    webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            setState(() {
              loadingProgress = progress;
              isLoading = progress < 100;
            });
          },
          onPageStarted: (String url) {
            setState(() {
              isLoading = true;
              currentUrl = url;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              isLoading = false;
              currentUrl = url;
            });

            // Delayed injection to ensure page is fully loaded
            Future.delayed(Duration(milliseconds: 800), () {
              webViewController.runJavaScript(injectedJavaScript);
            });
          },
          onWebResourceError: (WebResourceError error) {
            // Silent error handling to reduce console noise
          },
        ),
      )
      ..addJavaScriptChannel(
        'Flutter',
        onMessageReceived: (JavaScriptMessage message) {
          try {
            final data = message.message;
            if (data.contains('hamburger_clicked')) {
              HapticFeedback.selectionClick();
            }
            // Reduced logging to improve performance
          } catch (e) {
            // Silent error handling
          }
        },
      )
      ..loadRequest(Uri.parse(currentUrl));
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 32.0),
            child: WebViewWidget(controller: webViewController),
          ),
          if (isLoading)
            Container(
              color: Colors.white,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      value: loadingProgress / 100.0,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                    ),

                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

