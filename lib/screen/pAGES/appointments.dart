import 'dart:convert';

import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:datetime_picker_formfield/time_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pyramid/screen/welcomeScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;

class AppointMent extends StatefulWidget {
  // AppointMent({Key key, this.title}) : super(key: key);
  // final String title;

  @override
  _AppointMentState createState() => new _AppointMentState();
}

class _AppointMentState extends State<AppointMent> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  List<String> _colors = <String>['', 'red', 'green', 'blue', 'orange'];
  String _color = '';
  DateTime date2;
   final timeFormat = DateFormat("h:mm a");
  // DateTime date;
  TimeOfDay time;

  TextEditingController subjectController = new TextEditingController();
  TextEditingController priorityController = new TextEditingController();
  TextEditingController messagesController = new TextEditingController();
  TextEditingController dtacc = new TextEditingController();
  TextEditingController timeController = new TextEditingController();

  addappoinData() async {
    String subject = subjectController.text;
    String priority = priorityController.text;
    String messages = messagesController.text;
    String dda = dtacc.text;
    String time = timeController.text;
    final response = await http
      .post("https://pyramidpharmacy.com/rxcare/api/appointapi.php", body: {
      'date': dda,
      'subject': subject,
      'priority': priority,
      'message': messages,
      'name': fullname,
      'email': email,
      'user_id': id,
      'time': time,
    });
    final data = jsonDecode(response.body);
    int value = data['value'];
    print(data);

    if (value == 0) {
      Toast.show("Error", context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.TOP,
          backgroundColor: Colors.red,
          textColor: Colors.white);
      //  });
    } else {
      Toast.show(
          "Successfully Booked",
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.TOP,
          backgroundColor: Colors.green,
          textColor: Colors.white);
      Navigator.push(
          context, new MaterialPageRoute(builder: (context) => WelcomScreen()));
    }
  }

  @override
  void initState() {
    super.initState();
    getCredential();
  }



  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Color(0xFF5DB09E),
        title: new Text("Book Appointment"),
      ),
      body: new SafeArea(
          top: false,
          bottom: false,
          child: new Form(
              key: _formKey,
              autovalidate: true,
              child: new ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                children: <Widget>[
                  new TextFormField(
                    controller: subjectController,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Enter your Subject',
                      labelText: 'Subject',
                    ),
                  ),
                  new DateTimePickerFormField(
                    controller: dtacc,
                    inputType: InputType.date,
                    format: DateFormat("yyyy-MM-dd"),
                    initialDate: DateTime.now(),
                    editable: false,
                    decoration: InputDecoration(
                      icon: const Icon(Icons.date_range),
                        labelText: 'Enter your prefer date',
                        hasFloatingPlaceholder: false),
                    onChanged: (dt) {
                      setState(() => date2 = dt);
                      print('Selected date: $date2');
                    },
                  ),
                  new TimePickerFormField(
                        controller: timeController,
                        format: timeFormat,
                        initialTime: TimeOfDay.now(),
                        decoration: InputDecoration(labelText: 'Time',
                        icon: const Icon(Icons.timer),
                        hasFloatingPlaceholder: false
                        ),
                        onChanged: (t) => setState(() => time = t),
                      ),
                  new TextFormField(
                    controller: priorityController,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.textsms),
                      hintText: 'Ex: Emegency, Urgent, Normal',
                      labelText: 'Prioirity',
                    ),
                    keyboardType: TextInputType.text,
                    // inputFormatters: [
                    //   WhitelistingTextInputFormatter.digitsOnly,
                    // ],
                  ),
                  new TextFormField(
                    controller: messagesController,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.email),
                      hintText: 'Enter a email address',
                      labelText: 'messages',
                    ),
                    keyboardType: TextInputType.text,
                  ),
                  new Container(
                    padding: const EdgeInsets.only(left: 40.0, top: 20.0),
                    child: new MaterialButton(
                      child: new Text('Book Now '),
                      onPressed: () {
                         addappoinData();
                      },
                      textColor: Colors.white,
                      color: Color(0xFF5DB09E),
                      padding: const EdgeInsets.only(left: 40, right: 30),
                    ),
                  ),
                ],
              ))),
    );
  
}
SharedPreferences sharedPreferences;
  String fullname = "",
      phone = "",
      email = "",
      id = "",
      gender = "",
      image = "",
      wallet = "";
  getCredential() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      fullname = sharedPreferences.getString("fullname");
      phone = sharedPreferences.getString("phone");
      email = sharedPreferences.getString("email");
      gender = sharedPreferences.getString("gender");
      image = sharedPreferences.getString("image");
      wallet = sharedPreferences.getString("wallet");
      id = sharedPreferences.getString("id");
    });
    print(email);
    print(id);
  }

  }

class Contact {
  String name;
  DateTime dob;
  String phone = '';
  String email = '';
  String favoriteColor = '';
}
