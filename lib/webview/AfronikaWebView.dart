import 'package:afronika/common/GButton.dart';
import 'package:afronika/webview/UrlLauncherHelper.dart';
import 'package:afronika/webview/ChromeTabHelper.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:io';

import '../features/about/AboutAppScreen.dart';
import '../features/contact/ContactScreen.dart';
import '../features/privacy/PrivacyPolicyScreen.dart';
import '../utils/DialogHelper.dart';

class AfronikaBrowserApp extends StatefulWidget {
  const AfronikaBrowserApp({super.key});

  @override
  _AfronikaBrowserAppState createState() => _AfronikaBrowserAppState();
}

class _AfronikaBrowserAppState extends State<AfronikaBrowserApp> with TickerProviderStateMixin {
  late WebViewController webViewController;
  late AnimationController _bannerAnimationController;
  late Animation<double> _bannerAnimation;

  // Navigation history tracking
  List<String> navigationHistory = [];
  int currentHistoryIndex = -1;

  String currentUrl = "https://www.afronika.com/";
  bool isLoading = true;
  int loadingProgress = 0;
  bool isRefreshing = false;
  bool hasError = false;
  String errorMessage = "";
  bool _showCookieBanner = false;
  bool _cookiesAccepted = false;
  String get injectedJavaScript => '''
  (function() {
      'use strict';

      let bridgeInitialized = false;
      const cookiesAccepted = $_cookiesAccepted;

      // Set cookie consent if accepted
      if (cookiesAccepted) {
          try {
              document.cookie = "cookie_consent=accepted; path=/; max-age=31536000";
              localStorage.setItem('cookie_consent', 'true');
          } catch(e) {
              console.log('Error setting cookie consent:', e);
          }
      }

      function ensureMobileResponsive() {
          // Ensure viewport is set for mobile
          let viewport = document.querySelector('meta[name="viewport"]');
          if (!viewport) {
              viewport = document.createElement('meta');
              viewport.name = 'viewport';
              viewport.content = 'width=device-width, initial-scale=1.0, maximum-scale=5.0, user-scalable=yes';
              document.head.appendChild(viewport);
          }

          // Make images responsive
          try {
              const images = document.querySelectorAll('img');
              images.forEach(img => {
                  if (!img.style.maxWidth) {
                      img.style.maxWidth = '100%';
                      img.style.height = 'auto';
                  }
              });

              // Ensure logo images are properly sized for mobile
              const logoSelectors = [
                  '[data-zs-logo] img',
                  '.logo img',
                  '.brand-logo img',
                  '.site-logo img',
                  'header img',
                  '.header img'
              ];

              logoSelectors.forEach(selector => {
                  const logos = document.querySelectorAll(selector);
                  logos.forEach(logo => {
                      if (logo) {
                          logo.style.maxWidth = '100%';
                          logo.style.height = 'auto';
                          logo.style.objectFit = 'contain';
                      }
                  });
              });
          } catch(e) {
              console.error('Responsive image error:', e);
          }
      }

      function changeBackgroundColor() {
          try {
              document.body.style.backgroundColor = 'white';
              document.documentElement.style.backgroundColor = 'white';
              
              const containers = document.querySelectorAll('header, .header, .app-bar, .top-bar, nav');
              containers.forEach(container => {
                  if (container) {
                      container.style.backgroundColor = 'white';
                  }
              });
          } catch(e) {
              console.error('Background color change error:', e);
          }
      }

      function repositionChatIcon() {
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
                          el.style.cssText = `
                              position: fixed !important;
                              left: 20px !important;
                              top: 50% !important;
                              transform: translateY(-50%) !important;
                              right: auto !important;
                              bottom: auto !important;
                              z-index: 9999 !important;
                          `;
                      }
                  });
              } catch(e) {
                  console.error('Chat icon positioning error:', e);
              }
          });
      }

      function handleExternalLinks() {
          try {
              document.removeEventListener('click', globalClickHandler, true);
              document.addEventListener('click', globalClickHandler, true);
          } catch(e) {
              console.error('External link handler error:', e);
          }
      }

      function globalClickHandler(e) {
          try {
              let target = e.target;
              
              while (target && target !== document.body && target.tagName !== 'A' && target.tagName !== 'BUTTON') {
                  target = target.parentElement;
              }

              if (!target || (target.tagName !== 'A' && target.tagName !== 'BUTTON')) {
                  return;
              }

              const href = target.getAttribute('href') || target.getAttribute('data-href') || '';

              if (href) {
                  // Social media detection with improved patterns
                  const socialPatterns = {
                      facebook: /facebook\.com|fb\.com|fb\.me/i,
                      instagram: /instagram\.com|instagr\.am/i,
                      twitter: /twitter\.com|x\.com/i,
                      linkedin: /linkedin\.com|lnkd\.in/i,
                      youtube: /youtube\.com|youtu\.be/i,
                      tiktok: /tiktok\.com/i,
                      snapchat: /snapchat\.com/i
                  };
                  
                  for (const [platform, pattern] of Object.entries(socialPatterns)) {
                      if (pattern.test(href)) {
                          e.preventDefault();
                          e.stopPropagation();
                          
                          sendMessageToFlutter({
                              type: 'external_link',
                              url: href,
                              platform: platform === 'facebook' ? 'facebook' : 'social'
                          });
                          return false;
                      }
                  }

                  // Handle mailto and tel links
                  if (href.startsWith('mailto:') || href.startsWith('tel:')) {
                      e.preventDefault();
                      e.stopPropagation();
                      
                      sendMessageToFlutter({
                          type: 'external_link',
                          url: href
                      });
                      return false;
                  }
              }
          } catch(error) {
              console.error('Click handler error:', error);
          }
      }

      function sendMessageToFlutter(data) {
          const message = JSON.stringify(data);
          console.log('Sending to Flutter:', message);
          
          try {
              // Try multiple communication methods for better compatibility
              if (window.Flutter && window.Flutter.postMessage) {
                  window.Flutter.postMessage(message);
              }
              
              window.postMessage(message, '*');
              
              window.dispatchEvent(new CustomEvent('flutterMessage', {
                  detail: data
              }));
          } catch(err) {
              console.error('Message sending error:', err);
          }
      }

      function initializeBridge() {
          if (bridgeInitialized) return;
          bridgeInitialized = true;

          ensureMobileResponsive();
          changeBackgroundColor();
          repositionChatIcon();
          handleExternalLinks();

          // Optimized MutationObserver
          const observer = new MutationObserver(() => {
              requestAnimationFrame(() => {
                  ensureMobileResponsive();
                  changeBackgroundColor();
                  repositionChatIcon();
                  handleExternalLinks();
              });
          });

          observer.observe(document.body, {
              childList: true,
              subtree: true
          });

          // Staggered initialization for better performance
          const initTasks = [
              { fn: ensureMobileResponsive, delay: 300 },
              { fn: repositionChatIcon, delay: 400 },
              { fn: () => { changeBackgroundColor(); handleExternalLinks(); }, delay: 500 },
              { fn: () => sendMessageToFlutter({type: 'bridge_ready'}), delay: 600 }
          ];

          initTasks.forEach(task => {
              setTimeout(task.fn, task.delay);
          });
      }

      // Initialize when ready
      if (document.readyState === 'loading') {
          document.addEventListener('DOMContentLoaded', initializeBridge);
      } else {
          setTimeout(initializeBridge, 50);
      }
  })();
''';

  // String get injectedJavaScript => '''
  //   (function() {
  //       'use strict';
  //
  //       let bridgeInitialized = false;
  //       const cookiesAccepted = $_cookiesAccepted;
  //
  //       // Set cookie consent if accepted
  //       if (cookiesAccepted) {
  //           try {
  //               document.cookie = "cookie_consent=accepted; path=/; max-age=31536000";
  //               localStorage.setItem('cookie_consent', 'true');
  //           } catch(e) {
  //               console.log('Error setting cookie consent:', e);
  //           }
  //       }
  //
  //       function ensureMobileResponsive() {
  //           // Ensure viewport is set for mobile
  //           let viewport = document.querySelector('meta[name="viewport"]');
  //           if (!viewport) {
  //               viewport = document.createElement('meta');
  //               viewport.name = 'viewport';
  //               viewport.content = 'width=device-width, initial-scale=1.0, maximum-scale=5.0, user-scalable=yes';
  //               document.head.appendChild(viewport);
  //           }
  //
  //           // Make images responsive
  //           try {
  //               const images = document.querySelectorAll('img');
  //               images.forEach(img => {
  //                   if (!img.style.maxWidth) {
  //                       img.style.maxWidth = '100%';
  //                       img.style.height = 'auto';
  //                   }
  //               });
  //
  //               // Ensure logo images are properly sized for mobile
  //               const logoSelectors = [
  //                   '[data-zs-logo] img',
  //                   '.logo img',
  //                   '.brand-logo img',
  //                   '.site-logo img',
  //                   'header img',
  //                   '.header img'
  //               ];
  //
  //               logoSelectors.forEach(selector => {
  //                   const logos = document.querySelectorAll(selector);
  //                   logos.forEach(logo => {
  //                       if (logo) {
  //                           logo.style.maxWidth = '100%';
  //                           logo.style.height = 'auto';
  //                           logo.style.objectFit = 'contain';
  //                       }
  //                   });
  //               });
  //           } catch(e) {
  //               console.error('Responsive image error:', e);
  //           }
  //       }
  //
  //       function changeBackgroundColor() {
  //           try {
  //               document.body.style.backgroundColor = 'white';
  //               document.documentElement.style.backgroundColor = 'white';
  //
  //               const containers = document.querySelectorAll('header, .header, .app-bar, .top-bar, nav');
  //               containers.forEach(container => {
  //                   if (container) {
  //                       container.style.backgroundColor = 'white';
  //                   }
  //               });
  //           } catch(e) {
  //               console.error('Background color change error:', e);
  //           }
  //       }
  //
  //       function repositionChatIcon() {
  //           const chatSelectors = [
  //               '.zsiq_flt_rel',
  //               '#zsiq_float',
  //               '.zsiq_float',
  //               '[id*="zsiq"]',
  //               '.siqicon',
  //               '.siqico-chat'
  //           ];
  //
  //           chatSelectors.forEach(selector => {
  //               try {
  //                   const elements = document.querySelectorAll(selector);
  //                   elements.forEach(el => {
  //                       if (el && el.style) {
  //                           el.style.cssText = `
  //                               position: fixed !important;
  //                               left: 20px !important;
  //                               top: 50% !important;
  //                               transform: translateY(-50%) !important;
  //                               right: auto !important;
  //                               bottom: auto !important;
  //                               z-index: 9999 !important;
  //                           `;
  //                       }
  //                   });
  //               } catch(e) {
  //                   console.error('Chat icon positioning error:', e);
  //               }
  //           });
  //       }
  //
  //       function handleExternalLinks() {
  //           try {
  //               document.removeEventListener('click', globalClickHandler, true);
  //               document.addEventListener('click', globalClickHandler, true);
  //           } catch(e) {
  //               console.error('External link handler error:', e);
  //           }
  //       }
  //
  //       function globalClickHandler(e) {
  //           try {
  //               let target = e.target;
  //
  //               while (target && target !== document.body && target.tagName !== 'A' && target.tagName !== 'BUTTON') {
  //                   target = target.parentElement;
  //               }
  //
  //               if (!target || (target.tagName !== 'A' && target.tagName !== 'BUTTON')) {
  //                   return;
  //               }
  //
  //               const href = target.getAttribute('href') || target.getAttribute('data-href') || '';
  //               const buttonText = (target.textContent || target.innerText || '').toLowerCase();
  //               const buttonClass = (target.className || '').toLowerCase();
  //               const buttonId = (target.id || '').toLowerCase();
  //
  //               // Enhanced Google Sign-In detection
  //               const isGoogleSignIn =
  //                   buttonText.includes('google') && (buttonText.includes('sign') || buttonText.includes('login')) ||
  //                   buttonClass.includes('google') ||
  //                   buttonId.includes('google') ||
  //                   (href && (
  //                       href.includes('accounts.google.com') ||
  //                       href.includes('oauth.google.com') ||
  //                       href.includes('googleapis.com/oauth')
  //                   ));
  //
  //               if (isGoogleSignIn) {
  //                   e.preventDefault();
  //                   e.stopPropagation();
  //
  //                   const messageData = {
  //                       type: 'google_signin',
  //                       url: href || window.location.href,
  //                       buttonText: buttonText,
  //                       buttonClass: buttonClass,
  //                       buttonId: buttonId
  //                   };
  //
  //                   sendMessageToFlutter(messageData);
  //                   return false;
  //               }
  //
  //               if (href) {
  //                   // Social media detection with improved patterns
  //                   const socialPatterns = {
  //                       facebook: /facebook\.com|fb\.com|fb\.me/i,
  //                       instagram: /instagram\.com|instagr\.am/i,
  //                       twitter: /twitter\.com|x\.com/i,
  //                       linkedin: /linkedin\.com|lnkd\.in/i,
  //                       youtube: /youtube\.com|youtu\.be/i,
  //                       tiktok: /tiktok\.com/i,
  //                       snapchat: /snapchat\.com/i
  //                   };
  //
  //                   for (const [platform, pattern] of Object.entries(socialPatterns)) {
  //                       if (pattern.test(href)) {
  //                           e.preventDefault();
  //                           e.stopPropagation();
  //
  //                           sendMessageToFlutter({
  //                               type: 'external_link',
  //                               url: href,
  //                               platform: platform === 'facebook' ? 'facebook' : 'social'
  //                           });
  //                           return false;
  //                       }
  //                   }
  //
  //                   // Handle mailto and tel links
  //                   if (href.startsWith('mailto:') || href.startsWith('tel:')) {
  //                       e.preventDefault();
  //                       e.stopPropagation();
  //
  //                       sendMessageToFlutter({
  //                           type: 'external_link',
  //                           url: href
  //                       });
  //                       return false;
  //                   }
  //               }
  //           } catch(error) {
  //               console.error('Click handler error:', error);
  //           }
  //       }
  //
  //       function sendMessageToFlutter(data) {
  //           const message = JSON.stringify(data);
  //           console.log('Sending to Flutter:', message);
  //
  //           try {
  //               // Try multiple communication methods for better compatibility
  //               if (window.Flutter && window.Flutter.postMessage) {
  //                   window.Flutter.postMessage(message);
  //               }
  //
  //               window.postMessage(message, '*');
  //
  //               window.dispatchEvent(new CustomEvent('flutterMessage', {
  //                   detail: data
  //               }));
  //           } catch(err) {
  //               console.error('Message sending error:', err);
  //           }
  //       }
  //
  //       function initializeBridge() {
  //           if (bridgeInitialized) return;
  //           bridgeInitialized = true;
  //
  //           ensureMobileResponsive();
  //           changeBackgroundColor();
  //           repositionChatIcon();
  //           handleExternalLinks();
  //
  //           // Optimized MutationObserver
  //           const observer = new MutationObserver(() => {
  //               requestAnimationFrame(() => {
  //                   ensureMobileResponsive();
  //                   changeBackgroundColor();
  //                   repositionChatIcon();
  //                   handleExternalLinks();
  //               });
  //           });
  //
  //           observer.observe(document.body, {
  //               childList: true,
  //               subtree: true
  //           });
  //
  //           // Staggered initialization for better performance
  //           const initTasks = [
  //               { fn: ensureMobileResponsive, delay: 300 },
  //               { fn: repositionChatIcon, delay: 400 },
  //               { fn: () => { changeBackgroundColor(); handleExternalLinks(); }, delay: 500 },
  //               { fn: () => sendMessageToFlutter({type: 'bridge_ready'}), delay: 600 }
  //           ];
  //
  //           initTasks.forEach(task => {
  //               setTimeout(task.fn, task.delay);
  //           });
  //       }
  //
  //       // Initialize when ready
  //       if (document.readyState === 'loading') {
  //           document.addEventListener('DOMContentLoaded', initializeBridge);
  //       } else {
  //           setTimeout(initializeBridge, 50);
  //       }
  //   })();
  // ''';

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _checkCookieConsent();
    _initializeWebView();
  }

  @override
  void dispose() {
    _bannerAnimationController.dispose();
    super.dispose();
  }

  void _initializeAnimations() {
    _bannerAnimationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _bannerAnimation = CurvedAnimation(
      parent: _bannerAnimationController,
      curve: Curves.easeInOut,
    );
  }

  Future<void> _checkCookieConsent() async {
    final prefs = await SharedPreferences.getInstance();
    final consent = prefs.getBool('cookie_consent') ?? false;
    setState(() {
      _showCookieBanner = !consent;
      _cookiesAccepted = consent;
    });

    if (_showCookieBanner) {
      _bannerAnimationController.forward();
    }
  }

  Future<void> _handleCookieConsent(bool accept) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('cookie_consent', accept);

    setState(() {
      _cookiesAccepted = accept;
    });

    // Animate banner out
    await _bannerAnimationController.reverse();

    setState(() {
      _showCookieBanner = false;
    });

    // Inject updated JavaScript with cookie consent
    if (accept) {
      webViewController.runJavaScript('''
        document.cookie = "cookie_consent=accepted; path=/; max-age=31536000";
        try {
          localStorage.setItem('cookie_consent', 'true');
        } catch(e) {}
      ''');
    }

    // Reload page to apply cookie settings
    webViewController.reload();
  }

  void _initializeWebView() {
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

            // Check if navigating to home page
            bool isHomePage = url == 'https://www.afronika.com/' ||
                url == 'https://afronika.com/' ||
                url == 'http://www.afronika.com/' ||
                url == 'http://afronika.com/' ||
                url.endsWith('afronika.com');

            // Reset navigation history if going to home page
            if (isHomePage && navigationHistory.isNotEmpty) {
              // Clear history and start fresh when returning to home
              debugPrint('🏠 Home page detected - resetting navigation history');
              navigationHistory.clear();
              navigationHistory.add(url);
              currentHistoryIndex = 0;
            } else {
              // Normal navigation history tracking
              if (navigationHistory.isEmpty ||
                  (currentHistoryIndex >= 0 &&
                      currentHistoryIndex < navigationHistory.length &&
                      navigationHistory[currentHistoryIndex] != url)) {
                // Remove forward history if navigating to a new page
                if (currentHistoryIndex < navigationHistory.length - 1) {
                  navigationHistory = navigationHistory.sublist(0, currentHistoryIndex + 1);
                }
                navigationHistory.add(url);
                currentHistoryIndex = navigationHistory.length - 1;

                // Limit history size to prevent memory issues
                if (navigationHistory.length > 50) {
                  navigationHistory.removeAt(0);
                  currentHistoryIndex--;
                }
              }
            }

            debugPrint('📍 Navigation History: ${navigationHistory.length} pages');
            debugPrint('📍 Current Index: $currentHistoryIndex');
            debugPrint('📍 Current URL: $url');
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

            debugPrint('WebView Error: ${error.description}');

            // Show error dialog after a brief delay
            Future.delayed(const Duration(milliseconds: 500), () {
              if (mounted && hasError) {
                _showErrorDialog();
              }
            });
          },
          onNavigationRequest: (NavigationRequest request) {
            debugPrint('Navigation request: ${request.url}');
            //
            // // Check if it's a Google authentication URL
            // if (ChromeTabHelper.isGoogleAuthUrl(request.url)) {
            //   ChromeTabHelper.launchGoogleSignIn(
            //     url: request.url,
            //     context: context,
            //   );
            //   return NavigationDecision.prevent;
            // }

            // Check if it's an external URL
            if (UrlLauncherHelper.isExternalUrl(request.url)) {
              UrlLauncherHelper.handleExternalUrl(request.url, context);
              return NavigationDecision.prevent;
            }

            // Check if it's a Facebook link
            if (UrlLauncherHelper.isFacebookUrl(request.url)) {
              UrlLauncherHelper.handleFacebookUrl(request.url, context);
              return NavigationDecision.prevent;
            }

            // Check for other social media links
            if (UrlLauncherHelper.isSocialMediaUrl(request.url)) {
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
              UrlLauncherHelper.handleExternalUrl(request.url, context);
              return NavigationDecision.prevent;
            }

            return NavigationDecision.navigate;
          },
        ),
      )
      ..addJavaScriptChannel(
        'Flutter',
        onMessageReceived: _handleJavaScriptMessage,
      );

    _loadInitialUrl();
  }

  void _handleJavaScriptMessage(JavaScriptMessage message) {
    try {
      debugPrint('✓ Received JS message: ${message.message}');

      final data = message.message;

      if (data.contains('hamburger_clicked')) {
        HapticFeedback.selectionClick();
        return;
      }

      // Try to parse as JSON
      try {
        final Map<String, dynamic> parsedData =
        Map<String, dynamic>.from(jsonDecode(data) as Map);

        debugPrint('✓ Parsed JSON data: $parsedData');

        // Handle Google Sign-In
        // if (parsedData['type'] == 'google_signin') {
        //   final url = parsedData['url'] ?? 'https://accounts.google.com/signin';
        //   ChromeTabHelper.launchGoogleSignIn(
        //     url: url,
        //     context: context,
        //   );
        //   return;
        // }

        // Handle external links
        if (parsedData['type'] == 'external_link') {
          final url = parsedData['url'];
          final platform = parsedData['platform'];

          if (platform == 'facebook') {
            UrlLauncherHelper.handleFacebookUrl(url, context);
          } else if (platform == 'social') {
            UrlLauncherHelper.handleSocialMediaUrl(url, context);
          } else {
            UrlLauncherHelper.handleExternalUrl(url, context);
          }
        }
      } catch (jsonError) {
        debugPrint('❌ JSON parse error: $jsonError');

        // Fallback handling
        if (data.contains('google_signin')) {
          ChromeTabHelper.launchGoogleSignIn(
            url: 'https://accounts.google.com/signin',
            context: context,
          );
        } else if (data.contains('external_link')) {
          // Try to extract URL from the message
          final regex = RegExp(r'"url":"([^"]+)"');
          final match = regex.firstMatch(data);
          if (match != null) {
            final url = match.group(1);
            if (url != null) {
              UrlLauncherHelper.handleUrl(url, context);
            }
          }
        }
      }
    } catch (e) {
      debugPrint('❌ Error in JS message handler: $e');
    }
  }

  Future<void> _loadInitialUrl() async {
    try {
      // Check internet connectivity
      final result = await InternetAddress.lookup('google.com')
          .timeout(const Duration(seconds: 5));
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        webViewController.loadRequest(Uri.parse(currentUrl));
      } else {
        _showNoInternetDialog();
      }
    } catch (e) {
      debugPrint('Connectivity check failed: $e');
      // If connectivity check fails, still try to load but show appropriate error
      webViewController.loadRequest(Uri.parse(currentUrl));
    }
  }

  String _getErrorMessage(WebResourceError error) {
    final errorMessages = {
      WebResourceErrorType.hostLookup: "Unable to find the website. Please check your internet connection.",
      WebResourceErrorType.timeout: "The connection timed out. Please try again.",
      WebResourceErrorType.connect: "Unable to connect to the server. Please check your internet connection.",
      WebResourceErrorType.fileNotFound: "The requested page could not be found.",
      WebResourceErrorType.authentication: "Authentication required to access this page.",
      WebResourceErrorType.badUrl: "Invalid URL. Please check the web address.",
      WebResourceErrorType.file: "File access error occurred.",
      WebResourceErrorType.tooManyRequests: "Too many requests. Please try again later.",
    };

    return errorMessages[error.errorType] ??
        _getFallbackErrorMessage(error.description);
  }

  String _getFallbackErrorMessage(String description) {
    final desc = description.toLowerCase();
    if (desc.contains('internet')) {
      return "No internet connection. Please check your network settings.";
    } else if (desc.contains('server')) {
      return "Server is currently unavailable. Please try again later.";
    } else if (desc.contains('dns')) {
      return "DNS lookup failed. Please check your internet connection.";
    }
    return "Unable to load the page. Please try again.";
  }

  void _showNoInternetDialog() {
    if (!mounted) return;

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
            AButton(
              buttonType: AButtonType.outlined,
              text: "Exit",
              onPressed: () => SystemNavigator.pop(),
            ),

            SizedBox(height: 12,),

            AButton(
              text: 'Retry',
              onPressed: () {
                Navigator.of(context).pop();
                _retryConnection();
              },
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog() {
    if (!mounted || !hasError) return;

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
          content: Text(errorMessage.isNotEmpty
              ? errorMessage
              : 'Unable to load the page.'),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          actions: [
            AButton(
              buttonType: AButtonType.outlined,
              text: "Cancel",
              onPressed: () => Navigator.of(context).pop(),
            ),
            SizedBox(height: 12,),
            AButton(
              text: 'Retry',
              onPressed: () {
                Navigator.of(context).pop();
                _refreshPage();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _retryConnection() async {
    setState(() {
      isRefreshing = true;
      hasError = false;
      errorMessage = "";
    });

    try {
      final result = await InternetAddress.lookup('google.com')
          .timeout(const Duration(seconds: 3));
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        HapticFeedback.lightImpact();
        webViewController.reload();
      } else {
        setState(() => isRefreshing = false);
        _showNoInternetDialog();
      }
    } catch (e) {
      debugPrint('Retry connection failed: $e');
      setState(() => isRefreshing = false);
      HapticFeedback.lightImpact();
      webViewController.reload();
    }
  }

  Future<void> _refreshPage() async {
    setState(() {
      isRefreshing = true;
      hasError = false;
      errorMessage = "";
    });

    try {
      final result = await InternetAddress.lookup('google.com')
          .timeout(const Duration(seconds: 3));
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        HapticFeedback.lightImpact();
        webViewController.reload();
      } else {
        setState(() => isRefreshing = false);
        _showNoInternetDialog();
      }
    } catch (e) {
      debugPrint('Connectivity check during refresh failed: $e');
      HapticFeedback.lightImpact();
      webViewController.reload();
    }
  }

  Future<bool> _onWillPop() async {
    try {
      debugPrint('🔙 Back button pressed');
      debugPrint('📍 History: ${navigationHistory.length} pages, Current: $currentHistoryIndex');

      // Check if current page is home page
      bool isCurrentlyOnHome = currentUrl == 'https://www.afronika.com/' ||
          currentUrl == 'https://afronika.com/' ||
          currentUrl.endsWith('afronika.com');

      // If on home page and history is minimal, show exit dialog
      if (isCurrentlyOnHome && navigationHistory.length <= 1) {
        debugPrint('🏠 Already on home page, showing exit dialog');
        final shouldExit = await DialogHelper.showExitDialog(context);
        return shouldExit ?? false;
      }

      // First check if we can go back in our navigation history
      if (currentHistoryIndex > 0) {
        currentHistoryIndex--;
        final previousUrl = navigationHistory[currentHistoryIndex];

        debugPrint('🔙 Navigating back to: $previousUrl');

        // Check if going back to home page
        bool isGoingToHome = previousUrl == 'https://www.afronika.com/' ||
            previousUrl == 'https://afronika.com/' ||
            previousUrl.endsWith('afronika.com');

        if (isGoingToHome) {
          // Reset history when going back to home
          debugPrint('🏠 Going back to home - resetting navigation');
          navigationHistory.clear();
          navigationHistory.add(previousUrl);
          currentHistoryIndex = 0;
        }

        setState(() {
          isLoading = true;
          currentUrl = previousUrl;
        });

        await webViewController.loadRequest(Uri.parse(previousUrl));
        return false; // Don't exit the app
      }

      // Also check WebView's built-in navigation
      final canGoBack = await webViewController.canGoBack();
      if (canGoBack) {
        await webViewController.goBack();
        return false;
      }

      // No more pages to go back to, show exit dialog
      debugPrint('🔙 No more pages, showing exit dialog');
      final shouldExit = await DialogHelper.showExitDialog(context);
      return shouldExit ?? false;
    } catch (e) {
      debugPrint('❌ Error in back button handler: $e');
      final shouldExit = await DialogHelper.showExitDialog(context);
      return shouldExit ?? false;
    }
  }

  // Add method to go forward in history
  Future<void> _goForward() async {
    if (currentHistoryIndex < navigationHistory.length - 1) {
      currentHistoryIndex++;
      final nextUrl = navigationHistory[currentHistoryIndex];

      setState(() {
        isLoading = true;
        currentUrl = nextUrl;
      });

      await webViewController.loadRequest(Uri.parse(nextUrl));
    }
  }

  Widget _buildLoadingIndicator() {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 60,
                  height: 60,
                  child: CircularProgressIndicator(
                    value: isLoading ? (loadingProgress / 100) : null,
                    strokeWidth: 3,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.teal,
                    ),
                  ),
                ),
                Text(
                  '${loadingProgress}%',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Loading...',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: 200,
              child: Text(
                _getLoadingMessage(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[500],
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getLoadingMessage() {
    if (currentUrl.contains('afronika.com')) {
      return 'Loading Afronika...';
    } else if (currentUrl.contains('google.com')) {
      return 'Connecting to Google...';
    } else if (currentUrl.contains('facebook.com')) {
      return 'Loading Facebook...';
    } else {
      final uri = Uri.tryParse(currentUrl);
      if (uri != null) {
        return 'Loading ${uri.host}...';
      }
      return 'Please wait...';
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              // Main WebView
              Positioned.fill(
                child: WebViewWidget(controller: webViewController),
              ),

              // Progress indicator (top bar style)
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

              // Menu button (top right)
              Positioned(
                bottom: 170,
                left: 16,
                child: Material(
                  elevation: 4,
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white.withOpacity(0.95),
                  child: InkWell(
                    onTap: () => _showMenuBottomSheet(context),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.grey.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: Icon(
                        Icons.menu,
                        color: Colors.teal,
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ),

              // Error overlay
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
                              errorMessage.isNotEmpty
                                  ? errorMessage
                                  : 'Unable to load the page',
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

              // Cookie Consent Banner
              if (_showCookieBanner)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: AnimatedBuilder(
                    animation: _bannerAnimation,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(0, 100 * (1 - _bannerAnimation.value)),
                        child: Opacity(
                          opacity: _bannerAnimation.value,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[900],
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 10,
                                  offset: const Offset(0, -2),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.cookie,
                                      color: Colors.amber[700],
                                      size: 24,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        'Cookie Consent',
                                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'We use cookies to enhance your browsing experience, analyze site traffic, and personalize content. By clicking "Accept All", you consent to our use of cookies.',
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Colors.grey[300],
                                    height: 1.4,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TextButton(
                                      onPressed: () => _handleCookieConsent(false),
                                      style: TextButton.styleFrom(
                                        foregroundColor: Colors.grey[400],
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 20,
                                          vertical: 10,
                                        ),
                                      ),
                                      child: const Text('Decline'),
                                    ),
                                    const SizedBox(width: 8),
                                    ElevatedButton(
                                      onPressed: () => _handleCookieConsent(true),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.teal,
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 20,
                                          vertical: 10,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                      ),
                                      child: const Text('Accept All'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

              // Navigation buttons row (optional - you can add this for better UX)
              Positioned(
                bottom: _showCookieBanner ? 180 : 80,
                right: 16,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Back button
                      if (currentHistoryIndex > 0)
                        Material(
                          elevation: 4,
                          shape: const CircleBorder(),
                          color: Colors.white,
                          child: InkWell(
                            onTap: () async {
                              HapticFeedback.lightImpact();
                              await _onWillPop();
                            },
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.arrow_back_ios_rounded,
                                color: Colors.teal,
                                size: 20,
                              ),
                            ),
                          ),
                        ),

                      if (currentHistoryIndex > 0) const SizedBox(width: 8),

                      // Forward button
                      if (currentHistoryIndex < navigationHistory.length - 1)
                        Material(
                          elevation: 4,
                          shape: const CircleBorder(),
                          color: Colors.white,
                          child: InkWell(
                            onTap: () async {
                              HapticFeedback.lightImpact();
                              await _goForward();
                            },
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.arrow_forward_ios_rounded,
                                color: Colors.teal,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              // Refresh button
              Positioned(
                bottom: _showCookieBanner ? 180 : 80,
                left: 16,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
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
              ),
            ],
          ),
        ),
      ),
    );
  }


  // Add these methods to your _AfronikaBrowserAppState class, after the existing methods
// Place them before the @override Widget build(BuildContext context) method

  void _showMenuBottomSheet(BuildContext context) {
    HapticFeedback.selectionClick();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Menu title
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Icon(
                      Icons.apps,
                      color: Colors.teal,
                      size: 28,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Menu',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                  ],
                ),
              ),

              const Divider(height: 1),

              // Menu items
              _buildMenuItem(
                context: context,
                icon: Icons.privacy_tip,
                title: 'Privacy Policy',
                subtitle: 'Read our privacy policy',
                onTap: () {
                  Navigator.pop(context);
                  _navigateToPrivacyPolicy();
                },
              ),

              _buildMenuItem(
                context: context,
                icon: Icons.info,
                title: 'About App',
                subtitle: 'Learn about Afronika',
                onTap: () {
                  Navigator.pop(context);
                  _navigateToAboutApp();
                },
              ),

              _buildMenuItem(
                context: context,
                icon: Icons.contact_support,
                title: 'Contact',
                subtitle: 'Get in touch with us',
                onTap: () {
                  Navigator.pop(context);
                  _navigateToContact();
                },
              ),

              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMenuItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.teal.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: Colors.teal,
                  size: 24,
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
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800],
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey[400],
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToPrivacyPolicy() {
    // Uncomment this when you have imported the PrivacyPolicyScreen

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PrivacyPolicyScreen(),
      ),
    );


    // Temporary: Show a message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Privacy Policy Screen - Import the screen file to enable'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _navigateToAboutApp() {
    // Uncomment this when you have imported the AboutAppScreen

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AboutAppScreen(),
      ),
    );


    // Temporary: Show a message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('About App Screen - Import the screen file to enable'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _navigateToContact() {
    // Uncomment this when you have imported the ContactScreen

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ContactScreen(),
      ),
    );


    // Temporary: Show a message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Contact Screen - Import the screen file to enable'),
        backgroundColor: Colors.orange,
      ),
    );
  }
}