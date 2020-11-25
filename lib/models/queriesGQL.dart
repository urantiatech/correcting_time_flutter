String fetchLessonsQuery = """
    query fetchLessonsQuery (\$skip: Int!){
      index(lang:"en", sortby: "id", size: -1, skip: \$skip) {
        total,
        transcripts {
          header {
            id,
            slug
          },
          title,
          teachers,
          date,
          body,
          location,
          image
        }
      }
    }
    """;

String searchLessonsQuery = """
  query getSearchText(\$searchText: String!){
    search(query: \$searchText, lang: "en", size:-1){
        transcripts {
          header {
            id,
          },
      }
    }
  }
  """;

String totalNumberQuery = """
  query{
    index(lang:"en", sortby: "id") {
      total,
    }
  }
""";
