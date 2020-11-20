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
String fetchAllQuery = """
    query {
      index(lang:"en", sortby: "id", size: -1) {
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
// String searchLessons = """
//   query getSearchText(\$searchText: String!){
//     search(query: \$searchText, lang: "en", size:-1){
//       total,
//         transcripts {
//           header {
//             id,
//             slug
//           },
//         title,
//         teachers,
//         date,
//         image,
//       }
//     }
//   }
//   """;
String searchLessons = """
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
String getTotalLessonsNumber = """
  query{
    index(lang:"en", sortby: "id") {
      total,
    }
  }
""";
