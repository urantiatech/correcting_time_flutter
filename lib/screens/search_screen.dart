import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  var _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () {},
          ),
        ],
        title: TextField(
          autofocus: true,
          controller: _controller,
          decoration: InputDecoration(
            // prefixIcon: Icon(
            //   Icons.search,
            //   color: Colors.black38,
            // ),
            hintText: 'Search lessons',
          ),
          // onChanged: searchLesson(searchString: _controller.text),
          onChanged: (String value) {
            print(value);
          },
        ),
      ),
    );
  }

  // void searchLesson({String searchString}) {
  //   print('-----------------');
  //   print(searchString);
  // }
}
