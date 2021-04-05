import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:pyramid/screen/welcomeScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;

  class BpfScreen extends StatefulWidget {
    @override
    _BpfScreenState createState() {
      return _BpfScreenState();
    }
  }
  
  class _BpfScreenState extends State<BpfScreen> {
    DateTime date1;
    DateTime date2;
    DateTime date3;

   var dt;
  TextEditingController systolicController = new TextEditingController();
  TextEditingController diastolicController = new TextEditingController();
  TextEditingController dtacc = new TextEditingController();

  addbpData() async {
    String systolic = systolicController.text;
    String diastolic = diastolicController.text;
    String dda = dtacc.text;
    final response = await http
        .post("https://pyramidpharmacy.com/rxcare/api/bpapi.php", body: {
      'hdate': dda,
      'systolic': systolic,
      'diastolic': diastolic,
      'name': fullname,
      'email': email,
      'user_id': id,
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
          "Thank you for updating your record. An update has been made to your Dashboard",
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
    Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF5DB09E),
        title: const Text('Bp Monitoring'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            TextFormField(
              controller: systolicController,
              decoration: InputDecoration(
                  icon: const Icon(Icons.texture),
                  labelText: 'systolic',
                  hasFloatingPlaceholder: false
              ),
               inputFormatters: [
                      WhitelistingTextInputFormatter.digitsOnly,
                    ],
            ),
            TextFormField(
              controller: diastolicController,
              decoration: InputDecoration(
                  icon: const Icon(Icons.texture),
                  labelText: 'diastolic',
                  hasFloatingPlaceholder: false
              ),
               inputFormatters: [
                      WhitelistingTextInputFormatter.digitsOnly,
                    ],
            ),
            DateTimePickerFormField(
              controller: dtacc,
              inputType: InputType.date,
              format: DateFormat("yyyy-MM-dd"),
              initialDate:DateTime.now(),
              editable: false,
              decoration: InputDecoration(
                  icon: const Icon(Icons.date_range),
                  labelText: 'Date',
                  hasFloatingPlaceholder: false
              ),
              onChanged: (dt) {
                setState(() => date2 = dt);
                print('Selected date: $date2');
              },
            ),
            SizedBox(height: 16.0),
            MaterialButton(
                  child: new Text('Submit Records'),
                  onPressed: () {
                    addbpData();
                  },
                  textColor: Colors.white,
                  color: Color(0xFF5DB09E),
                  padding: const EdgeInsets.only(left: 40, right: 30),
                ),
          ],
        ),
      )
    );
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
  
 