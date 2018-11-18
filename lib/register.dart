import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timerack/models/user.dart';
import 'package:timerack/timerack.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'globals.dart' as globals;
import 'package:flutter/services.dart';
class Register extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return RegisterState();
  }
}
class RegisterState extends State<Register>{
  final _formKey = GlobalKey<FormState>();
  User user = new User();
  String result="Click Camera button to scan your QR Code";
  SharedPreferences prefs;
  @override
  void initState () {
    super.initState();
    prefs = globals.prefs;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Time Rack - Register'),
      ),
      body: Center(
        child: Text(
          result,
          style: new TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.camera_alt),
        label: Text("Scan"),
        onPressed: _scanQR,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
  /*@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Time Rack - Register'),
      ),
      body: new Form(
      key: _formKey,
        child: new ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          children:<Widget>[
          TextFormField(
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter name';
              }
            },
            decoration: const InputDecoration(
              icon: const Icon(Icons.person),
              hintText: 'Enter your first and last name',
              labelText: 'Name',
            ),
            onSaved: (val) => user.name=val,
          ),
          TextFormField(
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter company name';
              }
            },
            decoration: const InputDecoration(
              icon: const Icon(Icons.work),
              hintText: 'Enter your company name',
              labelText: 'Name',
            ),
            onSaved: (val) => user.companyName=val,
          ),
          TextFormField(
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter employee code';
              }
            },
            decoration: const InputDecoration(
              icon: const Icon(Icons.assignment_ind),
              hintText: 'Enter your employee code',
              labelText: 'Name',
            ),
            onSaved: (val) => user.empCode=val,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: RaisedButton(
              onPressed: () {
                // Validate will return true if the form is valid, or false if
                // the form is invalid.
                if (_formKey.currentState.validate()) {
                  _formKey.currentState.save();
                  prefs.setString("personName",user.name);
                  prefs.setString("companyName",user.companyName);
                  prefs.setString("empCode",user.empCode);
                  // If the form is valid, we want to show a Snackbar
                  Navigator.of(context).pushReplacement(
                      new MaterialPageRoute(builder: (context) => new TimeRackHome()));
                  Scaffold.of(context)
                      .showSnackBar(SnackBar(content: Text('Processing Data')));
                }
              },
              child: Text('Save'),
            ),
          ),
        ],
        ),
      ),
    );
  }*/

  Future _scanQR() async {
    try {
      String qrResult = await BarcodeScanner.scan();
      setState(() {
        result = qrResult;
        result = "DJ_Sgh_008";
        if(result.split("_").length<3){
          result = "Invalid QR Code";
        }else {
          prefs.setString("personName", result.split("_")[0]);
          prefs.setString("companyName", result.split("_")[1]);
          prefs.setString("empCode", result.split("_")[2]);
          prefs.setBool("seen", true);
          Navigator.of(context).pushReplacement(
              new MaterialPageRoute(builder: (context) => new TimeRackHome()));
        }
      });
    } on PlatformException catch (ex) {
      if (ex.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          result = "Camera permission was denied";
        });
      } else {
        setState(() {
          result = "Unknown Error $ex";
        });
      }
    } on FormatException {
      setState(() {
        result = "You pressed the back button before scanning anything";
      });
    } catch (ex) {
      setState(() {
        result = "Unknown Error $ex";
      });
    }
  }
}