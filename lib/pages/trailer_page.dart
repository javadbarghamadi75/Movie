import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:movie/models/trailer_model.dart';
import 'package:movie/services/trailer_service.dart';
import 'package:video_player/video_player.dart';
import 'package:http/http.dart';
import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
// import 'package:html/dom.dart';
// import 'package:html/dom_parsing.dart';
// import 'package:html/parser.dart';

class TrailerPage extends StatefulWidget {
  final String movieId;
  final String movieName;

  TrailerPage({
    required this.movieId,
    required this.movieName,
  });

  @override
  _TrailerPageState createState() => _TrailerPageState();
}

class _TrailerPageState extends State<TrailerPage> {
  late var videoDir;
  late var videoFile;
  late File fileVideo;
  bool isDataRecieved = false;
  late Trailer fetchedTrailer;
  final TrailerApiService _trailerApiService = TrailerApiService();
  VideoPlayerController? _videoPlayerController;

  ///===========================================================================

  var videoBaseUrl = 'https://www.imdb.com/video/imdb/vi2959588889/imdb/embed';

  getVideoHtmlTag() async {
    await get(Uri.parse(videoBaseUrl)).then((response) {
      if (response.statusCode == 200) {
        var soup = BeautifulSoup(response.body);
        var data = soup.find('script', attrs: {'class': 'imdb-player-data'});
        var videoUrl = jsonDecode(data!.text)['videoPlayerObject']['video']
            ['videoInfoList'][1]['videoUrl'];
        print('videoUrl : ');
        print(videoUrl);
        downloadVideo(videoUrl);
      }
    });
  }

  ///===========================================================================

  ///===========================================================================

  downloadVideo(String url) async {
    Dio dio = Dio();

    try {
      var dir = await getApplicationDocumentsDirectory();
      videoFile = await dio.download(url, "${dir.path}/myFile.mp4",
          onReceiveProgress: (rec, total) {
        print("Rec: $rec , Total: $total");
        videoDir = dir.path;
      });
    } catch (e) {
      print(e);
    }
    print("Download completed");
    print('videoDir : $videoDir');
    print('videoFile : $videoFile');
    print('$videoDir/myFile.mp4');
    fileVideo = File('$videoDir/myFile.mp4');
    _getVideoFromNetwork(file: fileVideo);
  }

  ///===========================================================================
  ///
  // Future<Trailer> _getMovieTrailer(String movieId) async {
  //   var response = await _trailerApiService.fetchTrailer(movieId);

  //   print('Response status: ${response.statusCode}');

  //   if (response.statusCode == 200) {
  //     final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
  //     final Trailer trailer = Trailer.fromJson(jsonResponse);

  //     setState(() {
  //       fetchedTrailer = trailer;
  //       isDataRecieved = true;
  //       print('isDataRecieved : $isDataRecieved');
  //     });
  //     print('trailer linkEmbed : ${trailer.linkEmbed}');
  //   }
  //   return fetchedTrailer;
  // }

  Future<void> _getVideoFromNetwork({required File file}) async {
    _videoPlayerController = VideoPlayerController.file(file)
      ..addListener(() => setState(() {}))
      ..setLooping(true)
      ..initialize().then((_) => _videoPlayerController?.play());
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    print('fetched movieId : ${widget.movieId}');
    // _getMovieTrailer(widget.movieId)
    //     .then((movieTrailer) =>
    //         _getVideoFromNetwork(movieLink: movieTrailer.linkEmbed))
    //     .whenComplete(
    //         () => _getVideoFromNetwork(movieLink: fetchedTrailer.linkEmbed));
    getVideoHtmlTag();
    // _getVideoFromNetwork();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('The AppBar'),
      ),
      body: VideoPlayerWidget(
        videoPlayerController: _videoPlayerController!,
      ),
    );
  }
}

class VideoPlayerWidget extends StatelessWidget {
  final VideoPlayerController videoPlayerController;

  const VideoPlayerWidget({
    Key? key,
    required this.videoPlayerController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return videoPlayerController.value.isInitialized &&
            videoPlayerController != null
        ? Container(
            alignment: Alignment.topCenter,
            child: AspectRatio(
              aspectRatio: 16.0 / 9.0,
              child: VideoPlayer(videoPlayerController),
            ),
          )
        : Container(
            height: 200,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
  }
}
