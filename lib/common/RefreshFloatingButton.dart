// // import 'package:flutter/material.dart';
// //
// // class RefreshFloatingButton extends StatelessWidget {
// //   final bool isRefreshing;
// //   // final bool showCookieBanner;
// //   final VoidCallback onRefresh;
// //
// //   const RefreshFloatingButton({
// //     Key? key,
// //     required this.isRefreshing,
// //     required this.showCookieBanner,
// //     required this.onRefresh,
// //   }) : super(key: key);
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Positioned(
// //       bottom: showCookieBanner ? 120 : 80,
// //       right: 16,
// //       child: FloatingActionButton(
// //         onPressed: isRefreshing ? null : onRefresh,
// //         backgroundColor: Colors.white,
// //         foregroundColor: Colors.teal,
// //         child: isRefreshing
// //             ? SizedBox(
// //           width: 20,
// //           height: 20,
// //           child: CircularProgressIndicator(strokeWidth: 2),
// //         )
// //             : Icon(Icons.refresh),
// //         elevation: 4,
// //       ),
// //     );
// //   }
// // }
//
// import 'package:flutter/material.dart';
//
// class RefreshFloatingButton extends StatelessWidget {
//   final bool isRefreshing;
//   final VoidCallback onRefresh;
//
//   const RefreshFloatingButton({
//     super.key,
//     required this.isRefreshing,
//     required this.onRefresh,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Positioned(
//       bottom: 80,
//       right: 16,
//       child: FloatingActionButton(
//
//         onPressed: isRefreshing ? null : onRefresh,
//         backgroundColor: Colors.white,
//         foregroundColor: Colors.teal,
//         child: isRefreshing
//             ? SizedBox(
//           width: 18,
//           height: 18,
//           child: CircularProgressIndicator(strokeWidth: 2),
//         )
//             : Icon(Icons.refresh),
//         elevation: 4,
//       ),
//     );
//   }
// }

// Main widget with both buttons

// RefreshFloatingButton widget
import 'package:flutter/material.dart';

class RefreshFloatingButton extends StatelessWidget {
  final bool isRefreshing;
  final VoidCallback onRefresh;

  const RefreshFloatingButton({
    super.key,
    required this.isRefreshing,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: isRefreshing ? null : onRefresh,
      backgroundColor: Colors.white,
      foregroundColor: Colors.teal,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: isRefreshing
          ? SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Icon(Icons.refresh),
    );
  }
}





