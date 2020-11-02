import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class LessonScreen extends StatelessWidget {
  final String lessonTitle;
  final String slug;
  LessonScreen({@required this.slug, @required this.lessonTitle});
  final String fetchLesson = """
    query getSlug(\$slug: String!) {
      transcript(lang:"en", slug:\$slug){
        title,
        teachers,
        date,
        image,
        location,
        body,
      }
    }
  """;
  @override
  Widget build(BuildContext context) {
    print(slug);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          lessonTitle,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(4),
          child: Column(
            children: [
              Expanded(
                child: Container(
                  child: Query(
                    options: QueryOptions(
                      documentNode: gql(
                          fetchLesson), // this is the query string you just created
                      variables: {
                        'slug': slug,
                      },
                      // pollInterval: 60,
                    ),
                    // Just like in apollo refetch() could be used to manually trigger a refetch
                    // while fetchMore() can be used for pagination purpose
                    builder: (QueryResult result,
                        {VoidCallback refetch, FetchMore fetchMore}) {
                      if (result.hasException) {
                        return Text(result.exception.toString());
                      }

                      if (result.loading) {
                        return Text('Loading');
                      }

                      // it can be either Map or List
                      Map lesson = result.data['transcript'];
                      print(lesson);

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Text(
                                  "Teachers: " + lesson['teachers'][0],
                                  style: TextStyle(
                                    // color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Text(
                                  "Date: " + lesson['date'],
                                  style: TextStyle(
                                    // color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Html(
                                data: lesson['body'],
                              ),
                              Image.network(
                                lesson['image'],
                                width: MediaQuery.of(context).size.width,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Text(
                                  "Location: " + lesson['location'],
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 17,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 16,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
