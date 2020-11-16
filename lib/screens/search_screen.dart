import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'lesson_screen.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

int displayNumberStart = 0;
int displayNumberEnd = 0;
int totalLessons = 500;

class _SearchScreenState extends State<SearchScreen> {
  dynamic controllerSearch = TextEditingController();
  bool showNextButton = true;
  int skipNumber = 0;
  String searchLessons = """
  query getSearchText(\$searchText: String!, \$skip: Int!){
    search(query: \$searchText, lang: "en", skip:\$skip){
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
  Widget build(BuildContext context) {
    displayNumberStart = skipNumber + 1;
    displayNumberEnd = skipNumber + 10;
    showNextButton = !(displayNumberEnd >= (totalLessons));
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
              skipNumber = 0;
              print(value);
            });
          },
        ),
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
                  child: QuerySearchWidget(
                    searchLessons: searchLessons,
                    searchText: controllerSearch.text,
                    skipNumber: skipNumber,
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

class QuerySearchWidget extends StatelessWidget {
  QuerySearchWidget({
    @required this.searchLessons,
    @required this.searchText,
    @required this.skipNumber,
  });

  final String searchLessons;
  final searchText;
  final int skipNumber;

  @override
  Widget build(BuildContext context) {
    return Query(
      options: QueryOptions(
        documentNode: gql(searchLessons),
        variables: {'searchText': searchText, 'skip': skipNumber},
      ),
      builder: (QueryResult result,
          {VoidCallback refetch, FetchMore fetchMore}) {
        if (result.hasException) {
          return Text(result.exception.toString());
        }

        if (result.loading) {
          return Text('Loading');
        }

        List lessons = result.data['search']['transcripts'];
        totalLessons = result.data['search']['total'];
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
                style: TextStyle(
                  color: Theme.of(context).accentColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
            lessons == null
                ? Text(
                    'No lessons found\nPlease try inputting a different text',
                    style: TextStyle(
                      color: Theme.of(context).accentColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 22,
                    ),
                  )
                : Expanded(
                    child: SizedBox(
                      child: ListView.builder(
                        itemCount: lessons.length,
                        itemBuilder: (context, index) {
                          final lesson = lessons[index];

                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
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
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(
                                        width: 5,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                    child: Image.network(
                                      lesson['image'],
                                      width: 80,
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
                                            MediaQuery.of(context).size.width *
                                                0.70,
                                        child: Text(
                                          lesson['title'],
                                          style: TextStyle(
                                            color:
                                                Theme.of(context).accentColor,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 22,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.70,
                                        child: Text(
                                          lesson['teachers'][0],
                                          style: TextStyle(
                                            color:
                                                Theme.of(context).accentColor,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.70,
                                        child: Text(
                                          lesson['date'],
                                          style: TextStyle(
                                            color:
                                                Theme.of(context).accentColor,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
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
    );
  }
}
