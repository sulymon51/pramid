import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:http/http.dart' as http;
import 'package:pyramid/screen/welcomeScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class SugarfScreen extends StatefulWidget {
  @override
  _SugarfScreenState createState() {
    return _SugarfScreenState();
  }
}

class _SugarfScreenState extends State<SugarfScreen> {
  DateTime date1;
  DateTime date2;
  DateTime date3;

  var dt;
  // final diabetesController = TextEditingController();
  TextEditingController diabetesController = new TextEditingController();
  TextEditingController dtacc = new TextEditingController();
  addsugData() async {
    String diabetes = diabetesController.text;
    String dda = dtacc.text;
    final response = await http
        .post("https://pyramidpharmacy.com/rxcare/api/sugapi.php", body: {
      'ddate': dda,
      'diabetes': diabetes,
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
        title: const Text('Sgurar Monitoring'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            TextFormField(
              controller: diabetesController,
              decoration: InputDecoration(
                  icon: const Icon(Icons.texture),
                  labelText: 'mg/dL',
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
              initialDate: DateTime.now(),
              editable: false,
              decoration: InputDecoration(
                  icon: const Icon(Icons.date_range),
                  labelText: 'Date',
                  hasFloatingPlaceholder: false),
              onChanged: (dt) {
                setState(() => date2 = dt);
                print('Selected date: $date2');
              },
            ),
            SizedBox(height: 16.0),
            MaterialButton(
              child: new Text('Submit Records'),
              onPressed: () {
                addsugData();
              },
              textColor: Colors.white,
              color: Color(0xFF5DB09E),
              padding: const EdgeInsets.only(left: 40, right: 30),
            ),
          ],
        ),
      ));

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
