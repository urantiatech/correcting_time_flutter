import 'dart:convert';

import 'package:correcting_time/widgets/lessonRow.dart';
import 'package:correcting_time/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import "package:graphql_flutter/graphql_flutter.dart";
import 'package:hive/hive.dart';
import '../models/queriesGQL.dart';
import 'search_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Box likedLessonsBox;
  Box allLessonsBox;
  int totalLessons;
  int totalLessonsOnServer;

  @override
  void initState() {
    super.initState();
    likedLessonsBox = Hive.box("likedLessons");
    allLessonsBox = Hive.box("allLessons");
  }

  @override
  Widget build(BuildContext context) {
    totalLessons = allLessonsBox.length;
    // // For testing whether it fetches only the new lessons or not
    // totalLessons = 557;
    // // For testing when the local db has more transcripts than server
    // totalLessons = 800;
    debugPrint('Total lessons in local DB $totalLessons');

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
                  documentNode: gql(totalNumberQuery),
                ),
                builder: (QueryResult result,
                    {VoidCallback refetch, FetchMore fetchMore}) {
                  var refresh = refetch;
                  if (result.hasException) {
                    totalLessonsOnServer = totalLessons;
                  }

                  if (result.loading) {
                    return LoadingWidget();
                  }

                  if (!(result.hasException)) {
                    totalLessonsOnServer = result.data['index']['total'];
                    debugPrint(
                        'Total Lessons on server: $totalLessonsOnServer');
                  }
                  return Expanded(
                    child: Container(
                      child: totalLessons < totalLessonsOnServer
                          ? Container(
                              height: 20,
                              child: Query(
                                options: QueryOptions(
                                  documentNode: gql(fetchLessonsQuery),
                                  variables: {'skip': totalLessons},
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
                                  totalLessons = allLessonsBox.length;
                                  return LessonsListView(
                                    allLessonsBox: allLessonsBox,
                                    refetchQuery: refresh,
                                  );
                                },
                              ),
                            )
                          : totalLessons == totalLessonsOnServer
                              ? LessonsListView(
                                  allLessonsBox: allLessonsBox,
                                  refetchQuery: refresh,
                                )
                              : Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'ERROR\nDatabase has been tampered\nPlease Re-Initialise the Database and Restart the App',
                                          style: TextStyle(
                                            color:
                                                Theme.of(context).accentColor,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 16,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        RaisedButton(
                                          onPressed: () {
                                            print('QUIT BUTTON PRESSED');
                                            allLessonsBox.deleteFromDisk();
                                            likedLessonsBox.deleteFromDisk();
                                            SystemNavigator.pop();
                                          },
                                          child: Text(
                                              'Re-Initialise the Database'),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// List allTeachers = new List();
// List distinctTeachers = new List();

class LessonsListView extends StatelessWidget {
  const LessonsListView({
    @required this.allLessonsBox,
    @required this.refetchQuery,
  });

  final Box allLessonsBox;
  final refetchQuery;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SizedBox(
            child: RefreshIndicator(
              onRefresh: refetchQuery,
              child: ListView.builder(
                itemCount: allLessonsBox.length,
                itemBuilder: (context, index) {
                  // allTeachers.add(
                  //     jsonDecode(allLessonsBox.getAt(index))['teachers']
                  //         .join(', '));
                  // distinctTeachers = allTeachers.toSet().toList();
                  // debugPrint(distinctTeachers.toString());
                  return ListOfLessons(
                    index: allLessonsBox.length - 1 - index,
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
