
import 'dart:convert';

// import 'package:auto_size_text/auto_size_text.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:pyramid/screen/home/walletScreen.dart';

// import 'package:login_dash_animation/screens/' as prefix0;
// import 'login.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:webview_flutter/webview_flutter.dart';
// import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;
import 'package:http/http.dart' as http;

final Color themeColor = Color(0xFF5DB09E);
final Color backgroundColor = Colors.white;



class AddfundPage extends StatefulWidget {
  static String tag = 'FundCurrent';
  @override
  _AddfundPage createState() => _AddfundPage();
}

class _AddfundPage extends State<AddfundPage> {
  TextEditingController eCtrl = new TextEditingController();
  
  String amountt = '';
  String email = "", name = "",  username = "", id = "";


  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      id = preferences.getString("id");
      email = preferences.getString("email");
      name = preferences.getString("name");
  
    });
  }

    Future<void> fetchSaveCurrentBal() async {
    var webAddress = "https://pyramidpharmacy.com/rxcare/api/walletapi.php?id="+id;
    var response = await http.get(Uri.encodeFull(webAddress),);
    var res = jsonDecode(response.body);
    var curr = res['data'];
    return curr;
  }

  @override
  void initState() {
    super.initState();
    getPref();
  } 

  @override
  Widget build(BuildContext context) {

     Size size = MediaQuery.of(context).size;
    final screenHeight = size.height;
    final screenWidth = size.width;

    final amount = TextFormField(
      controller: eCtrl,
      keyboardType: TextInputType.number,
      autofocus: false,
      decoration: InputDecoration(
        icon: Icon(Icons.dialpad, color: themeColor,),
        hintText: 'Amount',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32.0)
        )
      ),
      onChanged: (String text) {
        setState(() {
          amountt = text;
          // print("id" + amountt);
          // print(myInfo.uid);
        });

      },
      onFieldSubmitted: (String text) {
        setState(() {
          amountt = text;
        });
        eCtrl.clear();
      },

    );


    final amtText = FutureBuilder(
          future: fetchSaveCurrentBal(),
          builder: (BuildContext context, AsyncSnapshot snapshot){
            if(snapshot.data == null){
              return AutoSizeText(
                  'loading ...',
                  style: TextStyle(fontSize: 15),
                  maxLines: 1,
                );
            } else {
              return AutoSizeText(
                  'Your Wallet Balance: NGN ' + snapshot.data,
                  style: TextStyle(fontSize: 15,),
                  maxLines: 1,
                );

            }
          },
        );

    final payButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        borderRadius: BorderRadius.circular(30.0),
        shadowColor: Colors.blue.shade100,
        elevation: 5.0,
        child: MaterialButton(
          minWidth: 200.0,
          height: 50.0,

          // onPressed: () {
          //   var route = new MaterialPageRoute(
          //     builder: (BuildContext context)=> new MobilePayer(userid: id, amountValue: amountt,),
          //     );
          //   Navigator.of(context).push(route);
          // },

            onPressed: () {
              var webAddress = "https://pyramidpharmacy.com/rxcare/api/mob/addfundapi.php?ibd=" + id + "&abd="+ amountt; 
              FocusScope.of(context).requestFocus(FocusNode());
              this._openInWebview(webAddress);
              },
          color: Color(0xFF5DB09E),
          child: Text(
            'Pay Now',
           style: TextStyle(color: Colors.white)),
        ),
      ),
    );



        if (username == null) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF5DB09E),
        ),
        // backgroundColor: Colors.deepOrange,
        body: DecoratedBox(
          position: DecorationPosition.background,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/dashh.png'), fit: BoxFit.cover),
          ),
          child: Center(
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.only(left: 24.0, right: 24.0),
              children: <Widget>[
                AutoSizeText(
                  'Session Time-Out ',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 48.0),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: Material(
                    borderRadius: BorderRadius.circular(30.0),
                    shadowColor: Color(0xFF5DB09E),
                    elevation: 5.0,
                    child: MaterialButton(
                      minWidth: 200.0,
                      height: 50.0,
                      onPressed: () {
                        // Navigator.pushReplacement(
                        //   context,
                        //   new MaterialPageRoute(
                        //       builder: (context) => new HomeScreen()),
                        // );
                      },
                      color: Color(0xFF5DB09E),
                      child: Text("Login Again",
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ),
                SizedBox(height: 10.0),
                SizedBox(height: 30.0),
              ],
            ),
          ),
        ),
      );
    } else {

       return Scaffold(
      appBar: AppBar(
        title: Text("Fund Wallet"),
        backgroundColor: Color(0xFF5DB09E),),
      backgroundColor: Colors.white,
      body:  DecoratedBox(
            position: DecorationPosition.background,
            decoration: BoxDecoration(
              // image: DecorationImage(
              //     image: AssetImage('assets/dashh.png'),
              //     fit: BoxFit.cover),
            ),
      child: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          children: <Widget>[
            AutoSizeText(
              'Fund Your Wallet',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: themeColor),
              maxLines: 1,
            ),
            SizedBox(height: 10.0),
            AutoSizeText(
              '',
              style: TextStyle(fontSize: 12, ),
            ),
            SizedBox(height: 20.0),
            amtText,
            SizedBox(height: 48.0), AutoSizeText(
              'Enter Amount to Fund.',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: themeColor),
            ),
            SizedBox(height: 10.0),
            amount,
            SizedBox(height: 24.0),
            payButton,
          ],
        ),
      ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Container(
          height: 70.0,
          child:
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
          ),
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      // backgroundColor: Colors.white,
      // child: Icon(Icons.home, color: Colors.blueAccent,), 
      // onPressed: () {
      //    Navigator.pushReplacement(
      //       context,
      //       new MaterialPageRoute(builder: (context) => new HomeScreen()),
      //     );
      // },
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
    }
  }

   Future<Null> _openInWebview(String url) async {
    if (await url_launcher.canLaunch(url)) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (ctx) => WebviewScaffold(
            initialChild: Center(child: CircularProgressIndicator()),
            url: url,
            appBar: AppBar(title: Text('Payment'), backgroundColor: Color(0xFF5DB09E),),
            bottomNavigationBar: BottomAppBar(
            shape: const CircularNotchedRectangle(),
            child: Container(
              height: 70.0,
              child:
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(''),
                   FlatButton(
                    color: backgroundColor,
                    onPressed: () => setState(
                          () {
                            Navigator.pushReplacement(context,
                              new MaterialPageRoute(builder: (context) => new WalletPage()),
                            );
                          },
                        ),
                    child: Icon(
                      Icons.home,
                      color: themeColor,
                    )
                  ),
                  Text(''),
                ],
              ),
            ),
          ),
          ),
        ),
      );
    } else {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text('Error processing payment'),
        ),
      );
    }
  }
  
  
}
