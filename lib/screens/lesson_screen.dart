import 'package:correcting_time/models/lesson_model.dart';
import 'package:flutter/material.dart';

class LessonScreen extends StatelessWidget {
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
          child: Column(
            children: [
              Text(
                "Teachers: " + periodOfRecess.teachers,
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
            ],
          ),
        ),
      ),
    );
  }
}
