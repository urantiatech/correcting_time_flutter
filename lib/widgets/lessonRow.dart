import 'dart:convert';

import 'package:correcting_time/screens/lesson_details.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import '../constants.dart';

class ListOfLessons extends StatefulWidget {
  final index;
  ListOfLessons({@required this.index});
  @override
  _ListOfLessonsState createState() => _ListOfLessonsState();
}

class _ListOfLessonsState extends State<ListOfLessons> {
  Box likedLessonsBox;
  Box allLessonsBox;

  @override
  void initState() {
    super.initState();
    likedLessonsBox = Hive.box("likedLessons");
    allLessonsBox = Hive.box("allLessons");
  }

  @override
  Widget build(BuildContext context) {
    double fullWidth =
        MediaQuery.of(context).size.width - paddingHorizontal * 2;
    Map lesson = jsonDecode(allLessonsBox.getAt(widget.index));
    bool isLiked;
    bool isRead;
    if (likedLessonsBox.get(lesson['header']['slug'] + "isLiked") == true) {
      isLiked = true;
    } else {
      isLiked = false;
    }
    if (likedLessonsBox.get(lesson['header']['slug'] + "isRead") == true) {
      isRead = true;
    } else {
      isRead = false;
    }
    final kTextStyle14 = TextStyle(
      color: Theme.of(context).accentColor,
      fontWeight: FontWeight.w600,
      fontSize: 14,
    );

    final kTextStyle16 = TextStyle(
      color: Theme.of(context).accentColor,
      fontWeight: FontWeight.w600,
      fontSize: 16,
    );

    final kTextStyle20 = TextStyle(
      color: Theme.of(context).accentColor,
      fontWeight: FontWeight.w600,
      fontSize: 20,
    );
    return Padding(
      padding: EdgeInsets.all(paddingHorizontal),
      child: GestureDetector(
        onTap: () {
          setState(
            () {
              likedLessonsBox.put(lesson['header']['slug'] + "isRead", true);
            },
          );
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LessonScreen(
                index: widget.index,
                lessonTitle: lesson['title'],
              ),
            ),
          );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: fullWidth * 0.18,
                  height: fullWidth * 0.18,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      width: 5,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  child: Image.network(
                    lesson['image'] == null ? 'Null URL' : lesson['image'],
                    fit: BoxFit.fill,
                  ),
                ),
                SizedBox(
                  width: fullWidth * 0.02,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: fullWidth * 0.60,
                      child: Text(
                        lesson['title'],
                        overflow: TextOverflow.ellipsis,
                        style: kTextStyle20,
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Container(
                      width: fullWidth * 0.60,
                      child: Text(
                        lesson['teachers'].length == 0
                            ? 'No data found'
                            : lesson['teachers'][0],
                        overflow: TextOverflow.ellipsis,
                        style: kTextStyle16,
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Container(
                      width: fullWidth * 0.60,
                      child: Text(
                        DateFormat('EEEE, d MMMM y').format(
                          DateTime.parse((lesson['date']).toString()),
                        ),
                        style: kTextStyle14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Column(
              children: [
                Container(
                  width: fullWidth * 0.12,
                  child: IconButton(
                    icon: isLiked
                        ? Icon(Icons.favorite)
                        : Icon(Icons.favorite_border),
                    iconSize: 30.0,
                    color: isLiked ? Colors.red[400] : Colors.blueGrey,
                    onPressed: () {
                      setState(
                        () {
                          likedLessonsBox.put(
                              lesson['header']['slug'] + "isLiked", !isLiked);
                        },
                      );
                    },
                  ),
                ),
                Container(
                  width: fullWidth * 0.12,
                  child: IconButton(
                    icon: isRead
                        ? Icon(Icons.radio_button_checked)
                        : Icon(Icons.radio_button_unchecked),
                    iconSize: 30.0,
                    color: isRead ? Colors.blueGrey[300] : Colors.blueGrey,
                    onPressed: () {
                      setState(
                        () {
                          likedLessonsBox.put(
                              lesson['header']['slug'] + "isRead", !isRead);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
