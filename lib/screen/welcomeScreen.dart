import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:pyramid/screen/home/home_page.dart';
import 'package:pyramid/screen/home/uploadpres.dart';
import 'package:pyramid/screen/home/walletScreen.dart';
import 'package:pyramid/screen/home/ReportsScreen.dart';
import 'package:pyramid/screen/pAGES/reportsug.dart';
import 'package:pyramid/screen/pAGES/reportsec.dart';

import 'package:pyramid/screen/login/login_page.dart';
import 'package:pyramid/src/global_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WelcomScreen extends StatefulWidget {

  @override
  _WelcomScreenState createState() => _WelcomScreenState();
}

class _WelcomScreenState extends State<WelcomScreen> {
  SharedPreferences sharedPreferences;
GlobalBloc globalBloc;
  String name = "", phone = "", email = "", type = "", profilepic="";

  getCredential() async {
    sharedPreferences = await SharedPreferences.getInstance();

    setState(() {
      //
      name = sharedPreferences.getString("name");
      email = sharedPreferences.getString("email");
      phone = sharedPreferences.getString("phone");
      type = sharedPreferences.getString("type");
      profilepic= sharedPreferences.getString("profilepic");
    });
    //  print(type);
    //  print(name);
  }

  int pageIndex = 2;

  // final AllrideModel allrideModel = AllrideModel();

  final HomePage _dashScreen = HomePage();
  final Prescrip _profilePage = new Prescrip();
  final Reportsugar _myRides = new Reportsugar();
  final ReportBp _reportbp = new ReportBp();
  final WalletPage _walletPage = new WalletPage();

  Widget _showPage = new HomePage();
  Widget _pageChooser(int page) {
    switch (page) {
      case 0:
        return _profilePage;
        break;
      case 1:
        return _myRides;
        break;
      case 2:
        return  _dashScreen;
        break;
      case 3:
        return _reportbp;
        break;  
      case 4:
        return _walletPage;
        break;
      default:
        return new Container(
          child: new Center(
            child: new Text(
              ' Noosafdo ',
              style: new TextStyle(fontSize: 30),
            ),
          ),
        );
    }
  }

  @override
  void initState() {
    globalBloc = GlobalBloc();
    super.initState();



  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    getCredential();
    return new WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        // backgroundColor: Colors.white,
        bottomNavigationBar: CurvedNavigationBar(
          index: pageIndex,
          color: Color(0xFF5DB09E),
          backgroundColor: Color(0xFF042C63),
          buttonBackgroundColor: Color(0xFF5DB09E),
          height: 50,

          items: <Widget>[
            Icon(
              Icons.filter_drama,
              size: 20,
              color: Colors.white,
            ),
             Icon(
              Icons.insert_chart,
              size: 20,
              color: Colors.white,
            ),
            Icon(
              Icons.dashboard,
              size: 20,
              color: Colors.white,
            ),
           
             Icon(
              Icons.show_chart,
              size: 20,
              color: Colors.white,
            ),
            Icon(
              Icons.account_balance_wallet,
              size: 20,
              color: Colors.white,
            ),
          ],
          animationDuration: Duration(milliseconds: 200),
          // index: 1,
          animationCurve: Curves.easeIn,
          onTap: (int tappedIndex) {
            setState(() {
              _showPage = _pageChooser(tappedIndex);
            });
          },
        ),
        body: Container(
          child: _showPage,
        ),
        
        key: _scaffoldKey,
        floatingActionButton: FloatingActionButton(
          backgroundColor: Color(0xFF5DB09E),
          onPressed: () => setState(
                  () {
                    Navigator.pop(context);
                    signOut();
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginPage()));
                  },
                ),
          child: Icon(Icons.exit_to_app),
        ),
      ),
    );
  }

  LoginStatus _loginStatus = LoginStatus.notSignIn;

  var value;
  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      value = preferences.getInt("value");

      _loginStatus = value == 1 ? LoginStatus.signIn : LoginStatus.notSignIn;
    });
  }

  signOut() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setInt("value", null);
      preferences.setString("phone", null);
      preferences.setString("name", null);
      preferences.setString("email", null);
      preferences.setString("id", null);

      preferences.commit();
      _loginStatus = LoginStatus.notSignIn;
    });
  }
}
