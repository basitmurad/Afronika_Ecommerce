import 'package:afronika/webview/UrlLauncherHelper.dart';
import 'package:afronika/webview/AfronikaBrowserHelper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart'
    hide WebResourceError;
import 'package:flutter/services.dart';
import 'package:webview_flutter_platform_interface/src/types/web_resource_error.dart';
import 'dart:async';

import '../common/CookieBanner.dart';
import '../common/ErrorView.dart';
import '../common/MenuBottomSheetWidget.dart';
import '../common/RefreshFloatingButton.dart';
import '../features/about/AboutAppScreen.dart';
import '../features/contact/ContactScreen.dart';
import '../features/privacy/PrivacyPolicyScreen.dart';

class AfronikaBrowserApp extends StatefulWidget {
  const AfronikaBrowserApp({super.key});

  @override
  _AfronikaBrowserAppState createState() => _AfronikaBrowserAppState();
}

class _AfronikaBrowserAppState extends State<AfronikaBrowserApp>
    with TickerProviderStateMixin {
  late InAppWebViewController webViewController;
  late AnimationController _bannerAnimationController;
  late Animation<double> _bannerAnimation;

  String currentUrl = "https://www.afronika.com/";
  bool isLoading = true;
  double loadingProgress = 0;
  bool isRefreshing = false;
  bool hasError = false;
  String errorMessage = "";
  bool _showCookieBanner = false;
  bool _cookiesAccepted = false;

  // Payment Flow Properties
  bool _isInPaymentFlow = false;
  String? _paymentReturnUrl;
  Timer? _paymentCheckTimer;

  final GlobalKey webViewKey = GlobalKey();

  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
    crossPlatform: InAppWebViewOptions(
      useShouldOverrideUrlLoading: true,
      mediaPlaybackRequiresUserGesture: false,
      javaScriptEnabled: true,
      javaScriptCanOpenWindowsAutomatically: false,
      clearCache: false,
      transparentBackground: true,
      disableVerticalScroll: false,
      disableHorizontalScroll: false,
      supportZoom: false,
    ),
    android: AndroidInAppWebViewOptions(
      useHybridComposition: true,
      useShouldInterceptRequest: false,
      // adjust as needed
      hardwareAcceleration: false,
      // add this line
      disableDefaultErrorPage: false,
      // keep default

      mixedContentMode: AndroidMixedContentMode.MIXED_CONTENT_ALWAYS_ALLOW,
    ),
    ios: IOSInAppWebViewOptions(
      allowsInlineMediaPlayback: true,
      allowsAirPlayForMediaPlayback: true,
      allowsPictureInPictureMediaPlayback: true,
    ),
  );

  String get enhancedInjectedJavaScript => '''
  (function() {
      'use strict';

      let bridgeInitialized = false;
      const cookiesAccepted = $_cookiesAccepted;

      // Payment flow tracking
      let isInPaymentFlow = false;
      let originalCartUrl = '';

      // Set cookie consent if accepted
      if (cookiesAccepted) {
          try {
              document.cookie = "cookie_consent=accepted; path=/; max-age=31536000";
              localStorage.setItem('cookie_consent', 'true');
          } catch(e) {
              console.log('Error setting cookie consent:', e);
          }
      }

      function isPaymentUrl(url) {
          const lowerUrl = url.toLowerCase();
          
          // Exclude order-related pages that are NOT payment flows
          const excludePatterns = [
              '/my-orders', '/myorders', '/orders', '/order-history',
              '/account/orders', '/user/orders', '/profile/orders',
              '/dashboard/orders', '/order-list', '/order-tracking', '/track-order'
          ];
          
          // Check if URL should be excluded
          for (const pattern of excludePatterns) {
              if (lowerUrl.includes(pattern)) {
                  return false;
              }
          }
          
          // More specific payment patterns
          const paymentPatterns = [
              '/payment/', '/checkout/', '/cart/pay', '/pay/', '/billing/',
              '/purchase/', 'stripe.com', 'paypal.com', 'razorpay.com',
              'paytm.com', '/gateway/', '/transaction/', 'payment-gateway',
              'checkout-session', 'payment-intent', 'payment-method',
              'payment-confirm', 'checkout-confirm'
          ];
          
          return paymentPatterns.some(pattern => lowerUrl.includes(pattern));
      }

      function isPaymentSuccessUrl(url) {
          const successPatterns = ['payment-success', 'checkout-success', 'order-complete', 'payment-confirmed', 'purchase-complete'];
          const lowerUrl = url.toLowerCase();
          return successPatterns.some(pattern => lowerUrl.includes(pattern));
      }

      function isPaymentFailureUrl(url) {
          const failurePatterns = ['payment-cancel', 'payment-failed', 'checkout-failed', 'payment-error', 'payment-declined'];
          const lowerUrl = url.toLowerCase();
          return failurePatterns.some(pattern => lowerUrl.includes(pattern));
      }

      // Rest of your JavaScript code remains the same...
      function detectPaymentFlow() {
          const currentUrl = window.location.href;
          
          // Entering payment flow
          if (isPaymentUrl(currentUrl) && !isInPaymentFlow) {
              isInPaymentFlow = true;
              originalCartUrl = document.referrer || '';
              
              window.flutter_inappwebview.callHandler('paymentFlowStarted', currentUrl, originalCartUrl);
              
              console.log('Payment flow started:', currentUrl);
              return;
          }
          
          // Payment completed successfully
          if (isPaymentSuccessUrl(currentUrl) && isInPaymentFlow) {
              isInPaymentFlow = false;
              
              window.flutter_inappwebview.callHandler('paymentSuccess', currentUrl);
              
              console.log('Payment completed successfully');
              return;
          }
          
          // Payment cancelled or failed
          if (isPaymentFailureUrl(currentUrl) && isInPaymentFlow) {
              isInPaymentFlow = false;
              
              window.flutter_inappwebview.callHandler('paymentFailed', currentUrl, originalCartUrl);
              
              console.log('Payment cancelled or failed');
              return;
          }
      }

      // Continue with the rest of your existing JavaScript functions...
      function enhancePaymentButtons() {
          // Find payment buttons and add click tracking
          const paymentSelectors = [
              'button[class*="payment"]',
              'button[class*="checkout"]',
              'button[class*="pay-now"]',
              'input[value*="Pay Now"]',
              'input[value*="Proceed to Payment"]',
              'input[value*="Checkout"]',
              'a[href*="/payment/"]',
              'a[href*="/checkout/"]',
              '.payment-btn',
              '.checkout-btn',
              '.pay-btn',
              '[data-payment]',
              '.btn-payment',
              '.btn-checkout'
          ];

          paymentSelectors.forEach(selector => {
              try {
                  const buttons = document.querySelectorAll(selector);
                  buttons.forEach(button => {
                      if (button && !button.dataset.paymentTracked) {
                          button.dataset.paymentTracked = 'true';
                          
                          button.addEventListener('click', (e) => {
                              // Only track if it's actually a payment button, not order history
                              const buttonText = (button.textContent || button.value || '').toLowerCase();
                              const isOrderHistory = buttonText.includes('my orders') || 
                                                   buttonText.includes('order history') ||
                                                   buttonText.includes('view orders');
                              
                              if (!isOrderHistory) {
                                  console.log('Payment button clicked:', button);
                                  
                                  window.flutter_inappwebview.callHandler('paymentButtonClicked', 
                                      button.textContent || button.value || 'Unknown', 
                                      window.location.href
                                  );
                              }
                          });
                      }
                  });
              } catch(e) {
                  console.error('Payment button enhancement error:', e);
              }
          });
      }

      // Continue with the rest of your existing JavaScript code...
      // (include all other functions like monitorPaymentProgress, ensureMobileResponsive, etc.)
      
      // The initialization code remains the same
      function initializeBridge() {
          if (bridgeInitialized) return;
          bridgeInitialized = true;

          // Initialize all functions
          ensureMobileResponsive();
          changeBackgroundColor();
          repositionChatIcon();
          handleExternalLinks();
          enhancePaymentButtons();
          detectPaymentFlow();

          // Enhanced MutationObserver for payment flow
          const observer = new MutationObserver(() => {
              requestAnimationFrame(() => {
                  ensureMobileResponsive();
                  changeBackgroundColor();
                  repositionChatIcon();
                  handleExternalLinks();
                  enhancePaymentButtons();
                  detectPaymentFlow();
                  monitorPaymentProgress();
              });
          });

          observer.observe(document.body, {
              childList: true,
              subtree: true
          });

          // URL change detection for SPA applications
          let lastUrl = location.href;
          new MutationObserver(() => {
              const url = location.href;
              if (url !== lastUrl) {
                  lastUrl = url;
                  setTimeout(detectPaymentFlow, 100);
              }
          }).observe(document, { subtree: true, childList: true });

          // Staggered initialization
          const initTasks = [
              { fn: ensureMobileResponsive, delay: 300 },
              { fn: repositionChatIcon, delay: 400 },
              { fn: () => { changeBackgroundColor(); handleExternalLinks(); }, delay: 500 },
              { fn: enhancePaymentButtons, delay: 600 },
              { fn: detectPaymentFlow, delay: 700 },
              { fn: () => window.flutter_inappwebview.callHandler('bridgeReady'), delay: 800 }
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
//   String get enhancedInjectedJavaScript => '''
//   (function() {
//       'use strict';
//
//       let bridgeInitialized = false;
//       const cookiesAccepted = $_cookiesAccepted;
//
//       // Payment flow tracking
//       let isInPaymentFlow = false;
//       let originalCartUrl = '';
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
//       function isPaymentUrl(url) {
//           const paymentPatterns = [
//               'payment', 'checkout', 'pay', 'stripe', 'paypal', 'razorpay',
//               'paytm', 'gateway', '/cart/pay', '/payment/', '/checkout/',
//               'billing', 'order', 'purchase', 'transaction'
//           ];
//           const lowerUrl = url.toLowerCase();
//           return paymentPatterns.some(pattern => lowerUrl.includes(pattern));
//       }
//
//       function isPaymentSuccessUrl(url) {
//           const successPatterns = ['success', 'complete', 'confirmed', 'thank', 'order-complete', 'receipt', 'confirmation'];
//           const lowerUrl = url.toLowerCase();
//           return successPatterns.some(pattern => lowerUrl.includes(pattern));
//       }
//
//       function isPaymentFailureUrl(url) {
//           const failurePatterns = ['cancel', 'failed', 'error', 'declined', 'timeout', 'abort'];
//           const lowerUrl = url.toLowerCase();
//           return failurePatterns.some(pattern => lowerUrl.includes(pattern));
//       }
//
//       function detectPaymentFlow() {
//           const currentUrl = window.location.href;
//
//           // Entering payment flow
//           if (isPaymentUrl(currentUrl) && !isInPaymentFlow) {
//               isInPaymentFlow = true;
//               originalCartUrl = document.referrer || '';
//
//               window.flutter_inappwebview.callHandler('paymentFlowStarted', currentUrl, originalCartUrl);
//
//               console.log('Payment flow started:', currentUrl);
//               return;
//           }
//
//           // Payment completed successfully
//           if (isPaymentSuccessUrl(currentUrl) && isInPaymentFlow) {
//               isInPaymentFlow = false;
//
//               window.flutter_inappwebview.callHandler('paymentSuccess', currentUrl);
//
//               console.log('Payment completed successfully');
//               return;
//           }
//
//           // Payment cancelled or failed
//           if (isPaymentFailureUrl(currentUrl) && isInPaymentFlow) {
//               isInPaymentFlow = false;
//
//               window.flutter_inappwebview.callHandler('paymentFailed', currentUrl, originalCartUrl);
//
//               console.log('Payment cancelled or failed');
//               return;
//           }
//       }
//
//       function enhancePaymentButtons() {
//           // Find payment buttons and add click tracking
//           const paymentSelectors = [
//               'button[class*="payment"]',
//               'button[class*="checkout"]',
//               'button[class*="pay"]',
//               'input[value*="Pay"]',
//               'input[value*="Payment"]',
//               'input[value*="Checkout"]',
//               'a[href*="payment"]',
//               'a[href*="checkout"]',
//               '.payment-btn',
//               '.checkout-btn',
//               '.pay-btn',
//               '[data-payment]',
//               '.btn-payment',
//               '.btn-checkout'
//           ];
//
//           paymentSelectors.forEach(selector => {
//               try {
//                   const buttons = document.querySelectorAll(selector);
//                   buttons.forEach(button => {
//                       if (button && !button.dataset.paymentTracked) {
//                           button.dataset.paymentTracked = 'true';
//
//                           button.addEventListener('click', (e) => {
//                               console.log('Payment button clicked:', button);
//
//                               window.flutter_inappwebview.callHandler('paymentButtonClicked',
//                                   button.textContent || button.value || 'Unknown',
//                                   window.location.href
//                               );
//                           });
//                       }
//                   });
//               } catch(e) {
//                   console.error('Payment button enhancement error:', e);
//               }
//           });
//       }
//
//       function monitorPaymentProgress() {
//           // Monitor for payment progress indicators
//           const progressSelectors = [
//               '.payment-progress',
//               '.checkout-progress',
//               '.loading',
//               '.processing',
//               '[class*="progress"]',
//               '[class*="loading"]',
//               '.spinner',
//               '.loader'
//           ];
//
//           progressSelectors.forEach(selector => {
//               try {
//                   const elements = document.querySelectorAll(selector);
//                   elements.forEach(el => {
//                       if (el && el.style.display !== 'none' && el.offsetHeight > 0) {
//                           window.flutter_inappwebview.callHandler('paymentProcessing', 'Payment in progress...');
//                       }
//                   });
//               } catch(e) {
//                   console.error('Payment progress monitoring error:', e);
//               }
//           });
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
//
//               if (href) {
//                   // Don't interfere with payment URLs - let them load normally
//                   if (isPaymentUrl(href)) {
//                       console.log('Payment URL clicked, allowing normal navigation:', href);
//                       return true;
//                   }
//
//                   // Social media detection with improved patterns
//                   const socialPatterns = {
//                       facebook: /facebook.com|fb.com|fb.me/i,
//                       instagram: /instagram.com|instagr.am/i,
//                       twitter: /twitter.com|x.com/i,
//                       linkedin: /linkedin.com|lnkd.in/i,
//                       youtube: /youtube.com|youtu.be/i,
//                       tiktok: /tiktok.com/i,
//                       snapchat: /snapchat.com/i
//                   };
//
//                   for (const [platform, pattern] of Object.entries(socialPatterns)) {
//                       if (pattern.test(href)) {
//                           e.preventDefault();
//                           e.stopPropagation();
//
//                           window.flutter_inappwebview.callHandler('externalLink', href, platform === 'facebook' ? 'facebook' : 'social');
//                           return false;
//                       }
//                   }
//
//                   // Handle mailto and tel links
//                   if (href.startsWith('mailto:') || href.startsWith('tel:')) {
//                       e.preventDefault();
//                       e.stopPropagation();
//
//                       window.flutter_inappwebview.callHandler('externalLink', href);
//                       return false;
//                   }
//               }
//           } catch(error) {
//               console.error('Click handler error:', error);
//           }
//       }
//
//       function initializeBridge() {
//           if (bridgeInitialized) return;
//           bridgeInitialized = true;
//
//           // Initialize all functions
//           ensureMobileResponsive();
//           changeBackgroundColor();
//           repositionChatIcon();
//           handleExternalLinks();
//           enhancePaymentButtons();
//           detectPaymentFlow();
//
//           // Enhanced MutationObserver for payment flow
//           const observer = new MutationObserver(() => {
//               requestAnimationFrame(() => {
//                   ensureMobileResponsive();
//                   changeBackgroundColor();
//                   repositionChatIcon();
//                   handleExternalLinks();
//                   enhancePaymentButtons();
//                   detectPaymentFlow();
//                   monitorPaymentProgress();
//               });
//           });
//
//           observer.observe(document.body, {
//               childList: true,
//               subtree: true
//           });
//
//           // URL change detection for SPA applications
//           let lastUrl = location.href;
//           new MutationObserver(() => {
//               const url = location.href;
//               if (url !== lastUrl) {
//                   lastUrl = url;
//                   setTimeout(detectPaymentFlow, 100);
//               }
//           }).observe(document, { subtree: true, childList: true });
//
//           // Staggered initialization
//           const initTasks = [
//               { fn: ensureMobileResponsive, delay: 300 },
//               { fn: repositionChatIcon, delay: 400 },
//               { fn: () => { changeBackgroundColor(); handleExternalLinks(); }, delay: 500 },
//               { fn: enhancePaymentButtons, delay: 600 },
//               { fn: detectPaymentFlow, delay: 700 },
//               { fn: () => window.flutter_inappwebview.callHandler('bridgeReady'), delay: 800 }
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
  }

  @override
  void dispose() {
    _bannerAnimationController.dispose();
    _paymentCheckTimer?.cancel();
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
    final consentData = await AfronikaBrowserHelper.checkCookieConsent();
    setState(() {
      _showCookieBanner = consentData['showCookieBanner']!;
      _cookiesAccepted = consentData['cookiesAccepted']!;
    });

    if (_showCookieBanner) {
      _bannerAnimationController.forward();
    }
  }

  Future<void> _handleCookieConsent(bool accept) async {
    await AfronikaBrowserHelper.handleCookieConsent(
      accept: accept,
      webViewController: webViewController,
      bannerAnimationController: _bannerAnimationController,
      onStateUpdate: (cookiesAccepted, showCookieBanner) {
        setState(() {
          _cookiesAccepted = cookiesAccepted;
          _showCookieBanner = showCookieBanner;
        });
      },
    );
  }

  // Payment Flow Methods
  // bool _isPaymentUrl(String url) {
  //   final paymentPatterns = [
  //     'payment',
  //     'checkout',
  //     'pay',
  //     'stripe',
  //     'paypal',
  //     'razorpay',
  //     'paytm',
  //     'gateway',
  //     '/cart/pay',
  //     '/payment/',
  //     '/checkout/',
  //     'billing',
  //     'order',
  //     'purchase',
  //     'transaction'
  //   ];
  //
  //   final lowerUrl = url.toLowerCase();
  //   return paymentPatterns.any((pattern) => lowerUrl.contains(pattern));
  // }

  bool _isPaymentUrl(String url) {
    final lowerUrl = url.toLowerCase();

    // Exclude specific pages that should NOT trigger payment flow
    final excludePatterns = [
      '/my-orders',
      '/myorders',
      '/orders',
      '/order-history',
      '/account/orders',
      '/user/orders',
      '/profile/orders',
      '/dashboard/orders',
      '/order-list',
      '/order-tracking',
      '/track-order'
    ];

    // Check if URL should be excluded
    for (String pattern in excludePatterns) {
      if (lowerUrl.contains(pattern)) {
        return false;
      }
    }
    final paymentPatterns = [
      '/payment/',
      '/checkout/',
      '/cart/pay',
      '/pay/',
      '/billing/',
      '/purchase/',
      'stripe.com',
      'paypal.com',
      'razorpay.com',
      'paytm.com',
      '/gateway/',
      '/transaction/',
      'payment-gateway',
      'checkout-session',
      'payment-intent',
      'payment-method',
      'payment-confirm',
      'checkout-confirm'
    ];

    return paymentPatterns.any((pattern) => lowerUrl.contains(pattern));

  }

  void _handlePaymentFlow(String url) {
    setState(() {
      _isInPaymentFlow = true;
      _paymentReturnUrl = currentUrl;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation(Colors.white),
              ),
            ),
            SizedBox(width: 12),
            Text('Processing payment...'),
          ],
        ),
        duration: Duration(seconds: 3),
        backgroundColor: Colors.orange,
      ),
    );

    _checkPaymentCompletion();
  }

  void _checkPaymentCompletion() {
    _paymentCheckTimer?.cancel();
    _paymentCheckTimer = Timer.periodic(Duration(seconds: 2), (timer) async {
      if (!_isInPaymentFlow) {
        timer.cancel();
        return;
      }

      try {
        final currentPageUrl = await webViewController.getUrl();
        if (currentPageUrl != null) {
          final lowerUrl = currentPageUrl.toString().toLowerCase();

          if (lowerUrl.contains('success') ||
              lowerUrl.contains('complete') ||
              lowerUrl.contains('confirmed') ||
              lowerUrl.contains('thank') ||
              lowerUrl.contains('receipt') ||
              lowerUrl.contains('confirmation')) {
            _handlePaymentSuccess();
            timer.cancel();
          } else if (lowerUrl.contains('cancel') ||
              lowerUrl.contains('failed') ||
              lowerUrl.contains('error') ||
              lowerUrl.contains('declined') ||
              lowerUrl.contains('timeout') ||
              lowerUrl.contains('abort')) {
            _handlePaymentFailure();
            timer.cancel();
          } else if (_paymentReturnUrl != null &&
              currentPageUrl.toString().contains(_paymentReturnUrl!)) {
            _resetPaymentFlow();
            timer.cancel();
          }
        }
      } catch (e) {
        debugPrint('Payment check error: $e');
      }
    });
  }

  void _handlePaymentSuccess() {
    setState(() {
      _isInPaymentFlow = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 12),
            Text('Payment completed successfully!'),
          ],
        ),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 4),
      ),
    );

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) =>
          AlertDialog(
            title: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green, size: 30),
                SizedBox(width: 10),
                Text('Payment Success'),
              ],
            ),
            content: Text('Your payment has been processed successfully!'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Future.delayed(Duration(milliseconds: 500), () {
                    _refreshPage();
                  });
                },
                child: Text('OK'),
              ),
            ],
          ),
    );
  }

  void _handlePaymentFailure() {
    setState(() {
      _isInPaymentFlow = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.error, color: Colors.white),
            SizedBox(width: 12),
            Text('Payment was cancelled or failed'),
          ],
        ),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 4),
        action: SnackBarAction(
          label: 'RETRY',
          textColor: Colors.white,
          onPressed: () {
            if (_paymentReturnUrl != null) {
              webViewController.loadUrl(
                  urlRequest: URLRequest(url: WebUri(_paymentReturnUrl!)));
            }
          },
        ),
      ),
    );

    showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(
            title: Row(
              children: [
                Icon(Icons.error, color: Colors.red, size: 30),
                SizedBox(width: 10),
                Text('Payment Failed'),
              ],
            ),
            content: Text(
                'Your payment could not be processed. Would you like to try again?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  if (_paymentReturnUrl != null) {
                    webViewController.loadUrl(urlRequest: URLRequest(
                        url: WebUri(_paymentReturnUrl!)));
                  }
                },
                child: Text('Try Again'),
              ),
            ],
          ),
    );
  }

  void _resetPaymentFlow() {
    setState(() {
      _isInPaymentFlow = false;
      _paymentReturnUrl = null;
    });
    _paymentCheckTimer?.cancel();
  }

  // Future<void> _loadInitialUrl() async {
  //   await AfronikaBrowserHelper.loadInitialUrl(
  //     context: context,
  //     webViewController: webViewController,
  //     initialUrl: currentUrl,
  //   );
  // }

  Future<void> _refreshPage() async {
    await AfronikaBrowserHelper.refreshPage(
      context: context,
      webViewController: webViewController,
      onStateUpdate: (isRefreshing, hasError, errorMessage) {
        setState(() {
          this.isRefreshing = isRefreshing;
          this.hasError = hasError;
          this.errorMessage = errorMessage;
        });
      },
    );
  }

  Future<bool> _onWillPop() async {
    if (_isInPaymentFlow) {
      final shouldExit = await showDialog<bool>(
        context: context,
        builder: (context) =>
            AlertDialog(
              title: Text('Payment in Progress'),
              content: Text(
                  'You are currently in a payment process. Are you sure you want to go back?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text('Stay'),
                ),
                TextButton(
                  onPressed: () {
                    _resetPaymentFlow();
                    Navigator.of(context).pop(true);
                  },
                  style: TextButton.styleFrom(foregroundColor: Colors.red),
                  child: Text('Go Back'),
                ),
              ],
            ),
      );

      if (shouldExit == true) {
        _resetPaymentFlow();
      }
      return shouldExit ?? false;
    }

    return await AfronikaBrowserHelper.handleWillPop(
      context: context,
      currentUrl: currentUrl,
      webViewController: webViewController,
      onStateUpdate: (isLoading, url) {
        setState(() {
          this.isLoading = isLoading;
          currentUrl = url;
        });
      },
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
              // Main InAppWebView
              Positioned.fill(
                child: InAppWebView(
                  key: webViewKey,
                  initialUrlRequest: URLRequest(url: WebUri(currentUrl)),
                  initialOptions: options,
                  onWebViewCreated: (controller) {
                    webViewController = controller;
                    _setupJavaScriptHandlers();
                  },
                  onLoadStart: (controller, url) {
                    setState(() {
                      isLoading = true;
                      currentUrl = url?.toString() ?? currentUrl;
                      hasError = false;
                      errorMessage = "";
                    });

                    AfronikaBrowserHelper.updateNavigationHistory(
                        url?.toString() ?? currentUrl);

                    if (_isPaymentUrl(url?.toString() ?? "") &&
                        !_isInPaymentFlow) {
                      _handlePaymentFlow(url?.toString() ?? "");
                    }
                  },
                  onLoadStop: (controller, url) async {
                    setState(() {
                      isLoading = false;
                      isRefreshing = false;
                      currentUrl = url?.toString() ?? currentUrl;
                    });

                    // Inject JavaScript
                    await controller.evaluateJavascript(
                        source: enhancedInjectedJavaScript);
                  },
                  onProgressChanged: (controller, progress) {
                    setState(() {
                      loadingProgress = progress / 100;
                      isLoading = progress < 100;
                    });
                  },
                  onLoadError: (controller, url, code, message) {
                    final errorMsg = AfronikaBrowserHelper.getErrorMessage(
                        code as WebResourceError, message);

                    setState(() {
                      isRefreshing = false;
                      hasError = true;
                      errorMessage = errorMsg;
                    });

                    if (_isInPaymentFlow) {
                      _handlePaymentFailure();
                    }

                    debugPrint('WebView Error: $message');

                    Future.delayed(const Duration(milliseconds: 500), () {
                      if (mounted && hasError) {
                        AfronikaBrowserHelper.showErrorDialog(
                          context: context,
                          errorMessage: errorMessage,
                          onRetry: _refreshPage,
                        );
                      }
                    });
                  },
                  shouldOverrideUrlLoading: (controller,
                      navigationAction) async {
                    final url = navigationAction.request.url?.toString() ?? "";

                    debugPrint('Navigation request: $url');

                    // Special handling for payment URLs
                    if (_isPaymentUrl(url)) {
                      debugPrint(
                          'Payment URL detected, allowing in-app navigation: $url');
                      return NavigationActionPolicy.ALLOW;
                    }

                    // Handle external URLs
                    if (UrlLauncherHelper.isExternalUrl(url)) {
                      UrlLauncherHelper.handleExternalUrl(url, context);
                      return NavigationActionPolicy.CANCEL;
                    }

                    // Check if it's a Facebook link
                    if (UrlLauncherHelper.isFacebookUrl(url)) {
                      UrlLauncherHelper.handleFacebookUrl(url, context);
                      return NavigationActionPolicy.CANCEL;
                    }

                    // Check for other social media links
                    if (UrlLauncherHelper.isSocialMediaUrl(url)) {
                      UrlLauncherHelper.handleSocialMediaUrl(url, context);
                      return NavigationActionPolicy.CANCEL;
                    }

                    // Allow normal web navigation for your main domain
                    if (url.contains('afronika.com')) {
                      return NavigationActionPolicy.ALLOW;
                    }

                    // For any other external links, open in external browser
                    if (!url.startsWith('https://www.afronika.com') &&
                        !url.startsWith('https://afronika.com') &&
                        !_isPaymentUrl(url)) {
                      UrlLauncherHelper.handleExternalUrl(url, context);
                      return NavigationActionPolicy.CANCEL;
                    }

                    return NavigationActionPolicy.ALLOW;
                  },
                ),
              ),

              // Progress indicator
              if (isLoading)
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: LinearProgressIndicator(
                    value: loadingProgress,
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation(
                      _isInPaymentFlow ? Colors.orange : Colors.teal,
                    ),
                    minHeight: 3,
                  ),
                ),

              // Payment Flow Indicator
              if (_isInPaymentFlow)
                Positioned(
                  top: 8,
                  left: 16,
                  right: 16,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation(Colors.white),
                          ),
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Payment in Progress',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Spacer(),
                        GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) =>
                                  AlertDialog(
                                    title: Text('Payment Status'),
                                    content: Text(
                                        'Your payment is being processed. Please wait for completion or cancellation.'),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(),
                                        child: Text('OK'),
                                      ),
                                      if (_paymentReturnUrl != null)
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                            _resetPaymentFlow();
                                            webViewController.loadUrl(
                                                urlRequest: URLRequest(
                                                    url: WebUri(
                                                        _paymentReturnUrl!)));
                                          },
                                          style: TextButton.styleFrom(
                                              foregroundColor: Colors.red),
                                          child: Text('Back to Cart'),
                                        ),
                                    ],
                                  ),
                            );
                          },
                          child: Icon(
                            Icons.info_outline,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              // Menu button
              Positioned(
                bottom: 170,
                left: 16,
                child: Material(
                  elevation: 4,
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white.withOpacity(0.95),
                  child: InkWell(
                    onTap: () => _openMenu(context),
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
                        Icons.info_outline,
                        color: _isInPaymentFlow ? Colors.orange : Colors.teal,
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ),

              // Payment Back Button
              if (_isInPaymentFlow && _paymentReturnUrl != null)
                Positioned(
                  bottom: 230,
                  left: 16,
                  child: Material(
                    elevation: 4,
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.red.withOpacity(0.9),
                    child: InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) =>
                              AlertDialog(
                                title: Text('Cancel Payment'),
                                content: Text(
                                    'Are you sure you want to cancel the payment and return to cart?'),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    child: Text('Continue Payment'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      _resetPaymentFlow();
                                      webViewController.loadUrl(
                                          urlRequest: URLRequest(
                                              url: WebUri(_paymentReturnUrl!)));
                                    },
                                    style: TextButton.styleFrom(
                                        foregroundColor: Colors.red),
                                    child: Text('Cancel Payment'),
                                  ),
                                ],
                              ),
                        );
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                ),

              // Error overlay
              if (hasError && !isLoading)
                ErrorView(
                  message: errorMessage,
                  onRetry: _refreshPage,
                ),

              // Cookie Consent Banner
              if (_showCookieBanner)
                CookieBanner(
                  animation: _bannerAnimation,
                  onConsent: _handleCookieConsent,
                ),

              // Refresh Floating Button
              RefreshFloatingButton(
                isRefreshing: isRefreshing,
                showCookieBanner: _showCookieBanner,
                onRefresh: _refreshPage,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _setupJavaScriptHandlers() {
    // Payment flow started
    webViewController.addJavaScriptHandler(
      handlerName: 'paymentFlowStarted',
      callback: (args) {
        debugPrint('Payment flow started from JS: ${args[0]}');
      },
    );

    // Payment button clicked
    webViewController.addJavaScriptHandler(
      handlerName: 'paymentButtonClicked',
      callback: (args) {
        debugPrint('Payment button clicked: ${args[0]}');
        HapticFeedback.selectionClick();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation(Colors.white),
                  ),
                ),
                SizedBox(width: 12),
                Text('Initiating payment...'),
              ],
            ),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.blue,
          ),
        );
      },
    );

    // Payment processing
    webViewController.addJavaScriptHandler(
      handlerName: 'paymentProcessing',
      callback: (args) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation(Colors.white),
                  ),
                ),
                SizedBox(width: 12),
                Text(args[0] ?? 'Processing...'),
              ],
            ),
            duration: Duration(seconds: 3),
            backgroundColor: Colors.orange,
          ),
        );
      },
    );

    // Payment success
    webViewController.addJavaScriptHandler(
      handlerName: 'paymentSuccess',
      callback: (args) {
        _handlePaymentSuccess();
      },
    );

    // Payment failed
    webViewController.addJavaScriptHandler(
      handlerName: 'paymentFailed',
      callback: (args) {
        _handlePaymentFailure();
      },
    );

    // External links
    webViewController.addJavaScriptHandler(
      handlerName: 'externalLink',
      callback: (args) {
        final url = args[0];
        final platform = args.length > 1 ? args[1] : null;

        if (platform == 'facebook') {
          UrlLauncherHelper.handleFacebookUrl(url, context);
        } else if (platform == 'social') {
          UrlLauncherHelper.handleSocialMediaUrl(url, context);
        } else {
          UrlLauncherHelper.handleExternalUrl(url, context);
        }
      },
    );

    // Bridge ready
    webViewController.addJavaScriptHandler(
      handlerName: 'bridgeReady',
      callback: (args) {
        debugPrint('JavaScript bridge is ready');
      },
    );
  }

  void _openMenu(BuildContext context) {
    if (_isInPaymentFlow) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Menu is disabled during payment process'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) =>
          MenuBottomSheetWidget(
            onPrivacyPolicyTap: () => _navigateToPrivacyPolicy(),
            onAboutAppTap: () => _navigateToAboutApp(),
            onContactTap: () => _navigateToContact(),
          ),
    );
  }

  void _navigateToPrivacyPolicy() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PrivacyPolicyScreen(),
      ),
    );
  }

  void _navigateToAboutApp() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AboutAppScreen(),
      ),
    );
  }

  void _navigateToContact() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ContactScreen(),
      ),
    );
  }
}