import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:movie/models/popular_movies_model.dart';
import 'package:movie/services/popular_movies_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:movie/sheets/sort_modal_bottom_sheet.dart';
import 'package:auto_size_text/auto_size_text.dart';

class NewHomePageCopy extends StatefulWidget {
  final String title;

  const NewHomePageCopy({Key? key, required this.title}) : super(key: key);

  @override
  _NewHomePageCopyState createState() => _NewHomePageCopyState();
}

class _NewHomePageCopyState extends State<NewHomePageCopy>
    with TickerProviderStateMixin {
  bool isDataRecieved = false;
  List<Item> items = <Item>[];
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

  @override
  void initState() {
    getPopularMovies();
    print('isDataRecieved : $isDataRecieved');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //this sets the navigation bar color to green
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        shrinkWrap: true,
        slivers: <Widget>[
          SliverAppBar(
            // pinned: false,
            // floating: false,
            // elevation: 5,
            // forceElevated: true,
            backgroundColor: Colors.white,
            centerTitle: true,
            // expandedHeight: 80,
            title: Center(
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Chip(
                    label: Text(
                      'Top ${items.length}',
                      style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    backgroundColor: Colors.amber,
                    labelPadding: EdgeInsets.symmetric(horizontal: 5),
                    shape: ContinuousRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  SizedBox(width: 10),
                  AutoSizeText(
                    'Popular Movies',
                    minFontSize: 24,
                    maxFontSize: double.infinity,
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      // fontSize: 30,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverPersistentHeader(
            // floating: false,
            // pinned: true,
            delegate: PersistentHeader(
              widget: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AutoSizeText(
                      'Sort by : ',
                      minFontSize: 16,
                      style: TextStyle(
                        // fontSize: 16,
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
                          print(
                              'selectedSortOption home : $selectedSortOption');
                          selectedSortOption == null
                              ? sortFetchedPopularMovies(
                                  mode: 'Default Ascending')
                              : sortFetchedPopularMovies(
                                  mode: selectedSortOption);
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
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
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
                                color: Colors.grey[400],
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
                              filterQuality: FilterQuality.high,
                              height: 150,
                              width: 109,
                            ),
                          ),
                          Flexible(
                            child: InkWell(
                              borderRadius: BorderRadius.circular(10),
                              onTap: () => print('${items[index].id}'),
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
                                      items[index].title,
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
                                      items[index].year,
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
                                      items[index].imDbRating == ''
                                          ? Container(
                                              height: 0,
                                              width: 0,
                                            )
                                          : Icon(
                                              Icons.star_rate_rounded,
                                              // color: Colors.amber,
                                            ),
                                      Text(
                                        items[index].imDbRating,
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
              },
              childCount: items.length,
            ),
          ),
        ],
      ),
    );
  }
}

class PersistentHeader extends SliverPersistentHeaderDelegate {
  final Widget widget;

  PersistentHeader({required this.widget});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      width: double.infinity,
      height: AppBar().preferredSize.height + 10,
      child: Card(
        // margin: EdgeInsets.all(5),
        color: Colors.white,
        elevation: 5.0,
        child: Center(child: widget),
      ),
    );
  }

  @override
  double get maxExtent => AppBar().preferredSize.height + 40;

  @override
  double get minExtent => AppBar().preferredSize.height + 15;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
