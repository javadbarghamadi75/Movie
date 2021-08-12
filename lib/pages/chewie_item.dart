// import 'package:flutter/material.dart';
// import 'package:chewie/chewie.dart';
// import 'package:movie/pages/trailer_page.dart';
// import 'package:video_player/video_player.dart';

// class ChewieItem extends StatefulWidget {
//   final VideoPlayerController videoPlayerController;
//   final bool looping;

//   ChewieItem({
//     required this.videoPlayerController,
//     required this.looping,
//   });

//   @override
//   _ChewieItemState createState() => _ChewieItemState();
// }

// class _ChewieItemState extends State<ChewieItem> {
//   late ChewieController _chewieController;

//   _initializeChewieController() {
//     return _chewieController = ChewieController(
//         videoPlayerController: widget.videoPlayerController,
//         aspectRatio: 16/9,
//         autoInitialize: true,
//         looping: widget.looping,
//         errorBuilder: (context, errorMessage) {
//           return Center(
//             child: Text(
//               errorMessage,
//               style: TextStyle(color: Colors.white),
//             ),
//           );
//         });
//   }

//   @override
//   void initState() {
//     _initializeChewieController();
//     super.initState();
//   }

//   @override
//   void dispose() {
//     widget.videoPlayerController.dispose();
//     _chewieController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Chewie(controller: _chewieController),
//     );
//   }
// }
