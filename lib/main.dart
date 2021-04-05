import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pyramid/screen/login/login_page.dart';
import 'package:pyramid/login.dart';
import 'package:pyramid/register.dart';
import 'package:pyramid/src/global_bloc.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  GlobalBloc globalBloc;
   void initState() {
    globalBloc = GlobalBloc();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
     return Provider<GlobalBloc>.value(
      value: globalBloc,
      child: MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.green,
          brightness: Brightness.light,
        ),
        home: LoginPage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }}
  
  // {
  //   return MaterialApp(
  //      debugShowCheckedModeBanner: false,
  //     title: 'Pyramid',
  //     theme: ThemeData(
  //       primarySwatch: Colors.green,
  //     ),
  //     home: LoginPage()
  //     );
  // }


class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Page"),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            RaisedButton(
              onPressed: (){
                 Navigator.of(context).push(new CupertinoPageRoute(builder: (BuildContext context){
                   return new MyLogin();
                 }));
              },
              child: Text("Login"),
            ),
            RaisedButton(
              onPressed: (){
                 Navigator.of(context).push(new CupertinoPageRoute(builder: (BuildContext context){
                   return new MyRegister();
                 }));
              },
              child: Text("Register"),
            )
          ],
        ),
      ),
    );
  }
}