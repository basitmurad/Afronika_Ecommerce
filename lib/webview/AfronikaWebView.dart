// // import 'dart:io';
// //
// // import 'package:flutter/material.dart';
// // import 'package:webview_flutter/webview_flutter.dart';
// // import 'package:flutter/services.dart';
// // import 'dart:io';
// // import 'package:flutter/material.dart';
// // import 'package:webview_flutter/webview_flutter.dart';
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
// //   // Optimized JavaScript code to inject
// //   String get injectedJavaScript => '''
// //     (function() {
// //         'use strict';
// //
// //         // Throttle function to reduce excessive calls
// //         function throttle(func, limit) {
// //             let inThrottle;
// //             return function() {
// //                 const args = arguments;
// //                 const context = this;
// //                 if (!inThrottle) {
// //                     func.apply(context, args);
// //                     inThrottle = true;
// //                     setTimeout(() => inThrottle = false, limit);
// //                 }
// //             }
// //         }
// //
// //         let bridgeInitialized = false;
// //
// //         function addHamburgerToAppBar() {
// //             // Check if already exists
// //             if (document.querySelector('.app-bar-hamburger')) return;
// //
// //             const hamburgerIcon = document.createElement('div');
// //             hamburgerIcon.className = 'app-bar-hamburger';
// //
// //             hamburgerIcon.style.cssText = `
// //                 position: fixed;
// //                 top: 70px;
// //                 left: 15px;
// //                 z-index: 9999;
// //                 background: rgba(255, 255, 255, 0.95);
// //                 border-radius: 50%;
// //                 padding: 12px;
// //                 box-shadow: 0 4px 12px rgba(0,0,0,0.15);
// //                 cursor: pointer;
// //                 width: 48px;
// //                 height: 48px;
// //                 display: flex;
// //                 align-items: center;
// //                 justify-content: center;
// //                 border: 1px solid rgba(0,0,0,0.1);
// //                 transition: transform 0.2s ease;
// //             `;
// //
// //             hamburgerIcon.innerHTML = `
// //                 <svg width="24px" height="24px" fill="#000000" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">
// //                     <path d="M 2 5 L 2 7 L 22 7 L 22 5 L 2 5 z M 2 11 L 2 13 L 22 13 L 22 11 L 2 11 z M 2 17 L 2 19 L 22 19 L 22 17 L 2 17 z"></path>
// //                 </svg>
// //             `;
// //
// //             hamburgerIcon.addEventListener('click', function(e) {
// //                 e.preventDefault();
// //                 e.stopPropagation();
// //
// //                 // Find and click original navigation
// //                 const originalButton = document.querySelector('[data-zs-drawer-open-button="navigation"]:not(.app-bar-hamburger)') ||
// //                                      document.querySelector('[data-zs-mobile-header-slide-open]:not(.app-bar-hamburger)');
// //
// //                 if (originalButton) {
// //                     originalButton.click();
// //                 }
// //
// //                 // Notify Flutter
// //                 try {
// //                     window.postMessage(JSON.stringify({type: 'hamburger_clicked'}), '*');
// //                 } catch(e) {}
// //             });
// //
// //             // Simple hover effect
// //             hamburgerIcon.addEventListener('mousedown', function() {
// //                 this.style.transform = 'scale(0.95)';
// //             });
// //
// //             hamburgerIcon.addEventListener('mouseup', function() {
// //                 this.style.transform = 'scale(1)';
// //             });
// //
// //             document.body.appendChild(hamburgerIcon);
// //         }
// //
// //         function hideOriginalHamburgers() {
// //             // Simple approach - hide common hamburger selectors
// //             const selectors = [
// //                 '[data-zs-drawer-open-button="navigation"]:not(.app-bar-hamburger)',
// //                 '[data-zs-mobile-header-slide-open]:not(.app-bar-hamburger)',
// //                 '.theme-mobile-header-slide-open:not(.app-bar-hamburger)'
// //             ];
// //
// //             selectors.forEach(selector => {
// //                 try {
// //                     const elements = document.querySelectorAll(selector);
// //                     elements.forEach(el => {
// //                         if (el && !el.classList.contains('app-bar-hamburger')) {
// //                             el.style.display = 'none';
// //                         }
// //                     });
// //                 } catch(e) {}
// //             });
// //
// //             // Hide mobile header wrapper
// //             const wrapper = document.querySelector('.theme-mobile-header-icon-wrapper');
// //             if (wrapper) {
// //                 const hamburger = wrapper.querySelector('[data-zs-drawer-open-button]');
// //                 if (hamburger) hamburger.style.display = 'none';
// //             }
// //         }
// //
// //         // Throttled function to avoid excessive hiding
// //         const throttledHide = throttle(hideOriginalHamburgers, 1000);
// //
// //         function initializeBridge() {
// //             if (bridgeInitialized) return;
// //             bridgeInitialized = true;
// //
// //             // Add our hamburger
// //             addHamburgerToAppBar();
// //
// //             // Hide originals immediately and after delay
// //             hideOriginalHamburgers();
// //             setTimeout(hideOriginalHamburgers, 1000);
// //
// //             // Setup minimal observer for dynamic content
// //             const observer = new MutationObserver(throttledHide);
// //             observer.observe(document.body, {
// //                 childList: true,
// //                 subtree: false // Reduced scope
// //             });
// //
// //             // Notify Flutter
// //             setTimeout(() => {
// //                 try {
// //                     window.postMessage(JSON.stringify({type: 'bridge_ready'}), '*');
// //                 } catch(e) {}
// //             }, 1500);
// //         }
// //
// //         // Initialize when ready
// //         if (document.readyState === 'loading') {
// //             document.addEventListener('DOMContentLoaded', initializeBridge);
// //         } else {
// //             setTimeout(initializeBridge, 100);
// //         }
// //
// //     })();
// //   ''';
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //
// //     if (Platform.isAndroid) {
// //       WebView.platform = SurfaceAndroidWebView(); // Use hybrid composition
// //     }
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
// //             // Delayed injection to ensure page is fully loaded
// //             Future.delayed(Duration(milliseconds: 800), () {
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
// //             // Reduced logging to improve performance
// //           } catch (e) {
// //             // Silent error handling
// //           }
// //         },
// //       )
// //       ..loadRequest(Uri.parse(currentUrl));
// //   }
// //
// //   Future<void> _sendCommandToWebView(String command) async {
// //     final script = '''
// //       window.postMessage(JSON.stringify({
// //         type: 'flutter_command',
// //         command: '\$command'
// //       }), '*');
// //     ''';
// //
// //     try {
// //       await webViewController.runJavaScript(script);
// //     } catch (e) {
// //       debugPrint('Error sending command to WebView: \$e');
// //     }
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       body: Stack(
// //         children: [
// //           Padding(
// //             padding: const EdgeInsets.only(top: 28.0),
// //             child: WebViewWidget(controller: webViewController),
// //           ),
// //           if (isLoading)
// //             Container(
// //               color: Colors.white,
// //               child: Center(
// //                 child: Column(
// //                   mainAxisAlignment: MainAxisAlignment.center,
// //                   children: [
// //                     CircularProgressIndicator(
// //                       value: loadingProgress / 100.0,
// //                       valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
// //                     ),
// //                     SizedBox(height: 20),
// //                     Text(
// //                       'Loading Afronika... \${loadingProgress}%',
// //                       style: TextStyle(
// //                         fontSize: 16,
// //                         color: Colors.black54,
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //             ),
// //         ],
// //       ),
// //     );
// //   }
// // }
// //
// //
//
//
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
//   // Optimized JavaScript code to inject
//   String get injectedJavaScript => '''
//     (function() {
//         'use strict';
//        
//         // Throttle function to reduce excessive calls
//         function throttle(func, limit) {
//             let inThrottle;
//             return function() {
//                 const args = arguments;
//                 const context = this;
//                 if (!inThrottle) {
//                     func.apply(context, args);
//                     inThrottle = true;
//                     setTimeout(() => inThrottle = false, limit);
//                 }
//             }
//         }
//        
//         let bridgeInitialized = false;
//        
//         function addHamburgerToAppBar() {
//             // Check if already exists
//             if (document.querySelector('.app-bar-hamburger')) return;
//            
//             const hamburgerIcon = document.createElement('div');
//             hamburgerIcon.className = 'app-bar-hamburger';
//            
//             hamburgerIcon.style.cssText = `
//                 position: fixed;
//                 top: 70px;
//                 left: 15px;
//                 z-index: 9999;
//                 background: rgba(255, 255, 255, 0.95);
//                 border-radius: 50%;
//                 padding: 12px;
//                 box-shadow: 0 4px 12px rgba(0,0,0,0.15);
//                 cursor: pointer;
//                 width: 48px;
//                 height: 48px;
//                 display: flex;
//                 align-items: center;
//                 justify-content: center;
//                 border: 1px solid rgba(0,0,0,0.1);
//                 transition: transform 0.2s ease;
//             `;
//            
//             hamburgerIcon.innerHTML = `
//                 <svg width="24px" height="24px" fill="#000000" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">
//                     <path d="M 2 5 L 2 7 L 22 7 L 22 5 L 2 5 z M 2 11 L 2 13 L 22 13 L 22 11 L 2 11 z M 2 17 L 2 19 L 22 19 L 22 17 L 2 17 z"></path>
//                 </svg>
//             `;
//            
//             hamburgerIcon.addEventListener('click', function(e) {
//                 e.preventDefault();
//                 e.stopPropagation();
//                
//                 // Find and click original navigation
//                 const originalButton = document.querySelector('[data-zs-drawer-open-button="navigation"]:not(.app-bar-hamburger)') ||
//                                      document.querySelector('[data-zs-mobile-header-slide-open]:not(.app-bar-hamburger)');
//                
//                 if (originalButton) {
//                     originalButton.click();
//                 }
//                
//                 // Notify Flutter
//                 try {
//                     window.postMessage(JSON.stringify({type: 'hamburger_clicked'}), '*');
//                 } catch(e) {}
//             });
//            
//             // Simple hover effect
//             hamburgerIcon.addEventListener('mousedown', function() {
//                 this.style.transform = 'scale(0.95)';
//             });
//            
//             hamburgerIcon.addEventListener('mouseup', function() {
//                 this.style.transform = 'scale(1)';
//             });
//            
//             document.body.appendChild(hamburgerIcon);
//         }
//        
//         function hideBottomNavHamburgers() {
//             // Only hide hamburgers that are NOT in the top app bar area
//             const selectors = [
//                 '[data-zs-drawer-open-button="navigation"]',
//                 '[data-zs-mobile-header-slide-open]',
//                 '.theme-mobile-header-slide-open'
//             ];
//            
//             selectors.forEach(selector => {
//                 try {
//                     const elements = document.querySelectorAll(selector);
//                     elements.forEach(el => {
//                         if (el) {
//                             const rect = el.getBoundingClientRect();
//                             const windowHeight = window.innerHeight;
//                            
//                             // Only hide if it's in the bottom area (bottom navigation)
//                             // Keep the ones in top area (app bar)
//                             if (rect.top > windowHeight * 0.8) {
//                                 el.style.display = 'none';
//                                 console.log('Hidden bottom nav hamburger');
//                             }
//                         }
//                     });
//                 } catch(e) {}
//             });
//         }
//        
//         // Throttled function to avoid excessive operations
//         const throttledHide = throttle(hideBottomNavHamburgers, 1000);
//        
//         function initializeBridge() {
//             if (bridgeInitialized) return;
//             bridgeInitialized = true;
//            
//             // Remove logo and enhance original hamburger
//             modifyAppBarElements();
//            
//             // Hide bottom navigation hamburgers only
//             hideBottomNavHamburgers();
//             setTimeout(hideBottomNavHamburgers, 1000);
//            
//             // Setup minimal observer for dynamic content
//             const observer = new MutationObserver(throttledHide);
//             observer.observe(document.body, {
//                 childList: true,
//                 subtree: false
//             });
//            
//             // Notify Flutter
//             setTimeout(() => {
//                 try {
//                     window.postMessage(JSON.stringify({type: 'bridge_ready'}), '*');
//                 } catch(e) {}
//             }, 1500);
//         }
//        
//         // Initialize when ready
//         if (document.readyState === 'loading') {
//             document.addEventListener('DOMContentLoaded', initializeBridge);
//         } else {
//             setTimeout(initializeBridge, 100);
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
//               currentUrl = url;
//             });
//
//             // Delayed injection to ensure page is fully loaded
//             Future.delayed(Duration(milliseconds: 800), () {
//               webViewController.runJavaScript(injectedJavaScript);
//             });
//           },
//           onWebResourceError: (WebResourceError error) {
//             // Silent error handling to reduce console noise
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
//             // Reduced logging to improve performance
//           } catch (e) {
//             // Silent error handling
//           }
//         },
//       )
//       ..loadRequest(Uri.parse(currentUrl));
//   }
//
//   Future<void> _sendCommandToWebView(String command) async {
//     final script = '''
//       window.postMessage(JSON.stringify({
//         type: 'flutter_command',
//         command: '\$command'
//       }), '*');
//     ''';
//
//     try {
//       await webViewController.runJavaScript(script);
//     } catch (e) {
//       debugPrint('Error sending command to WebView: \$e');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Afronika'),
//         backgroundColor: Colors.white,
//         foregroundColor: Colors.black,
//         elevation: 1,
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back),
//           onPressed: () async {
//             if (await webViewController.canGoBack()) {
//               webViewController.goBack();
//             } else {
//               // If can't go back, exit app or go to home
//               Navigator.of(context).pop();
//             }
//           },
//         ),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.arrow_forward),
//             onPressed: () async {
//               if (await webViewController.canGoForward()) {
//                 webViewController.goForward();
//               }
//             },
//           ),
//           IconButton(
//             icon: Icon(Icons.refresh),
//             onPressed: () {
//               webViewController.reload();
//             },
//           ),
//           PopupMenuButton<String>(
//             onSelected: (value) async {
//               switch (value) {
//                 case 'home':
//                   webViewController.loadRequest(Uri.parse("https://www.afronika.com/"));
//                   break;
//                 case 'scroll_top':
//                   _sendCommandToWebView('scroll_top');
//                   break;
//                 case 'toggle_menu':
//                   _sendCommandToWebView('toggle_menu');
//                   break;
//                 case 'share':
//                 // Implement share functionality
//                   break;
//               }
//             },
//             itemBuilder: (BuildContext context) => [
//               PopupMenuItem(value: 'home', child: Text('Home')),
//               PopupMenuItem(value: 'scroll_top', child: Text('Scroll to Top')),
//               PopupMenuItem(value: 'toggle_menu', child: Text('Toggle Menu')),
//               PopupMenuItem(value: 'share', child: Text('Share')),
//             ],
//           ),
//         ],
//       ),
//       body: Stack(
//         children: [
//           WebViewWidget(controller: webViewController),
//           if (isLoading)
//             Container(
//               color: Colors.white,
//               child: Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     CircularProgressIndicator(
//                       value: loadingProgress / 100.0,
//                       valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
//                     ),
//                     SizedBox(height: 20),
//                     Text(
//                       'Loading Afronika... \${loadingProgress}%',
//                       style: TextStyle(
//                         fontSize: 16,
//                         color: Colors.black54,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }
//
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

