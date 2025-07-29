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
// //         body: SafeArea(
// //           child: Stack(
// //             children: [
// //               WebViewWidget(controller: webViewController),
// //
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
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }
//
//
// import 'package:flutter/material.dart';
// import 'package:webview_flutter/webview_flutter.dart';
// import 'package:flutter/services.dart';
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
//         function initializeBridge() {
//             if (bridgeInitialized) return;
//             bridgeInitialized = true;
//
//             // Replace logos and change background
//             replaceLogos();
//             changeBackgroundColor();
//             repositionChatIcon();
//
//             // Setup observer for dynamic content
//             const observer = new MutationObserver(() => {
//                 replaceLogos();
//                 changeBackgroundColor();
//                 repositionChatIcon();
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
//             }, 300);
//             setTimeout(() => {
//                 replaceLogos();
//                 repositionChatIcon();
//             }, 600);
//             setTimeout(() => {
//                 changeBackgroundColor();
//                 repositionChatIcon();
//             }, 400);
//             setTimeout(repositionChatIcon, 800);
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
//         ),
//       )
//       ..addJavaScriptChannel(
//         'Flutter',
//         onMessageReceived: (JavaScriptMessage message) {
//           try {
//             final data = message.message;
//             if (data.contains('hamburger_clicked')) {
//               HapticFeedback.selectionClick();
//             }
//           } catch (e) {
//             // Silent error handling
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
//               // Main WebView
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
              // Main WebView with pull-to-refresh
              Positioned.fill(
                child: RefreshIndicator(
                  onRefresh: () async {
                    _refreshPage();
                    // Wait for the refresh to complete
                    while (isRefreshing) {
                      await Future.delayed(Duration(milliseconds: 100));
                    }
                  },
                  color: Colors.teal,
                  backgroundColor: Colors.white,
                  strokeWidth: 3,
                  child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      child: WebViewWidget(controller: webViewController),
                    ),
                  ),
                ),
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