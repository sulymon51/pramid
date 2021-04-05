import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:pyramid/screen/login/login_animation.dart';
import 'package:pyramid/screen/login/login_page.dart';
import 'package:pyramid/utility/app_constant.dart';
import 'package:pyramid/widget/circular_reveal.dart';
import 'package:pyramid/widget/rounded_button.dart';
import 'package:pyramid/widget/trapezoid_down_cut_small.dart';
import 'package:pyramid/widget/trapezoid_left_cut.dart';
import 'package:pyramid/widget/trapezoid_up_cut.dart';
import 'package:pyramid/widget/trapezoid_up_cut_small.dart';
import 'package:toast/toast.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> with TickerProviderStateMixin {
  // final userNameController = TextEditingController();
  // final emailController = TextEditingController();
  // final phoneController = TextEditingController();
  // final passwordController = TextEditingController();
  TextEditingController userNameController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  final formKey = GlobalKey<FormState>();

  LoginEnterAnimation enterAnimation;
  AnimationController animationController;

  Animation<double> _animation;
  AnimationController revealAnimationController;
  double _fraction = 0.0;
  bool hidePass = true;

 
var url = "https://pyramidpharmacy.com/rxcare/api/registerapi.php";
 addData() async {

   
   String fullname = userNameController.text;
    String email = emailController.text;
     String phone = phoneController.text;
    String password = passwordController.text;

 var response = await http.post(url,
body: {
    "email": email,
    "fullname": fullname,
    "phone": phone,
    "password": password,
  }
  ); 
  var jsonData = jsonDecode(response.body);
  var message = jsonData['message'];
  int value = jsonData['value'];
  // obtain shared preferences

  //  if(jsonString=='success'){
  //    myToast(jsonString);
  //    //You can route to your desire page here
  // }else{
  //   myToast(jsonString);
  // }

   if (value == 1) {
      setState(() {
   
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

    animationController = new AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this)
      ..addListener(() {
        setState(() {});
      });

    enterAnimation = LoginEnterAnimation(animationController);

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
  }

  void reveal() {
    revealAnimationController = AnimationController(
        duration: const Duration(milliseconds: 200), vsync: this);

    _animation = Tween(begin: 0.0, end: 1.0).animate(revealAnimationController)
      ..addListener(() {
        setState(() {
          _fraction = _animation.value;

        });
      });

    revealAnimationController.forward();

    Timer(Duration(milliseconds: 3600), () {
      _fraction = 0;
        addData();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
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
                  "Register",
                  style: textTheme.display1.copyWith(
                      color: Colors.black, fontWeight: FontWeight.w700),
                ),
              ),
              SizedBox(
                height: size.height * 0.05,
              ),
              _buildTextFormUsername(textTheme),
                SizedBox(
                height: 3,
              ),
              _buildTextFormEmail(textTheme),
              SizedBox(
                height: 4,
              ),
              _buildTextFormPassword(textTheme),
              SizedBox(
                height: 3,
              ),
              _buildTextAdress(textTheme),
              SizedBox(
                height: 6,
              ),
              Transform(
                transform: Matrix4.translationValues(
                    -enterAnimation.buttontranslation.value, 0, 0),
                child: RoundedButton(
                  text: BUTTON_REGIS,
                  onPressed: () => reveal(),
                ),
                
              ),
              SizedBox(
                height: 15,
              ),
              GestureDetector(
              onTap: () {
                // Navigator.push(context, "");
                Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
              },
             child: Text('Already Registerd',
                 textAlign: TextAlign.left,
                 style: TextStyle(color: Colors.grey),
                 ),
            ),
            ],
            
          ),
        ),
      )
      );

  Widget _buildTextFormUsername(TextTheme textTheme) {
    return FadeTransition(
      opacity: enterAnimation.userNameOpacity,
      child: TextFormField(
        style: textTheme.title.copyWith(color: Colors.black87),
        decoration: new InputDecoration(
          border: UnderlineInputBorder(),
          labelText: PHONE_AUTH_HINT,
          labelStyle:
              textTheme.caption.copyWith(color: Theme.of(context).primaryColor),
          contentPadding: EdgeInsets.zero,
          suffixIcon: Icon(
            Icons.person_outline,
            color: Colors.grey,
          ),
        ),
        keyboardType: TextInputType.text,
        controller: userNameController,
        validator: (val) => val.length == 0
            ? PHONE_AUTH_VALIDATION_EMPTY
            : val.length < 10 ? PHONE_AUTH_VALIDATION_INVALID : null,
      ),
    );
  }
    Widget _buildTextFormEmail(TextTheme textTheme) {
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
     Widget _buildTextAdress(TextTheme textTheme) {
    return FadeTransition(
      opacity: enterAnimation.userNameOpacity,
      child: TextFormField(
        style: textTheme.title.copyWith(color: Colors.black87),
        decoration: new InputDecoration(
          border: UnderlineInputBorder(),
          labelText: Address_AUTH_HINT,
          labelStyle:
              textTheme.caption.copyWith(color: Theme.of(context).primaryColor),
          contentPadding: EdgeInsets.zero,
          suffixIcon: Icon(
            Icons.phone,
            color: Colors.grey,
          ),
        ),
        keyboardType: TextInputType.phone,
        controller: phoneController,
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
