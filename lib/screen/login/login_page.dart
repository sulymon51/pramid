import 'dart:async';
import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
import 'package:pyramid/screen/home/home_page.dart';
import 'package:pyramid/screen/login/forgetpass.dart';
import 'package:pyramid/screen/login/login_animation.dart';
import 'package:pyramid/screen/register/register.dart';
import 'package:pyramid/screen/welcomeScreen.dart';
import 'package:pyramid/utility/app_constant.dart';
import 'package:pyramid/widget/circular_reveal.dart';
import 'package:pyramid/widget/rounded_button.dart';
import 'package:pyramid/widget/trapezoid_down_cut_small.dart';
import 'package:pyramid/widget/trapezoid_left_cut.dart';
import 'package:pyramid/widget/trapezoid_up_cut.dart';
import 'package:pyramid/widget/trapezoid_up_cut_small.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';


class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}
   enum LoginStatus { notSignIn, signIn }
class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
    Future<SharedPreferences> sharedPreferences = SharedPreferences.getInstance();
  LoginStatus _loginStatus = LoginStatus.notSignIn;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool visible = false;
  bool _isLoading = false;
  bool hidePass = true;

  LoginEnterAnimation enterAnimation;
  AnimationController animationController;

  Animation<double> _animation;
  AnimationController revealAnimationController;
  double _fraction = 0.0;
   

  @override
  void dispose(){
    emailController.dispose();
    passwordController.dispose();
        animationController.dispose();
    super.dispose();
  }
 var url = "https://pyramidpharmacy.com/rxcare/api/login.php";

// Future <void>  addData() async{
//     SharedPreferences preferences = await SharedPreferences.getInstance();

//  var response = await http.post(url,
// body: {
//     "email":emailController.text.trim(),
//       "password": passwordController.text.trim(),
   
//   }
//   ); 
//   var jsonData = jsonDecode(response.body);
//       int value = jsonData['value'];
//     String message = jsonData['message'];
//     String phoneAPI = jsonData['phone'];
//     String nameAPI = jsonData['fullname'];
//     String emailAPI = jsonData['email'];
//     String walletAPI = jsonData['wallet'];
//     String genderAPI = jsonData['gender'];
//     String stateAPI = jsonData['state'];
//     String imageAPI = jsonData['image'];
//     String id = jsonData['id'];

//     savePref(int value, String phone, String fullname, String email,
//         String wallet, gender, state, image, String id) async {
//       SharedPreferences preferences = await SharedPreferences.getInstance();
//       setState(() {
//         visible = true;
//         // widget.allrideModel.fetchAllrides();
//         preferences.setInt("value", value);
//         preferences.setString("phone", phone);
//         preferences.setString("fullname", fullname);
//         preferences.setString("email", email);
//         preferences.setString("wallet", wallet);
//          preferences.setString("gender", gender);
//         preferences.setString("state", state);
//         preferences.setString("image", image);
//         preferences.setString("id", id);
//         preferences.commit();
//       });
//     }

    

//     if (value == 1) {
//       setState(() {
//         _loginStatus = LoginStatus.signIn;
//         savePref(value, phoneAPI, nameAPI, emailAPI, walletAPI, genderAPI, imageAPI,
//              stateAPI, id);


//       });
//       print(message);
//       myToast(message);
      
//     // if(genderAPI == 'driver'){
//     // Navigator.push(
//     //         context, new MaterialPageRoute(builder: (context) => HomePage()));
//     // }else{
//     //   Navigator.push(
//     //         context, new MaterialPageRoute(builder: (context) => HomePage()));
//     // }
    
//     } else {
//       print("fail");
//       print(message);
//       myToast(message);
//     }
//   var jsonString = jsonData['message'];
//   if(jsonString=='success'){
//     myToast(jsonString);
//      Navigator.push(
//             context, new MaterialPageRoute(builder: (context) => HomePage()));
    
//   }else{
//     myToast(jsonString);
//   }
// }


 Future addData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    // Showing CircularProgressIndicator.
    setState(() {
      _isLoading = false;
    });

    // Getting value from Controller
    String email = emailController.text;
    String password = passwordController.text;

    String rider ;
    String driver ;

    // SERVER LOGIN API URL
    var url = 'https://pyramidpharmacy.com/rxcare/api/loginapi.php';

    final response = await http.post(url, body: {
      // "flag": 1.toString(),
      "email":emailController.text.trim(),
      "password": passwordController.text.trim(),
    });
    final data = jsonDecode(response.body);
    int value = data['value'];
    String message = data['message'];
    String phoneAPI = data['phone'];
    String nameAPI = data['fullname'];
    String emailAPI = data['email'];
    String walletAPI = data['wallet'];
    String genderAPI = data['gender'];
    String stateAPI = data['state'];
    String imageAPI = data['image'];
    String id = data['id'];
  print(data);
    savePref(int value, String phone, String fullname, String email,
        String wallet, gender, state, image, String id) async {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      setState(() {
        visible = true;
        // widget.allrideModel.fetchAllrides();
        preferences.setInt("value", value);
        preferences.setString("phone", phone);
        preferences.setString("fullname", fullname);
        preferences.setString("email", email);
        preferences.setString("wallet", wallet);
        preferences.setString("gender", gender);
        preferences.setString("state", state);
        preferences.setString("image", image);
        preferences.setString("id", id);
        preferences.commit();
      });
    }

    

    if (value == 1) {
      setState(() {
        _loginStatus = LoginStatus.signIn;
        savePref(value, phoneAPI, nameAPI, emailAPI, walletAPI, genderAPI, imageAPI,
             stateAPI, id);
      });
      print(message);
      myToast(message);
      
    // if(genderAPI == 'driver'){
    // Navigator.push(
    //         context, new MaterialPageRoute(builder: (context) => HomePage()));
    // }else{
    //   Navigator.push(
    //         context, new MaterialPageRoute(builder: (context) => HomePage()));
    // }
    
    } else {
      print("fail");
      print(message);
      myToast(message);
    }

    // var data = {'phone': phone, 'password' : password};
    // var response = await http.post(url, body: json.encode(data));
    // var message = jsonDecode(response.body);
   
    // Navigator.push(
    //         context, new MaterialPageRoute(builder: (context) => WelcomScreen()));
  }

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

  myToast(String toast) {
    return Toast.show(toast, context,
        duration: Toast.LENGTH_LONG, 
        gravity: Toast.TOP,
        backgroundColor: Colors.red,
        textColor: Colors.white);
  }

  @override
  void initState() {
    super.initState();
      getPref();
    animationController = new AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this)
      ..addListener(() {
        setState(() {});
      });

    enterAnimation = LoginEnterAnimation(animationController);

    animationController.forward();
  }

  // @override
  // void dispose() {
  //   animationController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final TextTheme textTheme = Theme.of(context).textTheme;
    if (_loginStatus == LoginStatus.notSignIn) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          _buildContent(size, textTheme),
          Center(
            child: _fraction > 0
                ? CustomPaint(
                    painter: RevealProgressButtonPainter(
                        _fraction, MediaQuery.of(context).size),
                  )
                : Offstage(),
          ),
          Center(
            child: _fraction == 1 ? CircularProgressIndicator() : Offstage(),
          )
        ],
      ),
      resizeToAvoidBottomPadding: false,
    );
    }else{
      return WelcomScreen();
    }
  }

  void reveal() {
    revealAnimationController = AnimationController(
        duration: const Duration(milliseconds: 300), vsync: this);

    _animation = Tween(begin: 0.0, end: 1.0).animate(revealAnimationController)
      ..addListener(() {
        setState(() {
          _fraction = _animation.value;
        });
      });

    revealAnimationController.forward();

    Timer(Duration(milliseconds: 1000), () {
      _fraction = 0;
     addData();
    });
  }

  Widget _buildContent(Size size, TextTheme textTheme) => Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: FractionalOffset.topCenter,
            end: FractionalOffset.bottomCenter,
            colors: <Color>[
              const Color(0xFF7BDDB1),
              const Color(0xFF377885),
              const Color(0xFF265F7A),
            ],
          ),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            _buildBackgroundCenter(),
            _buildBackgroundTop(),
            _buildBackgroundBottom(),
            _buildBackgroundBottom2(),
            _buildForm(size, textTheme)
          ],
        ),
      );

  _buildBackgroundCenter() => Transform(
        transform: Matrix4.translationValues(
            -enterAnimation.backgroundTranslation.value, 0, 0),
        child: TrapezoidLeftCut(
          child: Container(
            color: Colors.white,
          ),
        ),
      );

  _buildBackgroundTop() => Transform(
        transform: Matrix4.translationValues(
            0, -enterAnimation.backgroundTranslation.value, 0),
        child: TrapezoidDownCutSmall(
          child: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: FractionalOffset.topRight,
                end: FractionalOffset.bottomRight,
                colors: <Color>[
                  const Color(0xFF64BCA2),
                  const Color(0xFF468E8E),
                  const Color(0xFF3C7E88),
                ],
              ),
            ),
          ),
        ),
      );

  _buildBackgroundBottom() => Transform(
        transform: Matrix4.translationValues(
            0, enterAnimation.backgroundTranslation.value, 0),
        child: TrapezoidUpCut(
          child: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: FractionalOffset.topCenter,
                end: FractionalOffset.bottomCenter,
                colors: <Color>[
                  const Color(0xFF468E8E),
                  const Color(0xFF3C7E88),
                ],
              ),
            ),
          ),
        ),
      );

  _buildBackgroundBottom2() => Transform(
        transform: Matrix4.translationValues(
            0, enterAnimation.backgroundTranslation.value, 0),
        child: TrapezoidUpCutSmall(
          child: Container(
            color: Colors.white,
          ),
        ),
      );

  _buildForm(Size size, TextTheme textTheme) => Positioned(
      top: size.height * 0.2,
      left: size.width * 0.08,
      right: size.width * 0.35,
      bottom: size.width * 0.3,
      child: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Transform(
                transform: Matrix4.translationValues(
                    -enterAnimation.translation.value, 0, 0),
                child: Text(
                  "Login",
                  style: textTheme.display1.copyWith(
                      color: Colors.black, fontWeight: FontWeight.w700),
                ),
              ),
              SizedBox(
                height: size.height * 0.05,
              ),
              _buildTextFormUsername(textTheme),
              SizedBox(
                height: 8,
              ),
              _buildTextFormPassword(textTheme),
              SizedBox(
                height: size.height * 0.05,
              ),
              Transform(
                transform: Matrix4.translationValues(
                    -enterAnimation.buttontranslation.value, 0, 0),
                child: RoundedButton(
                  text: BUTTON_LOGIN,
                  onPressed: () =>   reveal()  ,
                ),

              ),
              SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  GestureDetector(
                  onTap: () {
                    // Navigator.push(context, "");
                    Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => RegisterPage()),
                          );
                  },
             child: Text('Or Register',
                     textAlign: TextAlign.left,
                     style: TextStyle(color: Colors.grey),
                     ),
                     
            ),
            SizedBox(
                width: 18,
              ),
             GestureDetector(
                  onTap: () {
                    // Navigator.push(context, "");
                    Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ForgetPage()),
                          );
                  },
             child: Text('Forget Password',
                     textAlign: TextAlign.left,
                     style: TextStyle(color: Colors.grey),
                     ),
                     
            ),
                ],
              ),
                          // Container(
              

            ],
          ),
        ),
      ));

  Widget _buildTextFormUsername(TextTheme textTheme) {
    return FadeTransition(
      opacity: enterAnimation.userNameOpacity,
      child: TextFormField(
        style: textTheme.title.copyWith(color: Colors.black87),
        decoration: new InputDecoration(
          border: UnderlineInputBorder(),
          labelText: Email_AUTH_HINT,
          labelStyle:
              textTheme.caption.copyWith(color: Theme.of(context).primaryColor),
          contentPadding: EdgeInsets.zero,
          suffixIcon: Icon(
            Icons.email,
            color: Colors.grey,
          ),
        ),
        keyboardType: TextInputType.emailAddress,
        controller: emailController,
        validator: (val) => val.length == 0
            ? PHONE_AUTH_VALIDATION_EMPTY
            : val.length < 10 ? PHONE_AUTH_VALIDATION_INVALID : null,
      ),
    );
  }

  Widget _buildTextFormPassword(TextTheme textTheme) {
    return FadeTransition(
      opacity: enterAnimation.passowrdOpacity,
      child: TextFormField(
        style: textTheme.title.copyWith(color: Colors.black87),
        decoration: new InputDecoration(
          labelText: PASSWORD_AUTH_HINT,
          labelStyle:
              textTheme.caption.copyWith(color: Theme.of(context).primaryColor),
          contentPadding: const EdgeInsets.all(0.0),
          
           suffixIcon: IconButton(icon: Icon(Icons.visibility), onPressed:(){
                showandhide();
              }),
        ),
        keyboardType: TextInputType.text,
        controller: passwordController,
        obscureText: hidePass,
        validator: (val) => val.length == 0
            ? PHONE_AUTH_VALIDATION_EMPTY
            : val.length < 10 ? PHONE_AUTH_VALIDATION_INVALID : null,
      ),
    );
  }
  showandhide() {
    setState(() {
      hidePass = !hidePass;
    });
}
}
