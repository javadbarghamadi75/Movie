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

class NewHomePageCopy6 extends StatefulWidget {
  final String title;

  const NewHomePageCopy6({Key? key, required this.title}) : super(key: key);

  @override
  _NewHomePageCopy6State createState() => _NewHomePageCopy6State();
}

class _NewHomePageCopy6State extends State<NewHomePageCopy6>
    with TickerProviderStateMixin {
  int _widgetId = 1;
  bool isDataRecieved = false;
  List<Item> items = <Item>[];
  List<Item> searchedItems = <Item>[];
  final globalKey = new GlobalKey<ScaffoldState>();
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String selectedSortModeButtonText = 'Default Ascending';
  final PopularMoviesApiService _popularMoviesApiService =
      PopularMoviesApiService();

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
            items.sort((a, b) => a.title.compareTo(b.title));
          })
        : mode == 'Title Descending'
            ? setState(() {
                items.sort((a, b) => b.title.compareTo(a.title));
              })
            : mode == 'Rate Ascending'
                ? setState(() {
                    items.sort((a, b) => a.imDbRating.compareTo(b.imDbRating));
                  })
                : mode == 'Rate Descending'
                    ? setState(() {
                        items.sort(
                            (a, b) => b.imDbRating.compareTo(a.imDbRating));
                      })
                    : mode == 'Year Ascending'
                        ? setState(() {
                            items.sort((a, b) => a.year.compareTo(b.year));
                          })
                        : mode == 'Year Descending'
                            ? setState(() {
                                items.sort((a, b) => b.year.compareTo(a.year));
                              })
                            : mode == 'Default Descending'
                                ? setState(() {
                                    items.sort(
                                        (a, b) => b.rank.compareTo(a.rank));
                                  })
                                : mode == 'Default Ascending'
                                    ? setState(() {
                                        items.sort(
                                            (a, b) => a.rank.compareTo(b.rank));
                                      })
                                    : setState(() {
                                        items.sort(
                                            (a, b) => a.rank.compareTo(b.rank));
                                      });
  }

  Widget _renderWidget() {
    return _widgetId == 1 ? _sliverList() : _sliverGrid();
  }

  void _updateWidget() {
    setState(() {
      _widgetId = _widgetId == 1 ? 2 : 1;
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //this sets the navigation bar color to green
    return Scaffold(
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
          SliverAppBar(
            // pinned: true,
            floating: true,
            brightness: Brightness.dark,
            elevation: 0,
            backgroundColor: Colors.grey[900], //amber
            // toolbarHeight: AppBar().preferredSize.height,
            collapsedHeight: AppBar().preferredSize.height + 10,
            expandedHeight: AppBar().preferredSize.height + 10,
            centerTitle: true,
            title: Card(
              shape: ContinuousRectangleBorder(
                borderRadius: BorderRadius.circular(32),
              ),
              elevation: 0,
              color: Colors.grey[850],
              margin: EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 0,
              ),
              child: TextField(
                maxLines: 1,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  textBaseline: TextBaseline.alphabetic,
                  color: Colors.white70,
                ),
                textAlignVertical: TextAlignVertical.center,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  // contentPadding: EdgeInsets.symmetric(horizontal: 15),
                  hintText: 'Search',
                  hintStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    textBaseline: TextBaseline.alphabetic,
                    color: Colors.white70,
                  ),
                  isDense: true, // Added this
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 15,
                    // vertical: 12,
                  ),
                  suffixIcon: Icon(
                    Icons.search_rounded,
                    color: Colors.white60,
                    size: 22,
                  ),
                ),
              ),
            ),
            bottom: PreferredSize(
              preferredSize: AppBar().preferredSize,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          AutoSizeText(
                            'Popular Movies',
                            minFontSize: 16,
                            maxFontSize: 20,
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              // fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 10),
                          Chip(
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
                      child: _widgetId == 1
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
                        _updateWidget();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
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
          SliverAnimatedSwitcher(
            duration: Duration(milliseconds: 300),
            child: _renderWidget(),
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
          return _searchListView(index);
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
          return _searchGridView(index);
        },
        childCount: items.length,
      ),
    );
  }

  Widget _searchListView(int index) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 25,
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

  Widget _searchGridView(int index) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 25,
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
}
