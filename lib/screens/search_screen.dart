import 'package:correcting_time/listOfLessons.dart';
import 'package:correcting_time/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../queriesGQL.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

// int totalLessons = 500;
bool displayResult = false;

class _SearchScreenState extends State<SearchScreen> {
  dynamic controllerSearch = TextEditingController();
  bool showNextButton = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          autofocus: true,
          controller: controllerSearch,
          decoration: InputDecoration(
            hintText: 'Search lessons',
          ),
          onChanged: (String value) {
            setState(() {
              displayResult = true;
              print(value);
            });
          },
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Container(
            //   alignment: Alignment.center,
            // ),
            Expanded(
              child: Container(
                child: QuerySearchWidget(
                  searchLessons: searchLessons,
                  searchText: controllerSearch.text,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class QuerySearchWidget extends StatelessWidget {
  QuerySearchWidget({
    @required this.searchLessons,
    @required this.searchText,
  });

  final String searchLessons;
  final searchText;

  @override
  Widget build(BuildContext context) {
    // double fullWidth =
    //     MediaQuery.of(context).size.width - paddingHorizontal * 2;
    // final kTextStyle14 = TextStyle(
    //   color: Theme.of(context).accentColor,
    //   fontWeight: FontWeight.w600,
    //   fontSize: 14,
    // );
    //
    // final kTextStyle16 = TextStyle(
    //   color: Theme.of(context).accentColor,
    //   fontWeight: FontWeight.w600,
    //   fontSize: 16,
    // );
    //
    // final kTextStyle22 = TextStyle(
    //   color: Theme.of(context).accentColor,
    //   fontWeight: FontWeight.w600,
    //   fontSize: 22,
    // );
    return Query(
      options: QueryOptions(
        documentNode: gql(searchLessons),
        variables: {'searchText': searchText},
      ),
      builder: (QueryResult result,
          {VoidCallback refetch, FetchMore fetchMore}) {
        if (result.hasException) {
          return Center(
            child: Container(
              width: double.infinity,
              child: Text(
                'You need to be connected to the Internet to access Search functionality',
                style: TextStyle(
                  color: Theme.of(context).accentColor,
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        if (result.loading) {
          return Visibility(
            visible: displayResult,
            child: LoadingWidget(),
          );
        }

        List lessons = result.data['search']['transcripts'];
        // totalLessons = result.data['search']['total'];

        return Visibility(
          visible: displayResult,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              lessons == null
                  ? Center(
                      child: Container(
                        width: double.infinity,
                        child: Text(
                          'No lessons found\nPlease try inputting a different text',
                          style: TextStyle(
                            color: Theme.of(context).accentColor,
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  : Expanded(
                      child: SizedBox(
                        child: ListView.builder(
                          itemCount: lessons.length,
                          itemBuilder: (context, index) {
                            final lesson = lessons[index];
                            var indexString = lesson['header']['id'];
                            // print(indexString);
                            var indexNumerical =
                                int.parse(indexString.split('-')[2]) - 1;
                            // print(indexNumerical);

                            return ListOfLessons(index: indexNumerical);

                            // return Padding(
                            //   padding: EdgeInsets.all(paddingHorizontal),
                            //   child: GestureDetector(
                            //     onTap: () {
                            //       Navigator.push(
                            //         context,
                            //         MaterialPageRoute(
                            //           builder: (context) => LessonScreen(
                            //             // slug: lesson['header']['slug'],
                            //             index:
                            //                 indexNumerical,
                            //             lessonTitle: lesson['title'],
                            //           ),
                            //         ),
                            //       );
                            //     },
                            //     child: Row(
                            //       children: [
                            //         Container(
                            //           width: fullWidth * 0.18,
                            //           height: fullWidth * 0.18,
                            //           decoration: BoxDecoration(
                            //             borderRadius: BorderRadius.circular(6),
                            //             border: Border.all(
                            //               width: 5,
                            //               color: Theme.of(context).primaryColor,
                            //             ),
                            //           ),
                            //           child: Image.network(
                            //             lesson['image'] == null
                            //                 ? 'Null URL'
                            //                 : lesson['image'],
                            //           ),
                            //         ),
                            //         SizedBox(
                            //           width: fullWidth * 0.02,
                            //         ),
                            //         Column(
                            //           crossAxisAlignment:
                            //               CrossAxisAlignment.start,
                            //           children: [
                            //             Container(
                            //               width: fullWidth * 0.70,
                            //               child: Text(
                            //                 lesson['title'],
                            //                 style: kTextStyle22,
                            //               ),
                            //             ),
                            //             SizedBox(
                            //               height: 8,
                            //             ),
                            //             Container(
                            //               width: fullWidth * 0.70,
                            //               child: Text(
                            //                 lesson['teachers'].length == 0
                            //                     ? 'No data found'
                            //                     : lesson['teachers'][0],
                            //                 style: kTextStyle16,
                            //               ),
                            //             ),
                            //             SizedBox(
                            //               height: 8,
                            //             ),
                            //             Container(
                            //               width: fullWidth * 0.70,
                            //               child: Text(
                            //                 lesson['date'],
                            //                 style: kTextStyle14,
                            //               ),
                            //             ),
                            //           ],
                            //         ),
                            //       ],
                            //     ),
                            //   ),
                            // );
                          },
                        ),
                      ),
                    ),
            ],
          ),
        );
      },
    );
  }
}
