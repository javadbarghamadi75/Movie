import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:movie/models/trailer_model.dart';
import 'package:movie/services/trailer_service.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';

class TrailerPage extends StatefulWidget {
  final String movieId;

  TrailerPage({required this.movieId});

  @override
  _TrailerPageState createState() => _TrailerPageState();
}

class _TrailerPageState extends State<TrailerPage> {
  bool isDataRecieved = false;
  // late Trailer fetchedTrailer;
  final TrailerApiService _trailerApiService = TrailerApiService();
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;

  Future<void> getMovieTrailer(String movieId) async {
    Response response = await _trailerApiService.fetchTrailer(movieId);

    print('Response status: ${response.statusCode}');

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      final Trailer trailer = Trailer.fromJson(jsonResponse);

      setState(() {
        initializePlayer(trailer);
        // fetchedTrailer = trailer;
        // _videoPlayerController =
        //     VideoPlayerController.network(trailer.linkEmbed);
        isDataRecieved = true;
        print('isDataRecieved : $isDataRecieved');
      });
      print('trailer linkEmbed : ${trailer.linkEmbed}');
    }
  }

  Future<void> initializePlayer(Trailer fetchedTrailer) async {
    _videoPlayerController = VideoPlayerController.network(
      fetchedTrailer.linkEmbed,
      formatHint: VideoFormat.hls,
    );
    await Future.wait([_videoPlayerController.initialize()]);
    _createChewieController();
    setState(() {});
  }

  void _createChewieController() {
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: true,
      looping: true,
    );
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    print('fetched movieId : ${widget.movieId}');
    getMovieTrailer(widget.movieId);
    // initializePlayer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('The AppBar'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: _chewieController != null &&
                      _chewieController!
                          .videoPlayerController.value.isInitialized
                  ? Chewie(
                      controller: _chewieController!,
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        CircularProgressIndicator(),
                        SizedBox(height: 20),
                        Text('Loading'),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
