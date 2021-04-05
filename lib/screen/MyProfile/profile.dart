import 'package:flutter/material.dart';
import 'package:pyramid/model/profileMode.dart';
// import 'package:login_dash_animation/MyProfile/myProfile.dart';
import 'package:pyramid/screen/MyProfile/myProfile.dart';
import 'package:pyramid/screen/theme/style.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'chart.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold( 
      appBar: AppBar(
        title: Text("Profile"),
        actions: <Widget>[
          IconButton(
            icon: Icon(FontAwesomeIcons.pen),
            onPressed: (){
              // Navigator.of(context).push(MaterialPageRoute<Null>(
              //     builder: (BuildContext context) {
              //       return MyProfile();
              //     },
              // ));
            },
          ),
        ],
        elevation: 0,
        // backgroundColor: Color.fromARGB(255, 20, 0, 100),
        backgroundColor: Color(0xFF5DB09E),
        brightness: Brightness.dark,
        textTheme: TextTheme(
          title: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
      body:

      FutureBuilder(
        future: alridezpp(),
        builder: (context, snapshot) {
         if (snapshot.hasData) {
        return ListView.builder(
        // scrollDirection: Axis.horizontal,
        itemCount: snapshot.data.length, 
        shrinkWrap: true,
        itemBuilder: (BuildContext context, index){
        ProfileAcc profileAcc = snapshot.data[index];
         return 
        SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            color: Color(0xFF5DB09E),
              image: DecorationImage(
              image: CachedNetworkImageProvider('${profileAcc.image}'),
              fit: BoxFit.cover,
              colorFilter: new ColorFilter.mode(
                  Colors.deepOrange.withOpacity(0.3), BlendMode.dstATop),
            )),
          child: Column(
            children: <Widget>[
              Center(
                child: Stack(
                  children: <Widget>[
                    Material(
                      elevation: 10.0,
                      color: Colors.white,
                      shape: CircleBorder(),
                      child: Padding(
                        padding: EdgeInsets.all(2.0),
                        
                        child: SizedBox(
                          height: 150,
                          width: 150,
                          child: CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.transparent,
                            backgroundImage: CachedNetworkImageProvider('${profileAcc.image}',
                            )
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 10.0,
                      left: 25.0,
                      height: 15.0,
                      width: 15.0,
                      child: Container(
                        width: 15.0,
                        height: 15.0,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: greenColor,
                            border: Border.all(
                                color: Colors.white, width: 2.0)),
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                padding: EdgeInsets.only(top: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('${profileAcc.fullname}',
                      style: TextStyle( color: Colors.white,fontSize: 35.0),
                    ),
                    Text(
                      "Welcome",
                      style: TextStyle( color: blackColor, fontSize: 13.0),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Container(
                color: whiteColor,
                // child: LineChartWallet(),
              ),
              SizedBox(height: 20),
              Container(
                child: Column(
                  children: <Widget>[
                    Container(
                      height: 50,
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: whiteColor,
                        border: Border(
                          bottom: BorderSide(width: 1.0,color: backgroundColor)
                        )
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text('Username',style: textStyle,),
                          Text('${profileAcc.fullname}',style: textGrey,)
                        ],
                      ),
                    ),
                    Container(
                      height: 50,
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                          color: whiteColor,
                          border: Border(
                              bottom: BorderSide(width: 1.0,color: backgroundColor)
                          )
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text('Phone Number',style: textStyle,),
                          Text('${profileAcc.phone}',style: textGrey,)
                        ],
                      ),
                    ),
                    Container(
                      height: 50,
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                          color: whiteColor,
                          border: Border(
                              bottom: BorderSide(width: 1.0,color: backgroundColor)
                          )
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text('Email',style: textStyle,),
                          Text('${profileAcc.email}',style: textGrey,)
                        ],
                      ),
                    ),
                    Container(
                      height: 50,
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                          color: whiteColor,
                          border: Border(
                              bottom: BorderSide(width: 1.0,color: backgroundColor)
                          )
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text('State',style: textStyle,),
                          Text('${profileAcc.state}',style: textGrey,)
                        ],
                      ),
                    ),
                  ],
                ),
              )


            ],
          ),
        ),
      );
        }
     );
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
                //return  a circular progress indicator.
                return Center(child: new CircularProgressIndicator());
              },
    )
    );
  }

   SharedPreferences sharedPreferences;

  String name = "", phone = "", email = "", id="", profileAcc="";

  getCredential() async {
    sharedPreferences = await SharedPreferences.getInstance();

    setState(() {
      name = sharedPreferences.getString("name");
       phone= sharedPreferences.getString("phone");
      email= sharedPreferences.getString("email");
       id= sharedPreferences.getString("id");
       profileAcc= sharedPreferences.getString("profileAcc");
    });
  }

  final FocusNode myFocusNode = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCredential();
  }


 
Future<List<ProfileAcc>>  alridezpp() async {
  String url = "https://pyramidpharmacy.com/rxcare/api/profileapi.php?id="+id;
  final response = await http.get(url);
    print(response.body);
  return profileAccFromJson(response.body);
 }

}