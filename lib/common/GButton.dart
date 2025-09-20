import 'package:flutter/material.dart';
import '../utils/constant/app_test_style.dart';
import '../utils/constant/colors.dart';
import '../utils/device/device_utility.dart';

enum AButtonType {
  primary,
  outlined,
  text,
  social
}

class AButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final AButtonType buttonType;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final String? prefixImagePath;
  final double? prefixImageWidth;
  final double? prefixImageHeight;
  final bool isLoading;
  final Color? backgroundColor;
  final Color? textColor;
  final double? fontSize;
  final FontWeight? fontWeight;
  final EdgeInsetsGeometry? padding;

  const AButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.buttonType = AButtonType.primary,
    this.width,
    this.height = 54.0,
    this.borderRadius,
    this.prefixImagePath,
    this.prefixImageWidth = 24.0,
    this.prefixImageHeight = 24.0,
    this.isLoading = false,
    this.backgroundColor,
    this.textColor = Colors.white,
    this.fontSize = 16.0,
    this.fontWeight = FontWeight.w600,
    this.padding,
  });

  bool get isDisabled => onPressed == null && !isLoading;

  @override
  Widget build(BuildContext context) {
    final bool isDark = ADeviceUtils.isDarkMode(context);
    final radius = borderRadius ?? BorderRadius.circular(10);

    switch (buttonType) {
      case AButtonType.primary:
        return _buildPrimaryButton(context, isDark, radius);
      case AButtonType.outlined:
        return _buildOutlinedButton(context, isDark, radius);
      case AButtonType.text:
        return _buildTextButton(context, isDark, radius);
      case AButtonType.social:
        return _buildSocialButton(context, isDark, radius);
    }
  }

  Widget _buildPrimaryButton(BuildContext context, bool isDark, BorderRadius radius) {
    return GestureDetector(
      onTap: (isLoading || isDisabled) ? null : onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: width ?? double.infinity,
        height: height,
        decoration: BoxDecoration(
          color: _getPrimaryBackgroundColor(isDark),
          borderRadius: radius,
          boxShadow: isDisabled
              ? null
              : [
            BoxShadow(
              color: (backgroundColor ?? AColors.primary).withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: padding ?? const EdgeInsets.symmetric(vertical: 16),
        child: _buildButtonContent(isDark),
      ),
    );
  }

  Widget _buildOutlinedButton(BuildContext context, bool isDark, BorderRadius radius) {
    return GestureDetector(
      onTap: (isLoading || isDisabled) ? null : onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: width ?? double.infinity,
        height: height,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: radius,
          border: Border.all(
            color: _getOutlinedBorderColor(isDark),
            width: 1,
          ),
        ),
        padding: padding ?? const EdgeInsets.symmetric(vertical: 16),
        child: _buildButtonContent(isDark),
      ),
    );
  }

  Widget _buildTextButton(BuildContext context, bool isDark, BorderRadius radius) {
    return GestureDetector(
      onTap: (isLoading || isDisabled) ? null : onPressed,
      child: Container(
        width: width ?? double.infinity,
        height: height ?? 30,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: radius,
        ),
        padding: padding ?? EdgeInsets.zero,
        child: _buildButtonContent(isDark),
      ),
    );
  }

  Widget _buildSocialButton(BuildContext context, bool isDark, BorderRadius radius) {
    return GestureDetector(
      onTap: (isLoading || isDisabled) ? null : onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: width ?? double.infinity,
        height: height,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: radius,
          border: Border.all(
            color: _getSocialBorderColor(isDark),
            width: 1,
          ),
        ),
        padding: padding ?? const EdgeInsets.symmetric(vertical: 12),
        child: _buildButtonContent(isDark),
      ),
    );
  }

  Widget _buildButtonContent(bool isDark) {
    if (isLoading) {
      return Center(
        child: SizedBox(
          height: 20,
          width: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(
              textColor ?? (buttonType == AButtonType.primary ? Colors.white : AColors.primary),
            ),
          ),
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (prefixImagePath != null)
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: isDisabled ? 0.5 : 1.0,
              child: Image(
                image: AssetImage(prefixImagePath!),
                width: prefixImageWidth,
                height: prefixImageHeight,
              ),
            ),
          ),
        Flexible(
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            style: AappTextStyle.roboto(
              color: textColor ?? _getDefaultTextColor(isDark),
              fontSize: fontSize ?? 16.0,
              weight: fontWeight ?? FontWeight.w400,
            ),
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: AappTextStyle.roboto(color: textColor!, fontSize: fontSize!, weight: FontWeight.w400),
            ),
          ),
        ),
      ],
    );
  }

  Color _getPrimaryBackgroundColor(bool isDark) {
    if (isDisabled) {
      return isDark ? Colors.grey[800]! : Colors.grey[300]!;
    }
    return backgroundColor ?? AColors.primary;
  }

  Color _getOutlinedBorderColor(bool isDark) {
    if (isDisabled) {
      return isDark ? Colors.grey[700]! : Colors.grey[400]!;
    }
    return backgroundColor ?? AColors.primary;
  }

  Color _getSocialBorderColor(bool isDark) {
    if (isDisabled) {
      return isDark ? Colors.grey[700]! : Colors.grey[400]!;
    }
    return backgroundColor ?? (isDark ? Colors.grey.shade600 : Colors.grey.shade300);
  }

  Color _getDefaultTextColor(bool isDark) {
    if (isDisabled) {
      switch (buttonType) {
        case AButtonType.primary:
          return isDark ? Colors.grey[500]! : Colors.grey[600]!;
        case AButtonType.outlined:
        case AButtonType.text:
          return isDark ? Colors.grey[600]! : Colors.grey[500]!;
        case AButtonType.social:
          return isDark ? Colors.grey[600]! : Colors.grey[500]!;
      }
    }

    switch (buttonType) {
      case AButtonType.primary:
        return Colors.white;
      case AButtonType.outlined:
      case AButtonType.text:
        return AColors.primary;
      case AButtonType.social:
        return isDark ? AColors.lightGray100 : AColors.darkGray900;
    }
  }
}



//
//
// import 'package:afronika/common/GButton.dart';
// import 'package:afronika/webview/UrlLauncherHelper.dart';
// import 'package:afronika/webview/ChromeTabHelper.dart';
// import 'package:flutter/material.dart';
// import 'package:webview_flutter/webview_flutter.dart';
// import 'package:flutter/services.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'dart:convert';
// import 'dart:io';
//
// import '../utils/DialogHelper.dart';
//
// class AfronikaBrowserApp extends StatefulWidget {
//   const AfronikaBrowserApp({super.key});
//
//   @override
//   _AfronikaBrowserAppState createState() => _AfronikaBrowserAppState();
// }
//
// class _AfronikaBrowserAppState extends State<AfronikaBrowserApp> with TickerProviderStateMixin {
//   late WebViewController webViewController;
//   late AnimationController _bannerAnimationController;
//   late Animation<double> _bannerAnimation;
//
//   // Navigation history tracking
//   List<String> navigationHistory = [];
//   int currentHistoryIndex = -1;
//
//   String currentUrl = "https://www.afronika.com/";
//   bool isLoading = true;
//   int loadingProgress = 0;
//   bool isRefreshing = false;
//   bool hasError = false;
//   String errorMessage = "";
//   bool _showCookieBanner = false;
//   bool _cookiesAccepted = false;
//
//   String get injectedJavaScript => '''
//     (function() {
//         'use strict';
//
//         let bridgeInitialized = false;
//         const cookiesAccepted = $_cookiesAccepted;
//
//         // Set cookie consent if accepted
//         if (cookiesAccepted) {
//             try {
//                 document.cookie = "cookie_consent=accepted; path=/; max-age=31536000";
//                 localStorage.setItem('cookie_consent', 'true');
//             } catch(e) {
//                 console.log('Error setting cookie consent:', e);
//             }
//         }
//
//         function ensureMobileResponsive() {
//             // Ensure viewport is set for mobile
//             let viewport = document.querySelector('meta[name="viewport"]');
//             if (!viewport) {
//                 viewport = document.createElement('meta');
//                 viewport.name = 'viewport';
//                 viewport.content = 'width=device-width, initial-scale=1.0, maximum-scale=5.0, user-scalable=yes';
//                 document.head.appendChild(viewport);
//             }
//
//             // Make images responsive
//             try {
//                 const images = document.querySelectorAll('img');
//                 images.forEach(img => {
//                     if (!img.style.maxWidth) {
//                         img.style.maxWidth = '100%';
//                         img.style.height = 'auto';
//                     }
//                 });
//
//                 // Ensure logo images are properly sized for mobile
//                 const logoSelectors = [
//                     '[data-zs-logo] img',
//                     '.logo img',
//                     '.brand-logo img',
//                     '.site-logo img',
//                     'header img',
//                     '.header img'
//                 ];
//
//                 logoSelectors.forEach(selector => {
//                     const logos = document.querySelectorAll(selector);
//                     logos.forEach(logo => {
//                         if (logo) {
//                             logo.style.maxWidth = '100%';
//                             logo.style.height = 'auto';
//                             logo.style.objectFit = 'contain';
//                         }
//                     });
//                 });
//             } catch(e) {
//                 console.error('Responsive image error:', e);
//             }
//         }
//
//         function changeBackgroundColor() {
//             try {
//                 document.body.style.backgroundColor = 'white';
//                 document.documentElement.style.backgroundColor = 'white';
//
//                 const containers = document.querySelectorAll('header, .header, .app-bar, .top-bar, nav');
//                 containers.forEach(container => {
//                     if (container) {
//                         container.style.backgroundColor = 'white';
//                     }
//                 });
//             } catch(e) {
//                 console.error('Background color change error:', e);
//             }
//         }
//
//         function repositionChatIcon() {
//             const chatSelectors = [
//                 '.zsiq_flt_rel',
//                 '#zsiq_float',
//                 '.zsiq_float',
//                 '[id*="zsiq"]',
//                 '.siqicon',
//                 '.siqico-chat'
//             ];
//
//             chatSelectors.forEach(selector => {
//                 try {
//                     const elements = document.querySelectorAll(selector);
//                     elements.forEach(el => {
//                         if (el && el.style) {
//                             el.style.cssText = `
//                                 position: fixed !important;
//                                 left: 20px !important;
//                                 top: 50% !important;
//                                 transform: translateY(-50%) !important;
//                                 right: auto !important;
//                                 bottom: auto !important;
//                                 z-index: 9999 !important;
//                             `;
//                         }
//                     });
//                 } catch(e) {
//                     console.error('Chat icon positioning error:', e);
//                 }
//             });
//         }
//
//         function handleExternalLinks() {
//             try {
//                 document.removeEventListener('click', globalClickHandler, true);
//                 document.addEventListener('click', globalClickHandler, true);
//             } catch(e) {
//                 console.error('External link handler error:', e);
//             }
//         }
//
//         function globalClickHandler(e) {
//             try {
//                 let target = e.target;
//
//                 while (target && target !== document.body && target.tagName !== 'A' && target.tagName !== 'BUTTON') {
//                     target = target.parentElement;
//                 }
//
//                 if (!target || (target.tagName !== 'A' && target.tagName !== 'BUTTON')) {
//                     return;
//                 }
//
//                 const href = target.getAttribute('href') || target.getAttribute('data-href') || '';
//                 const buttonText = (target.textContent || target.innerText || '').toLowerCase();
//                 const buttonClass = (target.className || '').toLowerCase();
//                 const buttonId = (target.id || '').toLowerCase();
//
//                 // Enhanced Google Sign-In detection
//                 const isGoogleSignIn =
//                     buttonText.includes('google') && (buttonText.includes('sign') || buttonText.includes('login')) ||
//                     buttonClass.includes('google') ||
//                     buttonId.includes('google') ||
//                     (href && (
//                         href.includes('accounts.google.com') ||
//                         href.includes('oauth.google.com') ||
//                         href.includes('googleapis.com/oauth')
//                     ));
//
//                 if (isGoogleSignIn) {
//                     e.preventDefault();
//                     e.stopPropagation();
//
//                     const messageData = {
//                         type: 'google_signin',
//                         url: href || window.location.href,
//                         buttonText: buttonText,
//                         buttonClass: buttonClass,
//                         buttonId: buttonId
//                     };
//
//                     sendMessageToFlutter(messageData);
//                     return false;
//                 }
//
//                 if (href) {
//                     // Social media detection with improved patterns
//                     const socialPatterns = {
//                         facebook: /facebook\.com|fb\.com|fb\.me/i,
//                         instagram: /instagram\.com|instagr\.am/i,
//                         twitter: /twitter\.com|x\.com/i,
//                         linkedin: /linkedin\.com|lnkd\.in/i,
//                         youtube: /youtube\.com|youtu\.be/i,
//                         tiktok: /tiktok\.com/i,
//                         snapchat: /snapchat\.com/i
//                     };
//
//                     for (const [platform, pattern] of Object.entries(socialPatterns)) {
//                         if (pattern.test(href)) {
//                             e.preventDefault();
//                             e.stopPropagation();
//
//                             sendMessageToFlutter({
//                                 type: 'external_link',
//                                 url: href,
//                                 platform: platform === 'facebook' ? 'facebook' : 'social'
//                             });
//                             return false;
//                         }
//                     }
//
//                     // Handle mailto and tel links
//                     if (href.startsWith('mailto:') || href.startsWith('tel:')) {
//                         e.preventDefault();
//                         e.stopPropagation();
//
//                         sendMessageToFlutter({
//                             type: 'external_link',
//                             url: href
//                         });
//                         return false;
//                     }
//                 }
//             } catch(error) {
//                 console.error('Click handler error:', error);
//             }
//         }
//
//         function sendMessageToFlutter(data) {
//             const message = JSON.stringify(data);
//             console.log('Sending to Flutter:', message);
//
//             try {
//                 // Try multiple communication methods for better compatibility
//                 if (window.Flutter && window.Flutter.postMessage) {
//                     window.Flutter.postMessage(message);
//                 }
//
//                 window.postMessage(message, '*');
//
//                 window.dispatchEvent(new CustomEvent('flutterMessage', {
//                     detail: data
//                 }));
//             } catch(err) {
//                 console.error('Message sending error:', err);
//             }
//         }
//
//         function initializeBridge() {
//             if (bridgeInitialized) return;
//             bridgeInitialized = true;
//
//             ensureMobileResponsive();
//             changeBackgroundColor();
//             repositionChatIcon();
//             handleExternalLinks();
//
//             // Optimized MutationObserver
//             const observer = new MutationObserver(() => {
//                 requestAnimationFrame(() => {
//                     ensureMobileResponsive();
//                     changeBackgroundColor();
//                     repositionChatIcon();
//                     handleExternalLinks();
//                 });
//             });
//
//             observer.observe(document.body, {
//                 childList: true,
//                 subtree: true
//             });
//
//             // Staggered initialization for better performance
//             const initTasks = [
//                 { fn: ensureMobileResponsive, delay: 300 },
//                 { fn: repositionChatIcon, delay: 400 },
//                 { fn: () => { changeBackgroundColor(); handleExternalLinks(); }, delay: 500 },
//                 { fn: () => sendMessageToFlutter({type: 'bridge_ready'}), delay: 600 }
//             ];
//
//             initTasks.forEach(task => {
//                 setTimeout(task.fn, task.delay);
//             });
//         }
//
//         // Initialize when ready
//         if (document.readyState === 'loading') {
//             document.addEventListener('DOMContentLoaded', initializeBridge);
//         } else {
//             setTimeout(initializeBridge, 50);
//         }
//     })();
//   ''';
//
//   @override
//   void initState() {
//     super.initState();
//     _initializeAnimations();
//     _checkCookieConsent();
//     _initializeWebView();
//   }
//
//   @override
//   void dispose() {
//     _bannerAnimationController.dispose();
//     super.dispose();
//   }
//
//   void _initializeAnimations() {
//     _bannerAnimationController = AnimationController(
//       duration: const Duration(milliseconds: 500),
//       vsync: this,
//     );
//     _bannerAnimation = CurvedAnimation(
//       parent: _bannerAnimationController,
//       curve: Curves.easeInOut,
//     );
//   }
//
//   Future<void> _checkCookieConsent() async {
//     final prefs = await SharedPreferences.getInstance();
//     final consent = prefs.getBool('cookie_consent') ?? false;
//     setState(() {
//       _showCookieBanner = !consent;
//       _cookiesAccepted = consent;
//     });
//
//     if (_showCookieBanner) {
//       _bannerAnimationController.forward();
//     }
//   }
//
//   Future<void> _handleCookieConsent(bool accept) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setBool('cookie_consent', accept);
//
//     setState(() {
//       _cookiesAccepted = accept;
//     });
//
//     // Animate banner out
//     await _bannerAnimationController.reverse();
//
//     setState(() {
//       _showCookieBanner = false;
//     });
//
//     // Inject updated JavaScript with cookie consent
//     if (accept) {
//       webViewController.runJavaScript('''
//         document.cookie = "cookie_consent=accepted; path=/; max-age=31536000";
//         try {
//           localStorage.setItem('cookie_consent', 'true');
//         } catch(e) {}
//       ''');
//     }
//
//     // Reload page to apply cookie settings
//     webViewController.reload();
//   }
//
//   void _initializeWebView() {
//     webViewController = WebViewController()
//       ..setJavaScriptMode(JavaScriptMode.unrestricted)
//       ..setBackgroundColor(const Color(0x00000000))
//       ..setNavigationDelegate(
//         NavigationDelegate(
//           onProgress: (int progress) {
//             setState(() {
//               loadingProgress = progress;
//               isLoading = progress < 100;
//             });
//           },
//           onPageStarted: (String url) {
//             setState(() {
//               isLoading = true;
//               currentUrl = url;
//               hasError = false;
//               errorMessage = "";
//             });
//
//             // Add to navigation history
//             if (navigationHistory.isEmpty ||
//                 navigationHistory[currentHistoryIndex] != url) {
//               // Remove forward history if navigating to a new page
//               if (currentHistoryIndex < navigationHistory.length - 1) {
//                 navigationHistory = navigationHistory.sublist(0, currentHistoryIndex + 1);
//               }
//               navigationHistory.add(url);
//               currentHistoryIndex = navigationHistory.length - 1;
//
//               // Limit history size to prevent memory issues
//               if (navigationHistory.length > 50) {
//                 navigationHistory.removeAt(0);
//                 currentHistoryIndex--;
//               }
//             }
//
//             debugPrint('📍 Navigation History: ${navigationHistory.length} pages');
//             debugPrint('📍 Current Index: $currentHistoryIndex');
//           },
//           onPageFinished: (String url) {
//             setState(() {
//               isLoading = false;
//               isRefreshing = false;
//               currentUrl = url;
//             });
//
//             // Inject JavaScript after page loads
//             Future.delayed(const Duration(milliseconds: 300), () {
//               webViewController.runJavaScript(injectedJavaScript);
//             });
//           },
//           onWebResourceError: (WebResourceError error) {
//             setState(() {
//               isRefreshing = false;
//               hasError = true;
//               errorMessage = _getErrorMessage(error);
//             });
//
//             debugPrint('WebView Error: ${error.description}');
//
//             // Show error dialog after a brief delay
//             Future.delayed(const Duration(milliseconds: 500), () {
//               if (mounted && hasError) {
//                 _showErrorDialog();
//               }
//             });
//           },
//           onNavigationRequest: (NavigationRequest request) {
//             debugPrint('Navigation request: ${request.url}');
//
//             // Check if it's a Google authentication URL
//             if (ChromeTabHelper.isGoogleAuthUrl(request.url)) {
//               ChromeTabHelper.launchGoogleSignIn(
//                 url: request.url,
//                 context: context,
//               );
//               return NavigationDecision.prevent;
//             }
//
//             // Check if it's an external URL
//             if (UrlLauncherHelper.isExternalUrl(request.url)) {
//               UrlLauncherHelper.handleExternalUrl(request.url, context);
//               return NavigationDecision.prevent;
//             }
//
//             // Check if it's a Facebook link
//             if (UrlLauncherHelper.isFacebookUrl(request.url)) {
//               UrlLauncherHelper.handleFacebookUrl(request.url, context);
//               return NavigationDecision.prevent;
//             }
//
//             // Check for other social media links
//             if (UrlLauncherHelper.isSocialMediaUrl(request.url)) {
//               UrlLauncherHelper.handleSocialMediaUrl(request.url, context);
//               return NavigationDecision.prevent;
//             }
//
//             // Allow normal web navigation for your main domain
//             if (request.url.contains('afronika.com')) {
//               return NavigationDecision.navigate;
//             }
//
//             // For any other external links, open in external browser
//             if (!request.url.startsWith('https://www.afronika.com') &&
//                 !request.url.startsWith('https://afronika.com')) {
//               UrlLauncherHelper.handleExternalUrl(request.url, context);
//               return NavigationDecision.prevent;
//             }
//
//             return NavigationDecision.navigate;
//           },
//         ),
//       )
//       ..addJavaScriptChannel(
//         'Flutter',
//         onMessageReceived: _handleJavaScriptMessage,
//       );
//
//     _loadInitialUrl();
//   }
//
//   void _handleJavaScriptMessage(JavaScriptMessage message) {
//     try {
//       debugPrint('✓ Received JS message: ${message.message}');
//
//       final data = message.message;
//
//       if (data.contains('hamburger_clicked')) {
//         HapticFeedback.selectionClick();
//         return;
//       }
//
//       // Try to parse as JSON
//       try {
//         final Map<String, dynamic> parsedData =
//         Map<String, dynamic>.from(jsonDecode(data) as Map);
//
//         debugPrint('✓ Parsed JSON data: $parsedData');
//
//         // Handle Google Sign-In
//         if (parsedData['type'] == 'google_signin') {
//           final url = parsedData['url'] ?? 'https://accounts.google.com/signin';
//           ChromeTabHelper.launchGoogleSignIn(
//             url: url,
//             context: context,
//           );
//           return;
//         }
//
//         // Handle external links
//         if (parsedData['type'] == 'external_link') {
//           final url = parsedData['url'];
//           final platform = parsedData['platform'];
//
//           if (platform == 'facebook') {
//             UrlLauncherHelper.handleFacebookUrl(url, context);
//           } else if (platform == 'social') {
//             UrlLauncherHelper.handleSocialMediaUrl(url, context);
//           } else {
//             UrlLauncherHelper.handleExternalUrl(url, context);
//           }
//         }
//       } catch (jsonError) {
//         debugPrint('❌ JSON parse error: $jsonError');
//
//         // Fallback handling
//         if (data.contains('google_signin')) {
//           ChromeTabHelper.launchGoogleSignIn(
//             url: 'https://accounts.google.com/signin',
//             context: context,
//           );
//         } else if (data.contains('external_link')) {
//           // Try to extract URL from the message
//           final regex = RegExp(r'"url":"([^"]+)"');
//           final match = regex.firstMatch(data);
//           if (match != null) {
//             final url = match.group(1);
//             if (url != null) {
//               UrlLauncherHelper.handleUrl(url, context);
//             }
//           }
//         }
//       }
//     } catch (e) {
//       debugPrint('❌ Error in JS message handler: $e');
//     }
//   }
//
//   Future<void> _loadInitialUrl() async {
//     try {
//       // Check internet connectivity
//       final result = await InternetAddress.lookup('google.com')
//           .timeout(const Duration(seconds: 5));
//       if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
//         webViewController.loadRequest(Uri.parse(currentUrl));
//       } else {
//         _showNoInternetDialog();
//       }
//     } catch (e) {
//       debugPrint('Connectivity check failed: $e');
//       // If connectivity check fails, still try to load but show appropriate error
//       webViewController.loadRequest(Uri.parse(currentUrl));
//     }
//   }
//
//   String _getErrorMessage(WebResourceError error) {
//     final errorMessages = {
//       WebResourceErrorType.hostLookup: "Unable to find the website. Please check your internet connection.",
//       WebResourceErrorType.timeout: "The connection timed out. Please try again.",
//       WebResourceErrorType.connect: "Unable to connect to the server. Please check your internet connection.",
//       WebResourceErrorType.fileNotFound: "The requested page could not be found.",
//       WebResourceErrorType.authentication: "Authentication required to access this page.",
//       WebResourceErrorType.badUrl: "Invalid URL. Please check the web address.",
//       WebResourceErrorType.file: "File access error occurred.",
//       WebResourceErrorType.tooManyRequests: "Too many requests. Please try again later.",
//     };
//
//     return errorMessages[error.errorType] ??
//         _getFallbackErrorMessage(error.description);
//   }
//
//   String _getFallbackErrorMessage(String description) {
//     final desc = description.toLowerCase();
//     if (desc.contains('internet')) {
//       return "No internet connection. Please check your network settings.";
//     } else if (desc.contains('server')) {
//       return "Server is currently unavailable. Please try again later.";
//     } else if (desc.contains('dns')) {
//       return "DNS lookup failed. Please check your internet connection.";
//     }
//     return "Unable to load the page. Please try again.";
//   }
//
//   void _showNoInternetDialog() {
//     if (!mounted) return;
//
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Row(
//             children: [
//               Icon(Icons.wifi_off, color: Colors.red),
//               SizedBox(width: 8),
//               Text('No Internet Connection'),
//             ],
//           ),
//           content: const Text(
//             'Please check your internet connection and try again.',
//           ),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(15),
//           ),
//           actions: [
//             AButton(
//               buttonType: AButtonType.outlined,
//               text: "Exit",
//               onPressed: () => SystemNavigator.pop(),
//             ),
//             AButton(
//               text: 'Retry',
//               onPressed: () {
//                 Navigator.of(context).pop();
//                 _retryConnection();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   void _showErrorDialog() {
//     if (!mounted || !hasError) return;
//
//     showDialog(
//       context: context,
//       barrierDismissible: true,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Row(
//             children: [
//               Icon(Icons.error_outline, color: Colors.orange),
//               SizedBox(width: 8),
//               Text('Connection Error'),
//             ],
//           ),
//           content: Text(errorMessage.isNotEmpty
//               ? errorMessage
//               : 'Unable to load the page.'),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(15),
//           ),
//           actions: [
//             AButton(
//               buttonType: AButtonType.outlined,
//               text: "Cancel",
//               onPressed: () => Navigator.of(context).pop(),
//             ),
//             AButton(
//               text: 'Retry',
//               onPressed: () {
//                 Navigator.of(context).pop();
//                 _refreshPage();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   Future<void> _retryConnection() async {
//     setState(() {
//       isRefreshing = true;
//       hasError = false;
//       errorMessage = "";
//     });
//
//     try {
//       final result = await InternetAddress.lookup('google.com')
//           .timeout(const Duration(seconds: 3));
//       if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
//         HapticFeedback.lightImpact();
//         webViewController.reload();
//       } else {
//         setState(() => isRefreshing = false);
//         _showNoInternetDialog();
//       }
//     } catch (e) {
//       debugPrint('Retry connection failed: $e');
//       setState(() => isRefreshing = false);
//       HapticFeedback.lightImpact();
//       webViewController.reload();
//     }
//   }
//
//   Future<void> _refreshPage() async {
//     setState(() {
//       isRefreshing = true;
//       hasError = false;
//       errorMessage = "";
//     });
//
//     try {
//       final result = await InternetAddress.lookup('google.com')
//           .timeout(const Duration(seconds: 3));
//       if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
//         HapticFeedback.lightImpact();
//         webViewController.reload();
//       } else {
//         setState(() => isRefreshing = false);
//         _showNoInternetDialog();
//       }
//     } catch (e) {
//       debugPrint('Connectivity check during refresh failed: $e');
//       HapticFeedback.lightImpact();
//       webViewController.reload();
//     }
//   }
//
//   Future<bool> _onWillPop() async {
//     try {
//       debugPrint('🔙 Back button pressed');
//       debugPrint('📍 History: ${navigationHistory.length} pages, Current: $currentHistoryIndex');
//
//       // First check if we can go back in our navigation history
//       if (currentHistoryIndex > 0) {
//         currentHistoryIndex--;
//         final previousUrl = navigationHistory[currentHistoryIndex];
//
//         debugPrint('🔙 Navigating back to: $previousUrl');
//
//         setState(() {
//           isLoading = true;
//           currentUrl = previousUrl;
//         });
//
//         await webViewController.loadRequest(Uri.parse(previousUrl));
//         return false; // Don't exit the app
//       }
//
//       // Also check WebView's built-in navigation
//       final canGoBack = await webViewController.canGoBack();
//       if (canGoBack) {
//         await webViewController.goBack();
//         return false;
//       }
//
//       // No more pages to go back to, show exit dialog
//       debugPrint('🔙 No more pages, showing exit dialog');
//       final shouldExit = await DialogHelper.showExitDialog(context);
//       return shouldExit ?? false;
//     } catch (e) {
//       debugPrint('❌ Error in back button handler: $e');
//       final shouldExit = await DialogHelper.showExitDialog(context);
//       return shouldExit ?? false;
//     }
//   }
//
//   // Add method to go forward in history
//   Future<void> _goForward() async {
//     if (currentHistoryIndex < navigationHistory.length - 1) {
//       currentHistoryIndex++;
//       final nextUrl = navigationHistory[currentHistoryIndex];
//
//       setState(() {
//         isLoading = true;
//         currentUrl = nextUrl;
//       });
//
//       await webViewController.loadRequest(Uri.parse(nextUrl));
//     }
//   }
//
//   Widget _buildLoadingIndicator() {
//     return Center(
//       child: Container(
//         padding: const EdgeInsets.all(20),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(15),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.1),
//               blurRadius: 10,
//               spreadRadius: 2,
//             ),
//           ],
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Stack(
//               alignment: Alignment.center,
//               children: [
//                 SizedBox(
//                   width: 60,
//                   height: 60,
//                   child: CircularProgressIndicator(
//                     value: isLoading ? (loadingProgress / 100) : null,
//                     strokeWidth: 3,
//                     backgroundColor: Colors.grey[300],
//                     valueColor: AlwaysStoppedAnimation<Color>(
//                       Colors.teal,
//                     ),
//                   ),
//                 ),
//                 Text(
//                   '${loadingProgress}%',
//                   style: TextStyle(
//                     fontSize: 14,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.teal,
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),
//             Text(
//               'Loading...',
//               style: TextStyle(
//                 fontSize: 16,
//                 color: Colors.grey[700],
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//             const SizedBox(height: 8),
//             SizedBox(
//               width: 200,
//               child: Text(
//                 _getLoadingMessage(),
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   fontSize: 12,
//                   color: Colors.grey[500],
//                 ),
//                 maxLines: 2,
//                 overflow: TextOverflow.ellipsis,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   String _getLoadingMessage() {
//     if (currentUrl.contains('afronika.com')) {
//       return 'Loading Afronika...';
//     } else if (currentUrl.contains('google.com')) {
//       return 'Connecting to Google...';
//     } else if (currentUrl.contains('facebook.com')) {
//       return 'Loading Facebook...';
//     } else {
//       final uri = Uri.tryParse(currentUrl);
//       if (uri != null) {
//         return 'Loading ${uri.host}...';
//       }
//       return 'Please wait...';
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: _onWillPop,
//       child: Scaffold(
//         body: SafeArea(
//           child: Stack(
//             children: [
//               // Main WebView
//               Positioned.fill(
//                 child: WebViewWidget(controller: webViewController),
//               ),
//
//               // Modern centered loading indicator
//               if (isLoading)
//                 Positioned.fill(
//                   child: Container(
//                     color: Colors.black.withOpacity(0.3),
//                     child: _buildLoadingIndicator(),
//                   ),
//                 ),
//
//               // Error overlay
//               if (hasError && !isLoading)
//                 Positioned.fill(
//                   child: Container(
//                     color: Colors.white,
//                     child: Center(
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           const Icon(
//                             Icons.error_outline,
//                             size: 80,
//                             color: Colors.orange,
//                           ),
//                           const SizedBox(height: 16),
//                           Text(
//                             'Oops! Something went wrong',
//                             style: Theme.of(context).textTheme.headlineSmall?.copyWith(
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           const SizedBox(height: 8),
//                           Padding(
//                             padding: const EdgeInsets.symmetric(horizontal: 32),
//                             child: Text(
//                               errorMessage.isNotEmpty
//                                   ? errorMessage
//                                   : 'Unable to load the page',
//                               textAlign: TextAlign.center,
//                               style: Theme.of(context).textTheme.bodyLarge?.copyWith(
//                                 color: Colors.grey[600],
//                               ),
//                             ),
//                           ),
//                           const SizedBox(height: 24),
//                           ElevatedButton.icon(
//                             onPressed: _refreshPage,
//                             icon: const Icon(Icons.refresh),
//                             label: const Text('Try Again'),
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.teal,
//                               foregroundColor: Colors.white,
//                               padding: const EdgeInsets.symmetric(
//                                 horizontal: 24,
//                                 vertical: 12,
//                               ),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//
//               // Cookie Consent Banner
//               if (_showCookieBanner)
//                 Positioned(
//                   bottom: 0,
//                   left: 0,
//                   right: 0,
//                   child: AnimatedBuilder(
//                     animation: _bannerAnimation,
//                     builder: (context, child) {
//                       return Transform.translate(
//                         offset: Offset(0, 100 * (1 - _bannerAnimation.value)),
//                         child: Opacity(
//                           opacity: _bannerAnimation.value,
//                           child: Container(
//                             decoration: BoxDecoration(
//                               color: Colors.grey[900],
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: Colors.black.withOpacity(0.3),
//                                   blurRadius: 10,
//                                   offset: const Offset(0, -2),
//                                 ),
//                               ],
//                             ),
//                             padding: const EdgeInsets.all(16),
//                             child: Column(
//                               mainAxisSize: MainAxisSize.min,
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Row(
//                                   children: [
//                                     Icon(
//                                       Icons.cookie,
//                                       color: Colors.amber[700],
//                                       size: 24,
//                                     ),
//                                     const SizedBox(width: 12),
//                                     Expanded(
//                                       child: Text(
//                                         'Cookie Consent',
//                                         style: Theme.of(context).textTheme.titleMedium?.copyWith(
//                                           color: Colors.white,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 const SizedBox(height: 12),
//                                 Text(
//                                   'We use cookies to enhance your browsing experience, analyze site traffic, and personalize content. By clicking "Accept All", you consent to our use of cookies.',
//                                   style: Theme.of(context).textTheme.bodySmall?.copyWith(
//                                     color: Colors.grey[300],
//                                     height: 1.4,
//                                   ),
//                                 ),
//                                 const SizedBox(height: 16),
//                                 Row(
//                                   mainAxisAlignment: MainAxisAlignment.end,
//                                   children: [
//                                     TextButton(
//                                       onPressed: () => _handleCookieConsent(false),
//                                       style: TextButton.styleFrom(
//                                         foregroundColor: Colors.grey[400],
//                                         padding: const EdgeInsets.symmetric(
//                                           horizontal: 20,
//                                           vertical: 10,
//                                         ),
//                                       ),
//                                       child: const Text('Decline'),
//                                     ),
//                                     const SizedBox(width: 8),
//                                     ElevatedButton(
//                                       onPressed: () => _handleCookieConsent(true),
//                                       style: ElevatedButton.styleFrom(
//                                         backgroundColor: Colors.teal,
//                                         foregroundColor: Colors.white,
//                                         padding: const EdgeInsets.symmetric(
//                                           horizontal: 20,
//                                           vertical: 10,
//                                         ),
//                                         shape: RoundedRectangleBorder(
//                                           borderRadius: BorderRadius.circular(6),
//                                         ),
//                                       ),
//                                       child: const Text('Accept All'),
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//
//               // Navigation buttons row (optional - you can add this for better UX)
//               Positioned(
//                 bottom: _showCookieBanner ? 180 : 80,
//                 right: 16,
//                 child: AnimatedContainer(
//                   duration: const Duration(milliseconds: 300),
//                   child: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       // Back button
//                       if (currentHistoryIndex > 0)
//                         Material(
//                           elevation: 4,
//                           shape: const CircleBorder(),
//                           color: Colors.white,
//                           child: InkWell(
//                             onTap: () async {
//                               HapticFeedback.lightImpact();
//                               await _onWillPop();
//                             },
//                             borderRadius: BorderRadius.circular(20),
//                             child: Container(
//                               width: 40,
//                               height: 40,
//                               decoration: BoxDecoration(
//                                 shape: BoxShape.circle,
//                                 color: Colors.white,
//                                 boxShadow: [
//                                   BoxShadow(
//                                     color: Colors.black.withOpacity(0.1),
//                                     blurRadius: 4,
//                                     offset: const Offset(0, 2),
//                                   ),
//                                 ],
//                               ),
//                               child: const Icon(
//                                 Icons.arrow_back_ios_rounded,
//                                 color: Colors.teal,
//                                 size: 20,
//                               ),
//                             ),
//                           ),
//                         ),
//
//                       if (currentHistoryIndex > 0) const SizedBox(width: 8),
//
//                       // Forward button
//                       if (currentHistoryIndex < navigationHistory.length - 1)
//                         Material(
//                           elevation: 4,
//                           shape: const CircleBorder(),
//                           color: Colors.white,
//                           child: InkWell(
//                             onTap: () async {
//                               HapticFeedback.lightImpact();
//                               await _goForward();
//                             },
//                             borderRadius: BorderRadius.circular(20),
//                             child: Container(
//                               width: 40,
//                               height: 40,
//                               decoration: BoxDecoration(
//                                 shape: BoxShape.circle,
//                                 color: Colors.white,
//                                 boxShadow: [
//                                   BoxShadow(
//                                     color: Colors.black.withOpacity(0.1),
//                                     blurRadius: 4,
//                                     offset: const Offset(0, 2),
//                                   ),
//                                 ],
//                               ),
//                               child: const Icon(
//                                 Icons.arrow_forward_ios_rounded,
//                                 color: Colors.teal,
//                                 size: 20,
//                               ),
//                             ),
//                           ),
//                         ),
//                     ],
//                   ),
//                 ),
//               ),
//
//               // Refresh button
//               Positioned(
//                 bottom: _showCookieBanner ? 180 : 80,
//                 left: 16,
//                 child: AnimatedContainer(
//                   duration: const Duration(milliseconds: 300),
//                   child: Material(
//                     elevation: 6,
//                     shape: const CircleBorder(),
//                     color: Colors.white,
//                     child: InkWell(
//                       onTap: _refreshPage,
//                       borderRadius: BorderRadius.circular(28),
//                       child: Container(
//                         width: 56,
//                         height: 56,
//                         decoration: BoxDecoration(
//                           shape: BoxShape.circle,
//                           color: Colors.white,
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.black.withOpacity(0.1),
//                               blurRadius: 8,
//                               offset: const Offset(0, 2),
//                             ),
//                           ],
//                         ),
//                         child: isRefreshing
//                             ? const Padding(
//                           padding: EdgeInsets.all(16),
//                           child: CircularProgressIndicator(
//                             strokeWidth: 2,
//                             valueColor: AlwaysStoppedAnimation(Colors.teal),
//                           ),
//                         )
//                             : const Icon(
//                           Icons.refresh,
//                           color: Colors.teal,
//                           size: 28,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }