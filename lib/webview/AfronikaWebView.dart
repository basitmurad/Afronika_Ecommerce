import 'package:afronika/webview/UrlLauncherHelper.dart';
import 'package:afronika/webview/ChromeTabHelper.dart'; // Add this import
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'dart:io';

class AfronikaBrowserApp extends StatefulWidget {
  const AfronikaBrowserApp({super.key});

  @override
  _AfronikaBrowserAppState createState() => _AfronikaBrowserAppState();
}

class _AfronikaBrowserAppState extends State<AfronikaBrowserApp> {
  late WebViewController webViewController;
  String currentUrl = "https://www.afronika.com/";
  bool isLoading = true;
  int loadingProgress = 0;
  bool isRefreshing = false;
  bool hasError = false;
  String errorMessage = "";

  String get injectedJavaScript => '''
    (function() {
        'use strict';

        let bridgeInitialized = false;

        function createCustomLogo() {
            // Create the custom logo HTML with colors matching Flutter widget
            const logoHTML = `
                <div id="custom-afronika-logo" style="
                    display: inline-block;
                    padding: 10px 20px;
                    font-family: 'Roboto', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
                    font-size: 28px;
                    font-weight: bold;
                    line-height: 1;
                ">
                    <span style="color: #F44336;">Afr</span><span style="color: #000000;">o</span><span style="color: #FF9800;">n</span><span style="color: #00BCD4;">ika</span>
                </div>
                <style>
                    #custom-afronika-logo:hover {
                        transform: scale(1.05);
                        transition: transform 0.2s ease;
                    }

                    /* Responsive sizing */
                    @media (max-width: 768px) {
                        #custom-afronika-logo {
                            font-size: 24px !important;
                            padding: 8px 16px !important;
                        }
                    }
                    @media (max-width: 480px) {
                        #custom-afronika-logo {
                            font-size: 20px !important;
                            padding: 6px 12px !important;
                        }
                    }
                </style>
            `;
            return logoHTML;
        }

        function replaceLogos() {
            // Logo selectors to find and replace
            const logoSelectors = [
                '[data-zs-logo]',
                '[data-zs-logo-container]',
                '.theme-logo-parent',
                '.theme-branding-info',
                '[data-zs-branding]',
                '.logo',
                '.brand-logo',
                '.site-logo',
                'img[alt*="logo"]',
                'img[src*="logo"]'
            ];

            logoSelectors.forEach(selector => {
                try {
                    const elements = document.querySelectorAll(selector);
                    elements.forEach(el => {
                        if (el && !el.querySelector('#custom-afronika-logo')) {
                            // Instead of hiding, replace with custom logo
                            const customLogo = createCustomLogo();

                            // If it's an image, replace it
                            if (el.tagName === 'IMG') {
                                el.outerHTML = customLogo;
                            } else {
                                // If it's a container, replace its content
                                el.innerHTML = customLogo;
                                el.style.display = 'block';
                            }
                        }
                    });
                } catch(e) {
                    console.log('Error replacing logo:', e);
                }
            });

            // Also check for header areas where logo might be
            try {
                const headers = document.querySelectorAll('header, .header, .top-bar, .navbar');
                headers.forEach(header => {
                    const logoElements = header.querySelectorAll('img, .logo, [class*="logo"]');
                    logoElements.forEach(logo => {
                        if (logo && !logo.querySelector('#custom-afronika-logo')) {
                            const parent = logo.parentElement;
                            if (parent && !parent.querySelector('#custom-afronika-logo')) {
                                logo.outerHTML = createCustomLogo();
                            }
                        }
                    });
                });
            } catch(e) {
                console.log('Error in header logo replacement:', e);
            }
        }

        function changeBackgroundColor() {
            // Change body background to white
            try {
                document.body.style.backgroundColor = 'white';
                document.documentElement.style.backgroundColor = 'white';

                // Also target common container elements
                const containers = document.querySelectorAll('header, .header, .app-bar, .top-bar, nav');
                containers.forEach(container => {
                    if (container) {
                        container.style.backgroundColor = 'white';
                    }
                });
            } catch(e) {}
        }

        function repositionChatIcon() {
            // Find chat widget elements
            const chatSelectors = [
                '.zsiq_flt_rel',
                '#zsiq_float',
                '.zsiq_float',
                '[id*="zsiq"]',
                '.siqicon',
                '.siqico-chat'
            ];

            chatSelectors.forEach(selector => {
                try {
                    const elements = document.querySelectorAll(selector);
                    elements.forEach(el => {
                        if (el && el.style) {
                            // Position to center-left
                            el.style.position = 'fixed';
                            el.style.left = '20px';
                            el.style.top = '50%';
                            el.style.transform = 'translateY(-50%)';
                            el.style.right = 'auto';
                            el.style.bottom = 'auto';
                            el.style.zIndex = '9999';
                        }
                    });
                } catch(e) {}
            });

            // Also target parent containers
            try {
                const chatWidget = document.querySelector('.zsiq_flt_rel');
                if (chatWidget) {
                    chatWidget.style.cssText = `
                        position: fixed !important;
                        left: 20px !important;
                        top: 50% !important;
                        transform: translateY(-50%) !important;
                        right: auto !important;
                        bottom: auto !important;
                        z-index: 9999 !important;
                    `;
                }
            } catch(e) {}
        }

        // Add click event handling for phone, email, social media, and Google auth links
        function handleExternalLinks() {
            try {
                // Remove existing event listeners to avoid duplicates
                document.removeEventListener('click', globalClickHandler);

                // Add global click handler
                document.addEventListener('click', globalClickHandler, true);

            } catch(e) {
                console.log('Error handling external links:', e);
            }
        }

        function globalClickHandler(e) {
            try {
                let target = e.target;

                // Traverse up the DOM to find an anchor tag or button
                while (target && target.tagName !== 'A' && target.tagName !== 'BUTTON') {
                    target = target.parentElement;
                }

                if (target && (target.tagName === 'A' || target.tagName === 'BUTTON')) {
                    const href = target.getAttribute('href') || target.getAttribute('data-href') || target.onclick;
                    const buttonText = target.textContent || target.innerText || '';
                    const buttonClass = target.className || '';
                    const buttonId = target.id || '';

                    // Check for Google Sign-In buttons (various patterns)
                    const isGoogleSignIn = 
                        buttonText.toLowerCase().includes('sign in with google') ||
                        buttonText.toLowerCase().includes('continue with google') ||
                        buttonText.toLowerCase().includes('google sign in') ||
                        buttonText.toLowerCase().includes('login with google') ||
                        buttonClass.includes('google') ||
                        buttonId.includes('google') ||
                        (href && (
                            href.includes('accounts.google.com') ||
                            href.includes('oauth.google.com') ||
                            href.includes('googleapis.com/oauth')
                        ));

                    if (isGoogleSignIn) {
                        console.log('Intercepting Google Sign-In:', href || buttonText);
                        e.preventDefault();
                        e.stopPropagation();

                        const messageData = {
                            type: 'google_signin',
                            url: href || window.location.href,
                            buttonText: buttonText,
                            buttonClass: buttonClass,
                            buttonId: buttonId
                        };

                        console.log('Sending Google Sign-In message to Flutter:', JSON.stringify(messageData));

                        try {
                            window.postMessage(JSON.stringify(messageData), '*');

                            if (window.Flutter && window.Flutter.postMessage) {
                                window.Flutter.postMessage(JSON.stringify(messageData));
                            }

                            window.dispatchEvent(new CustomEvent('flutterMessage', {
                                detail: messageData
                            }));

                        } catch(err) {
                            console.log('Error sending Google Sign-In message:', err);
                        }

                        return false;
                    }

                    if (href) {
                        // Handle Facebook links
                        if (href.includes('facebook.com') || href.includes('fb.com') || href.includes('m.facebook.com')) {
                            console.log('Intercepting Facebook link:', href);
                            e.preventDefault();
                            e.stopPropagation();

                            const messageData = {
                                type: 'external_link',
                                url: href,
                                platform: 'facebook'
                            };

                            console.log('Sending Facebook message to Flutter:', JSON.stringify(messageData));

                            try {
                                window.postMessage(JSON.stringify(messageData), '*');

                                if (window.Flutter && window.Flutter.postMessage) {
                                    window.Flutter.postMessage(JSON.stringify(messageData));
                                }

                                window.dispatchEvent(new CustomEvent('flutterMessage', {
                                    detail: messageData
                                }));

                            } catch(err) {
                                console.log('Error sending Facebook message:', err);
                            }

                            return false;
                        }

                        // Handle other social media links
                        if (href.includes('instagram.com') || href.includes('twitter.com') ||
                            href.includes('linkedin.com') || href.includes('youtube.com') ||
                            href.includes('tiktok.com') || href.includes('snapchat.com')) {
                            console.log('Intercepting social media link:', href);
                            e.preventDefault();
                            e.stopPropagation();

                            const messageData = {
                                type: 'external_link',
                                url: href,
                                platform: 'social'
                            };

                            console.log('Sending social media message to Flutter:', JSON.stringify(messageData));

                            try {
                                window.postMessage(JSON.stringify(messageData), '*');

                                if (window.Flutter && window.Flutter.postMessage) {
                                    window.Flutter.postMessage(JSON.stringify(messageData));
                                }

                                window.dispatchEvent(new CustomEvent('flutterMessage', {
                                    detail: messageData
                                }));

                            } catch(err) {
                                console.log('Error sending social media message:', err);
                            }

                            return false;
                        }

                        // Handle mailto and tel links
                        if (href.startsWith('mailto:') || href.startsWith('tel:')) {
                            console.log('Intercepting click on:', href);
                            e.preventDefault();
                            e.stopPropagation();

                            const messageData = {
                                type: 'external_link',
                                url: href
                            };

                            console.log('Sending message to Flutter:', JSON.stringify(messageData));

                            try {
                                window.postMessage(JSON.stringify(messageData), '*');

                                if (window.Flutter && window.Flutter.postMessage) {
                                    window.Flutter.postMessage(JSON.stringify(messageData));
                                }

                                window.dispatchEvent(new CustomEvent('flutterMessage', {
                                    detail: messageData
                                }));

                            } catch(err) {
                                console.log('Error sending message:', err);
                            }

                            return false;
                        }
                    }
                }
            } catch(error) {
                console.log('Error in click handler:', error);
            }
        }

        function initializeBridge() {
            if (bridgeInitialized) return;
            bridgeInitialized = true;

            // Replace logos and change background
            replaceLogos();
            changeBackgroundColor();
            repositionChatIcon();
            handleExternalLinks();

            // Setup observer for dynamic content
            const observer = new MutationObserver(() => {
                replaceLogos();
                changeBackgroundColor();
                repositionChatIcon();
                handleExternalLinks();
            });

            observer.observe(document.body, {
                childList: true,
                subtree: true
            });

            // Repeated operations with reduced delays
            setTimeout(() => {
                replaceLogos();
                repositionChatIcon();
                handleExternalLinks();
            }, 300);
            setTimeout(() => {
                replaceLogos();
                repositionChatIcon();
                handleExternalLinks();
            }, 600);
            setTimeout(() => {
                changeBackgroundColor();
                repositionChatIcon();
                handleExternalLinks();
            }, 400);
            setTimeout(() => {
                repositionChatIcon();
                handleExternalLinks();
            }, 800);

            // Notify Flutter
            setTimeout(() => {
                try {
                    window.postMessage(JSON.stringify({type: 'bridge_ready'}), '*');
                } catch(e) {}
            }, 300);
        }

        // Initialize when ready
        if (document.readyState === 'loading') {
            document.addEventListener('DOMContentLoaded', initializeBridge);
        } else {
            setTimeout(initializeBridge, 50);
        }

    })();
  ''';

  @override
  void initState() {
    super.initState();
    _initializeWebView();
  }

  void _initializeWebView() {
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
              hasError = false;
              errorMessage = "";
            });
          },
          onPageFinished: (String url) {
            setState(() {
              isLoading = false;
              isRefreshing = false;
              currentUrl = url;
            });

            // Inject JavaScript after page loads
            Future.delayed(const Duration(milliseconds: 300), () {
              webViewController.runJavaScript(injectedJavaScript);
            });
          },
          onWebResourceError: (WebResourceError error) {
            setState(() {
              isRefreshing = false;
              hasError = true;
              errorMessage = _getErrorMessage(error);
            });

            print('WebView Error: ${error.description}');
            print('Error Code: ${error.errorCode}');
            print('Error Type: ${error.errorType}');

            // Show error dialog after a brief delay
            Future.delayed(const Duration(milliseconds: 500), () {
              _showErrorDialog();
            });
          },
          // Handle navigation requests to intercept external URLs and Google Sign-In
          onNavigationRequest: (NavigationRequest request) {
            print('Navigation request: ${request.url}');

            // Check if it's a Google authentication URL
            if (ChromeTabHelper.isGoogleAuthUrl(request.url)) {
              print('Intercepting Google Auth URL: ${request.url}');
              ChromeTabHelper.launchGoogleSignIn(
                url: request.url,
                context: context,
              );
              return NavigationDecision.prevent;
            }

            // Check if it's a mailto or tel link
            if (UrlLauncherHelper.isExternalUrl(request.url)) {
              print('Intercepting external URL: ${request.url}');
              UrlLauncherHelper.handleExternalUrl(request.url, context);
              return NavigationDecision.prevent;
            }

            // Check if it's a Facebook link
            if (UrlLauncherHelper.isFacebookUrl(request.url)) {
              print('Intercepting Facebook URL: ${request.url}');
              UrlLauncherHelper.handleFacebookUrl(request.url, context);
              return NavigationDecision.prevent;
            }

            // Check for other social media links
            if (UrlLauncherHelper.isSocialMediaUrl(request.url)) {
              print('Intercepting social media URL: ${request.url}');
              UrlLauncherHelper.handleSocialMediaUrl(request.url, context);
              return NavigationDecision.prevent;
            }

            // Allow normal web navigation for your main domain
            if (request.url.contains('afronika.com')) {
              return NavigationDecision.navigate;
            }

            // For any other external links, open in external browser
            if (!request.url.startsWith('https://www.afronika.com') &&
                !request.url.startsWith('https://afronika.com')) {
              print('Opening external link in browser: ${request.url}');
              UrlLauncherHelper.handleExternalUrl(request.url, context);
              return NavigationDecision.prevent;
            }

            return NavigationDecision.navigate;
          },
        ),
      )
      ..addJavaScriptChannel(
        'Flutter',
        onMessageReceived: (JavaScriptMessage message) {
          try {
            print('✓ Received JS message: ${message.message}');

            final data = message.message;

            if (data.contains('hamburger_clicked')) {
              HapticFeedback.selectionClick();
              return;
            }

            // Try to parse as JSON
            try {
              final Map<String, dynamic> parsedData =
              Map<String, dynamic>.from(jsonDecode(data) as Map);

              print('✓ Parsed JSON data: $parsedData');

              // Handle Google Sign-In specifically
              if (parsedData['type'] == 'google_signin') {
                final url = parsedData['url'];
                final buttonText = parsedData['buttonText'] ?? '';

                print('✓ Handling Google Sign-In: $url');
                print('✓ Button text: $buttonText');

                // Launch Google Sign-In in Chrome Custom Tab
                ChromeTabHelper.launchGoogleSignIn(
                  url: url ?? 'https://accounts.google.com/signin',
                  context: context,
                );
                return;
              }

              if (parsedData['type'] == 'external_link') {
                final url = parsedData['url'];
                final platform = parsedData['platform'];

                print('✓ Handling external link: $url (platform: $platform)');

                // Use the helper class to handle different platforms
                if (platform == 'facebook') {
                  UrlLauncherHelper.handleFacebookUrl(url, context);
                } else if (platform == 'social') {
                  UrlLauncherHelper.handleSocialMediaUrl(url, context);
                } else {
                  UrlLauncherHelper.handleExternalUrl(url, context);
                }
              }
            } catch (jsonError) {
              print('❌ JSON parse error: $jsonError');
              print('❌ Raw message: $data');

              // Fallback: check if message contains google_signin
              if (data.contains('google_signin')) {
                print('✓ Fallback: Launching Google Sign-In');
                ChromeTabHelper.launchGoogleSignIn(
                  url: 'https://accounts.google.com/signin',
                  context: context,
                );
                return;
              }

              // Fallback: check if message contains external_link
              if (data.contains('external_link')) {
                // Try to extract URL from the message
                final regex = RegExp(r'"url":"([^"]+)"');
                final match = regex.firstMatch(data);
                if (match != null) {
                  final url = match.group(1);
                  print('✓ Extracted URL from fallback: $url');
                  if (url != null) {
                    // Check if it's Google auth URL
                    if (ChromeTabHelper.isGoogleAuthUrl(url)) {
                      ChromeTabHelper.launchGoogleSignIn(
                        url: url,
                        context: context,
                      );
                    } else {
                      // Use helper class with automatic platform detection
                      UrlLauncherHelper.handleUrl(url, context);
                    }
                  }
                } else {
                  print('❌ Could not extract URL from message');
                }
              }
            }
          } catch (e) {
            print('❌ Error in JS message handler: $e');
          }
        },
      );

    // Initial load with connectivity check
    _loadInitialUrl();
  }

  // Load initial URL with network connectivity check
  Future<void> _loadInitialUrl() async {
    try {
      // Check internet connectivity
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        // Internet is available
        webViewController.loadRequest(Uri.parse(currentUrl));
      } else {
        // No internet connection
        _showNoInternetDialog();
      }
    } catch (e) {
      print('Connectivity check failed: $e');
      // If connectivity check fails, still try to load but show appropriate error
      webViewController.loadRequest(Uri.parse(currentUrl));
    }
  }

  // Generate user-friendly error messages
  String _getErrorMessage(WebResourceError error) {
    switch (error.errorType) {
      case WebResourceErrorType.hostLookup:
        return "Unable to find the website. Please check your internet connection.";
      case WebResourceErrorType.timeout:
        return "The connection timed out. Please try again.";
      case WebResourceErrorType.connect:
        return "Unable to connect to the server. Please check your internet connection.";
      case WebResourceErrorType.fileNotFound:
        return "The requested page could not be found.";
      case WebResourceErrorType.authentication:
        return "Authentication required to access this page.";
      case WebResourceErrorType.badUrl:
        return "Invalid URL. Please check the web address.";
      case WebResourceErrorType.file:
        return "File access error occurred.";
      case WebResourceErrorType.tooManyRequests:
        return "Too many requests. Please try again later.";
      case WebResourceErrorType.unknown:
      default:
      // Check specific error codes for more details
        if (error.description.toLowerCase().contains('internet')) {
          return "No internet connection. Please check your network settings.";
        } else if (error.description.toLowerCase().contains('server')) {
          return "Server is currently unavailable. Please try again later.";
        } else if (error.description.toLowerCase().contains('dns')) {
          return "DNS lookup failed. Please check your internet connection.";
        }
        return "Unable to load the page. Please try again.";
    }
  }

  // Show no internet connection dialog
  void _showNoInternetDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.wifi_off, color: Colors.red),
              SizedBox(width: 8),
              Text('No Internet Connection'),
            ],
          ),
          content: const Text(
            'Please check your internet connection and try again.',
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Exit the app or navigate to offline page
                SystemNavigator.pop();
              },
              child: const Text(
                'Exit',
                style: TextStyle(color: Colors.red),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _retryConnection();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Retry'),
            ),
          ],
        );
      },
    );
  }

  // Show general error dialog
  void _showErrorDialog() {
    if (!hasError) return;

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.error_outline, color: Colors.orange),
              SizedBox(width: 8),
              Text('Connection Error'),
            ],
          ),
          content: Text(errorMessage.isNotEmpty ? errorMessage : 'Unable to load the page.'),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _refreshPage();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Retry'),
            ),
          ],
        );
      },
    );
  }

  // Retry connection with connectivity check
  Future<void> _retryConnection() async {
    setState(() {
      isRefreshing = true;
      hasError = false;
      errorMessage = "";
    });

    try {
      // Check internet connectivity first
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        // Internet is available, reload the page
        HapticFeedback.lightImpact();
        webViewController.reload();
      } else {
        // Still no internet
        setState(() {
          isRefreshing = false;
        });
        _showNoInternetDialog();
      }
    } catch (e) {
      print('Retry connection failed: $e');
      setState(() {
        isRefreshing = false;
      });
      // Try loading anyway
      HapticFeedback.lightImpact();
      webViewController.reload();
    }
  }

  // Refresh function with connectivity check
  Future<void> _refreshPage() async {
    setState(() {
      isRefreshing = true;
      hasError = false;
      errorMessage = "";
    });

    try {
      // Quick connectivity check
      final result = await InternetAddress.lookup('google.com').timeout(
        const Duration(seconds: 3),
      );
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        HapticFeedback.lightImpact();
        webViewController.reload();
      } else {
        setState(() {
          isRefreshing = false;
        });
        _showNoInternetDialog();
      }
    } catch (e) {
      print('Connectivity check during refresh failed: $e');
      // Try refreshing anyway
      HapticFeedback.lightImpact();
      webViewController.reload();
    }
  }

  // Handle back button press
  Future<bool> _onWillPop() async {
    try {
      print('🔙 Back button pressed');

      // Check if WebView can go back
      final canGoBack = await webViewController.canGoBack();
      print('🔙 Can go back: $canGoBack');

      if (canGoBack) {
        // Go back in WebView history
        await webViewController.goBack();
        print('🔙 Navigated back in WebView');
        return false; // Don't exit the app
      } else {
        // No more pages to go back to, show exit dialog
        print('🔙 No more pages, showing exit dialog');
        final shouldExit = await _showExitDialog();
        return shouldExit ?? false;
      }
    } catch (e) {
      print('❌ Error in back button handler: $e');
      // If there's an error, show exit dialog
      final shouldExit = await _showExitDialog();
      return shouldExit ?? false;
    }
  }

  // Improved exit confirmation dialog
  Future<bool?> _showExitDialog() {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false, // Prevent dismissing by tapping outside
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.exit_to_app, color: Colors.red),
            SizedBox(width: 8),
            Text('Exit App'),
          ],
        ),
        content: const Text('Are you sure you want to exit Afronika?'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
              HapticFeedback.lightImpact();
            },
            child: const Text(
              'Stay',
              style: TextStyle(color: Colors.teal),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(true);
              HapticFeedback.mediumImpact();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Exit'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              // Main WebView - direct implementation for full scrolling
              Positioned.fill(
                child: WebViewWidget(controller: webViewController),
              ),

              // Progress indicator
              if (isLoading)
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: LinearProgressIndicator(
                    value: loadingProgress / 100,
                    backgroundColor: Colors.grey[200],
                    valueColor: const AlwaysStoppedAnimation(Colors.teal),
                    minHeight: 3,
                  ),
                ),

              // Error overlay (optional - shows when there's an error)
              if (hasError && !isLoading)
                Positioned.fill(
                  child: Container(
                    color: Colors.white,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            size: 80,
                            color: Colors.orange,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Oops! Something went wrong',
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 32),
                            child: Text(
                              errorMessage.isNotEmpty ? errorMessage : 'Unable to load the page',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton.icon(
                            onPressed: _refreshPage,
                            icon: const Icon(Icons.refresh),
                            label: const Text('Try Again'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

              // Refresh button positioned above bottom navbar on left side
              Positioned(
                bottom: 80,
                left: 16,
                child: Material(
                  elevation: 6,
                  shape: const CircleBorder(),
                  color: Colors.white,
                  child: InkWell(
                    onTap: _refreshPage,
                    borderRadius: BorderRadius.circular(28),
                    child: Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: isRefreshing
                          ? const Padding(
                        padding: EdgeInsets.all(16),
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation(Colors.teal),
                        ),
                      )
                          : const Icon(
                        Icons.refresh,
                        color: Colors.teal,
                        size: 28,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}