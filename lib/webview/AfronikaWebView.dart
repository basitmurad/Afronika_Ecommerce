// // // import 'package:afronika/utils/device/device_utility.dart';
// // // import 'package:flutter/material.dart';
// // // import 'package:webview_flutter/webview_flutter.dart';
// // // import 'package:flutter/services.dart';
// // // import 'dart:math' as math;
// // //
// // // import 'DottedCircularProgressIndicator.dart';
// // //
// // // class AfronikaBrowserApp extends StatefulWidget {
// // //   @override
// // //   _AfronikaBrowserAppState createState() => _AfronikaBrowserAppState();
// // // }
// // //
// // // class _AfronikaBrowserAppState extends State<AfronikaBrowserApp> {
// // //   late WebViewController webViewController;
// // //   String currentUrl = "https://www.afronika.com/";
// // //   bool isLoading = true;
// // //   int loadingProgress = 0;
// // //   bool showProgressIndicator = true;
// // //
// // //   String get injectedJavaScript => '''
// // //     (function() {
// // //         'use strict';
// // //
// // //         let bridgeInitialized = false;
// // //
// // //         function createCustomLogo() {
// // //             // Create the custom logo HTML with single theme
// // //             const logoHTML = `
// // //                 <div id="custom-afronika-logo" style="
// // //                     display: inline-block;
// // //                     padding: 10px 20px;
// // //                     font-family: 'Roboto', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
// // //                     font-size: 28px;
// // //                     font-weight: bold;
// // //                     line-height: 1;
// // //                     animation: logoFadeIn 1s ease-in-out, logoScale 2s ease-in-out infinite alternate;
// // //                 ">
// // //                     <span style="color: #FF0000;">Afr</span><span style="color: #000000;">o</span><span style="color: #00BCD4;">n</span><span style="color: #00FFFF;">ika</span>
// // //                 </div>
// // //                 <style>
// // //                     @keyframes logoFadeIn {
// // //                         from { opacity: 0; transform: scale(0.8); }
// // //                         to { opacity: 1; transform: scale(1); }
// // //                     }
// // //                     @keyframes logoScale {
// // //                         from { transform: scale(1); }
// // //                         to { transform: scale(1.05); }
// // //                     }
// // //                     #custom-afronika-logo:hover {
// // //                         transform: scale(1.1);
// // //                         transition: transform 0.3s ease;
// // //                     }
// // //
// // //                     /* Responsive sizing */
// // //                     @media (max-width: 768px) {
// // //                         #custom-afronika-logo {
// // //                             font-size: 24px !important;
// // //                             padding: 8px 16px !important;
// // //                         }
// // //                     }
// // //                     @media (max-width: 480px) {
// // //                         #custom-afronika-logo {
// // //                             font-size: 20px !important;
// // //                             padding: 6px 12px !important;
// // //                         }
// // //                     }
// // //                 </style>
// // //             `;
// // //             return logoHTML;
// // //         }
// // //
// // //         function replaceLogos() {
// // //             // Logo selectors to find and replace
// // //             const logoSelectors = [
// // //                 '[data-zs-logo]',
// // //                 '[data-zs-logo-container]',
// // //                 '.theme-logo-parent',
// // //                 '.theme-branding-info',
// // //                 '[data-zs-branding]',
// // //                 '.logo',
// // //                 '.brand-logo',
// // //                 '.site-logo',
// // //                 'img[alt*="logo"]',
// // //                 'img[src*="logo"]'
// // //             ];
// // //
// // //             logoSelectors.forEach(selector => {
// // //                 try {
// // //                     const elements = document.querySelectorAll(selector);
// // //                     elements.forEach(el => {
// // //                         if (el && !el.querySelector('#custom-afronika-logo')) {
// // //                             // Instead of hiding, replace with custom logo
// // //                             const customLogo = createCustomLogo();
// // //
// // //                             // If it's an image, replace it
// // //                             if (el.tagName === 'IMG') {
// // //                                 el.outerHTML = customLogo;
// // //                             } else {
// // //                                 // If it's a container, replace its content
// // //                                 el.innerHTML = customLogo;
// // //                                 el.style.display = 'block';
// // //                             }
// // //                         }
// // //                     });
// // //                 } catch(e) {
// // //                     console.log('Error replacing logo:', e);
// // //                 }
// // //             });
// // //
// // //             // Also check for header areas where logo might be
// // //             try {
// // //                 const headers = document.querySelectorAll('header, .header, .top-bar, .navbar');
// // //                 headers.forEach(header => {
// // //                     const logoElements = header.querySelectorAll('img, .logo, [class*="logo"]');
// // //                     logoElements.forEach(logo => {
// // //                         if (logo && !logo.querySelector('#custom-afronika-logo')) {
// // //                             const parent = logo.parentElement;
// // //                             if (parent && !parent.querySelector('#custom-afronika-logo')) {
// // //                                 logo.outerHTML = createCustomLogo();
// // //                             }
// // //                         }
// // //                     });
// // //                 });
// // //             } catch(e) {
// // //                 console.log('Error in header logo replacement:', e);
// // //             }
// // //         }
// // //
// // //         function changeBackgroundColor() {
// // //             // Change body background to white
// // //             try {
// // //                 document.body.style.backgroundColor = 'white';
// // //                 document.documentElement.style.backgroundColor = 'white';
// // //
// // //                 // Also target common container elements
// // //                 const containers = document.querySelectorAll('header, .header, .app-bar, .top-bar, nav');
// // //                 containers.forEach(container => {
// // //                     if (container) {
// // //                         container.style.backgroundColor = 'white';
// // //                     }
// // //                 });
// // //             } catch(e) {}
// // //         }
// // //
// // //         function repositionChatIcon() {
// // //             // Find chat widget elements
// // //             const chatSelectors = [
// // //                 '.zsiq_flt_rel',
// // //                 '#zsiq_float',
// // //                 '.zsiq_float',
// // //                 '[id*="zsiq"]',
// // //                 '.siqicon',
// // //                 '.siqico-chat'
// // //             ];
// // //
// // //             chatSelectors.forEach(selector => {
// // //                 try {
// // //                     const elements = document.querySelectorAll(selector);
// // //                     elements.forEach(el => {
// // //                         if (el && el.style) {
// // //                             // Position to center-left
// // //                             el.style.position = 'fixed';
// // //                             el.style.left = '20px';
// // //                             el.style.top = '50%';
// // //                             el.style.transform = 'translateY(-50%)';
// // //                             el.style.right = 'auto';
// // //                             el.style.bottom = 'auto';
// // //                             el.style.zIndex = '9999';
// // //                         }
// // //                     });
// // //                 } catch(e) {}
// // //             });
// // //
// // //             // Also target parent containers
// // //             try {
// // //                 const chatWidget = document.querySelector('.zsiq_flt_rel');
// // //                 if (chatWidget) {
// // //                     chatWidget.style.cssText = `
// // //                         position: fixed !important;
// // //                         left: 20px !important;
// // //                         top: 50% !important;
// // //                         transform: translateY(-50%) !important;
// // //                         right: auto !important;
// // //                         bottom: auto !important;
// // //                         z-index: 9999 !important;
// // //                     `;
// // //                 }
// // //             } catch(e) {}
// // //         }
// // //
// // //         function initializeBridge() {
// // //             if (bridgeInitialized) return;
// // //             bridgeInitialized = true;
// // //
// // //             // Replace logos and change background
// // //             replaceLogos();
// // //             changeBackgroundColor();
// // //             repositionChatIcon();
// // //
// // //             // Setup observer for dynamic content
// // //             const observer = new MutationObserver(() => {
// // //                 replaceLogos();
// // //                 changeBackgroundColor();
// // //                 repositionChatIcon();
// // //             });
// // //
// // //             observer.observe(document.body, {
// // //                 childList: true,
// // //                 subtree: true
// // //             });
// // //
// // //             // Repeat operations after delays to catch dynamically loaded content
// // //             setTimeout(() => {
// // //                 replaceLogos();
// // //                 repositionChatIcon();
// // //             }, 1000);
// // //             setTimeout(() => {
// // //                 replaceLogos();
// // //                 repositionChatIcon();
// // //             }, 2000);
// // //             setTimeout(() => {
// // //                 changeBackgroundColor();
// // //                 repositionChatIcon();
// // //             }, 1000);
// // //             setTimeout(repositionChatIcon, 3000);
// // //
// // //             // Notify Flutter
// // //             setTimeout(() => {
// // //                 try {
// // //                     window.postMessage(JSON.stringify({type: 'bridge_ready'}), '*');
// // //                 } catch(e) {}
// // //             }, 1500);
// // //         }
// // //
// // //         // Initialize when ready
// // //         if (document.readyState === 'loading') {
// // //             document.addEventListener('DOMContentLoaded', initializeBridge);
// // //         } else {
// // //             setTimeout(initializeBridge, 100);
// // //         }
// // //
// // //     })();
// // //   ''';
// // //
// // //   @override
// // //   void initState() {
// // //     super.initState();
// // //
// // //     // Initialize the WebView controller
// // //     webViewController = WebViewController()
// // //       ..setJavaScriptMode(JavaScriptMode.unrestricted)
// // //       ..setBackgroundColor(const Color(0x00000000))
// // //       ..setNavigationDelegate(
// // //         NavigationDelegate(
// // //           onProgress: (int progress) {
// // //             setState(() {
// // //               loadingProgress = progress;
// // //               isLoading = progress < 100;
// // //             });
// // //           },
// // //           onPageStarted: (String url) {
// // //             setState(() {
// // //               isLoading = true;
// // //               showProgressIndicator = true; // Show progress when new page starts
// // //               currentUrl = url;
// // //             });
// // //           },
// // //           onPageFinished: (String url) {
// // //             setState(() {
// // //               isLoading = false;
// // //               currentUrl = url;
// // //             });
// // //
// // //             // Delayed injection to ensure page is fully loaded
// // //             Future.delayed(Duration(milliseconds: 800), () {
// // //               webViewController.runJavaScript(injectedJavaScript);
// // //             });
// // //
// // //             // Hide progress indicator after a delay when page is loaded
// // //             Future.delayed(Duration(milliseconds: 2000), () {
// // //               if (mounted) {
// // //                 setState(() {
// // //                   showProgressIndicator = false;
// // //                 });
// // //               }
// // //             });
// // //           },
// // //           onWebResourceError: (WebResourceError error) {
// // //             // Silent error handling to reduce console noise
// // //           },
// // //         ),
// // //       )
// // //       ..addJavaScriptChannel(
// // //         'Flutter',
// // //         onMessageReceived: (JavaScriptMessage message) {
// // //           try {
// // //             final data = message.message;
// // //             if (data.contains('hamburger_clicked')) {
// // //               HapticFeedback.selectionClick();
// // //             }
// // //             // Reduced logging to improve performance
// // //           } catch (e) {
// // //             // Silent error handling
// // //           }
// // //         },
// // //       )
// // //       ..loadRequest(Uri.parse(currentUrl));
// // //   }
// // //
// // //   // Handle back button press
// // //   Future<bool> _onWillPop() async {
// // //     try {
// // //       // Check if WebView can go back
// // //       final canGoBack = await webViewController.canGoBack();
// // //       if (canGoBack) {
// // //         // Go back in WebView
// // //         await webViewController.goBack();
// // //         return false; // Don't exit the app
// // //       } else {
// // //         // Show exit confirmation dialog
// // //         return await _showExitDialog() ?? false;
// // //       }
// // //     } catch (e) {
// // //       // If there's an error, show exit dialog
// // //       return await _showExitDialog() ?? false;
// // //     }
// // //   }
// // //
// // //   // Show exit confirmation dialog
// // //   Future<bool?> _showExitDialog() {
// // //     return showDialog<bool>(
// // //       context: context,
// // //       builder: (context) => AlertDialog(
// // //         title: Text('Exit App'),
// // //         content: Text('Do you want to exit the app?'),
// // //         actions: [
// // //           TextButton(
// // //             onPressed: () => Navigator.of(context).pop(false),
// // //             child: Text('Cancel'),
// // //           ),
// // //           TextButton(
// // //             onPressed: () => Navigator.of(context).pop(true),
// // //             child: Text('Exit'),
// // //           ),
// // //         ],
// // //       ),
// // //     );
// // //   }
// // //
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     final bool dark = ADeviceUtils.isDarkMode(context);
// // //     return WillPopScope(
// // //       onWillPop: _onWillPop,
// // //       child: Scaffold(
// // //         body: Stack(
// // //           children: [
// // //             Padding(
// // //               padding: const EdgeInsets.only(top: 32.0),
// // //               child: WebViewWidget(controller: webViewController),
// // //             ),
// // //             if (isLoading || showProgressIndicator)
// // //               Container(
// // //                 color: Colors.black.withOpacity(0.3), // Dimmed overlay
// // //                 child: Center(
// // //                   child: Container(
// // //                     width: 120,
// // //                     height: 120,
// // //                     decoration: BoxDecoration(
// // //                       color: Colors.white,
// // //                       borderRadius: BorderRadius.circular(20),
// // //                       boxShadow: [
// // //                         BoxShadow(
// // //                           color: Colors.black.withOpacity(0.2),
// // //                           blurRadius: 15,
// // //                           spreadRadius: 3,
// // //                         ),
// // //                       ],
// // //                     ),
// // //                     child: Column(
// // //                       mainAxisAlignment: MainAxisAlignment.center,
// // //                       children: [
// // //                         CircularBarProgressIndicator(
// // //                           size: 60,
// // //                           primaryColor: Colors.yellow.shade600,
// // //                           secondaryColor: Colors.teal.shade600,
// // //                           backgroundColor: Colors.grey.shade300,
// // //                           strokeWidth: 6,
// // //                           progress: loadingProgress / 100.0,
// // //                           showGradient: true,
// // //                         ),
// // //                         SizedBox(height: 8),
// // //                         Text(
// // //                           '${loadingProgress}%',
// // //                           style: TextStyle(
// // //                             fontSize: 12,
// // //                             fontWeight: FontWeight.w500,
// // //                             color: Colors.black54,
// // //                           ),
// // //                         ),
// // //                       ],
// // //                     ),
// // //                   ),
// // //                 ),
// // //               ),
// // //           ],
// // //         ),
// // //       ),
// // //     );
// // //   }
// // // }
// //
// // // import 'package:afronika/utils/device/device_utility.dart';
// // // import 'package:flutter/material.dart';
// // // import 'package:webview_flutter/webview_flutter.dart';
// // // import 'package:flutter/services.dart';
// // // import 'dart:math' as math;
// // //
// // // import 'DottedCircularProgressIndicator.dart';
// // //
// // // class AfronikaBrowserApp extends StatefulWidget {
// // //   @override
// // //   _AfronikaBrowserAppState createState() => _AfronikaBrowserAppState();
// // // }
// // //
// // // class _AfronikaBrowserAppState extends State<AfronikaBrowserApp>
// // //     with TickerProviderStateMixin {
// // //   late WebViewController webViewController;
// // //   String currentUrl = "https://www.afronika.com/";
// // //   bool isLoading = true;
// // //   int loadingProgress = 0;
// // //   bool showProgressIndicator = true;
// // //
// // //   // Animation controllers for enhanced loading effect
// // //   late AnimationController _fadeController;
// // //   late AnimationController _scaleController;
// // //   late Animation<double> _fadeAnimation;
// // //   late Animation<double> _scaleAnimation;
// // //
// // //   String get injectedJavaScript => '''
// // //     (function() {
// // //         'use strict';
// // //
// // //         let bridgeInitialized = false;
// // //
// // //         function createCustomLogo() {
// // //             // Create the custom logo HTML with single theme
// // //             const logoHTML = `
// // //                 <div id="custom-afronika-logo" style="
// // //                     display: inline-block;
// // //                     padding: 10px 20px;
// // //                     font-family: 'Roboto', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
// // //                     font-size: 28px;
// // //                     font-weight: bold;
// // //                     line-height: 1;
// // //                     animation: logoFadeIn 0.6s ease-out, logoScale 1.5s ease-in-out infinite alternate;
// // //                 ">
// // //                     <span style="color: #FF0000;">Afr</span><span style="color: #000000;">o</span><span style="color: #00BCD4;">n</span><span style="color: #00FFFF;">ika</span>
// // //                 </div>
// // //                 <style>
// // //                     @keyframes logoFadeIn {
// // //                         from { opacity: 0; transform: scale(0.9); }
// // //                         to { opacity: 1; transform: scale(1); }
// // //                     }
// // //                     @keyframes logoScale {
// // //                         from { transform: scale(1); }
// // //                         to { transform: scale(1.03); }
// // //                     }
// // //                     #custom-afronika-logo:hover {
// // //                         transform: scale(1.1);
// // //                         transition: transform 0.2s ease;
// // //                     }
// // //
// // //                     /* Responsive sizing */
// // //                     @media (max-width: 768px) {
// // //                         #custom-afronika-logo {
// // //                             font-size: 24px !important;
// // //                             padding: 8px 16px !important;
// // //                         }
// // //                     }
// // //                     @media (max-width: 480px) {
// // //                         #custom-afronika-logo {
// // //                             font-size: 20px !important;
// // //                             padding: 6px 12px !important;
// // //                         }
// // //                     }
// // //                 </style>
// // //             `;
// // //             return logoHTML;
// // //         }
// // //
// // //         function replaceLogos() {
// // //             // Logo selectors to find and replace
// // //             const logoSelectors = [
// // //                 '[data-zs-logo]',
// // //                 '[data-zs-logo-container]',
// // //                 '.theme-logo-parent',
// // //                 '.theme-branding-info',
// // //                 '[data-zs-branding]',
// // //                 '.logo',
// // //                 '.brand-logo',
// // //                 '.site-logo',
// // //                 'img[alt*="logo"]',
// // //                 'img[src*="logo"]'
// // //             ];
// // //
// // //             logoSelectors.forEach(selector => {
// // //                 try {
// // //                     const elements = document.querySelectorAll(selector);
// // //                     elements.forEach(el => {
// // //                         if (el && !el.querySelector('#custom-afronika-logo')) {
// // //                             // Instead of hiding, replace with custom logo
// // //                             const customLogo = createCustomLogo();
// // //
// // //                             // If it's an image, replace it
// // //                             if (el.tagName === 'IMG') {
// // //                                 el.outerHTML = customLogo;
// // //                             } else {
// // //                                 // If it's a container, replace its content
// // //                                 el.innerHTML = customLogo;
// // //                                 el.style.display = 'block';
// // //                             }
// // //                         }
// // //                     });
// // //                 } catch(e) {
// // //                     console.log('Error replacing logo:', e);
// // //                 }
// // //             });
// // //
// // //             // Also check for header areas where logo might be
// // //             try {
// // //                 const headers = document.querySelectorAll('header, .header, .top-bar, .navbar');
// // //                 headers.forEach(header => {
// // //                     const logoElements = header.querySelectorAll('img, .logo, [class*="logo"]');
// // //                     logoElements.forEach(logo => {
// // //                         if (logo && !logo.querySelector('#custom-afronika-logo')) {
// // //                             const parent = logo.parentElement;
// // //                             if (parent && !parent.querySelector('#custom-afronika-logo')) {
// // //                                 logo.outerHTML = createCustomLogo();
// // //                             }
// // //                         }
// // //                     });
// // //                 });
// // //             } catch(e) {
// // //                 console.log('Error in header logo replacement:', e);
// // //             }
// // //         }
// // //
// // //         function changeBackgroundColor() {
// // //             // Change body background to white
// // //             try {
// // //                 document.body.style.backgroundColor = 'white';
// // //                 document.documentElement.style.backgroundColor = 'white';
// // //
// // //                 // Also target common container elements
// // //                 const containers = document.querySelectorAll('header, .header, .app-bar, .top-bar, nav');
// // //                 containers.forEach(container => {
// // //                     if (container) {
// // //                         container.style.backgroundColor = 'white';
// // //                     }
// // //                 });
// // //             } catch(e) {}
// // //         }
// // //
// // //         function repositionChatIcon() {
// // //             // Find chat widget elements
// // //             const chatSelectors = [
// // //                 '.zsiq_flt_rel',
// // //                 '#zsiq_float',
// // //                 '.zsiq_float',
// // //                 '[id*="zsiq"]',
// // //                 '.siqicon',
// // //                 '.siqico-chat'
// // //             ];
// // //
// // //             chatSelectors.forEach(selector => {
// // //                 try {
// // //                     const elements = document.querySelectorAll(selector);
// // //                     elements.forEach(el => {
// // //                         if (el && el.style) {
// // //                             // Position to center-left
// // //                             el.style.position = 'fixed';
// // //                             el.style.left = '20px';
// // //                             el.style.top = '50%';
// // //                             el.style.transform = 'translateY(-50%)';
// // //                             el.style.right = 'auto';
// // //                             el.style.bottom = 'auto';
// // //                             el.style.zIndex = '9999';
// // //                         }
// // //                     });
// // //                 } catch(e) {}
// // //             });
// // //
// // //             // Also target parent containers
// // //             try {
// // //                 const chatWidget = document.querySelector('.zsiq_flt_rel');
// // //                 if (chatWidget) {
// // //                     chatWidget.style.cssText = `
// // //                         position: fixed !important;
// // //                         left: 20px !important;
// // //                         top: 50% !important;
// // //                         transform: translateY(-50%) !important;
// // //                         right: auto !important;
// // //                         bottom: auto !important;
// // //                         z-index: 9999 !important;
// // //                     `;
// // //                 }
// // //             } catch(e) {}
// // //         }
// // //
// // //         function initializeBridge() {
// // //             if (bridgeInitialized) return;
// // //             bridgeInitialized = true;
// // //
// // //             // Replace logos and change background
// // //             replaceLogos();
// // //             changeBackgroundColor();
// // //             repositionChatIcon();
// // //
// // //             // Setup observer for dynamic content
// // //             const observer = new MutationObserver(() => {
// // //                 replaceLogos();
// // //                 changeBackgroundColor();
// // //                 repositionChatIcon();
// // //             });
// // //
// // //             observer.observe(document.body, {
// // //                 childList: true,
// // //                 subtree: true
// // //             });
// // //
// // //             // Faster repeated operations with reduced delays
// // //             setTimeout(() => {
// // //                 replaceLogos();
// // //                 repositionChatIcon();
// // //             }, 300);
// // //             setTimeout(() => {
// // //                 replaceLogos();
// // //                 repositionChatIcon();
// // //             }, 600);
// // //             setTimeout(() => {
// // //                 changeBackgroundColor();
// // //                 repositionChatIcon();
// // //             }, 400);
// // //             setTimeout(repositionChatIcon, 800);
// // //
// // //             // Notify Flutter faster
// // //             setTimeout(() => {
// // //                 try {
// // //                     window.postMessage(JSON.stringify({type: 'bridge_ready'}), '*');
// // //                 } catch(e) {}
// // //             }, 300);
// // //         }
// // //
// // //         // Initialize when ready
// // //         if (document.readyState === 'loading') {
// // //             document.addEventListener('DOMContentLoaded', initializeBridge);
// // //         } else {
// // //             setTimeout(initializeBridge, 50);
// // //         }
// // //
// // //     })();
// // //   ''';
// // //
// // //   @override
// // //   void initState() {
// // //     super.initState();
// // //
// // //     // Initialize animation controllers
// // //     _fadeController = AnimationController(
// // //       duration: Duration(milliseconds: 300),
// // //       vsync: this,
// // //     );
// // //
// // //     _scaleController = AnimationController(
// // //       duration: Duration(milliseconds: 200),
// // //       vsync: this,
// // //     );
// // //
// // //     _fadeAnimation = Tween<double>(
// // //       begin: 0.0,
// // //       end: 1.0,
// // //     ).animate(CurvedAnimation(
// // //       parent: _fadeController,
// // //       curve: Curves.easeOut,
// // //     ));
// // //
// // //     _scaleAnimation = Tween<double>(
// // //       begin: 0.8,
// // //       end: 1.0,
// // //     ).animate(CurvedAnimation(
// // //       parent: _scaleController,
// // //       curve: Curves.elasticOut,
// // //     ));
// // //
// // //     // Start animations
// // //     _fadeController.forward();
// // //     _scaleController.forward();
// // //
// // //     // Initialize the WebView controller
// // //     webViewController = WebViewController()
// // //       ..setJavaScriptMode(JavaScriptMode.unrestricted)
// // //       ..setBackgroundColor(const Color(0x00000000))
// // //       ..setNavigationDelegate(
// // //         NavigationDelegate(
// // //           onProgress: (int progress) {
// // //             setState(() {
// // //               loadingProgress = progress;
// // //               isLoading = progress < 100;
// // //             });
// // //           },
// // //           onPageStarted: (String url) {
// // //             setState(() {
// // //               isLoading = true;
// // //               showProgressIndicator = true;
// // //               currentUrl = url;
// // //             });
// // //
// // //             // Reset and start animations
// // //             _fadeController.reset();
// // //             _scaleController.reset();
// // //             _fadeController.forward();
// // //             _scaleController.forward();
// // //           },
// // //           onPageFinished: (String url) {
// // //             setState(() {
// // //               isLoading = false;
// // //               currentUrl = url;
// // //             });
// // //
// // //             // Faster injection - reduced delay
// // //             Future.delayed(Duration(milliseconds: 300), () {
// // //               webViewController.runJavaScript(injectedJavaScript);
// // //             });
// // //
// // //             // Hide progress indicator faster
// // //             Future.delayed(Duration(milliseconds: 800), () {
// // //               if (mounted) {
// // //                 _fadeController.reverse().then((_) {
// // //                   if (mounted) {
// // //                     setState(() {
// // //                       showProgressIndicator = false;
// // //                     });
// // //                   }
// // //                 });
// // //               }
// // //             });
// // //           },
// // //           onWebResourceError: (WebResourceError error) {
// // //             // Silent error handling to reduce console noise
// // //           },
// // //         ),
// // //       )
// // //       ..addJavaScriptChannel(
// // //         'Flutter',
// // //         onMessageReceived: (JavaScriptMessage message) {
// // //           try {
// // //             final data = message.message;
// // //             if (data.contains('hamburger_clicked')) {
// // //               HapticFeedback.selectionClick();
// // //             }
// // //           } catch (e) {
// // //             // Silent error handling
// // //           }
// // //         },
// // //       )
// // //       ..loadRequest(Uri.parse(currentUrl));
// // //   }
// // //
// // //   @override
// // //   void dispose() {
// // //     _fadeController.dispose();
// // //     _scaleController.dispose();
// // //     super.dispose();
// // //   }
// // //
// // //   // Handle back button press
// // //   Future<bool> _onWillPop() async {
// // //     try {
// // //       final canGoBack = await webViewController.canGoBack();
// // //       if (canGoBack) {
// // //         await webViewController.goBack();
// // //         return false;
// // //       } else {
// // //         return await _showExitDialog() ?? false;
// // //       }
// // //     } catch (e) {
// // //       return await _showExitDialog() ?? false;
// // //     }
// // //   }
// // //
// // //   // Show exit confirmation dialog
// // //   Future<bool?> _showExitDialog() {
// // //     return showDialog<bool>(
// // //       context: context,
// // //       builder: (context) => AlertDialog(
// // //         title: Text('Exit App'),
// // //         content: Text('Do you want to exit the app?'),
// // //         actions: [
// // //           TextButton(
// // //             onPressed: () => Navigator.of(context).pop(false),
// // //             child: Text('Cancel'),
// // //           ),
// // //           TextButton(
// // //             onPressed: () => Navigator.of(context).pop(true),
// // //             child: Text('Exit'),
// // //           ),
// // //         ],
// // //       ),
// // //     );
// // //   }
// // //
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     final bool dark = ADeviceUtils.isDarkMode(context);
// // //     return WillPopScope(
// // //       onWillPop: _onWillPop,
// // //       child: Scaffold(
// // //         body: Stack(
// // //           children: [
// // //             Padding(
// // //               padding: const EdgeInsets.only(top: 32.0),
// // //               child: WebViewWidget(controller: webViewController),
// // //             ),
// // //             if (isLoading || showProgressIndicator)
// // //               AnimatedBuilder(
// // //                 animation: _fadeAnimation,
// // //                 builder: (context, child) {
// // //                   return Opacity(
// // //                     opacity: _fadeAnimation.value,
// // //                     child: Container(
// // //                       color: Colors.black.withOpacity(0.2 * _fadeAnimation.value),
// // //                       child: Center(
// // //                         child: ScaleTransition(
// // //                           scale: _scaleAnimation,
// // //                           child: Container(
// // //                             width: 100,
// // //                             height: 100,
// // //                             decoration: BoxDecoration(
// // //                               color: Colors.white,
// // //                               borderRadius: BorderRadius.circular(15),
// // //                               boxShadow: [
// // //                                 BoxShadow(
// // //                                   color: Colors.black.withOpacity(0.15),
// // //                                   blurRadius: 10,
// // //                                   spreadRadius: 2,
// // //                                 ),
// // //                               ],
// // //                             ),
// // //                             child: Column(
// // //                               mainAxisAlignment: MainAxisAlignment.center,
// // //                               children: [
// // //                                 // Enhanced progress indicator with faster animation
// // //                                 CircularBarProgressIndicator(
// // //                                   size: 50,
// // //                                   primaryColor: Colors.yellow.shade600,
// // //                                   secondaryColor: Colors.teal.shade600,
// // //                                   backgroundColor: Colors.grey.shade200,
// // //                                   strokeWidth: 4,
// // //                                   progress: loadingProgress / 100.0,
// // //                                   showGradient: true,
// // //                                 ),
// // //                                 SizedBox(height: 6),
// // //                                 // Faster updating percentage text
// // //                                 AnimatedSwitcher(
// // //                                   duration: Duration(milliseconds: 150),
// // //                                   child: Text(
// // //                                     '${loadingProgress}%',
// // //                                     key: ValueKey(loadingProgress),
// // //                                     style: TextStyle(
// // //                                       fontSize: 11,
// // //                                       fontWeight: FontWeight.w600,
// // //                                       color: Colors.black87,
// // //                                     ),
// // //                                   ),
// // //                                 ),
// // //                               ],
// // //                             ),
// // //                           ),
// // //                         ),
// // //                       ),
// // //                     ),
// // //                   );
// // //                 },
// // //               ),
// // //           ],
// // //         ),
// // //       ),
// // //     );
// // //   }
// // // }
// //
// //
// //
// //
// // import 'package:afronika/utils/device/device_utility.dart';
// // import 'package:flutter/material.dart';
// // import 'package:webview_flutter/webview_flutter.dart';
// // import 'package:flutter/services.dart';
// //
// // class AfronikaBrowserApp extends StatefulWidget {
// //   @override
// //   _AfronikaBrowserAppState createState() => _AfronikaBrowserAppState();
// // }
// //
// // class _AfronikaBrowserAppState extends State<AfronikaBrowserApp> {
// //   late WebViewController webViewController;
// //   String currentUrl = "https://www.afronika.com/";
// //   bool isLoading = true;
// //   int loadingProgress = 0;
// //
// //   String get injectedJavaScript => '''
// //     (function() {
// //         'use strict';
// //
// //         let bridgeInitialized = false;
// //
// //         function createCustomLogo() {
// //             // Create the custom logo HTML with single theme
// //             const logoHTML = `
// //                 <div id="custom-afronika-logo" style="
// //                     display: inline-block;
// //                     padding: 10px 20px;
// //                     font-family: 'Roboto', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
// //                     font-size: 28px;
// //                     font-weight: bold;
// //                     line-height: 1;
// //                 ">
// //                     <span style="color: #FF0000;">Afr</span><span style="color: #000000;">o</span><span style="color: #00BCD4;">n</span><span style="color: #00FFFF;">ika</span>
// //                 </div>
// //                 <style>
// //                     #custom-afronika-logo:hover {
// //                         transform: scale(1.05);
// //                         transition: transform 0.2s ease;
// //                     }
// //
// //                     /* Responsive sizing */
// //                     @media (max-width: 768px) {
// //                         #custom-afronika-logo {
// //                             font-size: 24px !important;
// //                             padding: 8px 16px !important;
// //                         }
// //                     }
// //                     @media (max-width: 480px) {
// //                         #custom-afronika-logo {
// //                             font-size: 20px !important;
// //                             padding: 6px 12px !important;
// //                         }
// //                     }
// //                 </style>
// //             `;
// //             return logoHTML;
// //         }
// //
// //         function replaceLogos() {
// //             // Logo selectors to find and replace
// //             const logoSelectors = [
// //                 '[data-zs-logo]',
// //                 '[data-zs-logo-container]',
// //                 '.theme-logo-parent',
// //                 '.theme-branding-info',
// //                 '[data-zs-branding]',
// //                 '.logo',
// //                 '.brand-logo',
// //                 '.site-logo',
// //                 'img[alt*="logo"]',
// //                 'img[src*="logo"]'
// //             ];
// //
// //             logoSelectors.forEach(selector => {
// //                 try {
// //                     const elements = document.querySelectorAll(selector);
// //                     elements.forEach(el => {
// //                         if (el && !el.querySelector('#custom-afronika-logo')) {
// //                             // Instead of hiding, replace with custom logo
// //                             const customLogo = createCustomLogo();
// //
// //                             // If it's an image, replace it
// //                             if (el.tagName === 'IMG') {
// //                                 el.outerHTML = customLogo;
// //                             } else {
// //                                 // If it's a container, replace its content
// //                                 el.innerHTML = customLogo;
// //                                 el.style.display = 'block';
// //                             }
// //                         }
// //                     });
// //                 } catch(e) {
// //                     console.log('Error replacing logo:', e);
// //                 }
// //             });
// //
// //             // Also check for header areas where logo might be
// //             try {
// //                 const headers = document.querySelectorAll('header, .header, .top-bar, .navbar');
// //                 headers.forEach(header => {
// //                     const logoElements = header.querySelectorAll('img, .logo, [class*="logo"]');
// //                     logoElements.forEach(logo => {
// //                         if (logo && !logo.querySelector('#custom-afronika-logo')) {
// //                             const parent = logo.parentElement;
// //                             if (parent && !parent.querySelector('#custom-afronika-logo')) {
// //                                 logo.outerHTML = createCustomLogo();
// //                             }
// //                         }
// //                     });
// //                 });
// //             } catch(e) {
// //                 console.log('Error in header logo replacement:', e);
// //             }
// //         }
// //
// //         function changeBackgroundColor() {
// //             // Change body background to white
// //             try {
// //                 document.body.style.backgroundColor = 'white';
// //                 document.documentElement.style.backgroundColor = 'white';
// //
// //                 // Also target common container elements
// //                 const containers = document.querySelectorAll('header, .header, .app-bar, .top-bar, nav');
// //                 containers.forEach(container => {
// //                     if (container) {
// //                         container.style.backgroundColor = 'white';
// //                     }
// //                 });
// //             } catch(e) {}
// //         }
// //
// //         function repositionChatIcon() {
// //             // Find chat widget elements
// //             const chatSelectors = [
// //                 '.zsiq_flt_rel',
// //                 '#zsiq_float',
// //                 '.zsiq_float',
// //                 '[id*="zsiq"]',
// //                 '.siqicon',
// //                 '.siqico-chat'
// //             ];
// //
// //             chatSelectors.forEach(selector => {
// //                 try {
// //                     const elements = document.querySelectorAll(selector);
// //                     elements.forEach(el => {
// //                         if (el && el.style) {
// //                             // Position to center-left
// //                             el.style.position = 'fixed';
// //                             el.style.left = '20px';
// //                             el.style.top = '50%';
// //                             el.style.transform = 'translateY(-50%)';
// //                             el.style.right = 'auto';
// //                             el.style.bottom = 'auto';
// //                             el.style.zIndex = '9999';
// //                         }
// //                     });
// //                 } catch(e) {}
// //             });
// //
// //             // Also target parent containers
// //             try {
// //                 const chatWidget = document.querySelector('.zsiq_flt_rel');
// //                 if (chatWidget) {
// //                     chatWidget.style.cssText = `
// //                         position: fixed !important;
// //                         left: 20px !important;
// //                         top: 50% !important;
// //                         transform: translateY(-50%) !important;
// //                         right: auto !important;
// //                         bottom: auto !important;
// //                         z-index: 9999 !important;
// //                     `;
// //                 }
// //             } catch(e) {}
// //         }
// //
// //         function initializeBridge() {
// //             if (bridgeInitialized) return;
// //             bridgeInitialized = true;
// //
// //             // Replace logos and change background
// //             replaceLogos();
// //             changeBackgroundColor();
// //             repositionChatIcon();
// //
// //             // Setup observer for dynamic content
// //             const observer = new MutationObserver(() => {
// //                 replaceLogos();
// //                 changeBackgroundColor();
// //                 repositionChatIcon();
// //             });
// //
// //             observer.observe(document.body, {
// //                 childList: true,
// //                 subtree: true
// //             });
// //
// //             // Repeated operations with reduced delays
// //             setTimeout(() => {
// //                 replaceLogos();
// //                 repositionChatIcon();
// //             }, 300);
// //             setTimeout(() => {
// //                 replaceLogos();
// //                 repositionChatIcon();
// //             }, 600);
// //             setTimeout(() => {
// //                 changeBackgroundColor();
// //                 repositionChatIcon();
// //             }, 400);
// //             setTimeout(repositionChatIcon, 800);
// //
// //             // Notify Flutter
// //             setTimeout(() => {
// //                 try {
// //                     window.postMessage(JSON.stringify({type: 'bridge_ready'}), '*');
// //                 } catch(e) {}
// //             }, 300);
// //         }
// //
// //         // Initialize when ready
// //         if (document.readyState === 'loading') {
// //             document.addEventListener('DOMContentLoaded', initializeBridge);
// //         } else {
// //             setTimeout(initializeBridge, 50);
// //         }
// //
// //     })();
// //   ''';
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //
// //     // Initialize the WebView controller
// //     webViewController = WebViewController()
// //       ..setJavaScriptMode(JavaScriptMode.unrestricted)
// //       ..setBackgroundColor(const Color(0x00000000))
// //       ..setNavigationDelegate(
// //         NavigationDelegate(
// //           onProgress: (int progress) {
// //             setState(() {
// //               loadingProgress = progress;
// //               isLoading = progress < 100;
// //             });
// //           },
// //           onPageStarted: (String url) {
// //             setState(() {
// //               isLoading = true;
// //               currentUrl = url;
// //             });
// //           },
// //           onPageFinished: (String url) {
// //             setState(() {
// //               isLoading = false;
// //               currentUrl = url;
// //             });
// //
// //             // Inject JavaScript after page loads
// //             Future.delayed(Duration(milliseconds: 300), () {
// //               webViewController.runJavaScript(injectedJavaScript);
// //             });
// //           },
// //           onWebResourceError: (WebResourceError error) {
// //             // Silent error handling to reduce console noise
// //           },
// //         ),
// //       )
// //       ..addJavaScriptChannel(
// //         'Flutter',
// //         onMessageReceived: (JavaScriptMessage message) {
// //           try {
// //             final data = message.message;
// //             if (data.contains('hamburger_clicked')) {
// //               HapticFeedback.selectionClick();
// //             }
// //           } catch (e) {
// //             // Silent error handling
// //           }
// //         },
// //       )
// //       ..loadRequest(Uri.parse(currentUrl));
// //   }
// //
// //   // Handle back button press
// //   Future<bool> _onWillPop() async {
// //     try {
// //       final canGoBack = await webViewController.canGoBack();
// //       if (canGoBack) {
// //         await webViewController.goBack();
// //         return false;
// //       } else {
// //         return await _showExitDialog() ?? false;
// //       }
// //     } catch (e) {
// //       return await _showExitDialog() ?? false;
// //     }
// //   }
// //
// //   // Show exit confirmation dialog
// //   Future<bool?> _showExitDialog() {
// //     return showDialog<bool>(
// //       context: context,
// //       builder: (context) => AlertDialog(
// //         title: Text('Exit App'),
// //         content: Text('Do you want to exit the app?'),
// //         actions: [
// //           TextButton(
// //             onPressed: () => Navigator.of(context).pop(false),
// //             child: Text('Cancel'),
// //           ),
// //           TextButton(
// //             onPressed: () => Navigator.of(context).pop(true),
// //             child: Text('Exit'),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return WillPopScope(
// //       onWillPop: _onWillPop,
// //       child: Scaffold(
// //         body: Stack(
// //           children: [
// //             Padding(
// //               padding: const EdgeInsets.only(top: 32.0),
// //               child: WebViewWidget(controller: webViewController),
// //             ),
// //             // Simple loading indicator
// //             if (isLoading)
// //               Container(
// //                 color: Colors.white,
// //                 child: Center(
// //                   child: Column(
// //                     mainAxisAlignment: MainAxisAlignment.center,
// //                     children: [
// //                       CircularProgressIndicator(
// //                         color: Colors.teal,
// //                         strokeWidth: 3,
// //                       ),
// //                       SizedBox(height: 16),
// //                       Text(
// //                         'Loading ${loadingProgress}%',
// //                         style: TextStyle(
// //                           fontSize: 14,
// //                           color: Colors.grey[600],
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //               ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
//
// import 'package:afronika/utils/device/device_utility.dart';
// import 'package:flutter/material.dart';
// import 'package:webview_flutter/webview_flutter.dart';
// import 'package:flutter/services.dart';
//
// class AfronikaBrowserApp extends StatefulWidget {
//   @override
//   _AfronikaBrowserAppState createState() => _AfronikaBrowserAppState();
// }
//
// class _AfronikaBrowserAppState extends State<AfronikaBrowserApp> {
//   late WebViewController webViewController;
//   String currentUrl = "https://www.afronika.com/";
//   bool isLoading = true;
//   int loadingProgress = 0;
//
//   String get injectedJavaScript => '''
//     (function() {
//         'use strict';
//
//         function replaceLogos() {
//             const logoSelectors = [
//                 '[data-zs-logo]',
//                 '[data-zs-logo-container]',
//                 '.theme-logo-parent',
//                 '.theme-branding-info',
//                 '[data-zs-branding]',
//                 '.logo',
//                 '.brand-logo',
//                 '.site-logo',
//                 'img[alt*="logo"]',
//                 'img[src*="logo"]'
//             ];
//
//             logoSelectors.forEach(selector => {
//                 try {
//                     const elements = document.querySelectorAll(selector);
//                     elements.forEach(el => {
//                         if (el && !el.querySelector('#custom-afronika-logo')) {
//                             el.innerHTML = `
//                                 <div id="custom-afronika-logo" style="
//                                     display: inline-block;
//                                     padding: 10px 20px;
//                                     font-family: 'Roboto', sans-serif;
//                                     font-size: 28px;
//                                     font-weight: bold;
//                                     line-height: 1;
//                                 ">
//                                     <span style="color: #FF0000;">Afr</span>
//                                     <span style="color: #000000;">o</span>
//                                     <span style="color: #00BCD4;">n</span>
//                                     <span style="color: #00FFFF;">ika</span>
//                                 </div>
//                             `;
//                         }
//                     });
//                 } catch(e) {}
//             });
//         }
//
//         function changeBackgroundColor() {
//             try {
//                 document.body.style.backgroundColor = 'white';
//                 document.documentElement.style.backgroundColor = 'white';
//             } catch(e) {}
//         }
//
//         function repositionChatIcon() {
//             const chatSelectors = [
//                 '.zsiq_flt_rel',
//                 '#zsiq_float',
//                 '.zsiq_float',
//                 '[id*="zsiq"]'
//             ];
//
//             chatSelectors.forEach(selector => {
//                 try {
//                     const elements = document.querySelectorAll(selector);
//                     elements.forEach(el => {
//                         if (el && el.style) {
//                             el.style.position = 'fixed';
//                             el.style.left = '20px';
//                             el.style.top = '50%';
//                             el.style.transform = 'translateY(-50%)';
//                         }
//                     });
//                 } catch(e) {}
//             });
//         }
//
//         function initializeBridge() {
//             replaceLogos();
//             changeBackgroundColor();
//             repositionChatIcon();
//
//             const observer = new MutationObserver(() => {
//                 replaceLogos();
//                 repositionChatIcon();
//             });
//
//             observer.observe(document.body, {
//                 childList: true,
//                 subtree: true
//             });
//         }
//
//         if (document.readyState === 'loading') {
//             document.addEventListener('DOMContentLoaded', initializeBridge);
//         } else {
//             initializeBridge();
//         }
//     })();
//   ''';
//
//   @override
//   void initState() {
//     super.initState();
//
//     webViewController = WebViewController()
//       ..setJavaScriptMode(JavaScriptMode.unrestricted)
//       ..setBackgroundColor(Colors.white)
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
//             });
//           },
//           onPageFinished: (String url) {
//             setState(() {
//               isLoading = false;
//               currentUrl = url;
//             });
//             webViewController.runJavaScript(injectedJavaScript);
//           },
//           onWebResourceError: (WebResourceError error) {},
//         ),
//       )
//       ..loadRequest(Uri.parse(currentUrl));
//   }
//
//   Future<bool> _onWillPop() async {
//     if (await webViewController.canGoBack()) {
//       webViewController.goBack();
//       return false;
//     }
//     return true;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: _onWillPop,
//       child: Scaffold(
//         body: Stack(
//           children: [
//             WebViewWidget(controller: webViewController),
//
//             if (isLoading)
//               Positioned(
//                 top: 0,
//                 left: 0,
//                 right: 0,
//                 child: LinearProgressIndicator(
//                   value: loadingProgress / 100,
//                   backgroundColor: Colors.transparent,
//                   valueColor: AlwaysStoppedAnimation(Colors.blue),
//                   minHeight: 3,
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/services.dart';

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

  String get injectedJavaScript => '''
    (function() {
        'use strict';

        let bridgeInitialized = false;

        function createCustomLogo() {
            // Create the custom logo HTML with single theme
            const logoHTML = `
                <div id="custom-afronika-logo" style="
                    display: inline-block;
                    padding: 10px 20px;
                    font-family: 'Roboto', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
                    font-size: 28px;
                    font-weight: bold;
                    line-height: 1;
                ">
                    <span style="color: #FF0000;">Afr</span><span style="color: #000000;">o</span><span style="color: #00BCD4;">n</span><span style="color: #00FFFF;">ika</span>
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

        function initializeBridge() {
            if (bridgeInitialized) return;
            bridgeInitialized = true;

            // Replace logos and change background
            replaceLogos();
            changeBackgroundColor();
            repositionChatIcon();

            // Setup observer for dynamic content
            const observer = new MutationObserver(() => {
                replaceLogos();
                changeBackgroundColor();
                repositionChatIcon();
            });

            observer.observe(document.body, {
                childList: true,
                subtree: true
            });

            // Repeated operations with reduced delays
            setTimeout(() => {
                replaceLogos();
                repositionChatIcon();
            }, 300);
            setTimeout(() => {
                replaceLogos();
                repositionChatIcon();
            }, 600);
            setTimeout(() => {
                changeBackgroundColor();
                repositionChatIcon();
            }, 400);
            setTimeout(repositionChatIcon, 800);

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

            // Inject JavaScript after page loads
            Future.delayed(Duration(milliseconds: 300), () {
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
          } catch (e) {
            // Silent error handling
          }
        },
      )
      ..loadRequest(Uri.parse(currentUrl));
  }

  // Handle back button press
  Future<bool> _onWillPop() async {
    try {
      final canGoBack = await webViewController.canGoBack();
      if (canGoBack) {
        await webViewController.goBack();
        return false;
      } else {
        return await _showExitDialog() ?? false;
      }
    } catch (e) {
      return await _showExitDialog() ?? false;
    }
  }

  // Show exit confirmation dialog
  Future<bool?> _showExitDialog() {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Exit App'),
        content: Text('Do you want to exit the app?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Exit'),
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
              WebViewWidget(controller: webViewController),

              if (isLoading)
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: LinearProgressIndicator(
                    value: loadingProgress / 100,
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation(Colors.teal),
                    minHeight: 3,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}