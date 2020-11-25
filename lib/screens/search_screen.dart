import 'package:correcting_time/widgets/lessonRow.dart';
import 'package:correcting_time/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../models/queriesGQL.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

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
            Expanded(
              child: Container(
                child: QuerySearchWidget(
                  searchLessons: searchLessonsQuery,
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
                            var indexNumerical =
                                int.parse(indexString.split('-')[2]) - 1;

                            return ListOfLessons(index: indexNumerical);
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
