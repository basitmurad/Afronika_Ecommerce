// // import 'package:flutter/material.dart';
// // import 'package:webview_flutter/webview_flutter.dart';
// // import 'package:flutter/services.dart';
// //
// // class AfronikaBrowserApp extends StatefulWidget {
// //   const AfronikaBrowserApp({super.key});
// //
// //   @override
// //   _AfronikaBrowserAppState createState() => _AfronikaBrowserAppState();
// // }
// //
// // class _AfronikaBrowserAppState extends State<AfronikaBrowserApp> {
// //   late WebViewController webViewController;
// //   String currentUrl = "https://www.afronika.com/";
// //   bool isLoading = true;
// //   int loadingProgress = 0;
// //   bool isRefreshing = false;
// //
// //   String get injectedJavaScript => '''
// //     (function() {
// //         'use strict';
// //
// //         let bridgeInitialized = false;
// //
// //         function createCustomLogo() {
// //             // Create the custom logo HTML with colors matching Flutter widget
// //             const logoHTML = `
// //                 <div id="custom-afronika-logo" style="
// //                     display: inline-block;
// //                     padding: 10px 20px;
// //                     font-family: 'Roboto', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
// //                     font-size: 28px;
// //                     font-weight: bold;
// //                     line-height: 1;
// //                 ">
// //                     <span style="color: #F44336;">Afr</span><span style="color: #000000;">o</span><span style="color: #FF9800;">n</span><span style="color: #00BCD4;">ika</span>
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
// //               isRefreshing = false;
// //               currentUrl = url;
// //             });
// //
// //             // Inject JavaScript after page loads
// //             Future.delayed(Duration(milliseconds: 300), () {
// //               webViewController.runJavaScript(injectedJavaScript);
// //             });
// //           },
// //           onWebResourceError: (WebResourceError error) {
// //             setState(() {
// //               isRefreshing = false;
// //             });
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
// //   // Refresh function
// //   void _refreshPage() {
// //     setState(() {
// //       isRefreshing = true;
// //     });
// //     HapticFeedback.lightImpact();
// //     webViewController.reload();
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
// //         body: SafeArea(
// //           child: Stack(
// //             children: [
// //               // Main WebView - direct implementation for full scrolling
// //               Positioned.fill(
// //                 child: WebViewWidget(controller: webViewController),
// //               ),
// //
// //               // Progress indicator
// //               if (isLoading)
// //                 Positioned(
// //                   top: 0,
// //                   left: 0,
// //                   right: 0,
// //                   child: LinearProgressIndicator(
// //                     value: loadingProgress / 100,
// //                     backgroundColor: Colors.grey[200],
// //                     valueColor: AlwaysStoppedAnimation(Colors.teal),
// //                     minHeight: 3,
// //                   ),
// //                 ),
// //
// //               // Refresh button positioned above bottom navbar on left side
// //               Positioned(
// //                 bottom: 80,
// //                 left: 16,
// //                 child: Material(
// //                   elevation: 6,
// //                   shape: CircleBorder(),
// //                   color: Colors.white,
// //                   child: InkWell(
// //                     onTap: _refreshPage,
// //                     borderRadius: BorderRadius.circular(28),
// //                     child: Container(
// //                       width: 56,
// //                       height: 56,
// //                       decoration: BoxDecoration(
// //                         shape: BoxShape.circle,
// //                         color: Colors.white,
// //                         boxShadow: [
// //                           BoxShadow(
// //                             color: Colors.black.withOpacity(0.1),
// //                             blurRadius: 8,
// //                             offset: Offset(0, 2),
// //                           ),
// //                         ],
// //                       ),
// //                       child: isRefreshing
// //                           ? Padding(
// //                         padding: EdgeInsets.all(16),
// //                         child: CircularProgressIndicator(
// //                           strokeWidth: 2,
// //                           valueColor: AlwaysStoppedAnimation(Colors.teal),
// //                         ),
// //                       )
// //                           : Icon(
// //                         Icons.refresh,
// //                         color: Colors.teal,
// //                         size: 28,
// //                       ),
// //                     ),
// //                   ),
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }
// import 'package:flutter/material.dart';
// import 'package:webview_flutter/webview_flutter.dart';
// import 'package:flutter/services.dart';
// import 'package:url_launcher/url_launcher.dart'; // Add this dependency
// import 'dart:convert'; // Add this for JSON parsing
//
// class AfronikaBrowserApp extends StatefulWidget {
//   const AfronikaBrowserApp({super.key});
//
//   @override
//   _AfronikaBrowserAppState createState() => _AfronikaBrowserAppState();
// }
//
// class _AfronikaBrowserAppState extends State<AfronikaBrowserApp> {
//   late WebViewController webViewController;
//   String currentUrl = "https://www.afronika.com/";
//   bool isLoading = true;
//   int loadingProgress = 0;
//   bool isRefreshing = false;
//
//   String get injectedJavaScript => '''
//     (function() {
//         'use strict';
//
//         let bridgeInitialized = false;
//
//         function createCustomLogo() {
//             // Create the custom logo HTML with colors matching Flutter widget
//             const logoHTML = `
//                 <div id="custom-afronika-logo" style="
//                     display: inline-block;
//                     padding: 10px 20px;
//                     font-family: 'Roboto', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
//                     font-size: 28px;
//                     font-weight: bold;
//                     line-height: 1;
//                 ">
//                     <span style="color: #F44336;">Afr</span><span style="color: #000000;">o</span><span style="color: #FF9800;">n</span><span style="color: #00BCD4;">ika</span>
//                 </div>
//                 <style>
//                     #custom-afronika-logo:hover {
//                         transform: scale(1.05);
//                         transition: transform 0.2s ease;
//                     }
//
//                     /* Responsive sizing */
//                     @media (max-width: 768px) {
//                         #custom-afronika-logo {
//                             font-size: 24px !important;
//                             padding: 8px 16px !important;
//                         }
//                     }
//                     @media (max-width: 480px) {
//                         #custom-afronika-logo {
//                             font-size: 20px !important;
//                             padding: 6px 12px !important;
//                         }
//                     }
//                 </style>
//             `;
//             return logoHTML;
//         }
//
//         function replaceLogos() {
//             // Logo selectors to find and replace
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
//                             // Instead of hiding, replace with custom logo
//                             const customLogo = createCustomLogo();
//
//                             // If it's an image, replace it
//                             if (el.tagName === 'IMG') {
//                                 el.outerHTML = customLogo;
//                             } else {
//                                 // If it's a container, replace its content
//                                 el.innerHTML = customLogo;
//                                 el.style.display = 'block';
//                             }
//                         }
//                     });
//                 } catch(e) {
//                     console.log('Error replacing logo:', e);
//                 }
//             });
//
//             // Also check for header areas where logo might be
//             try {
//                 const headers = document.querySelectorAll('header, .header, .top-bar, .navbar');
//                 headers.forEach(header => {
//                     const logoElements = header.querySelectorAll('img, .logo, [class*="logo"]');
//                     logoElements.forEach(logo => {
//                         if (logo && !logo.querySelector('#custom-afronika-logo')) {
//                             const parent = logo.parentElement;
//                             if (parent && !parent.querySelector('#custom-afronika-logo')) {
//                                 logo.outerHTML = createCustomLogo();
//                             }
//                         }
//                     });
//                 });
//             } catch(e) {
//                 console.log('Error in header logo replacement:', e);
//             }
//         }
//
//         function changeBackgroundColor() {
//             // Change body background to white
//             try {
//                 document.body.style.backgroundColor = 'white';
//                 document.documentElement.style.backgroundColor = 'white';
//
//                 // Also target common container elements
//                 const containers = document.querySelectorAll('header, .header, .app-bar, .top-bar, nav');
//                 containers.forEach(container => {
//                     if (container) {
//                         container.style.backgroundColor = 'white';
//                     }
//                 });
//             } catch(e) {}
//         }
//
//         function repositionChatIcon() {
//             // Find chat widget elements
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
//                             // Position to center-left
//                             el.style.position = 'fixed';
//                             el.style.left = '20px';
//                             el.style.top = '50%';
//                             el.style.transform = 'translateY(-50%)';
//                             el.style.right = 'auto';
//                             el.style.bottom = 'auto';
//                             el.style.zIndex = '9999';
//                         }
//                     });
//                 } catch(e) {}
//             });
//
//             // Also target parent containers
//             try {
//                 const chatWidget = document.querySelector('.zsiq_flt_rel');
//                 if (chatWidget) {
//                     chatWidget.style.cssText = `
//                         position: fixed !important;
//                         left: 20px !important;
//                         top: 50% !important;
//                         transform: translateY(-50%) !important;
//                         right: auto !important;
//                         bottom: auto !important;
//                         z-index: 9999 !important;
//                     `;
//                 }
//             } catch(e) {}
//         }
//
//         // Add click event handling for phone and email links
//         function handleExternalLinks() {
//             try {
//                 // Remove existing event listeners to avoid duplicates
//                 document.removeEventListener('click', globalClickHandler);
//
//                 // Add global click handler
//                 document.addEventListener('click', globalClickHandler, true);
//
//             } catch(e) {
//                 console.log('Error handling external links:', e);
//             }
//         }
//
//         function globalClickHandler(e) {
//             try {
//                 let target = e.target;
//
//                 // Traverse up the DOM to find an anchor tag
//                 while (target && target.tagName !== 'A') {
//                     target = target.parentElement;
//                 }
//
//                 if (target && target.tagName === 'A') {
//                     const href = target.getAttribute('href');
//
//                     if (href && (href.startsWith('mailto:') || href.startsWith('tel:'))) {
//                         console.log('Intercepting click on:', href);
//                         e.preventDefault();
//                         e.stopPropagation();
//
//                         // Send message to Flutter using multiple methods
//                         const messageData = {
//                             type: 'external_link',
//                             url: href
//                         };
//
//                         console.log('Sending message to Flutter:', JSON.stringify(messageData));
//
//                         // Try multiple ways to send the message
//                         try {
//                             // Method 1: postMessage
//                             window.postMessage(JSON.stringify(messageData), '*');
//
//                             // Method 2: Direct Flutter channel (if available)
//                             if (window.Flutter && window.Flutter.postMessage) {
//                                 window.Flutter.postMessage(JSON.stringify(messageData));
//                             }
//
//                             // Method 3: Custom event
//                             window.dispatchEvent(new CustomEvent('flutterMessage', {
//                                 detail: messageData
//                             }));
//
//                         } catch(err) {
//                             console.log('Error sending message:', err);
//                         }
//
//                         return false;
//                     }
//                 }
//             } catch(error) {
//                 console.log('Error in click handler:', error);
//             }
//         }
//
//         function initializeBridge() {
//             if (bridgeInitialized) return;
//             bridgeInitialized = true;
//
//             // Replace logos and change background
//             replaceLogos();
//             changeBackgroundColor();
//             repositionChatIcon();
//             handleExternalLinks();
//
//             // Setup observer for dynamic content
//             const observer = new MutationObserver(() => {
//                 replaceLogos();
//                 changeBackgroundColor();
//                 repositionChatIcon();
//                 handleExternalLinks();
//             });
//
//             observer.observe(document.body, {
//                 childList: true,
//                 subtree: true
//             });
//
//             // Repeated operations with reduced delays
//             setTimeout(() => {
//                 replaceLogos();
//                 repositionChatIcon();
//                 handleExternalLinks();
//             }, 300);
//             setTimeout(() => {
//                 replaceLogos();
//                 repositionChatIcon();
//                 handleExternalLinks();
//             }, 600);
//             setTimeout(() => {
//                 changeBackgroundColor();
//                 repositionChatIcon();
//                 handleExternalLinks();
//             }, 400);
//             setTimeout(() => {
//                 repositionChatIcon();
//                 handleExternalLinks();
//             }, 800);
//
//             // Notify Flutter
//             setTimeout(() => {
//                 try {
//                     window.postMessage(JSON.stringify({type: 'bridge_ready'}), '*');
//                 } catch(e) {}
//             }, 300);
//         }
//
//         // Initialize when ready
//         if (document.readyState === 'loading') {
//             document.addEventListener('DOMContentLoaded', initializeBridge);
//         } else {
//             setTimeout(initializeBridge, 50);
//         }
//
//     })();
//   ''';
//
//   // Function to handle external URLs
//   Future<void> _handleExternalUrl(String url) async {
//     try {
//       print('🚀 Attempting to launch: $url'); // Debug log
//
//       final Uri uri = Uri.parse(url);
//
//       // Check if the URL can be launched first
//       bool canLaunch = await canLaunchUrl(uri);
//       print('📱 Can launch URL: $canLaunch'); // Debug log
//
//       if (canLaunch) {
//         // Use external application mode to ensure it opens in external apps
//         bool launched = await launchUrl(
//           uri,
//           mode: LaunchMode.externalApplication,
//         );
//
//         print('✅ Launch result: $launched'); // Debug log
//
//         if (launched) {
//           // Show success feedback
//           if (mounted) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: Text('Opening ${uri.scheme == 'mailto' ? 'email app' : 'phone app'}...'),
//                 backgroundColor: Colors.green,
//                 duration: Duration(seconds: 2),
//               ),
//             );
//           }
//         }
//       } else {
//         print('❌ Cannot launch URL: $url'); // Debug log
//
//         // Try alternative launch modes
//         try {
//           await launchUrl(uri, mode: LaunchMode.externalNonBrowserApplication);
//           print('✅ Launched with alternative mode'); // Debug log
//         } catch (e2) {
//           print('❌ Alternative launch failed: $e2'); // Debug log
//           throw e2;
//         }
//       }
//
//     } catch (e) {
//       print('❌ Error launching URL: $e'); // Debug log
//
//       // Show error message if URL can't be launched
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Could not open: $url\nError: ${e.toString()}'),
//             backgroundColor: Colors.red,
//             duration: Duration(seconds: 5),
//             action: SnackBarAction(
//               label: 'Copy URL',
//               textColor: Colors.white,
//               onPressed: () {
//                 Clipboard.setData(ClipboardData(text: url));
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(
//                     content: Text('URL copied to clipboard'),
//                     duration: Duration(seconds: 2),
//                   ),
//                 );
//               },
//             ),
//           ),
//         );
//       }
//     }
//   }
//
//   @override
//   void initState() {
//     super.initState();
//
//     // Initialize the WebView controller
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
//             });
//           },
//           onPageFinished: (String url) {
//             setState(() {
//               isLoading = false;
//               isRefreshing = false;
//               currentUrl = url;
//             });
//
//             // Inject JavaScript after page loads
//             Future.delayed(Duration(milliseconds: 300), () {
//               webViewController.runJavaScript(injectedJavaScript);
//             });
//           },
//           onWebResourceError: (WebResourceError error) {
//             setState(() {
//               isRefreshing = false;
//             });
//           },
//           // Handle navigation requests to intercept external URLs
//           onNavigationRequest: (NavigationRequest request) {
//             print('Navigation request: ${request.url}'); // Debug log
//
//             // Check if it's a mailto or tel link
//             if (request.url.startsWith('mailto:') || request.url.startsWith('tel:')) {
//               print('Intercepting external URL: ${request.url}'); // Debug log
//               _handleExternalUrl(request.url);
//               return NavigationDecision.prevent;
//             }
//
//             // Allow normal web navigation
//             return NavigationDecision.navigate;
//           },
//         ),
//       )
//       ..addJavaScriptChannel(
//         'Flutter',
//         onMessageReceived: (JavaScriptMessage message) {
//           try {
//             print('✓ Received JS message: ${message.message}'); // Debug log
//
//             final data = message.message;
//
//             if (data.contains('hamburger_clicked')) {
//               HapticFeedback.selectionClick();
//               return;
//             }
//
//             // Try to parse as JSON
//             try {
//               final Map<String, dynamic> parsedData =
//               Map<String, dynamic>.from(
//                   jsonDecode(data) as Map);
//
//               print('✓ Parsed JSON data: $parsedData'); // Debug log
//
//               if (parsedData['type'] == 'external_link') {
//                 final url = parsedData['url'];
//                 print('✓ Handling external link: $url'); // Debug log
//                 _handleExternalUrl(url);
//               }
//             } catch (jsonError) {
//               print('❌ JSON parse error: $jsonError'); // Debug log
//               print('❌ Raw message: $data'); // Debug log
//
//               // Fallback: check if message contains external_link
//               if (data.contains('external_link')) {
//                 // Try to extract URL from the message
//                 final regex = RegExp(r'"url":"([^"]+)"');
//                 final match = regex.firstMatch(data);
//                 if (match != null) {
//                   final url = match.group(1);
//                   print('✓ Extracted URL from fallback: $url'); // Debug log
//                   if (url != null) {
//                     _handleExternalUrl(url);
//                   }
//                 } else {
//                   print('❌ Could not extract URL from message'); // Debug log
//                 }
//               }
//             }
//           } catch (e) {
//             print('❌ Error in JS message handler: $e'); // Debug log
//           }
//         },
//       )
//       ..loadRequest(Uri.parse(currentUrl));
//   }
//
//   // Refresh function
//   void _refreshPage() {
//     setState(() {
//       isRefreshing = true;
//     });
//     HapticFeedback.lightImpact();
//     webViewController.reload();
//   }
//
//   // Handle back button press
//   Future<bool> _onWillPop() async {
//     try {
//       final canGoBack = await webViewController.canGoBack();
//       if (canGoBack) {
//         await webViewController.goBack();
//         return false;
//       } else {
//         return await _showExitDialog() ?? false;
//       }
//     } catch (e) {
//       return await _showExitDialog() ?? false;
//     }
//   }
//
//   // Show exit confirmation dialog
//   Future<bool?> _showExitDialog() {
//     return showDialog<bool>(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text('Exit App'),
//         content: Text('Do you want to exit the app?'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(false),
//             child: Text('Cancel'),
//           ),
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(true),
//             child: Text('Exit'),
//           ),
//         ],
//       ),
//     );
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
//               // Main WebView - direct implementation for full scrolling
//               Positioned.fill(
//                 child: WebViewWidget(controller: webViewController),
//               ),
//
//               // Progress indicator
//               if (isLoading)
//                 Positioned(
//                   top: 0,
//                   left: 0,
//                   right: 0,
//                   child: LinearProgressIndicator(
//                     value: loadingProgress / 100,
//                     backgroundColor: Colors.grey[200],
//                     valueColor: AlwaysStoppedAnimation(Colors.teal),
//                     minHeight: 3,
//                   ),
//                 ),
//
//               // Refresh button positioned above bottom navbar on left side
//               Positioned(
//                 bottom: 80,
//                 left: 16,
//                 child: Material(
//                   elevation: 6,
//                   shape: CircleBorder(),
//                   color: Colors.white,
//                   child: InkWell(
//                     onTap: _refreshPage,
//                     borderRadius: BorderRadius.circular(28),
//                     child: Container(
//                       width: 56,
//                       height: 56,
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         color: Colors.white,
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.black.withOpacity(0.1),
//                             blurRadius: 8,
//                             offset: Offset(0, 2),
//                           ),
//                         ],
//                       ),
//                       child: isRefreshing
//                           ? Padding(
//                         padding: EdgeInsets.all(16),
//                         child: CircularProgressIndicator(
//                           strokeWidth: 2,
//                           valueColor: AlwaysStoppedAnimation(Colors.teal),
//                         ),
//                       )
//                           : Icon(
//                         Icons.refresh,
//                         color: Colors.teal,
//                         size: 28,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//
//               // Debug test buttons (remove in production)
//               Positioned(
//                 bottom: 150,
//                 left: 16,
//                 child: Column(
//                   children: [
//                     // Test Email Button
//                     Container(
//                       width: 48,
//                       height: 48,
//                       margin: EdgeInsets.only(bottom: 8),
//                       decoration: BoxDecoration(
//                         color: Colors.blue,
//                         shape: BoxShape.circle,
//                       ),
//                       child: IconButton(
//                         onPressed: () {
//                           print('🧪 Testing email launch');
//                           _handleExternalUrl('mailto:contact@afronika.com');
//                         },
//                         icon: Icon(Icons.email, color: Colors.white, size: 20),
//                       ),
//                     ),
//                     // Test Phone Button
//                     Container(
//                       width: 48,
//                       height: 48,
//                       decoration: BoxDecoration(
//                         color: Colors.green,
//                         shape: BoxShape.circle,
//                       ),
//                       child: IconButton(
//                         onPressed: () {
//                           print('🧪 Testing phone launch');
//                           _handleExternalUrl('tel:07032280605');
//                         },
//                         icon: Icon(Icons.phone, color: Colors.white, size: 20),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';

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

        // Add click event handling for phone, email, and social media links
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
                
                // Traverse up the DOM to find an anchor tag
                while (target && target.tagName !== 'A') {
                    target = target.parentElement;
                }
                
                if (target && target.tagName === 'A') {
                    const href = target.getAttribute('href');
                    
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
                            
                            // Try multiple ways to send the message
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

  // Function to handle Facebook URLs specifically
  Future<void> _handleFacebookUrl(String url) async {
    try {
      print('🔵 Handling Facebook URL: $url');

      final Uri uri = Uri.parse(url);

      // For Facebook links, always use external browser/app
      bool launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (launched) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Opening Facebook...'),
              backgroundColor: Colors.blue,
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      print('❌ Error launching Facebook URL: $e');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not open Facebook link'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
  }

  // Function to handle social media URLs
  Future<void> _handleSocialMediaUrl(String url) async {
    try {
      print('📱 Handling Social Media URL: $url');

      final Uri uri = Uri.parse(url);

      // For social media links, always use external browser/app
      bool launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (launched) {
        String platform = 'social media';
        if (url.contains('instagram.com')) platform = 'Instagram';
        else if (url.contains('twitter.com')) platform = 'Twitter';
        else if (url.contains('linkedin.com')) platform = 'LinkedIn';
        else if (url.contains('youtube.com')) platform = 'YouTube';
        else if (url.contains('tiktok.com')) platform = 'TikTok';

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Opening $platform...'),
              backgroundColor: Colors.purple,
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      print('❌ Error launching Social Media URL: $e');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not open social media link'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
  }

  // Function to handle external URLs (email, phone, etc.)
  Future<void> _handleExternalUrl(String url) async {
    try {
      print('🚀 Attempting to launch: $url');

      final Uri uri = Uri.parse(url);

      // Check if the URL can be launched first
      bool canLaunch = await canLaunchUrl(uri);
      print('📱 Can launch URL: $canLaunch');

      if (canLaunch) {
        // Use external application mode to ensure it opens in external apps
        bool launched = await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );

        print('✅ Launch result: $launched');

        if (launched) {
          // Show success feedback
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Opening ${uri.scheme == 'mailto' ? 'email app' : 'phone app'}...'),
                backgroundColor: Colors.green,
                duration: Duration(seconds: 2),
              ),
            );
          }
        }
      } else {
        print('❌ Cannot launch URL: $url');

        // Try alternative launch modes
        try {
          await launchUrl(uri, mode: LaunchMode.externalNonBrowserApplication);
          print('✅ Launched with alternative mode');
        } catch (e2) {
          print('❌ Alternative launch failed: $e2');
          throw e2;
        }
      }

    } catch (e) {
      print('❌ Error launching URL: $e');

      // Show error message if URL can't be launched
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not open: $url\nError: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 5),
            action: SnackBarAction(
              label: 'Copy URL',
              textColor: Colors.white,
              onPressed: () {
                Clipboard.setData(ClipboardData(text: url));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('URL copied to clipboard'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
            ),
          ),
        );
      }
    }
  }

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
              isRefreshing = false;
              currentUrl = url;
            });

            // Inject JavaScript after page loads
            Future.delayed(Duration(milliseconds: 300), () {
              webViewController.runJavaScript(injectedJavaScript);
            });
          },
          onWebResourceError: (WebResourceError error) {
            setState(() {
              isRefreshing = false;
            });
          },
          // Handle navigation requests to intercept external URLs
          onNavigationRequest: (NavigationRequest request) {
            print('Navigation request: ${request.url}');

            // Check if it's a mailto or tel link
            if (request.url.startsWith('mailto:') || request.url.startsWith('tel:')) {
              print('Intercepting external URL: ${request.url}');
              _handleExternalUrl(request.url);
              return NavigationDecision.prevent;
            }

            // Check if it's a Facebook link
            if (request.url.contains('facebook.com') ||
                request.url.contains('fb.com') ||
                request.url.contains('m.facebook.com')) {
              print('Intercepting Facebook URL: ${request.url}');
              _handleFacebookUrl(request.url);
              return NavigationDecision.prevent;
            }

            // Check for other social media links that might have similar issues
            if (request.url.contains('instagram.com') ||
                request.url.contains('twitter.com') ||
                request.url.contains('linkedin.com') ||
                request.url.contains('youtube.com') ||
                request.url.contains('tiktok.com') ||
                request.url.contains('snapchat.com')) {
              print('Intercepting social media URL: ${request.url}');
              _handleSocialMediaUrl(request.url);
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
              _handleExternalUrl(request.url);
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
              Map<String, dynamic>.from(
                  jsonDecode(data) as Map);

              print('✓ Parsed JSON data: $parsedData');

              if (parsedData['type'] == 'external_link') {
                final url = parsedData['url'];
                final platform = parsedData['platform'];

                print('✓ Handling external link: $url (platform: $platform)');

                // Handle different platforms
                if (platform == 'facebook') {
                  _handleFacebookUrl(url);
                } else if (platform == 'social') {
                  _handleSocialMediaUrl(url);
                } else {
                  _handleExternalUrl(url);
                }
              }
            } catch (jsonError) {
              print('❌ JSON parse error: $jsonError');
              print('❌ Raw message: $data');

              // Fallback: check if message contains external_link
              if (data.contains('external_link')) {
                // Try to extract URL from the message
                final regex = RegExp(r'"url":"([^"]+)"');
                final match = regex.firstMatch(data);
                if (match != null) {
                  final url = match.group(1);
                  print('✓ Extracted URL from fallback: $url');
                  if (url != null) {
                    // Check platform in fallback
                    if (data.contains('facebook')) {
                      _handleFacebookUrl(url);
                    } else if (data.contains('social')) {
                      _handleSocialMediaUrl(url);
                    } else {
                      _handleExternalUrl(url);
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
      )
      ..loadRequest(Uri.parse(currentUrl));
  }

  // Refresh function
  void _refreshPage() {
    setState(() {
      isRefreshing = true;
    });
    HapticFeedback.lightImpact();
    webViewController.reload();
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
                    valueColor: AlwaysStoppedAnimation(Colors.teal),
                    minHeight: 3,
                  ),
                ),

              // Refresh button positioned above bottom navbar on left side
              Positioned(
                bottom: 80,
                left: 16,
                child: Material(
                  elevation: 6,
                  shape: CircleBorder(),
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
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: isRefreshing
                          ? Padding(
                        padding: EdgeInsets.all(16),
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation(Colors.teal),
                        ),
                      )
                          : Icon(
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