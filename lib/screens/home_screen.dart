import 'dart:io';

import 'package:correcting_time/screens/lesson_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import "package:graphql_flutter/graphql_flutter.dart";
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'search_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Box likedLessonsBox;
  bool showNextButton = true;
  int skipNumber = 0;
  int displayNumberStart = 0;
  int displayNumberEnd = 0;
  int totalLessons = 500;
  String readLessons = """
  query getPage(\$skip: Int!){
    index(lang:"en", sortby: "id", skip:\$skip) {
      total,
      transcripts {
        header {
          slug
          },
      title,
      teachers,
      date,
      image,
      }
    }
  }
  """;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    likedLessonsBox = Hive.box("likedLessons");
  }

  @override
  Widget build(BuildContext context) {
    displayNumberStart = skipNumber + 1;
    displayNumberEnd = skipNumber + 10;
    showNextButton = !(displayNumberEnd >= (totalLessons));

    final kTextStyle14 = TextStyle(
      color: Theme.of(context).accentColor,
      fontWeight: FontWeight.w600,
      fontSize: 14,
    );

    final kTextStyle16 = TextStyle(
      color: Theme.of(context).accentColor,
      fontWeight: FontWeight.w600,
      fontSize: 16,
    );

    final kTextStyle22 = TextStyle(
      color: Theme.of(context).accentColor,
      fontWeight: FontWeight.w600,
      fontSize: 22,
    );

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
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Column(
            children: [
              Container(
                alignment: Alignment.center,
              ),
              Expanded(
                child: Container(
                  child: Query(
                    options: QueryOptions(
                      documentNode: gql(readLessons),
                      variables: {
                        'skip': skipNumber, // used to be nRepositories
                      },
                      // pollInterval: 60, // not required for CT app, this is refresh interval in seconds
                    ),
                    builder: (QueryResult result,
                        {VoidCallback refetch, FetchMore fetchMore}) {
                      if (result.hasException) {
                        return Text(result.exception.toString());
                      }

                      if (result.loading) {
                        return Text('Loading');
                      }

                      // it can be either Map or List
                      List lessons = result.data['index']['transcripts'];
                      totalLessons = result.data['index']['total'];
                      // print(totalLessons);
                      if (displayNumberEnd > totalLessons) {
                        displayNumberEnd = totalLessons;
                      }

                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text(
                              'Displaying $displayNumberStart-$displayNumberEnd of $totalLessons',
                              style: kTextStyle16,
                            ),
                          ),
                          Expanded(
                            child: SizedBox(
                              child: ListView.builder(
                                itemCount: lessons.length,
                                itemBuilder: (context, index) {
                                  final lesson = lessons[index];
                                  bool isLiked;
                                  if (likedLessonsBox
                                          .get(lesson['header']['slug']) ==
                                      true) {
                                    isLiked = true;
                                  } else {
                                    isLiked = false;
                                  }

                                  return Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 8),
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => LessonScreen(
                                              slug: lesson['header']['slug'],
                                              lessonTitle: lesson['title'],
                                            ),
                                          ),
                                        );
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.20,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                  border: Border.all(
                                                    width: 5,
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                  ),
                                                ),
                                                // child: Image.asset('images/Period_of_Recess.jpg'),
                                                child: Image.network(
                                                  lesson['image'],
                                                ),
                                              ),
                                              SizedBox(
                                                width: 8,
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.60,
                                                    child: Text(
                                                      lesson['title'],
                                                      style: kTextStyle22,
                                                    ),
                                                  ),
                                                  // Text(lesson['title']),
                                                  SizedBox(
                                                    height: 8,
                                                  ),
                                                  Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.60,
                                                    child: Text(
                                                      lesson['teachers'][0],
                                                      style: kTextStyle16,
                                                    ),
                                                  ),
                                                  // Text(lesson['teachers'][0]),
                                                  SizedBox(
                                                    height: 8,
                                                  ),
                                                  Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.60,
                                                    child: Text(
                                                      lesson['date'],
                                                      style: kTextStyle14,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          IconButton(
                                            icon: isLiked
                                                ? Icon(Icons.favorite)
                                                : Icon(Icons.favorite_border),
                                            iconSize: 30.0,
                                            color: isLiked
                                                ? Colors.red[400]
                                                : Colors.blueGrey,
                                            onPressed: () {
                                              setState(
                                                () {
                                                  likedLessonsBox.put(
                                                      lesson['header']['slug'],
                                                      !isLiked);
                                                },
                                              );
                                              print(isLiked);
                                            },
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.01,
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RaisedButton(
                    child: Text('Previous'),
                    onPressed: skipNumber == 0
                        ? null
                        : () {
                            setState(
                              () {
                                skipNumber -= 10;
                              },
                            );
                          },
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  RaisedButton(
                    child: Text('Next'),
                    // onPressed: () {
                    //   setState(() {
                    //     skipNumber += 10;
                    //   });
                    // }
                    onPressed: showNextButton
                        ? () {
                            setState(
                              () {
                                skipNumber += 10;
                              },
                            );
                          }
                        : null,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
