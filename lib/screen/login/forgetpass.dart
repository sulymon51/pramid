import 'dart:async';
import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
import 'package:pyramid/screen/home/home_page.dart';
import 'package:pyramid/screen/login/login_animation.dart';
import 'package:pyramid/screen/login/login_page.dart';
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


class ForgetPage extends StatefulWidget {
  @override
  _ForgetPageState createState() => _ForgetPageState();
}
   enum LoginStatus { notSignIn, signIn }
class _ForgetPageState extends State<ForgetPage> with TickerProviderStateMixin {
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

 


 Future addData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    // Showing CircularProgressIndicator.
    setState(() {
      _isLoading = false;
    });

    // Getting value from Controller
    String email = emailController.text;
   
    var url = 'https://pyramidpharmacy.com/rxcare/api/forgetpassword.php';

    final response = await http.post(url, body: {
      // "flag": 1.toString(),
      "email":emailController.text.trim(),
     });
    final data = jsonDecode(response.body);
    int value = data['value'];
    String emailAPI = data['email'];
    
  print(data);
   


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
                  "Forget Password",
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
               SizedBox(
                height: size.height * 0.05,
              ),
              Transform(
                transform: Matrix4.translationValues(
                    -enterAnimation.buttontranslation.value, 0, 0),
                child: RoundedButton(
                  text: BUTTON_FORGOT,
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
                width: 15,
              ),
                GestureDetector(
                  onTap: () {
                    // Navigator.push(context, "");
                    Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => LoginPage()),
                          );
                  },
             child: Text('Back to Login',
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
  
}
