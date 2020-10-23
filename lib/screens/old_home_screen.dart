import 'package:correcting_time/models/lesson_model.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('images/logo.png'),
            SizedBox(
              height: 30,
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  width: 5,
                  color: Theme.of(context).accentColor,
                ),
              ),
              // child: Image.asset('images/Period_of_Recess.jpg'),
              child: Image.network(
                periodOfRecess.image,
                width: 300,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              periodOfRecess.title,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 30,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
