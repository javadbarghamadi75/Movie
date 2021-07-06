import 'package:flutter/material.dart';

class SortModesBottomSheet extends StatefulWidget {
  SortModesBottomSheet({Key? key}) : super(key: key);

  @override
  _SortModesBottomSheetState createState() => _SortModesBottomSheetState();
}

enum SortByModes { Default, Title, Rate, Year }
enum SortOrderModes { Ascending, Descending }

class _SortModesBottomSheetState extends State<SortModesBottomSheet> {
  bool isSortModeSelected = false;
  static SortByModes _selectedSortMode = SortByModes.Default;
  static SortOrderModes _selectedSortOrder = SortOrderModes.Ascending;
  static String _selectedSortOption = 'Default Ascending';

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        print('onWillPop');
        print('selectedSortMode : $_selectedSortMode');
        print('selectedSortOrder : $_selectedSortOrder');
        // setState(() {
        //   _selectedSortOption =
        //       '${_selectedSortMode.toString().substring(12)}' +
        //           ' ' +
        //           '${_selectedSortOrder.toString().substring(15)}';
        // });
        print('selectedSortOption sheet Done : $_selectedSortOption');
        // print('_selectedSortOption : $_selectedSortOption');
        Navigator.pop(context, _selectedSortOption);

        return true;
      },
      child: BottomSheet(
        backgroundColor: Colors.transparent,
        enableDrag: false,
        builder: (_) => Container(
          margin: EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: Colors.white,
          ),
          child: SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Container(
                //   height: AppBar().preferredSize.height * 0.75,
                //   width: double.infinity,
                //   padding: EdgeInsets.zero,
                //   child: Center(
                //     child: Text(
                //       'Sort by',
                //       style: TextStyle(
                //         fontSize: 18,
                //         fontWeight: FontWeight.bold,
                //       ),
                //     ),
                //   ),
                // ),
                // // Divider(
                // //   color: Colors.grey[900],
                // //   height: 0,
                // //   // indent: 75,
                // //   // endIndent: 75,
                // //   // thickness: 1,
                // // ),
                ListView(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 24),
                      title: Text(
                        'Sort by',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    _sortByRadioButtons(),
                    // RadioListTile(
                    //   title: Text('value1'),
                    //   value: 'value1',
                    //   groupValue: 'groupValue',
                    //   onChanged: (f) {},
                    // ),
                    // RadioListTile(
                    //   title: Text('value2'),
                    //   value: 'value2',
                    //   groupValue: 'groupValue',
                    //   onChanged: (f) {},
                    // ),
                    // RadioListTile(
                    //   title: Text('value3'),
                    //   value: 'value3',
                    //   groupValue: 'groupValue',
                    //   onChanged: (f) {},
                    // ),
                    // RadioListTile(
                    //   title: Text('value4'),
                    //   value: 'value4',
                    //   groupValue: 'groupValue',
                    //   onChanged: (f) {},
                    // ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 10,
                      ),
                      child: Row(
                        children: [
                          // Expanded(
                          //   child: Divider(
                          //     color: Colors.grey,
                          //   ),
                          // ),
                          Text(
                            'Order',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 15),
                          Expanded(
                            child: Divider(
                              color: Colors.grey,
                              // thickness: 0.60,
                            ),
                          ),
                        ],
                      ),
                    ),
                    _sortOrderRadioButtons(),
                    // RadioListTile(
                    //   title: Text(
                    //     'value3',
                    //     style: TextStyle(
                    //       fontWeight: FontWeight.w500,
                    //     ),
                    //   ),
                    //   value: 'value3',
                    //   groupValue: 'groupValue',
                    //   onChanged: (f) {},
                    // ),
                    // RadioListTile(
                    //   title: Text(
                    //     'value4',
                    //     style: TextStyle(
                    //       fontWeight: FontWeight.w500,
                    //     ),
                    //   ),
                    //   value: 'value4',
                    //   groupValue: 'groupValue',
                    //   onChanged: (f) {},
                    // ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        MaterialButton(
                          child: Text('Dismiss'),
                          textColor: Colors.amber,
                          shape: ContinuousRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          onPressed: () {
                            print('Dismiss');
                            print('selectedSortMode : $_selectedSortMode');
                            print('selectedSortOrder : $_selectedSortOrder');
                            // setState(() {
                            //   _selectedSortOption =
                            //       '${_selectedSortMode.toString().substring(12)}' +
                            //           ' ' +
                            //           '${_selectedSortOrder.toString().substring(15)}';
                            // });
                            print(
                                'selectedSortOption sheet Done : $_selectedSortOption');
                            // print('_selectedSortOption : $_selectedSortOption');
                            Navigator.pop(context, _selectedSortOption);
                            // Navigator.pop(context);
                          },
                        ),
                        SizedBox(width: 15),
                        MaterialButton(
                          child: Text('Done'),
                          color: Colors.amber,
                          shape: ContinuousRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          highlightElevation: 0,
                          elevation: 0,
                          onPressed: () {
                            print('Done');
                            print('selectedSortMode : $_selectedSortMode');
                            print('selectedSortOrder : $_selectedSortOrder');
                            setState(() {
                              _selectedSortOption =
                                  '${_selectedSortMode.toString().substring(12)}' +
                                      ' ' +
                                      '${_selectedSortOrder.toString().substring(15)}';
                            });
                            print(
                                'selectedSortOption sheet Done : $_selectedSortOption');
                            // print('_selectedSortOption : $_selectedSortOption');
                            Navigator.pop(context, _selectedSortOption);
                          },
                        ),
                        SizedBox(width: 25)
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        onClosing: () {
          print('onClosing');
        },
      ),
    );
  }

  // The radio button itself does not maintain any state.
  // Instead, selecting the radio invokes the onChanged callback,
  // passing value as a parameter. If groupValue and value match,
  // this radio will be selected.
  Widget _sortByRadioButtons() {
    return ListView(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      // padding: EdgeInsets.symmetric(vertical: 16),
      children: [
        RadioListTile(
          title: Text(
            'Default',
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
          value: SortByModes.Default,
          groupValue: _selectedSortMode,
          onChanged: (SortByModes? sortMode) {
            setState(() {
              _selectedSortMode = sortMode!;
            });
          },
          selected: SortByModes.Default == _selectedSortMode,
          activeColor: Colors.amber,
          selectedTileColor: Colors.blue,
          // activeColor: Colors.amber,
          // selectedTileColor: Colors.red,
          // tileColor: Colors.green,
        ),
        RadioListTile(
          title: const Text(
            'Title',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
          value: SortByModes.Title,
          groupValue: _selectedSortMode,
          onChanged: (SortByModes? sortMode) {
            setState(() {
              _selectedSortMode = sortMode!;
            });
          },
          selected: SortByModes.Title == _selectedSortMode,
          activeColor: Colors.amber,
          selectedTileColor: Colors.red,
          tileColor: Colors.green,
        ),
        RadioListTile(
          title: const Text(
            'Rate',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
          value: SortByModes.Rate,
          groupValue: _selectedSortMode,
          onChanged: (SortByModes? sortMode) {
            setState(() {
              _selectedSortMode = sortMode!;
            });
          },
          selected: SortByModes.Rate == _selectedSortMode,
          activeColor: Colors.amber,
          selectedTileColor: Colors.red,
          tileColor: Colors.green,
        ),
        RadioListTile(
          title: const Text(
            'Year',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
          value: SortByModes.Year,
          groupValue: _selectedSortMode,
          onChanged: (SortByModes? sortMode) {
            setState(() {
              _selectedSortMode = sortMode!;
            });
          },
          selected: SortByModes.Year == _selectedSortMode,
          activeColor: Colors.amber,
          selectedTileColor: Colors.red,
          tileColor: Colors.green,
        ),
      ],
    );
  }

  Widget _sortOrderRadioButtons() {
    return ListView(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      // padding: EdgeInsets.symmetric(vertical: 16),
      children: [
        RadioListTile(
          title: const Text(
            'Ascending',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
          value: SortOrderModes.Ascending,
          groupValue: _selectedSortOrder,
          onChanged: (SortOrderModes? sortMode) {
            setState(() {
              _selectedSortOrder = sortMode!;
            });
          },
          selected: SortOrderModes.Ascending == _selectedSortOrder,
          activeColor: Colors.amber,
          selectedTileColor: Colors.red,
          tileColor: Colors.green,
        ),
        RadioListTile(
          title: const Text(
            'Descending',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
          value: SortOrderModes.Descending,
          groupValue: _selectedSortOrder,
          onChanged: (SortOrderModes? sortMode) {
            setState(() {
              _selectedSortOrder = sortMode!;
            });
          },
          selected: SortOrderModes.Descending == _selectedSortOrder,
          activeColor: Colors.amber,
          selectedTileColor: Colors.red,
          tileColor: Colors.green,
        ),
      ],
    );
  }
}
  //   return SingleChildScrollView(
  //     physics: NeverScrollableScrollPhysics(),
  //     child: Column(
  //       mainAxisSize: MainAxisSize.max,
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         // Container(
  //         //   height: AppBar().preferredSize.height * 0.75,
  //         //   width: double.infinity,
  //         //   padding: EdgeInsets.zero,
  //         //   child: Center(
  //         //     child: Text(
  //         //       'Sort by',
  //         //       style: TextStyle(
  //         //         fontSize: 18,
  //         //         fontWeight: FontWeight.bold,
  //         //       ),
  //         //     ),
  //         //   ),
  //         // ),
  //         // // Divider(
  //         // //   color: Colors.grey[900],
  //         // //   height: 0,
  //         // //   // indent: 75,
  //         // //   // endIndent: 75,
  //         // //   // thickness: 1,
  //         // // ),
  //         ListView(
  //           physics: NeverScrollableScrollPhysics(),
  //           shrinkWrap: true,
  //           children: [
  //             ListTile(
  //               contentPadding: EdgeInsets.symmetric(horizontal: 24),
  //               title: Text(
  //                 'Sort by',
  //                 style: TextStyle(
  //                   fontSize: 20,
  //                   fontWeight: FontWeight.bold,
  //                 ),
  //               ),
  //             ),
  //             RadioListTile(
  //               title: Text('value1'),
  //               value: 'value1',
  //               groupValue: 'groupValue',
  //               onChanged: (f) {},
  //             ),
  //             RadioListTile(
  //               title: Text('value2'),
  //               value: 'value2',
  //               groupValue: 'groupValue',
  //               onChanged: (f) {},
  //             ),
  //             RadioListTile(
  //               title: Text('value3'),
  //               value: 'value3',
  //               groupValue: 'groupValue',
  //               onChanged: (f) {},
  //             ),
  //             RadioListTile(
  //               title: Text('value4'),
  //               value: 'value4',
  //               groupValue: 'groupValue',
  //               onChanged: (f) {},
  //             ),
  //             Divider(
  //               color: Colors.grey,
  //               // height: 1,
  //             ),
  //             RadioListTile(
  //               title: Text('value3'),
  //               value: 'value3',
  //               groupValue: 'groupValue',
  //               onChanged: (f) {},
  //             ),
  //             RadioListTile(
  //               title: Text('value4'),
  //               value: 'value4',
  //               groupValue: 'groupValue',
  //               onChanged: (f) {},
  //             ),
  //             Row(
  //               mainAxisSize: MainAxisSize.max,
  //               mainAxisAlignment: MainAxisAlignment.end,
  //               crossAxisAlignment: CrossAxisAlignment.center,
  //               children: [
  //                 MaterialButton(
  //                   child: Text('Dismiss'),
  //                   textColor: Colors.amber,
  //                   shape: ContinuousRectangleBorder(
  //                     borderRadius: BorderRadius.circular(15),
  //                   ),
  //                   onPressed: () {
  //                     Navigator.pop(context);
  //                   },
  //                 ),
  //                 SizedBox(width: 25),
  //                 MaterialButton(
  //                   child: Text('Done'),
  //                   color: Colors.amber,
  //                   shape: ContinuousRectangleBorder(
  //                     borderRadius: BorderRadius.circular(15),
  //                   ),
  //                   highlightElevation: 0,
  //                   onPressed: () {},
  //                 ),
  //                 SizedBox(width: 25)
  //               ],
  //             ),
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }
// }

            //[
            //   ListTile(
            //     contentPadding: EdgeInsets.symmetric(
            //       horizontal: 16,
            //       vertical: 5,
            //     ),
            //     leading: Icon(Icons.refresh_rounded),
            //     minLeadingWidth: 0,
            //     title: Text(
            //       'Default Order',
            //       style: TextStyle(
            //         color: Colors.black,
            //         fontWeight: FontWeight.bold,
            //       ),
            //     ),
            //     // subtitle: Row(
            //     //   mainAxisSize: MainAxisSize.max,
            //     //   mainAxisAlignment: MainAxisAlignment.spaceAround,
            //     //   crossAxisAlignment: CrossAxisAlignment.center,
            //     //   children: [
            //     //     ChoiceChip(
            //     //       label: Text('Ascending'),
            //     //       disabledColor: Colors.transparent,
            //     //       selectedColor: Colors.amber,
            //     //       labelStyle: TextStyle(
            //     //         color: Colors.black,
            //     //         fontWeight: FontWeight.bold,
            //     //       ),
            //     //       selected: isSortModeSelected,
            //     //       onSelected: (selected) {},
            //     //     ),
            //     //     // SizedBox(width: 10),
            //     //     ChoiceChip(
            //     //       label: Text('Descending'),
            //     //       disabledColor: Colors.transparent,
            //     //       selectedColor: Colors.amber,
            //     //       labelStyle: TextStyle(
            //     //         color: Colors.black,
            //     //         fontWeight: FontWeight.bold,
            //     //       ),
            //     //       selected: isSortModeSelected,
            //     //       onSelected: (selected) {},
            //     //     ),
            //     //   ],
            //     // ),
            //   ),
            //   Divider(
            //     color: Colors.grey,
            //     height: 0,
            //     indent: 50,
            //     endIndent: 50,
            //   ),
            //   ListTile(
            //     contentPadding: EdgeInsets.symmetric(
            //       horizontal: 16,
            //       vertical: 5,
            //     ),
            //     leading: Icon(Icons.text_fields_rounded),
            //     minLeadingWidth: 0,
            //     title: Text(
            //       'Title',
            //       style: TextStyle(
            //         color: Colors.black,
            //         fontWeight: FontWeight.bold,
            //       ),
            //     ),
            //     subtitle: Row(
            //       mainAxisSize: MainAxisSize.max,
            //       mainAxisAlignment: MainAxisAlignment.spaceAround,
            //       crossAxisAlignment: CrossAxisAlignment.center,
            //       children: [
            //         ChoiceChip(
            //           label: Text('Ascending'),
            //           disabledColor: Colors.transparent,
            //           selectedColor: Colors.amber,
            //           labelStyle: TextStyle(
            //             color: Colors.black,
            //             fontWeight: FontWeight.bold,
            //           ),
            //           selected: isSortModeSelected,
            //           onSelected: (selected) {},
            //         ),
            //         // SizedBox(width: 10),
            //         ChoiceChip(
            //           label: Text('Descending'),
            //           disabledColor: Colors.transparent,
            //           selectedColor: Colors.amber,
            //           labelStyle: TextStyle(
            //             color: Colors.black,
            //             fontWeight: FontWeight.bold,
            //           ),
            //           selected: isSortModeSelected,
            //           onSelected: (selected) {},
            //         ),
            //       ],
            //     ),
            //   ),
            //   Divider(
            //     color: Colors.grey,
            //     height: 0,
            //     indent: 50,
            //     endIndent: 50,
            //   ),
            //   ListTile(
            //     contentPadding: EdgeInsets.symmetric(
            //       horizontal: 16,
            //       vertical: 5,
            //     ),
            //     leading: Icon(Icons.star_rounded),
            //     minLeadingWidth: 0,
            //     title: Text(
            //       'Rate',
            //       style: TextStyle(
            //         color: Colors.black,
            //         fontWeight: FontWeight.bold,
            //       ),
            //     ),
            //     subtitle: Row(
            //       mainAxisSize: MainAxisSize.max,
            //       mainAxisAlignment: MainAxisAlignment.spaceAround,
            //       crossAxisAlignment: CrossAxisAlignment.center,
            //       children: [
            //         ChoiceChip(
            //           label: Text('Ascending'),
            //           disabledColor: Colors.transparent,
            //           selectedColor: Colors.amber,
            //           labelStyle: TextStyle(
            //             color: Colors.black,
            //             fontWeight: FontWeight.bold,
            //           ),
            //           selected: isSortModeSelected,
            //           onSelected: (selected) {},
            //         ),
            //         // SizedBox(width: 10),
            //         ChoiceChip(
            //           label: Text('Descending'),
            //           disabledColor: Colors.transparent,
            //           selectedColor: Colors.amber,
            //           labelStyle: TextStyle(
            //             color: Colors.black,
            //             fontWeight: FontWeight.bold,
            //           ),
            //           selected: isSortModeSelected,
            //           onSelected: (selected) {},
            //         ),
            //       ],
            //     ),
            //   ),
            //   Divider(
            //     color: Colors.grey,
            //     height: 0,
            //     indent: 50,
            //     endIndent: 50,
            //   ),
            //   ListTile(
            //     contentPadding: EdgeInsets.symmetric(
            //       horizontal: 16,
            //       vertical: 5,
            //     ),
            //     leading: Icon(Icons.today_rounded),
            //     minLeadingWidth: 0,
            //     title: Text(
            //       'Year',
            //       style: TextStyle(
            //         color: Colors.black,
            //         fontWeight: FontWeight.bold,
            //       ),
            //     ),
            //     subtitle: Row(
            //       mainAxisSize: MainAxisSize.max,
            //       mainAxisAlignment: MainAxisAlignment.spaceAround,
            //       crossAxisAlignment: CrossAxisAlignment.center,
            //       children: [
            //         ChoiceChip(
            //           label: Text('Ascending'),
            //           disabledColor: Colors.transparent,
            //           selectedColor: Colors.amber,
            //           labelStyle: TextStyle(
            //             color: Colors.black,
            //             fontWeight: FontWeight.bold,
            //           ),
            //           selected: isSortModeSelected,
            //           onSelected: (selected) {},
            //         ),
            //         // SizedBox(width: 10),
            //         ChoiceChip(
            //           label: Text('Descending'),
            //           disabledColor: Colors.transparent,
            //           selectedColor: Colors.amber,
            //           labelStyle: TextStyle(
            //             color: Colors.black,
            //             fontWeight: FontWeight.bold,
            //           ),
            //           selected: isSortModeSelected,
            //           onSelected: (selected) {
            //             setState(() {
            //               isSortModeSelected = selected;
            //             });
            //           },
            //         ),
            //       ],
            //     ),
            //   ),
            // ],
