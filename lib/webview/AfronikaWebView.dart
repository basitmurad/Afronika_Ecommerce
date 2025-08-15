import 'package:afronika/webview/UrlType.dart' show UrlLauncherHelper;
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

class AfronikaBrowserApp extends StatefulWidget {
  const AfronikaBrowserApp({super.key});

  @override
  State<AfronikaBrowserApp> createState() => _AfronikaBrowserAppScreenState();
}

class _AfronikaBrowserAppScreenState extends State<AfronikaBrowserApp>
    with TickerProviderStateMixin {

  // WebView Controller
  late WebViewController webViewController;

  // State variables
  String currentUrl = "https://www.afronika.com/";
  String homeUrl = "https://www.afronika.com/";
  bool isLoading = true;
  int loadingProgress = 0;
  bool isRefreshing = false;
  bool canGoBack = false;
  bool canGoForward = false;

  // Track navigation history manually
  List<String> navigationHistory = [];
  int currentHistoryIndex = -1;

  // Animation controllers
  late AnimationController _refreshAnimationController;
  late AnimationController _logoAnimationController;

  // Animations
  late Animation<double> _refreshRotation;
  late Animation<double> _logoScale;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _initializeWebView();
    // Add home URL to history
    navigationHistory.add(homeUrl);
    currentHistoryIndex = 0;
  }

  @override
  void dispose() {
    _refreshAnimationController.dispose();
    _logoAnimationController.dispose();
    super.dispose();
  }

  void _initializeAnimations() {
    // Refresh button animation
    _refreshAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _refreshRotation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _refreshAnimationController,
      curve: Curves.easeInOut,
    ));

    // Logo animation
    _logoAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _logoScale = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _logoAnimationController,
      curve: Curves.elasticOut,
    ));
  }

  void _initializeWebView() {
    webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(_createNavigationDelegate())
      ..addJavaScriptChannel('Flutter', onMessageReceived: _handleJavaScriptMessage)
      ..loadRequest(Uri.parse(currentUrl));
  }

  NavigationDelegate _createNavigationDelegate() {
    return NavigationDelegate(
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
        _updateNavigationState();
      },
      onPageFinished: (String url) {
        setState(() {
          isLoading = false;
          isRefreshing = false;
          currentUrl = url;
        });

        // Add to navigation history if it's a new URL
        _addToNavigationHistory(url);
        _updateNavigationState();
        _injectCustomJavaScript();
      },
      onWebResourceError: (WebResourceError error) {
        setState(() {
          isRefreshing = false;
          isLoading = false;
        });
        _showErrorSnackBar('Failed to load page: ${error.description}');
      },
      onNavigationRequest: _handleNavigationRequest,
    );
  }

  // Add URL to navigation history
  void _addToNavigationHistory(String url) {
    // Don't add same URL twice in a row
    if (navigationHistory.isEmpty || navigationHistory.last != url) {
      // If we're not at the end of history, remove everything after current position
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

      print('📝 Navigation History: ${navigationHistory.length} items, current: $currentHistoryIndex');
    }
  }

  NavigationDecision _handleNavigationRequest(NavigationRequest request) {
    print('🌐 Navigation request: ${request.url}');

    // Handle external URLs
    if (_isExternalUrl(request.url)) {
      print('🔗 Intercepting external URL: ${request.url}');
      UrlLauncherHelper.launchURL(
        url: request.url,
        context: context,
        showFeedback: true,
      );
      return NavigationDecision.prevent;
    }

    // Allow navigation within the main domain
    if (_isInternalUrl(request.url)) {
      return NavigationDecision.navigate;
    }

    // Handle other external links
    print('🌍 Opening external link: ${request.url}');
    UrlLauncherHelper.launchURL(
      url: request.url,
      context: context,
      showFeedback: true,
    );
    return NavigationDecision.prevent;
  }

  bool _isExternalUrl(String url) {
    return url.startsWith('mailto:') ||
        url.startsWith('tel:') ||
        url.startsWith('sms:') ||
        url.contains('facebook.com') ||
        url.contains('fb.com') ||
        url.contains('m.facebook.com') ||
        url.contains('instagram.com') ||
        url.contains('twitter.com') ||
        url.contains('x.com') ||
        url.contains('linkedin.com') ||
        url.contains('youtube.com') ||
        url.contains('tiktok.com') ||
        url.contains('snapchat.com') ||
        url.contains('whatsapp.com');
  }

  bool _isInternalUrl(String url) {
    return url.contains('afronika.com');
  }

  void _handleJavaScriptMessage(JavaScriptMessage message) {
    try {
      print('📨 Received JS message: ${message.message}');

      final data = message.message;

      // Handle hamburger menu click
      if (data.contains('hamburger_clicked')) {
        HapticFeedback.selectionClick();
        return;
      }

      // Handle bridge ready
      if (data.contains('bridge_ready')) {
        print('✅ JavaScript bridge initialized');
        return;
      }

      // Try to parse as JSON for external links
      try {
        final Map<String, dynamic> parsedData =
        Map<String, dynamic>.from(jsonDecode(data) as Map);

        if (parsedData['type'] == 'external_link') {
          final url = parsedData['url'];
          print('🔗 Handling external link from JS: $url');

          UrlLauncherHelper.launchURL(
            url: url,
            context: context,
            showFeedback: true,
          );
        }
      } catch (jsonError) {
        // Fallback parsing for malformed JSON
        _handleFallbackParsing(data);
      }
    } catch (e) {
      print('❌ Error in JS message handler: $e');
    }
  }

  void _handleFallbackParsing(String data) {
    if (data.contains('external_link')) {
      final regex = RegExp(r'"url":"([^"]+)"');
      final match = regex.firstMatch(data);
      if (match != null) {
        final url = match.group(1);
        if (url != null) {
          print('🔗 Extracted URL from fallback: $url');
          UrlLauncherHelper.launchURL(
            url: url,
            context: context,
            showFeedback: true,
          );
        }
      }
    }
  }

  void _injectCustomJavaScript() {
    Future.delayed(const Duration(milliseconds: 300), () {
      webViewController.runJavaScript(_getInjectedJavaScript());
    });
  }

  Future<void> _updateNavigationState() async {
    try {
      final backState = await webViewController.canGoBack();
      final forwardState = await webViewController.canGoForward();

      if (mounted) {
        setState(() {
          canGoBack = backState || _canGoBackInHistory();
          canGoForward = forwardState || _canGoForwardInHistory();
        });
      }
    } catch (e) {
      print('❌ Error updating navigation state: $e');
    }
  }

  // Check if we can go back in our custom history
  bool _canGoBackInHistory() {
    return currentHistoryIndex > 0;
  }

  // Check if we can go forward in our custom history
  bool _canGoForwardInHistory() {
    return currentHistoryIndex < navigationHistory.length - 1;
  }

  // UI Actions
  void _refreshPage() {
    if (isRefreshing) return;

    setState(() {
      isRefreshing = true;
    });

    HapticFeedback.lightImpact();
    _refreshAnimationController.forward().then((_) {
      _refreshAnimationController.reset();
    });

    webViewController.reload();
  }

  Future<void> _goBack() async {
    try {
      HapticFeedback.selectionClick();

      // First try WebView's built-in back
      if (await webViewController.canGoBack()) {
        await webViewController.goBack();
        await _updateNavigationState();
        return;
      }

      // If WebView can't go back, use our custom history
      if (_canGoBackInHistory()) {
        currentHistoryIndex--;
        final previousUrl = navigationHistory[currentHistoryIndex];
        print('⬅️ Going back to: $previousUrl');
        await webViewController.loadRequest(Uri.parse(previousUrl));
        await _updateNavigationState();
      }
    } catch (e) {
      print('❌ Error going back: $e');
    }
  }

  Future<void> _goForward() async {
    try {
      HapticFeedback.selectionClick();

      // First try WebView's built-in forward
      if (await webViewController.canGoForward()) {
        await webViewController.goForward();
        await _updateNavigationState();
        return;
      }

      // If WebView can't go forward, use our custom history
      if (_canGoForwardInHistory()) {
        currentHistoryIndex++;
        final nextUrl = navigationHistory[currentHistoryIndex];
        print('➡️ Going forward to: $nextUrl');
        await webViewController.loadRequest(Uri.parse(nextUrl));
        await _updateNavigationState();
      }
    } catch (e) {
      print('❌ Error going forward: $e');
    }
  }

  void _goHome() {
    HapticFeedback.mediumImpact();
    _logoAnimationController.forward().then((_) {
      _logoAnimationController.reverse();
    });
    webViewController.loadRequest(Uri.parse(homeUrl));
  }

  // FIXED: Better back navigation with custom history
  Future<bool> _onWillPop() async {
    try {
      // Check if we can go back (WebView or custom history)
      if (await webViewController.canGoBack() || _canGoBackInHistory()) {
        await _goBack();
        return false; // Don't exit the app
      } else {
        // If we can't go back anywhere, show exit dialog
        return await _showExitDialog() ?? false;
      }
    } catch (e) {
      print('❌ Error in _onWillPop: $e');
      return await _showExitDialog() ?? false;
    }
  }

  Future<bool?> _showExitDialog() {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Row(
          children: [
            Icon(Icons.exit_to_app, color: Colors.red),
            SizedBox(width: 8),
            Text('Exit App'),
          ],
        ),
        content: const Text('Do you want to exit the Afronika app?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Exit'),
          ),
        ],
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 4),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        action: SnackBarAction(
          label: 'Retry',
          textColor: Colors.white,
          onPressed: _refreshPage,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            // Add navigation bar at the top
            _buildNavigationBar(),
            // WebView takes the rest
            Expanded(child: _buildBody()),
          ],
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 58.0),
          child: _buildFloatingActionButton(),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      ),
    );
  }

  Widget _buildNavigationBar() {
    return Container(
      height: 30,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: SafeArea(
        child: Row(
          children: [
            // Back button
            IconButton(
              onPressed: canGoBack ? _goBack : null,
              icon: Icon(
                Icons.arrow_back_ios,
                color: canGoBack ? Colors.teal : Colors.grey[400],
                size: 20,
              ),
            ),
            // Forward button
            IconButton(
              onPressed: canGoForward ? _goForward : null,
              icon: Icon(
                Icons.arrow_forward_ios,
                color: canGoForward ? Colors.teal : Colors.grey[400],
                size: 20,
              ),
            ),
            // URL display
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Icon(Icons.public, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _getDisplayUrl(currentUrl),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[700],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Home button
            IconButton(
              onPressed: _goHome,
              icon: const Icon(Icons.home, color: Colors.teal, size: 24),
            ),
            // Options menu
            IconButton(
              onPressed: _showOptionsMenu,
              icon: const Icon(Icons.more_vert, color: Colors.teal, size: 24),
            ),
          ],
        ),
      ),
    );
  }

  String _getDisplayUrl(String url) {
    // Clean up URL for display
    String displayUrl = url;
    if (displayUrl.startsWith('https://')) {
      displayUrl = displayUrl.substring(8);
    } else if (displayUrl.startsWith('http://')) {
      displayUrl = displayUrl.substring(7);
    }
    if (displayUrl.startsWith('www.')) {
      displayUrl = displayUrl.substring(4);
    }
    return displayUrl;
  }

  Widget _buildBody() {
    return Container(
      color: Colors.white,
      child: Stack(
        children: [
          // Main WebView
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

          // Loading overlay for initial load
          if (isLoading && loadingProgress < 30)
            Container(
              color: Colors.white,
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Colors.teal),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Loading Afronika...',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return AnimatedBuilder(
      animation: _refreshRotation,
      builder: (context, child) {
        return FloatingActionButton(
          onPressed: isRefreshing ? null : _refreshPage,
          backgroundColor: Colors.white,
          foregroundColor: Colors.teal,
          elevation: 6,
          child: Transform.rotate(
            angle: _refreshRotation.value * 2 * 3.14159,
            child: Icon(
              isRefreshing ? Icons.hourglass_empty : Icons.refresh,
              size: 28,
            ),
          ),
        );
      },
    );
  }

  void _showOptionsMenu() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.home, color: Colors.teal),
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context);
                _goHome();
              },
            ),
            ListTile(
              leading: const Icon(Icons.refresh, color: Colors.teal),
              title: const Text('Refresh'),
              onTap: () {
                Navigator.pop(context);
                _refreshPage();
              },
            ),
            ListTile(
              leading: const Icon(Icons.share, color: Colors.teal),
              title: const Text('Share'),
              onTap: () {
                Navigator.pop(context);
                _shareCurrentPage();
              },
            ),
            ListTile(
              leading: const Icon(Icons.copy, color: Colors.teal),
              title: const Text('Copy URL'),
              onTap: () {
                Navigator.pop(context);
                UrlLauncherHelper.copyToClipboard(currentUrl, context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.history, color: Colors.teal),
              title: const Text('History'),
              subtitle: Text('${navigationHistory.length} pages visited'),
              onTap: () {
                Navigator.pop(context);
                _showHistoryDialog();
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _showHistoryDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Navigation History'),
        content: SizedBox(
          width: double.maxFinite,
          height: 300,
          child: ListView.builder(
            itemCount: navigationHistory.length,
            itemBuilder: (context, index) {
              final url = navigationHistory[index];
              final isCurrent = index == currentHistoryIndex;
              return ListTile(
                leading: Icon(
                  isCurrent ? Icons.location_on : Icons.history,
                  color: isCurrent ? Colors.teal : Colors.grey,
                  size: 20,
                ),
                title: Text(
                  _getDisplayUrl(url),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                    color: isCurrent ? Colors.teal : Colors.black87,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  currentHistoryIndex = index;
                  webViewController.loadRequest(Uri.parse(url));
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _shareCurrentPage() {
    UrlLauncherHelper.copyToClipboard(currentUrl, context);
  }

  String _getInjectedJavaScript() {
    return '''
      (function() {
          'use strict';

          let bridgeInitialized = false;

          function createCustomLogo() {
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
                              const customLogo = createCustomLogo();
                              if (el.tagName === 'IMG') {
                                  el.outerHTML = customLogo;
                              } else {
                                  el.innerHTML = customLogo;
                                  el.style.display = 'block';
                              }
                          }
                      });
                  } catch(e) {
                      console.log('Error replacing logo:', e);
                  }
              });

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
              try {
                  document.body.style.backgroundColor = 'white';
                  document.documentElement.style.backgroundColor = 'white';
                  const containers = document.querySelectorAll('header, .header, .app-bar, .top-bar, nav');
                  containers.forEach(container => {
                      if (container) {
                          container.style.backgroundColor = 'white';
                      }
                  });
              } catch(e) {}
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
          }

          function handleExternalLinks() {
              try {
                  document.removeEventListener('click', globalClickHandler);
                  document.addEventListener('click', globalClickHandler, true);
              } catch(e) {
                  console.log('Error handling external links:', e);
              }
          }

          function globalClickHandler(e) {
              try {
                  let target = e.target;
                  while (target && target.tagName !== 'A') {
                      target = target.parentElement;
                  }

                  if (target && target.tagName === 'A') {
                      const href = target.getAttribute('href');
                      if (href) {
                          if (href.includes('facebook.com') || href.includes('fb.com') || 
                              href.includes('instagram.com') || href.includes('twitter.com') ||
                              href.includes('linkedin.com') || href.includes('youtube.com') ||
                              href.includes('tiktok.com') || href.startsWith('mailto:') || 
                              href.startsWith('tel:')) {
                              
                              e.preventDefault();
                              e.stopPropagation();

                              const messageData = {
                                  type: 'external_link',
                                  url: href
                              };

                              try {
                                  window.postMessage(JSON.stringify(messageData), '*');
                                  if (window.Flutter && window.Flutter.postMessage) {
                                      window.Flutter.postMessage(JSON.stringify(messageData));
                                  }
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

              replaceLogos();
              changeBackgroundColor();
              repositionChatIcon();
              handleExternalLinks();

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

              setTimeout(() => {
                  replaceLogos();
                  repositionChatIcon();
                  handleExternalLinks();
              }, 300);

              setTimeout(() => {
                  try {
                      window.postMessage(JSON.stringify({type: 'bridge_ready'}), '*');
                  } catch(e) {}
              }, 300);
          }

          if (document.readyState === 'loading') {
              document.addEventListener('DOMContentLoaded', initializeBridge);
          } else {
              setTimeout(initializeBridge, 50);
          }
      })();
    ''';
  }
}