import 'dart:convert';
import 'dart:io';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:movie/models/trailer_model.dart';
import 'package:movie/pages/chewie_item.dart';
import 'package:movie/services/trailer_service.dart';
import 'package:video_player/video_player.dart';
import 'package:http/http.dart';
import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
// import 'package:html/dom.dart';
// import 'package:html/dom_parsing.dart';
// import 'package:html/parser.dart';

class TrailerPageChewie extends StatefulWidget {
  final String movieId;
  final String movieName;

  TrailerPageChewie({
    required this.movieId,
    required this.movieName,
  });

  @override
  _TrailerPageChewieState createState() => _TrailerPageChewieState();
}

class _TrailerPageChewieState extends State<TrailerPageChewie> {
  late var videoDir;
  late var videoFile;
  File fileVideo = File('');
  bool isDataRecieved = false;
  late String fetchedTrailerId;
  final TrailerApiService _trailerApiService = TrailerApiService();
  VideoPlayerController? _videoPlayerController;

  ///===========================================================================

  Future<void> _getMovieTrailerId(String movieId) async {
    var response = await _trailerApiService.fetchTrailer(movieId);

    print('Response status: ${response.statusCode}');

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      final Trailer trailer = Trailer.fromJson(jsonResponse);

      setState(() {
        fetchedTrailerId = trailer.videoId;
        isDataRecieved = true;
        print('isDataRecieved : $isDataRecieved');
      });
      print('trailer linkEmbed : ${trailer.videoId}');
      print('trailer linkEmbed : ${trailer.linkEmbed}');
    }
    _getVideoHtmlTag(videoId: fetchedTrailerId);
  }

  ///===========================================================================

  _getVideoHtmlTag({required String videoId}) async {
    var videoBaseUrl = 'https://www.imdb.com/video/imdb/$videoId/imdb/embed';
    await get(Uri.parse(videoBaseUrl)).then((response) {
      if (response.statusCode == 200) {
        var soup = BeautifulSoup(response.body);
        var data = soup.find('script', attrs: {'class': 'imdb-player-data'});
        var videoUrl = jsonDecode(data!.text)['videoPlayerObject']['video']
            ['videoInfoList'][1]['videoUrl'];
        print('videoUrl : ');
        print(videoUrl);
        // _playVideo(videoUrl: videoUrl);
        _getVideoFromNetwork(videoUrl: videoUrl);
      }
    });
  }

  ///===========================================================================

  // _playVideo({required String videoUrl}) {
  //   _videoPlayerController = VideoPlayerController.network(videoUrl);
  // }

  ///===========================================================================

  ///===========================================================================

  _getVideoFromNetwork({required String videoUrl}) {
    _videoPlayerController = VideoPlayerController.network(videoUrl)
      ..addListener(() => setState(() {}))
      ..setLooping(true)
      ..initialize().then((_) => _videoPlayerController?.play());
  }

  ///===========================================================================
  // downloadVideo(String url) async {
  //   Dio dio = Dio();
  //   try {
  //     var dir = await getApplicationDocumentsDirectory();
  //     videoFile = await dio.download(url, "${dir.path}/${widget.movieName}.mp4",
  //         onReceiveProgress: (rec, total) {
  //       print("Rec: $rec , Total: $total");
  //       videoDir = dir.path;
  //     });
  //   } catch (e) {
  //     print(e);
  //   }
  //   print("Download completed");
  //   print('videoDir : $videoDir');
  //   print('videoFile : $videoFile');
  //   print('$videoDir/myFile.mp4');
  //   setState(() {
  //     fileVideo = File('$videoDir/${widget.movieName}.mp4');
  //   });
  //   // fileVideo = File('$videoDir/${widget.movieName}.mp4');
  //   _getVideoFromNetwork(file: fileVideo);
  // }

  ///===========================================================================

  // Future<VideoPlayerController> _getVideoFromNetwork(
  //     {required File file}) async {
  //   return _videoPlayerController = VideoPlayerController.file(file);
  //   // ..addListener(() => setState(() {}))
  //   // ..setLooping(true)
  //   // ..initialize().then((_) => _videoPlayerController?.play());
  // }

  ///===========================================================================

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    print('fetched movieId : ${widget.movieId}');
    _getMovieTrailerId(widget.movieId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: _videoPlayerController != null
          ? Center(
              child: Container(
                height: 250,
                width: MediaQuery.of(context).size.width,
                color: Colors.transparent,
                child: ChewieItem(
                  videoPlayerController: _videoPlayerController!,
                  looping: true,
                ),
              ),
            )
          : Center(
              child: Container(
                height: 250,
                width: MediaQuery.of(context).size.width,
                color: Colors.black,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
    );
  }
}

//000000000000000000000000000000000000000000000000000000000000000000000000000000

class ChewieItem extends StatefulWidget {
  final VideoPlayerController videoPlayerController;
  final bool looping;

  ChewieItem({
    required this.videoPlayerController,
    required this.looping,
  });

  @override
  _ChewieItemState createState() => _ChewieItemState();
}

class _ChewieItemState extends State<ChewieItem> {
  late ChewieController _chewieController;

  @override
  void initState() {
    _chewieController = ChewieController(
      videoPlayerController: widget.videoPlayerController,
      aspectRatio: 16 / 9,
      autoInitialize: true,
      allowFullScreen: true,
      showControls: true,
      showOptions: false,
      autoPlay: true,
      looping: widget.looping,
      errorBuilder: (context, errorMessage) {
        return Center(
          child: Text(
            errorMessage,
            style: TextStyle(color: Colors.white),
          ),
        );
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    widget.videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Chewie(controller: _chewieController);
  }
}
