import 'dart:async';
import 'package:timerack/register.dart';

import 'globals.dart' as globals;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timerack/timerack.dart';
import 'package:camera/camera.dart';

//void main() => runApp(new TimeRackApp());
Future<Null> main() async {
  globals.cameras = await availableCameras();
  globals.prefs = await SharedPreferences.getInstance();
  runApp(new TimeRackApp());
}
class TimeRackApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      color: Colors.green,
      home: new Splash(),
      theme: new ThemeData(
        primarySwatch: Colors.orange,
      ),
    );
  }
}

class Splash extends StatefulWidget {
  @override
  SplashState createState() => new SplashState();
}

class SplashState extends State<Splash> {

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor:Colors.white,
        body: new InkWell(
          child:new Stack(
            fit: StackFit.expand,
            children: <Widget>[
              new Container(
                decoration: BoxDecoration(color: Colors.green),
              ),
              new Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  new Expanded(
                    flex: 2,
                    child: new Container(
                        child: new Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            new CircleAvatar(
                              backgroundColor: Colors.transparent,
                              child: new Container(
                                  child: new Image.network("")
                              ),
                              radius: 100,
                            ),
                            new Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                            ),
                            new Text("Time Rack")
                          ],
                        )),
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[

                        CircularProgressIndicator(
                          valueColor: new AlwaysStoppedAnimation<Color>(Colors.red),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                        ),
                        Text("Loading",style: new TextStyle()
                        ),
                        new Center(
                          child: Text("Now",style: new TextStyle()
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }

  Future checkFirstSeen() async {
    bool _seen = (globals.prefs.getBool('seen') ?? false);
    if (_seen) {
      Navigator.of(context).pushReplacement(
          new MaterialPageRoute(builder: (context) => new TimeRackHome()));
    } else {
      Navigator.of(context).pushReplacement(
          new MaterialPageRoute(builder: (context) => new Register()));
    }
  }

  @override
  void initState() {
    super.initState();
    new Timer(new Duration(seconds: 3), () {
      checkFirstSeen();
    });
  }
}