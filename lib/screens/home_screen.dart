import 'dart:convert';

import 'package:correcting_time/listOfLessons.dart';
import 'package:correcting_time/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import "package:graphql_flutter/graphql_flutter.dart";
import 'package:hive/hive.dart';
import '../queriesGQL.dart';
import 'search_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Box likedLessonsBox;
  Box allLessonsBox;
  int skipNumber = 0;
  int totalLessons = 500;
  int totalLessonsOnServer;
  var fetchTotalNumberWidget;

  @override
  void initState() {
    super.initState();
    likedLessonsBox = Hive.box("likedLessons");
    allLessonsBox = Hive.box("allLessons");
    // fetchTotalNumberWidget = Query(
    //   options: QueryOptions(
    //     documentNode: gql(getTotalLessonsNumber),
    //   ),
    //   builder: (QueryResult result,
    //       {VoidCallback refetch, FetchMore fetchMore}) {
    //     if (result.hasException) {
    //       return Text(
    //         result.exception.toString(),
    //       );
    //     }
    //
    //     if (result.loading) {
    //       return Text('Loading');
    //     }
    //
    //     totalLessonsOnServer = result.data['index']['total'];
    //     // totalLessonsOnServer++;
    //     build(context);
    //     print('Total Lessons in Query: $totalLessonsOnServer');
    //     return Container(
    //       color: totalLessonsOnServer == 559 ? Colors.red : Colors.blue,
    //       child: Text('Total Number of lessons fetched'),
    //     );
    //   },
    // );
    // print(totalLessonsOnServer);
    // if (totalLessonsOnServer == null) {
    //   totalLessonsOnServer = 558;
    // }
  }

  @override
  Widget build(BuildContext context) {
    totalLessons = allLessonsBox.length;
    print('TotalLessonsOnServer in build: $totalLessonsOnServer');
    print('Total lessons in DB $totalLessons');

    return Scaffold(
      appBar: AppBar(
        title: Text('11:11 - Correcting Time'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SearchScreen(),
                ),
              );
            },
          )
        ],
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Query(
                options: QueryOptions(
                  documentNode: gql(getTotalLessonsNumber),
                ),
                builder: (QueryResult result,
                    {VoidCallback refetch, FetchMore fetchMore}) {
                  if (result.hasException) {
                    totalLessonsOnServer = 558;
                  }

                  if (result.loading) {
                    return LoadingWidget();
                  }

                  if (!(result.hasException)) {
                    totalLessonsOnServer = result.data['index']['total'];
                    print('Total Lessons in Query: $totalLessonsOnServer');
                  }
                  // return Container(
                  //   color: totalLessonsOnServer == 559 ? Colors.red : Colors.blue,
                  //   child: Text('Total Number of lessons fetched'),
                  // );
                  return Expanded(
                    child: Container(
                      child: totalLessons <
                              totalLessonsOnServer //Hard-coded for now. Fetch this number from the GQL server later
                          ? Container(
                              height: 20,
                              // width: MediaQuery.of(context).size.width * 0.9,
                              child: Query(
                                options: QueryOptions(
                                  documentNode: gql(fetchAllQuery),
                                ),
                                builder: (QueryResult result,
                                    {VoidCallback refetch,
                                    FetchMore fetchMore}) {
                                  if (result.hasException) {
                                    return Center(
                                      child: Container(
                                        width: double.infinity,
                                        child: Text(
                                          'You need to be connected to the Internet for the first launch of the app.\nYou can use the offline later on',
                                          style: TextStyle(
                                            color:
                                                Theme.of(context).accentColor,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 16,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    );
                                  }

                                  if (result.loading) {
                                    return LoadingWidget();
                                  }

                                  List lessons =
                                      result.data['index']['transcripts'];

                                  var lesson;
                                  for (lesson in lessons) {
                                    allLessonsBox.add(jsonEncode(lesson));
                                  }

                                  // var startButton = Center(
                                  //   child: Container(
                                  //     height: 40,
                                  //     width: MediaQuery.of(context).size.width *
                                  //         0.4,
                                  //     child: RaisedButton(
                                  //         child: Text('Let\'s go'),
                                  //         onPressed: () {
                                  //           setState(() {
                                  //             totalLessons =
                                  //                 allLessonsBox.length;
                                  //           });
                                  //         }),
                                  //   ),
                                  // );

                                  // return startButton;
                                  return Column(
                                    children: [
                                      Expanded(
                                        child: SizedBox(
                                          child: ListView.builder(
                                            itemCount: allLessonsBox.length,
                                            itemBuilder: (context, index) {
                                              return ListOfLessons(
                                                index: index,
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            )
                          : Column(
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    child: ListView.builder(
                                      itemCount: allLessonsBox.length,
                                      itemBuilder: (context, index) {
                                        return ListOfLessons(
                                          index: index,
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                    ),
                  );
                },
              ),
              // Expanded(
              //   child: Container(
              //     child: totalLessons <
              //             totalLessonsOnServer //Hard-coded for now. Fetch this number from the GQL server later
              //         ? Container(
              //             height: 20,
              //             width: MediaQuery.of(context).size.width * 0.9,
              //             child: Query(
              //               options: QueryOptions(
              //                 documentNode: gql(fetchAllQuery),
              //               ),
              //               builder: (QueryResult result,
              //                   {VoidCallback refetch, FetchMore fetchMore}) {
              //                 if (result.hasException) {
              //                   return Text(
              //                     result.exception.toString(),
              //                   );
              //                 }
              //
              //                 if (result.loading) {
              //                   return Center(
              //                     child: Container(
              //                       child: Column(
              //                         mainAxisAlignment:
              //                             MainAxisAlignment.center,
              //                         children: [
              //                           CircularProgressIndicator(
              //                             strokeWidth: 2.0,
              //                           ),
              //                           SizedBox(
              //                             height: 10,
              //                           ),
              //                           Text(
              //                             'Downloading Transcripts...',
              //                             style: TextStyle(
              //                               color:
              //                                   Theme.of(context).accentColor,
              //                               fontWeight: FontWeight.w400,
              //                               fontSize: 16,
              //                             ),
              //                           ),
              //                         ],
              //                       ),
              //                     ),
              //                   );
              //                 }
              //
              //                 List lessons =
              //                     result.data['index']['transcripts'];
              //
              //                 var lesson;
              //                 for (lesson in lessons) {
              //                   allLessonsBox.add(jsonEncode(lesson));
              //                 }
              //
              //                 var startButton = Center(
              //                   child: Container(
              //                     height: 40,
              //                     width:
              //                         MediaQuery.of(context).size.width * 0.4,
              //                     child: RaisedButton(
              //                         child: Text('Let\'s go'),
              //                         onPressed: () {
              //                           setState(() {
              //                             totalLessons = allLessonsBox.length;
              //                           });
              //                         }),
              //                   ),
              //                 );
              //
              //                 return startButton;
              //               },
              //             ),
              //           )
              //         : Column(
              //             children: [
              //               Expanded(
              //                 child: SizedBox(
              //                   child: ListView.builder(
              //                     itemCount: allLessonsBox.length,
              //                     itemBuilder: (context, index) {
              //                       return ListOfLessons(
              //                         index: index,
              //                       );
              //                     },
              //                   ),
              //                 ),
              //               ),
              //             ],
              //           ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
