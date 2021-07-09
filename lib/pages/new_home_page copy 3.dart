import 'dart:convert';
import 'package:lottie/lottie.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:movie/models/popular_movies_model.dart';
import 'package:movie/pages/image_page.dart';
import 'package:movie/services/popular_movies_service.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:movie/sheets/sort_modal_bottom_sheet.dart';
import 'package:auto_size_text/auto_size_text.dart';

class NewHomePageCopy3 extends StatefulWidget {
  final String title;

  const NewHomePageCopy3({Key? key, required this.title}) : super(key: key);

  @override
  _NewHomePageCopy3State createState() => _NewHomePageCopy3State();
}

class _NewHomePageCopy3State extends State<NewHomePageCopy3>
    with TickerProviderStateMixin {
  bool isDataRecieved = false;
  bool? _isSearching;
  int _widgetId = 1;
  List<Item> items = <Item>[];
  List<Item> searchedItems = <Item>[];
  final globalKey = new GlobalKey<ScaffoldState>();
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String _searchText = "";
  String selectedSortModeButtonText = 'Default Ascending';
  // final List<String> sortModes = const [
  //   'Default Order',
  //   'Title Ascending',
  //   'Title Descending',
  //   'Rate Ascending',
  //   'Rate Descending',
  //   'Year Ascending',
  //   'Year Descending',
  // ];
  final PopularMoviesApiService popularMoviesApiService =
      PopularMoviesApiService();

  _NewHomePageCopy2State() {
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
    Response response = await popularMoviesApiService.fetchMovies();
    // response.then((value) => print(value.body));
    // print('response : ${response.body}');

    print('Response status: ${response.statusCode}');

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      final PopularMovies popularMoviesList =
          PopularMovies.fromJson(jsonResponse);
      // results.addAll(popularMoviesList.results);
      setState(() {
        items.addAll(popularMoviesList.items);
        // items.sort((a, b) => a.title.compareTo(b.title));
        isDataRecieved = true;
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

  void _updateWidget() {
    setState(() {
      _widgetId = _widgetId == 1 ? 2 : 1;
    });
  }

  Widget _renderWidget() {
    return _widgetId == 1 ? _sortWidget() : _searchWidget();
  }

  _searchFor(String query) {
    searchedItems.clear();
    if (_isSearching != null) {}
  }

  @override
  void initState() {
    getPopularMovies();
    print('isDataRecieved : $isDataRecieved');
    _isSearching = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //this sets the navigation bar color to green
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        brightness: Brightness.dark,
        elevation: 0,
        backgroundColor: Colors.grey[900], //amber
        toolbarHeight: AppBar().preferredSize.height,
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
        // AnimatedSwitcher(
        //   duration: Duration(seconds: 1),
        //   child: _renderWidget(),
        //   switchInCurve: Curves.easeInBack,
        //   switchOutCurve: Curves.easeOutBack,
        // ),
      ),
      backgroundColor: Colors.grey[900], //grey[50]
      // extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        controller: _scrollController,
        physics: BouncingScrollPhysics(),
        child: ListView.builder(
          // padding: EdgeInsets.symmetric(vertical: 0),
          controller: _scrollController,
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: 1 + items.length,
          itemBuilder: (BuildContext context, int index) {
            print('index : $index');
            if (isDataRecieved == false) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 100.0),
                  child: CircularProgressIndicator(),
                ),
              );
            }
            // if (isDataRecieved == true && items.length == 0) {
            //   if (index == 0) {
            //     return Padding(
            //       padding: EdgeInsets.symmetric(
            //         horizontal: 40,
            //         vertical: 20,
            //       ),
            //       child: Column(
            //         crossAxisAlignment: CrossAxisAlignment.start,
            //         children: [
            //           Text(
            //             'Popular Movies',
            //             style: TextStyle(
            //               fontWeight: FontWeight.bold,
            //               fontSize: 40,
            //               color: Colors.black,
            //             ),
            //           ),
            //           SizedBox(height: 20),
            //           Center(
            //             child: Container(
            //               height: 150,
            //               width: 150,
            //               color: Colors.blue,
            //             ),
            //           ),
            //         ],
            //       ),
            //     );
            //   }
            //   return Center(
            //     child: Container(
            //       height: 150,
            //       width: 150,
            //       color: Colors.blue,
            //     ),
            //   );
            // }
            if (index == 0) {
              return Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 15,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Row(
                    //   mainAxisSize: MainAxisSize.max,
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   crossAxisAlignment: CrossAxisAlignment.center,
                    //   children: [
                    //     // Container(
                    //     //   // alignment: Alignment.center,
                    //     //   color: Colors.transparent,
                    //     //   height: 35,
                    //     //   width: 35,
                    //     //   child: Lottie.asset(
                    //     //     'assets/animations/popular_movies.json',
                    //     //     repeat: true,
                    //     //     reverse: true,
                    //     //     animate: true,
                    //     //     frameRate: FrameRate(1000),
                    //     //     fit: BoxFit.cover,
                    //     //   ),
                    //     // ),
                    //     Chip(
                    //       label: Text(
                    //         'Top ${items.length}',
                    //         style: TextStyle(
                    //           fontSize: 20,
                    //           fontWeight: FontWeight.w900,
                    //         ),
                    //       ),
                    //       backgroundColor: Colors.amber,
                    //       labelPadding: EdgeInsets.symmetric(horizontal: 5),
                    //       shape: ContinuousRectangleBorder(
                    //         borderRadius: BorderRadius.circular(15),
                    //       ),
                    //       // padding: EdgeInsets.zero,
                    //       // visualDensity: VisualDensity.compact,
                    //     ),
                    //     SizedBox(width: 10),
                    //     AutoSizeText(
                    //       'Popular Movies',
                    //       // presetFontSizes: [
                    //       //   40,
                    //       //   36,
                    //       //   32,
                    //       //   30,
                    //       //   24,
                    //       //   20,
                    //       //   16,
                    //       //   14,
                    //       //   12,
                    //       // ],
                    //       minFontSize: 24,
                    //       maxFontSize: double.infinity,
                    //       style: TextStyle(
                    //         fontWeight: FontWeight.w900,
                    //         // fontSize: 30,
                    //         color: Colors.black,
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    // Text(
                    //   'Popular Movies',
                    //   style: TextStyle(
                    //     fontWeight: FontWeight.w900,
                    //     fontSize: 30,
                    //     color: Colors.black,
                    //   ),
                    // ),
                    // SizedBox(height: 25),
                    // Row(
                    //   mainAxisSize: MainAxisSize.max,
                    //   mainAxisAlignment: MainAxisAlignment.start,
                    //   crossAxisAlignment: CrossAxisAlignment.center,
                    //   children: [
                    //     Chip(
                    //       label: Text(
                    //         'Top ${items.length}',
                    //         style: TextStyle(
                    //           fontSize: 16,
                    //           fontWeight: FontWeight.w900,
                    //         ),
                    //       ),
                    //       backgroundColor: Colors.amber,
                    //       labelPadding: EdgeInsets.symmetric(horizontal: 5),
                    //       shape: ContinuousRectangleBorder(
                    //         borderRadius: BorderRadius.circular(15),
                    //       ),
                    //       // padding: EdgeInsets.zero,
                    //       visualDensity: VisualDensity.compact,
                    //     ),
                    //     // Text(
                    //     //   'Top ${items.length}',
                    //     //   style: TextStyle(
                    //     //     fontWeight: FontWeight.w600,
                    //     //     fontSize: 18,
                    //     //     color: Colors.grey,
                    //     //   ),
                    //     // ),
                    //   ],
                    // ),
                    // SizedBox(height: 40),
                    // _sortWidget(),
                    // AnimatedSwitcher(
                    //   duration: Duration(seconds: 1),
                    //   child: _renderWidget(),
                    //   switchInCurve: Curves.easeInBack,
                    //   switchOutCurve: Curves.easeOutBack,
                    // ),
                    // Row(
                    //   mainAxisSize: MainAxisSize.max,
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   crossAxisAlignment: CrossAxisAlignment.center,
                    //   children: [
                    //     AutoSizeText(
                    //       'Sort by : ',
                    //       minFontSize: 16,
                    //       style: TextStyle(
                    //         // fontSize: 16,
                    //         fontWeight: FontWeight.bold,
                    //       ),
                    //     ),
                    //     MaterialButton(
                    //       child: AutoSizeText(
                    //         selectedSortModeButtonText,
                    //         minFontSize: 16,
                    //         style: TextStyle(
                    //           // fontSize: 16,
                    //           fontWeight: FontWeight.bold,
                    //         ),
                    //       ),
                    //       // padding: EdgeInsets.zero,
                    //       color: Colors.grey[300],
                    //       shape: StadiumBorder(),
                    //       // shape: ContinuousRectangleBorder(
                    //       //   borderRadius: BorderRadius.circular(15),
                    //       // ),
                    //       minWidth: MediaQuery.of(context).size.width * 0.4,
                    //       elevation: 0,
                    //       highlightElevation: 0,
                    //       onPressed: () {
                    //         showModalBottomSheet<String>(
                    //           context: context,
                    //           builder: (builder) => SortModesBottomSheet(),
                    //           backgroundColor: Colors.transparent,
                    //           shape: RoundedRectangleBorder(
                    //             borderRadius: BorderRadius.all(
                    //               Radius.circular(25),
                    //             ),
                    //           ),
                    //           // shape: ContinuousRectangleBorder(
                    //           //   borderRadius:
                    //           //       BorderRadius.all(Radius.circular(25)),
                    //           // ),
                    //           // elevation: 50,
                    //           isScrollControlled: true,
                    //           transitionAnimationController: AnimationController(
                    //             vsync: this,
                    //             duration: Duration(milliseconds: 1000),
                    //             reverseDuration: Duration(milliseconds: 500),
                    //           ),
                    //           // elevation: 5,
                    //         ).then((selectedSortOption) {
                    //           print(
                    //               'selectedSortOption home : $selectedSortOption');
                    //           selectedSortOption == null
                    //               ? sortFetchedPopularMovies(
                    //                   mode: 'Default Ascending')
                    //               : sortFetchedPopularMovies(
                    //                   mode: selectedSortOption);
                    //           setState(() {
                    //             selectedSortModeButtonText = selectedSortOption!;
                    //           });
                    //         });
                    //       },
                    //     ),
                    //   ],
                    // ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        // SizedBox(height: 100),
                        items.length == 0
                            ? Center(
                                child: Lottie.asset(
                                  'assets/animations/empty_list.json',
                                  repeat: true,
                                  reverse: true,
                                  animate: true,
                                  frameRate: FrameRate(1000),
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Popular Movies',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w900,
                                          fontSize: 20,
                                          color: Colors.white,
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Chip(
                                        label: Text(
                                          'Top ${items.length}',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w900,
                                            color: Colors.black,
                                          ),
                                        ),
                                        backgroundColor: Colors.amber[900],
                                        labelPadding:
                                            EdgeInsets.symmetric(horizontal: 5),
                                        shape: ContinuousRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        // padding: EdgeInsets.zero,
                                        visualDensity: VisualDensity.compact,
                                      ),
                                    ],
                                  ),
                                  FloatingActionButton(
                                    mini: true,
                                    elevation: 0,
                                    highlightElevation: 0,
                                    child: Icon(
                                      Icons.grid_view,
                                      color: Colors.grey[600],
                                      size: 28,
                                    ),
                                    backgroundColor: Colors.transparent,
                                    onPressed: () {},
                                  ),
                                  // IconButton(
                                  //   icon: Icon(
                                  //     Icons.grid_view_rounded,
                                  //     color: Colors.grey[600],
                                  //   ),
                                  //   // splashColor: Colors.transparent,
                                  //   highlightColor: Colors.transparent,
                                  //   iconSize: 28,
                                  //   padding: EdgeInsets.all(0),
                                  //   onPressed: () {},
                                  // ),
                                ],
                              ),
                      ],
                    )
                  ],
                ),
              );
            }
            return searchedItems.length != 0 || _textController.text.isNotEmpty
                ? _sortListView(index)
                : _searchListView(index);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
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
              duration: Duration(milliseconds: 3500),
            );
          });
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        // notchMargin: 25,
        color: Colors.grey[900],
        // elevation: 0,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 13,
            vertical: 5,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              OutlinedButton.icon(
                label: Text(
                  '$selectedSortModeButtonText',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    color: Colors.black87,
                  ),
                ),
                icon: Icon(
                  Icons.sort_rounded,
                  color: Colors.black87,
                ),
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.amber[900],
                  padding: EdgeInsets.symmetric(horizontal: 10),
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
              // IconButton(
              //   icon: Icon(
              //     Icons.sort_rounded,
              //     size: 28,
              //     color: Colors.white70,
              //   ),
              //   highlightColor: Colors.transparent,
              //   splashColor: Colors.transparent,
              //   onPressed: () {
              //     showModalBottomSheet<String>(
              //       context: context,
              //       builder: (builder) => SortModesBottomSheet(),
              //       backgroundColor: Colors.transparent,
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.all(
              //           Radius.circular(25),
              //         ),
              //       ),
              //       // shape: ContinuousRectangleBorder(
              //       //   borderRadius:
              //       //       BorderRadius.all(Radius.circular(25)),
              //       // ),
              //       // elevation: 50,
              //       isScrollControlled: true,
              //       transitionAnimationController: AnimationController(
              //         vsync: this,
              //         duration: Duration(milliseconds: 1000),
              //         reverseDuration: Duration(milliseconds: 500),
              //       ),
              //       // elevation: 5,
              //     ).then((selectedSortOption) {
              //       print('selectedSortOption home : $selectedSortOption');
              //       selectedSortOption == null
              //           ? sortFetchedPopularMovies(mode: 'Default Ascending')
              //           : sortFetchedPopularMovies(mode: selectedSortOption);
              //       setState(() {
              //         selectedSortModeButtonText = selectedSortOption!;
              //       });
              //     });
              //   },
              // ),
              // SizedBox(width: 5),
              // IconButton(
              //   icon: Icon(
              //     Icons.view_list_rounded,
              //     size: 28,
              //     color: Colors.white70,
              //   ),
              //   highlightColor: Colors.transparent,
              //   splashColor: Colors.transparent,
              //   onPressed: () {},
              // ),
              // SizedBox(width: 5),
              // IconButton(
              //   icon: Icon(
              //     Icons.search_rounded,
              //     size: 28,
              //     color: Colors.white70,
              //   ),
              //   highlightColor: Colors.transparent,
              //   splashColor: Colors.transparent,
              //   onPressed: () {},
              // ),
            ],
          ),
        ),
        // Card(
        //   color: Colors.amber[900],
        //   margin: EdgeInsets.all(10),
        //   shape: ContinuousRectangleBorder(
        //     borderRadius: BorderRadius.circular(20),
        //   ),
        //   child: Padding(
        //     padding: const EdgeInsets.symmetric(horizontal: 13),
        //     child: Row(
        //       mainAxisSize: MainAxisSize.max,
        //       mainAxisAlignment: MainAxisAlignment.start,
        //       crossAxisAlignment: CrossAxisAlignment.center,
        //       children: [
        //         IconButton(
        //           icon: Icon(
        //             Icons.sort_rounded,
        //             size: 28,
        //             color: Colors.white70,
        //           ),
        //           highlightColor: Colors.transparent,
        //           splashColor: Colors.transparent,
        //           onPressed: () {
        //             showModalBottomSheet<String>(
        //               context: context,
        //               builder: (builder) => SortModesBottomSheet(),
        //               backgroundColor: Colors.transparent,
        //               shape: RoundedRectangleBorder(
        //                 borderRadius: BorderRadius.all(
        //                   Radius.circular(25),
        //                 ),
        //               ),
        //               // shape: ContinuousRectangleBorder(
        //               //   borderRadius:
        //               //       BorderRadius.all(Radius.circular(25)),
        //               // ),
        //               // elevation: 50,
        //               isScrollControlled: true,
        //               transitionAnimationController: AnimationController(
        //                 vsync: this,
        //                 duration: Duration(milliseconds: 1000),
        //                 reverseDuration: Duration(milliseconds: 500),
        //               ),
        //               // elevation: 5,
        //             ).then((selectedSortOption) {
        //               print('selectedSortOption home : $selectedSortOption');
        //               selectedSortOption == null
        //                   ? sortFetchedPopularMovies(mode: 'Default Ascending')
        //                   : sortFetchedPopularMovies(mode: selectedSortOption);
        //               setState(() {
        //                 selectedSortModeButtonText = selectedSortOption!;
        //               });
        //             });
        //           },
        //         ),
        //         SizedBox(width: 5),
        //         IconButton(
        //           icon: Icon(
        //             Icons.view_list_rounded,
        //             size: 28,
        //             color: Colors.white70,
        //           ),
        //           highlightColor: Colors.transparent,
        //           splashColor: Colors.transparent,
        //           onPressed: () {},
        //         ),
        //         SizedBox(width: 5),
        //         IconButton(
        //           icon: Icon(
        //             Icons.search_rounded,
        //             size: 28,
        //             color: Colors.white70,
        //           ),
        //           highlightColor: Colors.transparent,
        //           splashColor: Colors.transparent,
        //           onPressed: () {},
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
        // Container(
        //   margin: EdgeInsets.all(5),
        //   // padding: EdgeInsets.all(5),
        //   height: AppBar().preferredSize.height,
        //   width: double.infinity,
        //   decoration: BoxDecoration(
        //     color: Colors.grey[800],
        //     shape: BoxShape.rectangle,
        //     borderRadius: BorderRadius.only(
        //       bottomLeft: Radius.zero,
        //       bottomRight: Radius.zero,
        //       topLeft: Radius.circular(15),
        //       topRight: Radius.circular(15),
        //     ),
        //   ),
        // ),
      ),
    );
  }

  Widget _sortWidget() {
    return Container(
      key: Key('sort'),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      height: AppBar().preferredSize.height,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Sort by : ',
              // minFontSize: 12,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            MaterialButton(
              child: AutoSizeText(
                selectedSortModeButtonText,
                minFontSize: 16,
                style: TextStyle(
                  // fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // padding: EdgeInsets.zero,
              color: Colors.grey[300],
              shape: StadiumBorder(),
              // shape: ContinuousRectangleBorder(
              //   borderRadius: BorderRadius.circular(15),
              // ),
              minWidth: MediaQuery.of(context).size.width * 0.4,
              elevation: 0,
              highlightElevation: 0,
              onPressed: () {
                showModalBottomSheet<String>(
                  context: context,
                  builder: (builder) => SortModesBottomSheet(),
                  backgroundColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(15),
                    ),
                  ),
                  // shape: ContinuousRectangleBorder(
                  //   borderRadius: BorderRadius.all(
                  //     Radius.circular(15),
                  //   ),
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
    );
  }

  Widget _searchWidget() {
    return Container(
      key: Key('search'),
      height: AppBar().preferredSize.height,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: TextField(
          controller: _textController,
          minLines: 1,
          maxLines: 1,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            textBaseline: TextBaseline.alphabetic,
          ),
          textAlignVertical: TextAlignVertical.center,
          cursorHeight: 20,
          textAlign: TextAlign.start,
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.search_rounded,
              color: Colors.black,
            ),
            // icon: Icon(
            //   Icons.search_rounded,
            //   color: Colors.black,
            // ),
            // contentPadding: EdgeInsets.zero,
            // border: InputBorder.none,
            // focusedBorder: InputBorder.none,
            // enabledBorder: InputBorder.none,
            // errorBorder: InputBorder.none,
            // disabledBorder: InputBorder.none,
            // contentPadding:
            //     EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
            // hintText: "Hint here",
            hintStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              textBaseline: TextBaseline.alphabetic,
            ),
          ),
          onChanged: (searchedQuery) => _searchFor(searchedQuery),
        ),
        // TextField(
        //   controller: _controller,
        //   minLines: 1,
        //   maxLines: 1,
        //   style: TextStyle(
        //     fontSize: 16,
        //     fontWeight: FontWeight.bold,
        //     textBaseline: TextBaseline.alphabetic,
        //   ),
        //   textAlignVertical: TextAlignVertical.center,
        //   cursorHeight: 20,
        //   textAlign: TextAlign.start,
        //   decoration: InputDecoration(
        //     prefixIcon: Icon(
        //       Icons.search_rounded,
        //       color: Colors.black,
        //     ),
        //     // icon: Icon(
        //     //   Icons.search_rounded,
        //     //   color: Colors.black,
        //     // ),
        //     // contentPadding: EdgeInsets.zero,
        //     border: OutlineInputBorder(
        //       borderRadius: BorderRadius.circular(10),
        //     ),
        //     // focusedBorder: InputBorder.none,
        //     // enabledBorder: InputBorder.none,
        //     // errorBorder: InputBorder.none,
        //     // disabledBorder: InputBorder.none,
        //     // contentPadding:
        //     //     EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
        //     // hintText: "Hint here",
        //     hintStyle: TextStyle(
        //       fontSize: 16,
        //       fontWeight: FontWeight.bold,
        //       textBaseline: TextBaseline.alphabetic,
        //     ),
        //   ),
        //   onChanged: (searchedQuery) => _searchFor(searchedQuery),
        // ),
      ),
    );
  }

  Widget _searchListView(int index) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25),
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
                  placeholder: (context, url) => Container(
                    color: Colors.grey.withOpacity(0.3),
                    padding: EdgeInsets.zero,
                    child: Icon(
                      Icons.local_movies_rounded,
                      size: 80,
                      color: Colors.grey,
                    ),
                  ),
                  imageUrl: items[index - 1].image,
                  // items[index - 1].image,
                  fit: BoxFit.cover,
                  filterQuality: FilterQuality.high,
                  height: 150,
                  width: 109,
                ),
              ),
              Flexible(
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () => print('${items[index - 1].id}'),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                    ),
                    // padding: EdgeInsets.only(left: 5),
                    height: 130,
                    width: double.infinity,
                    child: ListTile(
                      // contentPadding: EdgeInsets.symmetric(
                      //   horizontal: 16.0,
                      //   vertical: 8,
                      // ),
                      // tileColor: Colors.orange.withOpacity(0.5),
                      title: Padding(
                        padding: EdgeInsets.only(top: 16),
                        child: Text(
                          items[index - 1].title,
                          maxLines: 2,
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Text(
                          items[index - 1].year,
                          maxLines: 1,
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white38,
                          ),
                        ),
                      ),
                      trailing: Column(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          items[index - 1].imDbRating == ''
                              ? Icon(
                                  Icons.grade_rounded,
                                  color: Colors.amber[900],
                                )
                              : Icon(
                                  Icons.grade_rounded,
                                  color: Colors.amber[900],
                                ),
                          SizedBox(height: 5),
                          items[index - 1].imDbRating == ''
                              ? Text(
                                  'N/A',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                  ),
                                )
                              : Text(
                                  items[index - 1].imDbRating,
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
          // ListTile(
          //   // contentPadding: EdgeInsets.zero,
          //   tileColor: Colors.orange.withOpacity(0.5),
          //   leading: Container(
          //     height: 500,
          //     width: 100,
          //     child: Image.network(
          //       posterBaseUrl + results[index - 1].posterPath,
          //       fit: BoxFit.cover,
          //     ),
          //   ),
          //   title: Text(results[index - 1].originalTitle),
          // ),
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

  Widget _sortListView(int index) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ClipRRect(
              //   borderRadius: BorderRadius.only(
              //     topLeft: Radius.circular(10),
              //     bottomLeft: Radius.circular(10),
              //     topRight: Radius.circular(10),
              //     bottomRight: Radius.circular(10),
              //   ),
              //   child: CachedNetworkImage(
              //     placeholder: (context, url) => Container(
              //       color: Colors.grey[400],
              //       padding: EdgeInsets.zero,
              //       child: Icon(
              //         Icons.local_movies_rounded,
              //         size: 80,
              //         color: Colors.grey,
              //       ),
              //     ),
              //     imageUrl: items[index - 1].image,
              //     // items[index - 1].image,
              //     fit: BoxFit.cover,
              //     filterQuality: FilterQuality.high,
              //     height: 150,
              //     width: 109,
              //   ),
              // ),
              Flexible(
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () => print('${items[index - 1].id}'),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                    ),
                    // padding: EdgeInsets.only(left: 5),
                    height: 130,
                    width: double.infinity,
                    child: ListTile(
                      // contentPadding: EdgeInsets.symmetric(
                      //   horizontal: 16.0,
                      //   vertical: 8,
                      // ),
                      // tileColor: Colors.orange.withOpacity(0.5),
                      title: Padding(
                        padding: EdgeInsets.only(top: 16),
                        child: Text(
                          items[index - 1].title,
                          maxLines: 2,
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Text(
                          items[index - 1].year,
                          maxLines: 1,
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      trailing: Column(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          items[index - 1].imDbRating == ''
                              ? Container(
                                  height: 0,
                                  width: 0,
                                )
                              : Icon(
                                  Icons.star_rate_rounded,
                                  // color: Colors.amber,
                                ),
                          Text(
                            items[index - 1].imDbRating,
                            style: TextStyle(
                                // fontWeight: FontWeight.normal,
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
          // ListTile(
          //   // contentPadding: EdgeInsets.zero,
          //   tileColor: Colors.orange.withOpacity(0.5),
          //   leading: Container(
          //     height: 500,
          //     width: 100,
          //     child: Image.network(
          //       posterBaseUrl + results[index - 1].posterPath,
          //       fit: BoxFit.cover,
          //     ),
          //   ),
          //   title: Text(results[index - 1].originalTitle),
          // ),
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
