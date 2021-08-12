// import 'dart:convert';
// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:http/http.dart';
// import 'package:movie/models/trailer_model.dart';
// import 'package:movie/services/trailer_service.dart';
// import 'package:video_player/video_player.dart';
// import 'package:http/http.dart';
// import 'package:beautiful_soup_dart/beautiful_soup.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:dio/dio.dart';
// // import 'package:html/dom.dart';
// // import 'package:html/dom_parsing.dart';
// // import 'package:html/parser.dart';

// class TrailerPage extends StatefulWidget {
//   final String movieId;
//   final String movieName;

//   TrailerPage({
//     required this.movieId,
//     required this.movieName,
//   });

//   @override
//   _TrailerPageState createState() => _TrailerPageState();
// }

// class _TrailerPageState extends State<TrailerPage> {
//   late var videoDir;
//   late var videoFile;
//   late File fileVideo;
//   bool isDataRecieved = false;
//   late String fetchedTrailerId;
//   final TrailerApiService _trailerApiService = TrailerApiService();
//   VideoPlayerController? _videoPlayerController =
//       VideoPlayerController.asset('dataSource');

//   ///===========================================================================

//   _getVideoHtmlTag({required String videoId}) async {
//     var videoBaseUrl = 'https://www.imdb.com/video/imdb/$videoId/imdb/embed';
//     await get(Uri.parse(videoBaseUrl)).then((response) {
//       if (response.statusCode == 200) {
//         var soup = BeautifulSoup(response.body);
//         var data = soup.find('script', attrs: {'class': 'imdb-player-data'});
//         var videoUrl = jsonDecode(data!.text)['videoPlayerObject']['video']
//             ['videoInfoList'][1]['videoUrl'];
//         print('videoUrl : ');
//         print(videoUrl);
//         downloadVideo(videoUrl);
//       }
//     });
//   }

//   ///===========================================================================

//   ///===========================================================================

//   downloadVideo(String url) async {
//     Dio dio = Dio();

//     try {
//       var dir = await getApplicationDocumentsDirectory();
//       videoFile = await dio.download(url, "${dir.path}/${widget.movieName}.mp4",
//           onReceiveProgress: (rec, total) {
//         print("Rec: $rec , Total: $total");
//         videoDir = dir.path;
//       });
//     } catch (e) {
//       print(e);
//     }
//     print("Download completed");
//     print('videoDir : $videoDir');
//     print('videoFile : $videoFile');
//     print('$videoDir/myFile.mp4');
//     fileVideo = File('$videoDir/${widget.movieName}.mp4');
//     _getVideoFromNetwork(file: fileVideo);
//   }

//   ///===========================================================================

//   Future<void> _getMovieTrailerId(String movieId) async {
//     var response = await _trailerApiService.fetchTrailer(movieId);

//     print('Response status: ${response.statusCode}');

//     if (response.statusCode == 200) {
//       final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
//       final Trailer trailer = Trailer.fromJson(jsonResponse);

//       setState(() {
//         fetchedTrailerId = trailer.videoId;
//         isDataRecieved = true;
//         print('isDataRecieved : $isDataRecieved');
//       });
//       print('trailer linkEmbed : ${trailer.videoId}');
//       print('trailer linkEmbed : ${trailer.linkEmbed}');
//     }
//     _getVideoHtmlTag(videoId: fetchedTrailerId);
//   }

//   Future<void> _getVideoFromNetwork({required File file}) async {
//     _videoPlayerController = VideoPlayerController.file(file)
//       ..addListener(() => setState(() {}))
//       ..setLooping(true)
//       ..initialize().then((_) => _videoPlayerController?.play());
//   }

//   @override
//   void dispose() {
//     _videoPlayerController?.dispose();
//     super.dispose();
//   }

//   @override
//   void initState() {
//     print('fetched movieId : ${widget.movieId}');
//     // _getMovieTrailer(widget.movieId)
//     //     .then((movieTrailer) =>
//     //         _getVideoFromNetwork(movieLink: movieTrailer.linkEmbed))
//     //     .whenComplete(
//     //         () => _getVideoFromNetwork(movieLink: fetchedTrailer.linkEmbed));
//     _getMovieTrailerId(widget.movieId);
//     // _getVideoHtmlTag();
//     // _getVideoFromNetwork();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // appBar: AppBar(
//       //   title: Text('The AppBar'),
//       // ),
//       backgroundColor: Colors.grey[900],
//       body: Center(
//         child: VideoPlayerWidget(
//           videoPlayerController: _videoPlayerController!,
//         ),
//       ),
//     );
//   }
// }

// class VideoPlayerWidget extends StatelessWidget {
//   final VideoPlayerController videoPlayerController;

//   const VideoPlayerWidget({
//     Key? key,
//     required this.videoPlayerController,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return videoPlayerController.value.isInitialized &&
//             videoPlayerController != null
//         ? Stack(
//             alignment: Alignment.center,
//             children: [
//               AspectRatio(
//                 aspectRatio: videoPlayerController.value.aspectRatio,
//                 child: VideoPlayer(videoPlayerController),
//               ),
//               Align(
//                 alignment: Alignment.center,
//                 child: FloatingActionButton(
//                   onPressed: () {
//                     // If the video is playing, pause it.
//                     if (videoPlayerController.value.isPlaying) {
//                       videoPlayerController.pause();
//                     } else {
//                       // If the video is paused, play it.
//                       videoPlayerController.play();
//                     }
//                   },
//                   child: Icon(
//                     videoPlayerController.value.isPlaying
//                         ? Icons.pause
//                         : Icons.play_arrow,
//                     size: 50,
//                     color: Colors.amber[900],
//                   ),
//                 ),
//               ),
//             ],
//           )
//         : Container(
//             height: 250,
//             color: Colors.red,
//             child: Center(
//               child: CircularProgressIndicator(),
//             ),
//           );
//   }
// }
