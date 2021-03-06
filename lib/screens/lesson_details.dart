import 'dart:convert';

import 'package:correcting_time/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart';
import 'package:hive/hive.dart';
import 'package:share/share.dart';
import 'package:html/parser.dart';

class LessonScreen extends StatefulWidget {
  final String lessonTitle;
  final int index;

  LessonScreen({@required this.index, @required this.lessonTitle});

  @override
  _LessonScreenState createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {
  Box allLessonsBox;
  @override
  void initState() {
    super.initState();
    allLessonsBox = Hive.box("allLessons");
  }

  @override
  Widget build(BuildContext context) {
    Map lesson = jsonDecode(allLessonsBox.getAt(widget.index));
    var document = parse(lesson['body']);
    String lessonBody = parse(document.body.text).documentElement.text;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.lessonTitle,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Container(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(paddingHorizontal),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(
                            "Teacher: " + lesson['teachers'].join(', '),
                            style: TextStyle(
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
                            'Date: ' +
                                DateFormat('EEEE, d MMMM y').format(
                                  DateTime.parse((lesson['date']).toString()),
                                ),
                            style: TextStyle(
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
                        SizedBox(
                          height: 16,
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
                ),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Share.share(
            'Teacher: ${lesson['teachers'][0]} \nDate: ${DateFormat('EEEE, d MMMM y').format(
              DateTime.parse((lesson['date']).toString()),
            )}\nLocation: ${lesson['location']}\n\n$lessonBody',
            subject: lesson['title'],
          );
        },
        child: Icon(Icons.share),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }
}
