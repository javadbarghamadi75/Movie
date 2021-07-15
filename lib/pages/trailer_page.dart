import 'package:flutter/material.dart';

class TrailerPage extends StatefulWidget {
  final String movieId;

  TrailerPage({required this.movieId});

  @override
  _TrailerPageState createState() => _TrailerPageState();
}

class _TrailerPageState extends State<TrailerPage> {
  @override
  void initState() {
    print('fetched movieId : ${widget.movieId}');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
