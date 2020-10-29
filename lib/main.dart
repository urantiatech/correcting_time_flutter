import 'package:correcting_time/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import "package:graphql_flutter/graphql_flutter.dart";

void main() => runApp(
      MyApp(),
    );

// void main() {
//   runApp(
//     MyApp(),
//   );
// }

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final HttpLink httpLink =
        HttpLink(uri: 'https://gql.correctingtime.org/query');

    ValueNotifier<GraphQLClient> client = ValueNotifier<GraphQLClient>(
      GraphQLClient(
        cache: InMemoryCache(),
        link: httpLink,
      ),
    );

    return GraphQLProvider(
      client: client,
      child: MaterialApp(
        title: 'Correcting Time',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Color(0xFFD1AF67),
          accentColor: Color(0xFFa2825c),
        ),
        home: HomeScreen(),
      ),
    );
  }
}

class HomeScreen3 extends StatelessWidget {
  final String readLessons = """
  query {
    index(lang:"en", sortby: "id") {
      total,
      transcripts {
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
    return Scaffold(
      body: Center(
        child: SafeArea(
          child: Column(
            children: [
              Text(
                'Hello world',
                style: TextStyle(
                  fontSize: 30,
                ),
              ),
              Container(
                color: Colors.red[50],
                width: 300,
                height: 600,
                child: Query(
                  options: QueryOptions(
                    documentNode: gql(
                        readLessons), // this is the query string you just created
                    // variables: {
                    //   'nRepositories': 50,
                    // },
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
                    List repositories = result.data['index']['transcripts'];

                    return ListView.builder(
                        itemCount: repositories.length,
                        itemBuilder: (context, index) {
                          final repository = repositories[index];
                          print(repository);

                          return Column(
                            children: [
                              Text(repository['title']),
                            ],
                          );
                        });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeScreen2 extends StatelessWidget {
  final String readCountries = """
  query ReadCountries {
    countries {
      code
      name
      currency
      emoji
    }
  } 
  """;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SafeArea(
          child: Column(
            children: [
              Text(
                'Hello world',
                style: TextStyle(
                  fontSize: 30,
                ),
              ),
              Container(
                color: Colors.red[50],
                width: 300,
                height: 600,
                child: Query(
                  options: QueryOptions(
                    documentNode: gql(
                        readCountries), // this is the query string you just created
                    // variables: {
                    //   'nRepositories': 50,
                    // },
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
                    List repositories = result.data['countries'];

                    return ListView.builder(
                        itemCount: repositories.length,
                        itemBuilder: (context, index) {
                          final repository = repositories[index];
                          print(repository);

                          return Column(
                            children: [
                              Text("code: " + repository['code']),
                              Text("name: " + repository['name']),
                              Text("emoji: " + repository['emoji'] + "\n"),
                            ],
                          );
                        });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
