import 'dart:convert';
import 'package:lottie/lottie.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:movie/models/popular_movies_model.dart';
import 'package:movie/pages/trailer_page.dart';
import 'package:movie/pages/trailer_page_chewie.dart';
import 'package:movie/services/popular_movies_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:movie/sheets/sort_modal_bottom_sheet.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:sliver_tools/sliver_tools.dart';
// import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

class NewHomePageCopy6 extends StatefulWidget {
  final String title;

  const NewHomePageCopy6({Key? key, required this.title}) : super(key: key);

  @override
  _NewHomePageCopy6State createState() => _NewHomePageCopy6State();
}

class _NewHomePageCopy6State extends State<NewHomePageCopy6>
    with TickerProviderStateMixin {
  Widget appBarTitle = Text(
    "MOVIE",
    style: TextStyle(
      color: Colors.amber[900],
      fontWeight: FontWeight.w900,
    ),
  );
  Icon icon = Icon(
    Icons.search_rounded,
    color: Colors.white60, //white60
    size: 24,
  );
  int _sliversId = 1;
  int _suffixesId = 1;
  bool isDataRecieved = false;
  List<Item> items = <Item>[];
  // List<Item> searchedItems = <Item>[];
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String selectedSortModeButtonText = 'Default Ascending';
  final PopularMoviesApiService _popularMoviesApiService =
      PopularMoviesApiService();

  final globalKey = GlobalKey<ScaffoldState>();
  late bool _isSearching;
  String _searchText = "";
  List searchResult = [];

  _NewHomePageCopy6State() {
    _textController.addListener(() {
      if (_textController.text.isEmpty) {
        setState(() {
          _isSearching = false;
          _searchText = "";
        });
      } else {
        setState(() {
          _isSearching = true;
          _searchText = _textController.text;
        });
      }
    });
  }

  Future<void> getPopularMovies() async {
    Response response = await _popularMoviesApiService.fetchMovies();
    //     .then((response) {
    //   if (response.statusCode == 200) {
    //     final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
    //     final PopularMovies popularMoviesList =
    //         PopularMovies.fromJson(jsonResponse);
    //     // results.addAll(popularMoviesList.results);
    //     setState(() {
    //       items.addAll(popularMoviesList.items);
    //       // items.sort((a, b) => a.title.compareTo(b.title));
    //       isDataRecieved = true;
    //     });
    //     print('results length : ${items.length}');
    //   }
    //   throw 'isDataRecieved = $isDataRecieved';
    //   // return response;
    // });

    print('Response status: ${response.statusCode}');

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      final PopularMovies popularMoviesList =
          PopularMovies.fromJson(jsonResponse);
      // results.addAll(popularMoviesList.results);
      setState(() {
        items.addAll(popularMoviesList.items);
        // items.sort((a, b) => a.title.compareTo(b.title));
        // sortFetchedPopularMovies(mode: 'Default Ascending');
        isDataRecieved = true;
        print('isDataRecieved : $isDataRecieved');
      });
      print('results length : ${items.length}');
    }
    // return response;
  }

  void sortFetchedPopularMovies({required String mode}) {
    mode == 'Title Ascending'
        ? setState(() {
            searchResult.length == 0
                ? items.sort((a, b) => a.title.compareTo(b.title))
                : searchResult.sort((a, b) => a.title.compareTo(b.title));
          })
        : mode == 'Title Descending'
            ? setState(() {
                searchResult.length == 0
                    ? items.sort((a, b) => b.title.compareTo(a.title))
                    : searchResult.sort((a, b) => b.title.compareTo(a.title));
              })
            : mode == 'Rate Ascending'
                ? setState(() {
                    searchResult.length == 0
                        ? items.sort(
                            (a, b) => a.imDbRating.compareTo(b.imDbRating))
                        : searchResult.sort(
                            (a, b) => a.imDbRating.compareTo(b.imDbRating));
                  })
                : mode == 'Rate Descending'
                    ? setState(() {
                        searchResult.length == 0
                            ? items.sort(
                                (a, b) => b.imDbRating.compareTo(a.imDbRating))
                            : searchResult.sort(
                                (a, b) => b.imDbRating.compareTo(a.imDbRating));
                      })
                    : mode == 'Year Ascending'
                        ? setState(() {
                            searchResult.length == 0
                                ? items.sort((a, b) => a.year.compareTo(b.year))
                                : searchResult
                                    .sort((a, b) => a.year.compareTo(b.year));
                          })
                        : mode == 'Year Descending'
                            ? setState(() {
                                searchResult.length == 0
                                    ? items.sort(
                                        (a, b) => b.year.compareTo(a.year))
                                    : searchResult.sort(
                                        (a, b) => b.year.compareTo(a.year));
                              })
                            : mode == 'Default Descending'
                                ? setState(() {
                                    searchResult.length == 0
                                        ? items.sort(
                                            (a, b) => b.rank.compareTo(a.rank))
                                        : searchResult.sort(
                                            (a, b) => b.rank.compareTo(a.rank));
                                  })
                                : mode == 'Default Ascending'
                                    ? setState(() {
                                        searchResult.length == 0
                                            ? items.sort((a, b) =>
                                                a.rank.compareTo(b.rank))
                                            : searchResult.sort((a, b) =>
                                                a.rank.compareTo(b.rank));
                                      })
                                    : setState(() {
                                        searchResult.length == 0
                                            ? items.sort((a, b) =>
                                                a.rank.compareTo(b.rank))
                                            : searchResult.sort((a, b) =>
                                                a.rank.compareTo(b.rank));
                                      });
  }

  Widget _renderSlivers() {
    return _sliversId == 1 ? _sliverList() : _sliverGrid();
  }

  Widget _renderSearchSlivers() {
    return _sliversId == 1 ? _sliverSearchList() : _sliverSearchGrid();
  }

  void _updateSlivers() {
    setState(() {
      _sliversId = _sliversId == 1 ? 2 : 1;
    });
  }

  Widget _renderSuffiexs() {
    return _suffixesId == 1
        ? GestureDetector(
            onTap: () {
              print('search button tapped!');
              print('${_textController.text}');
              setState(() {
                _updateSuffiexs();
                _handleSearchStart();
              });
            },
            child: Icon(
              Icons.search_rounded,
              color: Colors.white60,
              size: 22,
            ),
          )
        : GestureDetector(
            onTap: () {
              print('close button tapped!');
              _updateSuffiexs();
              _handleSearchEnd();
              // setState(() {
              //   _textController.clear();
              //   _suffixesId = 1;
              // });
            },
            child: Icon(
              Icons.close,
              color: Colors.white60,
              size: 22,
            ),
          );
  }

  void _handleSearchStart() {
    setState(() {
      _isSearching = true;
    });
  }

  void _handleSearchEnd() {
    setState(() {
      this.icon = Icon(
        Icons.search_rounded,
        color: Colors.white60,
        size: 24,
      );
      this.appBarTitle = Text(
        "MOVIE",
        style: TextStyle(
          color: Colors.amber[900],
          fontWeight: FontWeight.w900,
        ),
      );
      _isSearching = false;
      searchResult.length = 0;
      sortFetchedPopularMovies(mode: '$selectedSortModeButtonText');
      _textController.clear();
    });
  }

  void searchOperation(String searchText) {
    searchResult.clear();
    if (_isSearching != null) {
      for (int i = 0; i < items.length; i++) {
        var data = items[i];
        if (data.title.toLowerCase().contains(searchText.toLowerCase())) {
          searchResult.add(data);
        }
      }
    }
  }

  void _updateSuffiexs() {
    _textController.text.isEmpty || _textController.text == ''
        ? setState(() {
            _suffixesId = 1;
          })
        : setState(() {
            _suffixesId = 2;
          });
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    getPopularMovies().then((value) {
      print('initState `then` popularMovies got!');
      print('initState `then` completed!');
    }).whenComplete(() {
      print('initState `whenComplete` popularMovies got!');
      print('initState sort');
      return sortFetchedPopularMovies(mode: 'Default Ascending');
    });
    print('isDataRecieved : $isDataRecieved');
    // getPopularMovies().whenComplete(() {
    //   print('initState sort');
    //   return sortFetchedPopularMovies(mode: 'Default Ascending');
    // });
    _isSearching = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //this sets the navigation bar color to green
    return Scaffold(
      key: globalKey,
      extendBody: false,
      // appBar: AppBar(
      //   brightness: Brightness.dark,
      //   elevation: 0,
      //   backgroundColor: Colors.grey[900], //amber
      //   toolbarHeight: AppBar().preferredSize.height,
      //   centerTitle: true,
      //   title: Card(
      //     shape: ContinuousRectangleBorder(
      //       borderRadius: BorderRadius.circular(32),
      //     ),
      //     elevation: 0,
      //     color: Colors.grey[850],
      //     margin: EdgeInsets.symmetric(
      //       horizontal: 10,
      //       vertical: 0,
      //     ),
      //     child: TextField(
      //       maxLines: 1,
      //       style: TextStyle(
      //         fontSize: 16,
      //         fontWeight: FontWeight.bold,
      //         textBaseline: TextBaseline.alphabetic,
      //         color: Colors.white70,
      //       ),
      //       textAlignVertical: TextAlignVertical.center,
      //       keyboardType: TextInputType.text,
      //       decoration: InputDecoration(
      //         border: InputBorder.none,
      //         // contentPadding: EdgeInsets.symmetric(horizontal: 15),
      //         hintText: 'Search',
      //         hintStyle: TextStyle(
      //           fontSize: 16,
      //           fontWeight: FontWeight.bold,
      //           textBaseline: TextBaseline.alphabetic,
      //           color: Colors.white70,
      //         ),
      //         isDense: true, // Added this
      //         contentPadding: EdgeInsets.symmetric(
      //           horizontal: 15,
      //           // vertical: 12,
      //         ),
      //         suffixIcon: Icon(
      //           Icons.search_rounded,
      //           color: Colors.white60,
      //           size: 22,
      //         ),
      //       ),
      //     ),
      //   ),
      // ),
      backgroundColor: Colors.grey[900], //grey[50]
      // extendBodyBehindAppBar: true,
      body: CustomScrollView(
        controller: _scrollController,
        shrinkWrap: true,
        slivers: [
          // SliverAppBar(
          //   snap: true,
          //   // pinned: true,
          //   floating: true,
          //   toolbarHeight: AppBar().preferredSize.height + 20,
          //   brightness: Brightness.dark,
          //   elevation: 0,
          //   backgroundColor: Colors.grey[900], //amber
          //   // toolbarHeight: AppBar().preferredSize.height,
          //   collapsedHeight: AppBar().preferredSize.height + 20,
          //   // expandedHeight: AppBar().preferredSize.height + 10,
          //   centerTitle: true,
          //   title: Text(
          //     'Movie',
          //     style: TextStyle(
          //       fontSize: 28,
          //       fontWeight: FontWeight.w900,
          //       color: Colors.amber[900],
          //     ),
          //   ),
          //   actions: [
          //     Padding(
          //       padding: const EdgeInsets.symmetric(horizontal: 38),
          //       child: Icon(
          //         Icons.search_rounded,
          //         color: Colors.white60,
          //         size: 22,
          //       ),
          //     ),
          //   ],
          //   bottom: PreferredSize(
          //     preferredSize: AppBar().preferredSize,
          //     child: Padding(
          //       padding: const EdgeInsets.only(bottom: 15),
          //       child: Container(
          //         color: Colors.grey[900],
          //         child: Padding(
          //           padding: EdgeInsets.symmetric(horizontal: 25),
          //           child: Row(
          //             mainAxisSize: MainAxisSize.max,
          //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //             crossAxisAlignment: CrossAxisAlignment.center,
          //             children: [
          //               Padding(
          //                 padding: EdgeInsets.only(left: 10),
          //                 child: Row(
          //                   mainAxisSize: MainAxisSize.max,
          //                   mainAxisAlignment: MainAxisAlignment.start,
          //                   crossAxisAlignment: CrossAxisAlignment.center,
          //                   children: [
          //                     AutoSizeText(
          //                       'Popular Movies',
          //                       minFontSize: 16,
          //                       maxFontSize: 20,
          //                       style: TextStyle(
          //                         fontWeight: FontWeight.w900,
          //                         // fontSize: 20,
          //                         color: Colors.white,
          //                       ),
          //                     ),
          //                     SizedBox(width: 10),
          //                     Chip(
          //                       label: AutoSizeText(
          //                         'Top ${items.length}',
          //                         minFontSize: 14,
          //                         maxFontSize: 16,
          //                         textAlign: TextAlign.center,
          //                         style: TextStyle(
          //                           // fontSize: 14,
          //                           fontWeight: FontWeight.w900,
          //                           color: Colors.black,
          //                         ),
          //                       ),
          //                       backgroundColor: Colors.amber[900],
          //                       labelPadding: EdgeInsets.symmetric(
          //                         horizontal: 5,
          //                         vertical: 0,
          //                       ),
          //                       shape: ContinuousRectangleBorder(
          //                         borderRadius: BorderRadius.circular(20),
          //                       ),
          //                       // padding: EdgeInsets.zero,
          //                       visualDensity: VisualDensity.compact,
          //                     ),
          //                   ],
          //                 ),
          //               ),
          //               FloatingActionButton(
          //                 heroTag: 'changeUI',
          //                 mini: true,
          //                 tooltip: 'View Mode',
          //                 elevation: 0,
          //                 highlightElevation: 0,
          //                 child: _sliversId == 1
          //                     ? Icon(
          //                         Icons.photo_rounded,
          //                         color: Colors.grey[600],
          //                         size: 28,
          //                       )
          //                     : Icon(
          //                         Icons.art_track_rounded,
          //                         color: Colors.grey[600],
          //                         size: 28,
          //                       ),
          //                 backgroundColor: Colors.transparent,
          //                 onPressed: () {
          //                   _updateSlivers();
          //                 },
          //               ),
          //             ],
          //           ),
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
          buildAppBar(context),
          // SliverAppBar(
          //   snap: true,
          //   // pinned: true,
          //   floating: true,
          //   toolbarHeight: AppBar().preferredSize.height + 20,
          //   brightness: Brightness.dark,
          //   elevation: 0,
          //   backgroundColor: Colors.grey[900], //amber
          //   // toolbarHeight: AppBar().preferredSize.height,
          //   collapsedHeight: AppBar().preferredSize.height + 20,
          //   // expandedHeight: AppBar().preferredSize.height + 10,
          //   centerTitle: true,
          //   title: Card(
          //     shape: ContinuousRectangleBorder(
          //       borderRadius: BorderRadius.circular(32),
          //     ),
          //     elevation: 0,
          //     color: Colors.grey[850],
          //     margin: EdgeInsets.symmetric(
          //       horizontal: 10,
          //       vertical: 0,
          //     ),
          //     child: TextField(
          //       controller: _textController,
          //       maxLines: 1,
          //       style: TextStyle(
          //         fontSize: 16,
          //         fontWeight: FontWeight.bold,
          //         textBaseline: TextBaseline.alphabetic,
          //         color: Colors.white70,
          //       ),
          //       textAlignVertical: TextAlignVertical.center,
          //       keyboardType: TextInputType.text,
          //       decoration: InputDecoration(
          //         border: InputBorder.none,
          //         // contentPadding: EdgeInsets.symmetric(horizontal: 15),
          //         hintText: 'Search',
          //         hintStyle: TextStyle(
          //           fontSize: 16,
          //           fontWeight: FontWeight.bold,
          //           textBaseline: TextBaseline.alphabetic,
          //           color: Colors.white70,
          //         ),
          //         isDense: true, // Added this
          //         contentPadding: EdgeInsets.symmetric(
          //           horizontal: 15,
          //           // vertical: 12,
          //         ),
          //         suffixIcon: _renderSuffiexs(),
          //       ),
          //       onChanged: (value) {
          //         _updateSuffiexs();
          //         searchOperation(_textController.text);
          //       },
          //     ),
          //   ),
          //   bottom: PreferredSize(
          //     preferredSize: AppBar().preferredSize,
          //     child: Padding(
          //       padding: const EdgeInsets.only(bottom: 15),
          //       child: Container(
          //         color: Colors.grey[900],
          //         child: Padding(
          //           padding: EdgeInsets.symmetric(horizontal: 25),
          //           child: Row(
          //             mainAxisSize: MainAxisSize.max,
          //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //             crossAxisAlignment: CrossAxisAlignment.center,
          //             children: [
          //               Padding(
          //                 padding: EdgeInsets.only(left: 10),
          //                 child: Row(
          //                   mainAxisSize: MainAxisSize.max,
          //                   mainAxisAlignment: MainAxisAlignment.start,
          //                   crossAxisAlignment: CrossAxisAlignment.center,
          //                   children: [
          //                     AutoSizeText(
          //                       'Popular Movies',
          //                       minFontSize: 16,
          //                       maxFontSize: 20,
          //                       style: TextStyle(
          //                         fontWeight: FontWeight.w900,
          //                         // fontSize: 20,
          //                         color: Colors.white,
          //                       ),
          //                     ),
          //                     SizedBox(width: 10),
          //                     Chip(
          //                       label: AutoSizeText(
          //                         'Top ${items.length}',
          //                         minFontSize: 14,
          //                         maxFontSize: 16,
          //                         textAlign: TextAlign.center,
          //                         style: TextStyle(
          //                           // fontSize: 14,
          //                           fontWeight: FontWeight.w900,
          //                           color: Colors.black,
          //                         ),
          //                       ),
          //                       backgroundColor: Colors.amber[900],
          //                       labelPadding: EdgeInsets.symmetric(
          //                         horizontal: 5,
          //                         vertical: 0,
          //                       ),
          //                       shape: ContinuousRectangleBorder(
          //                         borderRadius: BorderRadius.circular(20),
          //                       ),
          //                       // padding: EdgeInsets.zero,
          //                       visualDensity: VisualDensity.compact,
          //                     ),
          //                   ],
          //                 ),
          //               ),
          //               FloatingActionButton(
          //                 heroTag: 'changeUI',
          //                 mini: true,
          //                 tooltip: 'View Mode',
          //                 elevation: 0,
          //                 highlightElevation: 0,
          //                 child: _sliversId == 1
          //                     ? Icon(
          //                         Icons.photo_rounded,
          //                         color: Colors.grey[600],
          //                         size: 28,
          //                       )
          //                     : Icon(
          //                         Icons.art_track_rounded,
          //                         color: Colors.grey[600],
          //                         size: 28,
          //                       ),
          //                 backgroundColor: Colors.transparent,
          //                 onPressed: () {
          //                   _updateSlivers();
          //                 },
          //               ),
          //             ],
          //           ),
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
          // ListView.builder(
          //   // padding: EdgeInsets.symmetric(vertical: 0),
          //   // controller: _scrollController,
          //   // physics: BouncingScrollPhysics(),
          //   // shrinkWrap: false,
          //   itemCount: 1 + items.length,
          //   itemBuilder: (BuildContext context, int index) {
          //     print('index : $index');
          //     if (isDataRecieved == false) {
          //       return Center(
          //         child: Padding(
          //           padding: EdgeInsets.only(top: 100.0),
          //           child: CircularProgressIndicator(),
          //         ),
          //       );
          //     }
          //     if (index == 0) {
          //       return Padding(
          //         padding: EdgeInsets.symmetric(
          //           horizontal: 30,
          //           vertical: 15,
          //         ),
          //         child: Column(
          //           mainAxisSize: MainAxisSize.max,
          //           mainAxisAlignment: MainAxisAlignment.start,
          //           crossAxisAlignment: CrossAxisAlignment.start,
          //           children: [
          //             Column(
          //               mainAxisAlignment: MainAxisAlignment.center,
          //               crossAxisAlignment: CrossAxisAlignment.center,
          //               mainAxisSize: MainAxisSize.max,
          //               children: [
          //                 // SizedBox(height: 100),
          //                 items.length == 0
          //                     ? Center(
          //                         child: Lottie.asset(
          //                           'assets/animations/empty_list.json',
          //                           repeat: true,
          //                           reverse: true,
          //                           animate: true,
          //                           frameRate: FrameRate(1000),
          //                           fit: BoxFit.cover,
          //                         ),
          //                       )
          //                     : Row(
          //                         mainAxisSize: MainAxisSize.max,
          //                         mainAxisAlignment:
          //                             MainAxisAlignment.spaceBetween,
          //                         crossAxisAlignment: CrossAxisAlignment.center,
          //                         children: [
          //                           Row(
          //                             mainAxisSize: MainAxisSize.max,
          //                             mainAxisAlignment:
          //                                 MainAxisAlignment.start,
          //                             crossAxisAlignment:
          //                                 CrossAxisAlignment.center,
          //                             children: [
          //                               AutoSizeText(
          //                                 'Popular Movies',
          //                                 minFontSize: 12,
          //                                 maxFontSize: 20,
          //                                 style: TextStyle(
          //                                   fontWeight: FontWeight.w900,
          //                                   // fontSize: 20,
          //                                   color: Colors.white,
          //                                 ),
          //                               ),
          //                               SizedBox(width: 10),
          //                               Chip(
          //                                 label: AutoSizeText(
          //                                   'Top ${items.length}',
          //                                   minFontSize: 8,
          //                                   maxFontSize: 14,
          //                                   textAlign: TextAlign.center,
          //                                   style: TextStyle(
          //                                     // fontSize: 14,
          //                                     fontWeight: FontWeight.w900,
          //                                     color: Colors.black,
          //                                   ),
          //                                 ),
          //                                 backgroundColor: Colors.amber[900],
          //                                 labelPadding: EdgeInsets.symmetric(
          //                                   horizontal: 5,
          //                                   vertical: 0,
          //                                 ),
          //                                 shape: ContinuousRectangleBorder(
          //                                   borderRadius:
          //                                       BorderRadius.circular(20),
          //                                 ),
          //                                 // padding: EdgeInsets.zero,
          //                                 visualDensity: VisualDensity.compact,
          //                               ),
          //                             ],
          //                           ),
          //                           FloatingActionButton(
          //                             mini: true,
          //                             tooltip: 'View Mode',
          //                             elevation: 0,
          //                             highlightElevation: 0,
          //                             child: Icon(
          //                               Icons.grid_view,
          //                               color: Colors.grey[600],
          //                               size: 28,
          //                             ),
          //                             backgroundColor: Colors.transparent,
          //                             onPressed: () {},
          //                           ),
          //                         ],
          //                       ),
          //               ],
          //             )
          //           ],
          //         ),
          //       );
          //     }
          //     return _searchListView(index);
          //   },
          // ),
          // SliverPersistentHeader(
          //   pinned: true,
          //   floating: true,
          //   delegate: PersistentHeader(
          //     widget: Row(
          //       mainAxisSize: MainAxisSize.max,
          //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //       crossAxisAlignment: CrossAxisAlignment.center,
          //       children: [
          //         Row(
          //           mainAxisSize: MainAxisSize.max,
          //           mainAxisAlignment: MainAxisAlignment.start,
          //           crossAxisAlignment: CrossAxisAlignment.center,
          //           children: [
          //             AutoSizeText(
          //               'Popular Movies',
          //               minFontSize: 12,
          //               maxFontSize: 20,
          //               style: TextStyle(
          //                 fontWeight: FontWeight.w900,
          //                 // fontSize: 20,
          //                 color: Colors.white,
          //               ),
          //             ),
          //             SizedBox(width: 10),
          //             Chip(
          //               label: AutoSizeText(
          //                 'Top ${items.length}',
          //                 minFontSize: 8,
          //                 maxFontSize: 14,
          //                 textAlign: TextAlign.center,
          //                 style: TextStyle(
          //                   // fontSize: 14,
          //                   fontWeight: FontWeight.w900,
          //                   color: Colors.black,
          //                 ),
          //               ),
          //               backgroundColor: Colors.amber[900],
          //               labelPadding: EdgeInsets.symmetric(
          //                 horizontal: 5,
          //                 vertical: 0,
          //               ),
          //               shape: ContinuousRectangleBorder(
          //                 borderRadius: BorderRadius.circular(20),
          //               ),
          //               // padding: EdgeInsets.zero,
          //               visualDensity: VisualDensity.compact,
          //             ),
          //           ],
          //         ),
          //         FloatingActionButton(
          //           mini: true,
          //           tooltip: 'View Mode',
          //           elevation: 0,
          //           highlightElevation: 0,
          //           child: Icon(
          //             Icons.grid_view,
          //             color: Colors.grey[600],
          //             size: 28,
          //           ),
          //           backgroundColor: Colors.transparent,
          //           onPressed: () {},
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
          // _sliverList(),
          // SliverList(
          searchResult.length != 0 || _textController.text.isNotEmpty
              ? SliverAnimatedSwitcher(
                  duration: Duration(milliseconds: 300),
                  child: _renderSearchSlivers(),
                )
              : SliverAnimatedSwitcher(
                  duration: Duration(milliseconds: 300),
                  child: _renderSlivers(),
                ),
          //   delegate: SliverChildBuilderDelegate(
          //     (context, index) {
          //       print('index : $index');
          //       if (isDataRecieved == false) {
          //         return Center(
          //           child: Padding(
          //             padding: EdgeInsets.only(top: 100.0),
          //             child: CircularProgressIndicator(),
          //           ),
          //         );
          //       }
          //       // if (index == 0) {
          //       //   return Padding(
          //       //     padding: EdgeInsets.symmetric(
          //       //       horizontal: 30,
          //       //       vertical: 15,
          //       //     ),
          //       //     child: Column(
          //       //       mainAxisSize: MainAxisSize.max,
          //       //       mainAxisAlignment: MainAxisAlignment.start,
          //       //       crossAxisAlignment: CrossAxisAlignment.start,
          //       //       children: [
          //       //         Column(
          //       //           mainAxisAlignment: MainAxisAlignment.center,
          //       //           crossAxisAlignment: CrossAxisAlignment.center,
          //       //           mainAxisSize: MainAxisSize.max,
          //       //           children: [
          //       //             // SizedBox(height: 100),
          //       //             items.length == 0
          //       //                 ? Center(
          //       //                     child: Lottie.asset(
          //       //                       'assets/animations/empty_list.json',
          //       //                       repeat: true,
          //       //                       reverse: true,
          //       //                       animate: true,
          //       //                       frameRate: FrameRate(1000),
          //       //                       fit: BoxFit.cover,
          //       //                     ),
          //       //                   )
          //       //                 : Container(
          //       //                     height: 0,
          //       //                     width: 0,
          //       //                   ),
          //       //             // Row(
          //       //             //     mainAxisSize: MainAxisSize.max,
          //       //             //     mainAxisAlignment:
          //       //             //         MainAxisAlignment.spaceBetween,
          //       //             //     crossAxisAlignment: CrossAxisAlignment.center,
          //       //             //     children: [
          //       //             //       Row(
          //       //             //         mainAxisSize: MainAxisSize.max,
          //       //             //         mainAxisAlignment:
          //       //             //             MainAxisAlignment.start,
          //       //             //         crossAxisAlignment:
          //       //             //             CrossAxisAlignment.center,
          //       //             //         children: [
          //       //             //           AutoSizeText(
          //       //             //             'Popular Movies',
          //       //             //             minFontSize: 12,
          //       //             //             maxFontSize: 20,
          //       //             //             style: TextStyle(
          //       //             //               fontWeight: FontWeight.w900,
          //       //             //               // fontSize: 20,
          //       //             //               color: Colors.white,
          //       //             //             ),
          //       //             //           ),
          //       //             //           SizedBox(width: 10),
          //       //             //           Chip(
          //       //             //             label: AutoSizeText(
          //       //             //               'Top ${items.length}',
          //       //             //               minFontSize: 8,
          //       //             //               maxFontSize: 14,
          //       //             //               textAlign: TextAlign.center,
          //       //             //               style: TextStyle(
          //       //             //                 // fontSize: 14,
          //       //             //                 fontWeight: FontWeight.w900,
          //       //             //                 color: Colors.black,
          //       //             //               ),
          //       //             //             ),
          //       //             //             backgroundColor: Colors.amber[900],
          //       //             //             labelPadding: EdgeInsets.symmetric(
          //       //             //               horizontal: 5,
          //       //             //               vertical: 0,
          //       //             //             ),
          //       //             //             shape: ContinuousRectangleBorder(
          //       //             //               borderRadius:
          //       //             //                   BorderRadius.circular(20),
          //       //             //             ),
          //       //             //             // padding: EdgeInsets.zero,
          //       //             //             visualDensity: VisualDensity.compact,
          //       //             //           ),
          //       //             //         ],
          //       //             //       ),
          //       //             //       FloatingActionButton(
          //       //             //         mini: true,
          //       //             //         tooltip: 'View Mode',
          //       //             //         elevation: 0,
          //       //             //         highlightElevation: 0,
          //       //             //         child: Icon(
          //       //             //           Icons.grid_view,
          //       //             //           color: Colors.grey[600],
          //       //             //           size: 28,
          //       //             //         ),
          //       //             //         backgroundColor: Colors.transparent,
          //       //             //         onPressed: () {},
          //       //             //       ),
          //       //             //     ],
          //       //             //   ),
          //       //           ],
          //       //         )
          //       //       ],
          //       //     ),
          //       //   );
          //       // }
          //       return _searchListView(index);
          //     },
          //     childCount: items.length,
          //   ),
          // ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'goToTop',
        tooltip: 'Go to Top',
        elevation: 0,
        // label: Text('Label'),
        child: Icon(
          Icons.keyboard_arrow_up_rounded,
          size: 28,
        ),
        backgroundColor: Colors.amber[900],
        onPressed: () {
          setState(() {
            _scrollController.animateTo(
              0.0,
              curve: Curves.easeInQuart,
              duration: Duration(milliseconds: 1000),
            );
          });
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: BottomAppBar(
        // shape: CircularNotchedRectangle(),
        // notchMargin: 25,
        color: Colors.grey[900],
        // elevation: 0,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 13,
            vertical: 5,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              OutlinedButton.icon(
                label: AutoSizeText(
                  '$selectedSortModeButtonText',
                  minFontSize: 12,
                  maxFontSize: 14,
                  style: TextStyle(
                    // fontSize: 14,
                    fontWeight: FontWeight.w900,
                    color: Colors.amber[900],
                  ),
                ),
                icon: Icon(
                  Icons.sort_rounded,
                  color: Colors.amber[900],
                ),
                style: OutlinedButton.styleFrom(
                  // backgroundColor: Colors.amber[900],
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  side: BorderSide(
                    color: Colors.amber[900]!,
                  ),
                  shape: StadiumBorder(),
                  // shape: ContinuousRectangleBorder(
                  //   borderRadius: BorderRadius.circular(20),
                  // ),
                ),
                onPressed: () {
                  showModalBottomSheet<String>(
                    context: context,
                    builder: (builder) => SortModesBottomSheet(),
                    backgroundColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(25),
                      ),
                    ),
                    // shape: ContinuousRectangleBorder(
                    //   borderRadius:
                    //       BorderRadius.all(Radius.circular(25)),
                    // ),
                    // elevation: 50,
                    isScrollControlled: true,
                    transitionAnimationController: AnimationController(
                      vsync: this,
                      duration: Duration(milliseconds: 1000),
                      reverseDuration: Duration(milliseconds: 500),
                    ),
                    // elevation: 5,
                  ).then((selectedSortOption) {
                    print('selectedSortOption home : $selectedSortOption');
                    selectedSortOption == null
                        ? sortFetchedPopularMovies(mode: 'Default Ascending')
                        : sortFetchedPopularMovies(mode: selectedSortOption);
                    setState(() {
                      selectedSortModeButtonText = selectedSortOption!;
                    });
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildAppBar(BuildContext context) {
    return SliverAppBar(
      snap: true,
      // pinned: true,
      floating: true,
      titleSpacing: 0,
      toolbarHeight: AppBar().preferredSize.height + 20,
      brightness: Brightness.dark,
      elevation: 0,
      backgroundColor: Colors.grey[900], //amber
      // toolbarHeight: AppBar().preferredSize.height,
      collapsedHeight: AppBar().preferredSize.height + 20,
      // expandedHeight: AppBar().preferredSize.height + 10,
      centerTitle: true,
      title: appBarTitle,
      actions: [
        SizedBox(
          width: 25,
        ),
        Padding(
          padding: EdgeInsets.only(right: 25),
          child: FloatingActionButton(
            child: icon,
            mini: true,
            tooltip: 'Search for a Movie',
            backgroundColor: Colors.transparent,
            splashColor: Colors.transparent,
            highlightElevation: 0,
            elevation: 0,
            onPressed: () {
              setState(() {
                if (this.icon.icon == Icons.search_rounded) {
                  this.icon = Icon(
                    Icons.close_rounded,
                    color: Colors.white60,
                  );
                  this.appBarTitle = Padding(
                    padding: const EdgeInsets.only(left: 25),
                    child: Card(
                      shape: ContinuousRectangleBorder(
                        borderRadius: BorderRadius.circular(32),
                      ),
                      elevation: 0,
                      color: Colors.grey[850],
                      margin: EdgeInsets.zero,
                      child: TextField(
                        autofocus: true,
                        controller: _textController,
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          textBaseline: TextBaseline.alphabetic,
                          color: Colors.white70,
                        ),
                        // textAlignVertical: TextAlignVertical.center,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          //   //   // contentPadding: EdgeInsets.symmetric(horizontal: 15),
                          hintText: 'Search..',
                          hintStyle: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            textBaseline: TextBaseline.alphabetic,
                            color: Colors.white54,
                          ),
                          //   //   isDense: false, // Added this
                          contentPadding: EdgeInsets.symmetric(horizontal: 15),
                          //   //   // suffixIcon: _renderSuffiexs(),
                        ),
                        onChanged: (value) {
                          // _updateSuffiexs();
                          searchOperation(_textController.text);
                          sortFetchedPopularMovies(
                              mode: '$selectedSortModeButtonText');
                        },
                      ),
                    ),
                  );
                  _handleSearchStart();
                } else {
                  _handleSearchEnd();
                }
              });
            },
          ),
        )
      ],
      bottom: PreferredSize(
        preferredSize: AppBar().preferredSize,
        child: Padding(
          padding: EdgeInsets.only(bottom: 15),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 25),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _isSearching == false
                          ? AutoSizeText(
                              'Popular Movies',
                              minFontSize: 16,
                              maxFontSize: 20,
                              maxLines: 2,
                              style: TextStyle(
                                fontWeight: FontWeight.w900,
                                // fontSize: 20,
                                color: Colors.white,
                              ),
                            )
                          : AutoSizeText(
                              _textController.text == "" ||
                                      _textController.text.isEmpty
                                  ? 'Popular Movies'
                                  : searchResult.length == 1
                                      ? 'result'
                                      : 'resutls',
                              minFontSize: 16,
                              maxFontSize: 20,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontWeight: FontWeight.w900,
                                // fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                      SizedBox(width: 10),
                      _isSearching == false
                          ? Chip(
                              label: AutoSizeText(
                                'Top ${items.length}',
                                minFontSize: 14,
                                maxFontSize: 16,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  // fontSize: 14,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.black,
                                ),
                              ),
                              backgroundColor: Colors.amber[900],
                              labelPadding: EdgeInsets.symmetric(
                                horizontal: 5,
                                vertical: 0,
                              ),
                              shape: ContinuousRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              // padding: EdgeInsets.zero,
                              visualDensity: VisualDensity.compact,
                            )
                          : Chip(
                              label: AutoSizeText(
                                _textController.text == "" ||
                                        _textController.text.isEmpty
                                    ? 'Top ${items.length}'
                                    : '${searchResult.length}',
                                minFontSize: 14,
                                maxFontSize: 16,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  // fontSize: 14,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.black,
                                ),
                              ),
                              backgroundColor: Colors.amber[900],
                              labelPadding: EdgeInsets.symmetric(
                                horizontal: 5,
                                vertical: 0,
                              ),
                              shape: ContinuousRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              // padding: EdgeInsets.zero,
                              visualDensity: VisualDensity.compact,
                            ),
                    ],
                  ),
                ),
                FloatingActionButton(
                  heroTag: 'changeUI',
                  mini: true,
                  tooltip: 'View Mode',
                  elevation: 0,
                  highlightElevation: 0,
                  child: _sliversId == 1
                      ? Icon(
                          Icons.photo_rounded,
                          color: Colors.grey[600],
                          size: 28,
                        )
                      : Icon(
                          Icons.art_track_rounded,
                          color: Colors.grey[600],
                          size: 28,
                        ),
                  backgroundColor: Colors.transparent,
                  onPressed: () {
                    _updateSlivers();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _sliverList() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          print('index : $index');
          if (isDataRecieved == false) {
            return Center(
              child: Padding(
                padding: EdgeInsets.only(top: 100.0),
                child: CircularProgressIndicator(),
              ),
            );
          }
          return _sliverListView(index);
        },
        childCount: items.length,
      ),
    );
  }

  Widget _sliverGrid() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          print('index : $index');
          if (isDataRecieved == false) {
            return Center(
              child: Padding(
                padding: EdgeInsets.only(top: 100.0),
                child: CircularProgressIndicator(),
              ),
            );
          }
          return _sliverGridView(index);
        },
        childCount: items.length,
      ),
    );
  }

  Widget _sliverListView(int index) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 25,
        // vertical: 10,
      ),
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
                child: CachedNetworkImage(
                  alignment: Alignment.center,
                  placeholder: (context, url) => Container(
                    color: Colors.grey.withOpacity(0.3),
                    padding: EdgeInsets.zero,
                    child: Icon(
                      Icons.local_movies_rounded,
                      size: 80,
                      color: Colors.grey,
                    ),
                  ),
                  imageUrl: items[index].image,
                  // items[index - 1].image,
                  fit: BoxFit.cover,
                  filterQuality: FilterQuality.high, //was high
                  height: MediaQuery.of(context).size.height * 0.2, // 150
                  width: MediaQuery.of(context).size.height * 0.13, // 109
                ),
              ),
              Flexible(
                child: InkWell(
                  key: Key('listViewInkWell'),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                  onTap: () {
                    print('${items[index].id}');
                    // Navigator.of(context).push(
                    //   MaterialPageRoute(
                    //     builder: (_) => TrailerPage(),
                    //   ),
                    // );
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => TrailerPageChewie(
                          movieId: items[index].id.toString(),
                          movieName: items[index].title,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                    ),
                    // padding: EdgeInsets.only(left: 5),
                    height:
                        MediaQuery.of(context).size.height * 0.2 - 20, // 130
                    width: MediaQuery.of(context).size.width,
                    child: ListTile(
                      // contentPadding: EdgeInsets.symmetric(
                      //   horizontal: 16.0,
                      //   vertical: 8,
                      // ),
                      // focusColor: Colors.transparent,
                      // hoverColor: Colors.transparent,
                      // tileColor: Colors.transparent,
                      title: Padding(
                        padding: EdgeInsets.only(top: 16),
                        child: AutoSizeText(
                          items[index].title,
                          maxLines: 2,
                          minFontSize: 12,
                          maxFontSize: 16,
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            // fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                      ),
                      subtitle: Padding(
                        padding: EdgeInsets.only(top: 16),
                        child: AutoSizeText(
                          items[index].year,
                          maxLines: 1,
                          minFontSize: 12,
                          maxFontSize: 16,
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            // fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white38,
                          ),
                        ),
                      ),
                      trailing: Column(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          items[index].imDbRating == ''
                              ? Icon(
                                  Icons.grade_rounded,
                                  color: Colors.amber[900],
                                )
                              : Icon(
                                  Icons.grade_rounded,
                                  color: Colors.amber[900],
                                ),
                          SizedBox(height: 5),
                          items[index].imDbRating == ''
                              ? Text(
                                  'N/A',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                  ),
                                )
                              : Text(
                                  items[index].imDbRating,
                                  style: TextStyle(
                                    color: Colors.white70,
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Divider(
            indent: 125,
            endIndent: 125,
            color: Colors.grey[400],
            // height: 10,
            // thickness: 1,
          ),
        ],
      ),
    );
  }

  Widget _sliverGridView(int index) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 25,
        // vertical: 10,
      ),
      child: Column(
        children: [
          InkWell(
            key: Key('gridViewInkWell'),
            onTap: () {
              print('${items[index].id}');
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => TrailerPageChewie(
                    movieId: items[index].id.toString(),
                    movieName: items[index].title,
                  ),
                ),
              );
            },
            child: Stack(
              alignment: AlignmentDirectional.bottomCenter,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                  child: CachedNetworkImage(
                    alignment: Alignment.center,
                    placeholder: (context, url) => Container(
                      color: Colors.grey.withOpacity(0.3),
                      padding: EdgeInsets.zero,
                      child: Icon(
                        Icons.local_movies_rounded,
                        size: 80,
                        color: Colors.grey,
                      ),
                    ),
                    imageUrl: items[index].image,
                    // items[index - 1].image,
                    fit: BoxFit.cover,
                    filterQuality: FilterQuality.high, //was high
                    height: MediaQuery.of(context).size.height * 0.7, // 150
                    width: MediaQuery.of(context).size.height * 0.5, // 109
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                  child: Container(
                    color: Colors.black.withOpacity(0.9),
                    height: 100,
                    width: double.infinity,
                    child: ListTile(
                      // contentPadding: EdgeInsets.symmetric(
                      //   horizontal: 16.0,
                      //   vertical: 8,
                      // ),
                      // focusColor: Colors.transparent,
                      // hoverColor: Colors.transparent,
                      // tileColor: Colors.transparent,
                      title: Padding(
                        padding: EdgeInsets.only(top: 16),
                        child: AutoSizeText(
                          items[index].title,
                          maxLines: 2,
                          minFontSize: 12,
                          maxFontSize: 16,
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            // fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: AutoSizeText(
                          items[index].year,
                          maxLines: 1,
                          minFontSize: 12,
                          maxFontSize: 16,
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            // fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white38,
                          ),
                        ),
                      ),
                      trailing: Column(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          items[index].imDbRating == ''
                              ? Icon(
                                  Icons.grade_rounded,
                                  color: Colors.amber[900],
                                )
                              : Icon(
                                  Icons.grade_rounded,
                                  color: Colors.amber[900],
                                ),
                          SizedBox(height: 5),
                          items[index].imDbRating == ''
                              ? Text(
                                  'N/A',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                  ),
                                )
                              : Text(
                                  items[index].imDbRating,
                                  style: TextStyle(
                                    color: Colors.white70,
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
          Divider(
            indent: 125,
            endIndent: 125,
            color: Colors.grey[400],
            // height: 10,
            // thickness: 1,
          ),
        ],
      ),
    );
  }

  Widget _sliverSearchList() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          // Item listData = searchResult[index];
          return _sliverSearchListView(index);
        },
        childCount: searchResult.length,
      ),
    );
  }

  Widget _sliverSearchGrid() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          // Item listData = searchResult[index];
          return _sliverSearchGridView(index);
        },
        childCount: searchResult.length,
      ),
    );
  }

  Widget _sliverSearchListView(int index) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 25,
        // vertical: 10,
      ),
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
                child: CachedNetworkImage(
                  alignment: Alignment.center,
                  placeholder: (context, url) => Container(
                    color: Colors.grey.withOpacity(0.3),
                    padding: EdgeInsets.zero,
                    child: Icon(
                      Icons.local_movies_rounded,
                      size: 80,
                      color: Colors.grey,
                    ),
                  ),
                  imageUrl: searchResult[index].image,
                  // items[index - 1].image,
                  fit: BoxFit.cover,
                  filterQuality: FilterQuality.high, //was high
                  height: MediaQuery.of(context).size.height * 0.2, // 150
                  width: MediaQuery.of(context).size.height * 0.13, // 109
                ),
              ),
              Flexible(
                child: InkWell(
                  key: Key('listViewInkWell'),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                  onTap: () {
                    print('${searchResult[index].id}');
                    // Navigator.of(context).push(
                    //   MaterialPageRoute(
                    //     builder: (_) => TrailerPage(),
                    //   ),
                    // );
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => TrailerPageChewie(
                          movieId: searchResult[index].id.toString(),
                          movieName: searchResult[index].title,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                    ),
                    // padding: EdgeInsets.only(left: 5),
                    height:
                        MediaQuery.of(context).size.height * 0.2 - 20, // 130
                    width: MediaQuery.of(context).size.width,
                    child: ListTile(
                      // contentPadding: EdgeInsets.symmetric(
                      //   horizontal: 16.0,
                      //   vertical: 8,
                      // ),
                      // focusColor: Colors.transparent,
                      // hoverColor: Colors.transparent,
                      // tileColor: Colors.transparent,
                      title: Padding(
                        padding: EdgeInsets.only(top: 16),
                        child: AutoSizeText(
                          searchResult[index].title,
                          maxLines: 2,
                          minFontSize: 12,
                          maxFontSize: 16,
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            // fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                      ),
                      subtitle: Padding(
                        padding: EdgeInsets.only(top: 16),
                        child: AutoSizeText(
                          searchResult[index].year,
                          maxLines: 1,
                          minFontSize: 12,
                          maxFontSize: 16,
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            // fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white38,
                          ),
                        ),
                      ),
                      trailing: Column(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          searchResult[index].imDbRating == ''
                              ? Icon(
                                  Icons.grade_rounded,
                                  color: Colors.amber[900],
                                )
                              : Icon(
                                  Icons.grade_rounded,
                                  color: Colors.amber[900],
                                ),
                          SizedBox(height: 5),
                          searchResult[index].imDbRating == ''
                              ? Text(
                                  'N/A',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                  ),
                                )
                              : Text(
                                  searchResult[index].imDbRating,
                                  style: TextStyle(
                                    color: Colors.white70,
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Divider(
            indent: 125,
            endIndent: 125,
            color: Colors.grey[400],
            // height: 10,
            // thickness: 1,
          ),
        ],
      ),
    );
  }

  Widget _sliverSearchGridView(int index) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 25,
        // vertical: 10,
      ),
      child: Column(
        children: [
          InkWell(
            key: Key('gridViewInkWell'),
            onTap: () {
              print('${searchResult[index].id}');
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => TrailerPageChewie(
                    movieId: searchResult[index].id.toString(),
                    movieName: searchResult[index].title,
                  ),
                ),
              );
            },
            child: Stack(
              alignment: AlignmentDirectional.bottomCenter,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                  child: CachedNetworkImage(
                    alignment: Alignment.center,
                    placeholder: (context, url) => Container(
                      color: Colors.grey.withOpacity(0.3),
                      padding: EdgeInsets.zero,
                      child: Icon(
                        Icons.local_movies_rounded,
                        size: 80,
                        color: Colors.grey,
                      ),
                    ),
                    imageUrl: searchResult[index].image,
                    // items[index - 1].image,
                    fit: BoxFit.cover,
                    filterQuality: FilterQuality.high, //was high
                    height: MediaQuery.of(context).size.height * 0.7, // 150
                    width: MediaQuery.of(context).size.height * 0.5, // 109
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                  child: Container(
                    color: Colors.black.withOpacity(0.9),
                    height: 100,
                    width: double.infinity,
                    child: ListTile(
                      // contentPadding: EdgeInsets.symmetric(
                      //   horizontal: 16.0,
                      //   vertical: 8,
                      // ),
                      // focusColor: Colors.transparent,
                      // hoverColor: Colors.transparent,
                      // tileColor: Colors.transparent,
                      title: Padding(
                        padding: EdgeInsets.only(top: 16),
                        child: AutoSizeText(
                          searchResult[index].title,
                          maxLines: 2,
                          minFontSize: 12,
                          maxFontSize: 16,
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            // fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: AutoSizeText(
                          searchResult[index].year,
                          maxLines: 1,
                          minFontSize: 12,
                          maxFontSize: 16,
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            // fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white38,
                          ),
                        ),
                      ),
                      trailing: Column(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          searchResult[index].imDbRating == ''
                              ? Icon(
                                  Icons.grade_rounded,
                                  color: Colors.amber[900],
                                )
                              : Icon(
                                  Icons.grade_rounded,
                                  color: Colors.amber[900],
                                ),
                          SizedBox(height: 5),
                          searchResult[index].imDbRating == ''
                              ? Text(
                                  'N/A',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                  ),
                                )
                              : Text(
                                  searchResult[index].imDbRating,
                                  style: TextStyle(
                                    color: Colors.white70,
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
          Divider(
            indent: 125,
            endIndent: 125,
            color: Colors.grey[400],
            // height: 10,
            // thickness: 1,
          ),
        ],
      ),
    );
  }
}
