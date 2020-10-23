import 'package:correcting_time/models/lesson_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class LessonScreen extends StatelessWidget {
  final htmlData = """<h1>Hello</h1>""";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          periodOfRecess.title,
        ),
      ),
      // backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  " Teachers: " + periodOfRecess.teachers,
                  style: TextStyle(
                    // color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w400,
                    fontSize: 18,
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                // Text(periodOfRecess.body),
                Html(
                  data: periodOfRecess.body,
                ),
                SizedBox(
                  height: 8,
                ),
                Image.network(
                  periodOfRecess.image,
                  width: MediaQuery.of(context).size.width,
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  "Location: " + periodOfRecess.location,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 17,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
