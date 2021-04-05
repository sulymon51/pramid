import 'package:flutter/material.dart';
import 'package:pyramid/screen/MyProfile/profile.dart';
import 'package:pyramid/screen/home/home_animation.dart';
import 'package:pyramid/screen/home/walletScreen.dart';
import 'package:pyramid/screen/pAGES/Bmiscreen.dart';
import 'package:pyramid/screen/pAGES/Formpage/bpform.dart';
import 'package:pyramid/screen/pAGES/Formpage/sugarf.dart';
import 'package:pyramid/screen/pAGES/NewShop/screen/menu/home.dart';
import 'package:pyramid/screen/pAGES/SHOP/Homeshop.dart';
import 'package:pyramid/screen/pAGES/appointments.dart';
import 'package:pyramid/src/ui/homepage/homepage.dart';

import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() {
    return new HomePageState();
  }
}

class HomePageState extends State<HomePage> with TickerProviderStateMixin {
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

  HomeEnterAnimation enterAnimation;
  AnimationController animationController;

  @override
  void initState() {
    super.initState();
    getCredential();
    animationController = new AnimationController(
        duration: const Duration(milliseconds: 3000), vsync: this);
    enterAnimation = HomeEnterAnimation(animationController);
    animationController.forward();

    
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
        body: AnimatedBuilder(
            animation: animationController,
            builder: (BuildContext context, Widget child) {
              return Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  _buildBackgroundImage(size),
                  _buildBackgroundGradient(size),
                  _buildCard(size, textTheme),
                ],
              );
            }));
  }

  _buildBackgroundImage(Size size) => Positioned(
        top: 0,
        bottom: size.height * 0.6,
        left: 0,
        right: 0,
        child: FadeTransition(
          opacity: enterAnimation.fadeTranslation,
          child: Container(
              decoration: BoxDecoration(
            image: new DecorationImage(
              image: new ExactAssetImage('assets/images/doctor.jpg'),
              fit: BoxFit.cover,
            ),
          )),
        ),
      );

  _buildBackgroundGradient(Size size) => Positioned(
        top: size.height * 0.4,
        bottom: 0,
        left: 0,
        right: 0,
        child: FadeTransition(
          opacity: enterAnimation.fadeTranslation,
          child: Container(
              decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: FractionalOffset.topCenter,
              end: FractionalOffset.bottomCenter,
              colors: <Color>[
                const Color(0xFF5DB09E),
                const Color(0xFF40858B),
                const Color(0xFF042C63),
              ],
            ),
          )),
        ),
      );

  _buildCard(Size size, TextTheme textTheme) => Positioned(
        top: size.height * 0.3,
        bottom: size.height * 0.1,
        left: size.width * 0.05,
        right: size.width * 0.05,
        child: Transform(
          transform: Matrix4.translationValues(
              0, enterAnimation.Ytranslation.value, 0),
          child: Card(
              elevation: 8,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text(
                          "Hello," " " + fullname,
                          style: textTheme.caption.copyWith(
                              color: Colors.black, fontWeight: FontWeight.w300),
                        ),
                        Text(
                          "                        ",
                          textAlign: TextAlign.right,
                          style: textTheme.subtitle.copyWith(
                              color: Colors.black, fontWeight: FontWeight.w700),
                        ),
                        Text(
                          "Member Board",
                          textAlign: TextAlign.right,
                          style: textTheme.subtitle.copyWith(
                              color: Color(0xFF5DB09E), fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Text(
                      "Welcome",
                      textAlign: TextAlign.right,
                      style: textTheme.subtitle.copyWith(
                          color: Colors.black, fontWeight: FontWeight.w700),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Expanded(
                      child: GridView.count(
                        crossAxisCount: 3,
                        mainAxisSpacing: 20.0,
                        crossAxisSpacing: 20.0,
                        childAspectRatio: (size.width) / ((size.height * 0.6)),
                        controller:
                            new ScrollController(keepScrollOffset: false),
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        children: <Widget>[
                          // return
                          Container(
                            decoration: BoxDecoration(
                                border: new Border.all(
                                    color: Theme.of(context).primaryColor),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4))),
                            padding: EdgeInsets.all(8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                  child: GestureDetector(
                                      onTap: () {
                                        // Navigator.push(context, "");
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  AppointMent()),
                                        );
                                      },
                                      child: Transform(
                                        transform: Matrix4.diagonal3Values(
                                            enterAnimation.scale.value,
                                            enterAnimation.scale.value,
                                            0),
                                        alignment: Alignment.center,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Image.asset(
                                              "assets/images/appointment.png"),
                                        ),
                                      )),
                                ),
                                Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        // Navigator.push(context, "");
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  AppointMent()),
                                        );
                                      },
                                      child: Text(
                                        "Book an appointment",
                                        style: TextStyle(
                                            fontSize: 8,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    )),
                              ],
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                border: new Border.all(
                                    color: Theme.of(context).primaryColor),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4))),
                            padding: EdgeInsets.all(8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                    child: GestureDetector(
                                        onTap: () {
                                          // Navigator.push(context, "");
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    Home()),
                                          );
                                        },
                                        child: Transform(
                                          transform: Matrix4.diagonal3Values(
                                              enterAnimation.scale.value,
                                              enterAnimation.scale.value,
                                              0),
                                          alignment: Alignment.center,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Image.asset(
                                                "assets/images/reminder.png"),
                                          ),
                                        ))),
                                Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        // Navigator.push(context, "");
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  Home()),
                                        );
                                      },
                                      child: Text(
                                        "Manage Store",
                                        style: TextStyle(
                                            fontSize: 8,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ))
                              ],
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                border: new Border.all(
                                    color: Theme.of(context).primaryColor),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4))),
                            padding: EdgeInsets.all(8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                  child: GestureDetector(
                                      onTap: () {
                                        // Navigator.push(context, "");
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  BMIscreen()),
                                        );
                                      },
                                      child: Transform(
                                        transform: Matrix4.diagonal3Values(
                                            enterAnimation.scale.value,
                                            enterAnimation.scale.value,
                                            0),
                                        alignment: Alignment.center,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Image.asset(
                                              "assets/images/reports.png"),
                                        ),
                                      )),
                                ),
                                Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        // Navigator.push(context, "");
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  BMIscreen()),
                                        );
                                      },
                                      child: Text(
                                        "BMI Monitoring",
                                        style: TextStyle(
                                            fontSize: 8,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    )),
                              ],
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                border: new Border.all(
                                    color: Theme.of(context).primaryColor),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4))),
                            padding: EdgeInsets.all(8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                  child: GestureDetector(
                                      onTap: () {
                                        // Navigator.push(context, "");
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  HomePageMedr()),
                                        );
                                      },
                                      child: Transform(
                                        transform: Matrix4.diagonal3Values(
                                            enterAnimation.scale.value,
                                            enterAnimation.scale.value,
                                            0),
                                        alignment: Alignment.center,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Image.asset(
                                              "assets/images/yourappointments.png"),
                                        ),
                                      )),
                                ),
                                Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        // Navigator.push(context, "");
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  HomePageMedr()),
                                        );
                                      },
                                      child: Text(
                                        "Medicine Reminder",
                                        style: TextStyle(
                                            fontSize: 8,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    )),
                              ],
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                border: new Border.all(
                                    color: Theme.of(context).primaryColor),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4))),
                            padding: EdgeInsets.all(8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                  child: GestureDetector(
                                      onTap: () {
                                        // Navigator.push(context, "");
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  SugarfScreen()),
                                        );
                                      },
                                      child: Transform(
                                        transform: Matrix4.diagonal3Values(
                                            enterAnimation.scale.value,
                                            enterAnimation.scale.value,
                                            0),
                                        alignment: Alignment.center,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Image.asset(
                                              "assets/images/appointment.png"),
                                        ),
                                      )),
                                ),
                                Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        // Navigator.push(context, "");
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  SugarfScreen()),
                                        );
                                      },
                                      child: Text(
                                        "Sugar Monitoring",
                                        style: TextStyle(
                                            fontSize: 8,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    )),
                              ],
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                border: new Border.all(
                                    color: Theme.of(context).primaryColor),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4))),
                            padding: EdgeInsets.all(8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                  child: GestureDetector(
                                      onTap: () {
                                        // Navigator.push(context, "");
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  BpfScreen()),
                                        );
                                      },
                                      child: Transform(
                                        transform: Matrix4.diagonal3Values(
                                            enterAnimation.scale.value,
                                            enterAnimation.scale.value,
                                            0),
                                        alignment: Alignment.center,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Image.asset(
                                              "assets/images/appointment.png"),
                                        ),
                                      )),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      // Navigator.push(context, "");
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => BpfScreen()),
                                      );
                                    },
                                    child: Text(
                                      "Bp Monitoring",
                                      style: TextStyle(
                                          fontSize: 8,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              )),
        ),
      );
}
