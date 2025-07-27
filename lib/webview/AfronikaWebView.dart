// import 'package:flutter/material.dart';
// import 'package:webview_flutter/webview_flutter.dart';
// import 'package:flutter/services.dart';
// import 'dart:math' as math;
//
// import 'DottedCircularProgressIndicator.dart';
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
//   bool showProgressIndicator = true;
//
//   // JavaScript code to hide logo and modify app bar
//   String get injectedJavaScript => '''
//     (function() {
//         'use strict';
//
//         let bridgeInitialized = false;
//
//         function hideLogo() {
//             // Hide the logo image
//             const logoSelectors = [
//                 '[data-zs-logo]',
//                 '[data-zs-logo-container]',
//                 '.theme-logo-parent',
//                 '.theme-branding-info',
//                 '[data-zs-branding]'
//             ];
//
//             logoSelectors.forEach(selector => {
//                 try {
//                     const elements = document.querySelectorAll(selector);
//                     elements.forEach(el => {
//                         if (el) {
//                             el.style.display = 'none';
//                         }
//                     });
//                 } catch(e) {}
//             });
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
//         function initializeBridge() {
//             if (bridgeInitialized) return;
//             bridgeInitialized = true;
//
//             // Hide logo and change background
//             hideLogo();
//             changeBackgroundColor();
//
//             // Setup observer for dynamic content
//             const observer = new MutationObserver(() => {
//                 hideLogo();
//                 changeBackgroundColor();
//             });
//
//             observer.observe(document.body, {
//                 childList: true,
//                 subtree: true
//             });
//
//             // Repeat hiding after delays to catch dynamically loaded content
//             setTimeout(hideLogo, 1000);
//             setTimeout(hideLogo, 2000);
//             setTimeout(changeBackgroundColor, 1000);
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
//               showProgressIndicator = true; // Show progress when new page starts
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
//
//             // Hide progress indicator after a delay when page is loaded
//             Future.delayed(Duration(milliseconds: 2000), () {
//               if (mounted) {
//                 setState(() {
//                   showProgressIndicator = false;
//                 });
//               }
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
//   // Handle back button press
//   Future<bool> _onWillPop() async {
//     try {
//       // Check if WebView can go back
//       final canGoBack = await webViewController.canGoBack();
//       if (canGoBack) {
//         // Go back in WebView
//         await webViewController.goBack();
//         return false; // Don't exit the app
//       } else {
//         // Show exit confirmation dialog
//         return await _showExitDialog() ?? false;
//       }
//     } catch (e) {
//       // If there's an error, show exit dialog
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
//         body: Stack(
//           children: [
//             Padding(
//               padding: const EdgeInsets.only(top: 32.0),
//               child: WebViewWidget(controller: webViewController),
//             ),
//             if (isLoading || showProgressIndicator)
//               Container(
//                 color: Colors.black.withOpacity(0.3), // Dimmed overlay
//                 child: Center(
//                   child: Container(
//                     width: 120,
//                     height: 120,
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(20),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.2),
//                           blurRadius: 15,
//                           spreadRadius: 3,
//                         ),
//                       ],
//                     ),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         CircularBarProgressIndicator(
//                           size: 60,
//                           strokeWidth: 6,
//                           progress: loadingProgress / 100.0,
//                         ),
//                         SizedBox(height: 8),
//                         Text(
//                           '${loadingProgress}%',
//                           style: TextStyle(
//                             fontSize: 12,
//                             fontWeight: FontWeight.w500,
//                             color: Colors.black54,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//


import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;

import 'DottedCircularProgressIndicator.dart';

class AfronikaBrowserApp extends StatefulWidget {
  @override
  _AfronikaBrowserAppState createState() => _AfronikaBrowserAppState();
}

class _AfronikaBrowserAppState extends State<AfronikaBrowserApp> {
  late WebViewController webViewController;
  String currentUrl = "https://www.afronika.com/";
  bool isLoading = true;
  int loadingProgress = 0;
  bool showProgressIndicator = true;

  // JavaScript code to hide logo, modify app bar, and reposition chat icon
  String get injectedJavaScript => '''
    (function() {
        'use strict';
        
        let bridgeInitialized = false;
        
        function hideLogo() {
            // Hide the logo image
            const logoSelectors = [
                '[data-zs-logo]',
                '[data-zs-logo-container]',
                '.theme-logo-parent',
                '.theme-branding-info',
                '[data-zs-branding]'
            ];
            
            logoSelectors.forEach(selector => {
                try {
                    const elements = document.querySelectorAll(selector);
                    elements.forEach(el => {
                        if (el) {
                            el.style.display = 'none';
                        }
                    });
                } catch(e) {}
            });
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
            
            // Hide logo and change background
            hideLogo();
            changeBackgroundColor();
            repositionChatIcon();
            
            // Setup observer for dynamic content
            const observer = new MutationObserver(() => {
                hideLogo();
                changeBackgroundColor();
                repositionChatIcon();
            });
            
            observer.observe(document.body, {
                childList: true,
                subtree: true
            });
            
            // Repeat operations after delays to catch dynamically loaded content
            setTimeout(() => {
                hideLogo();
                repositionChatIcon();
            }, 1000);
            setTimeout(() => {
                hideLogo();
                repositionChatIcon();
            }, 2000);
            setTimeout(() => {
                changeBackgroundColor();
                repositionChatIcon();
            }, 1000);
            setTimeout(repositionChatIcon, 3000);
            
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
              showProgressIndicator = true; // Show progress when new page starts
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

            // Hide progress indicator after a delay when page is loaded
            Future.delayed(Duration(milliseconds: 2000), () {
              if (mounted) {
                setState(() {
                  showProgressIndicator = false;
                });
              }
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

  // Handle back button press
  Future<bool> _onWillPop() async {
    try {
      // Check if WebView can go back
      final canGoBack = await webViewController.canGoBack();
      if (canGoBack) {
        // Go back in WebView
        await webViewController.goBack();
        return false; // Don't exit the app
      } else {
        // Show exit confirmation dialog
        return await _showExitDialog() ?? false;
      }
    } catch (e) {
      // If there's an error, show exit dialog
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
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 32.0),
              child: WebViewWidget(controller: webViewController),
            ),
            if (isLoading || showProgressIndicator)
              Container(
                color: Colors.black.withOpacity(0.3), // Dimmed overlay
                child: Center(
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 15,
                          spreadRadius: 3,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularBarProgressIndicator(
                          size: 60,
                          primaryColor: Colors.yellow.shade600,
                          secondaryColor: Colors.teal.shade600,
                          backgroundColor: Colors.grey.shade300,
                          strokeWidth: 6,
                          progress: loadingProgress / 100.0,
                          showGradient: true,
                        ),
                        SizedBox(height: 8),
                        Text(
                          '${loadingProgress}%',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// Custom Dotted Circular Progress Indicator
class DottedCircularProgressIndicator extends StatefulWidget {
  final double size;
  final Color dotColor;
  final Color backgroundColor;
  final double strokeWidth;
  final int numberOfDots;
  final double? progress; // null for infinite animation, 0.0-1.0 for progress
  final Duration animationDuration;

  const DottedCircularProgressIndicator({
    Key? key,
    this.size = 60.0,
    this.dotColor = Colors.blue,
    this.backgroundColor = Colors.grey,
    this.strokeWidth = 4.0,
    this.numberOfDots = 12,
    this.progress,
    this.animationDuration = const Duration(milliseconds: 1200),
  }) : super(key: key);

  @override
  _DottedCircularProgressIndicatorState createState() =>
      _DottedCircularProgressIndicatorState();
}

class _DottedCircularProgressIndicatorState
    extends State<DottedCircularProgressIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.linear),
    );

    if (widget.progress == null) {
      _animationController.repeat();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return CustomPaint(
            painter: DottedCircularProgressPainter(
              animationValue: widget.progress ?? _animation.value,
              dotColor: widget.dotColor,
              backgroundColor: widget.backgroundColor,
              strokeWidth: widget.strokeWidth,
              numberOfDots: widget.numberOfDots,
              isIndeterminate: widget.progress == null,
            ),
          );
        },
      ),
    );
  }
}

class DottedCircularProgressPainter extends CustomPainter {
  final double animationValue;
  final Color dotColor;
  final Color backgroundColor;
  final double strokeWidth;
  final int numberOfDots;
  final bool isIndeterminate;

  DottedCircularProgressPainter({
    required this.animationValue,
    required this.dotColor,
    required this.backgroundColor,
    required this.strokeWidth,
    required this.numberOfDots,
    required this.isIndeterminate,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;
    final dotRadius = strokeWidth / 2;

    for (int i = 0; i < numberOfDots; i++) {
      final angle = (2 * math.pi * i) / numberOfDots;
      final dotCenter = Offset(
        center.dx + radius * math.cos(angle),
        center.dy + radius * math.sin(angle),
      );

      Color currentColor;

      if (isIndeterminate) {
        // Infinite animation - create a wave effect
        final progress = (animationValue + (i / numberOfDots)) % 1.0;
        final opacity = (math.sin(progress * 2 * math.pi) + 1) / 2;
        currentColor = Color.lerp(backgroundColor, dotColor, opacity)!;
      } else {
        // Progress-based animation
        final dotProgress = i / numberOfDots;
        if (dotProgress <= animationValue) {
          currentColor = dotColor;
        } else {
          currentColor = backgroundColor;
        }
      }

      final paint = Paint()
        ..color = currentColor
        ..style = PaintingStyle.fill;

      canvas.drawCircle(dotCenter, dotRadius, paint);
    }
  }

  @override
  bool shouldRepaint(DottedCircularProgressPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue ||
        oldDelegate.dotColor != dotColor ||
        oldDelegate.backgroundColor != backgroundColor;
  }
}