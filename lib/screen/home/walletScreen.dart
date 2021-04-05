import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pyramid/model/mywallethisModel.dart';
import 'package:pyramid/screen/pAGES/NewShop/screen/fundwallet.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;



class WalletPage extends StatefulWidget {
  @override
  _WalletPageState createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
Future<List<MyWalletHis>> fetchWallethisaa() async {
    String url = "https://pyramidpharmacy.com/rxcare/api/deposithisapi.php?userid=" + id;
    final response = await http.get(url);
    // print(response);
    return myWalletHisFromMap(response.body);
  }

    Future<void> fetchBal() async {
    var url = "https://pyramidpharmacy.com/rxcare/api/walletapi.php?id=" + id;
    var response = await http.get(
      Uri.encodeFull(url),
    );
    var res = jsonDecode(response.body);
    var data = res['data'];
    return data;
  }
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

  @override
  void initState() {
    super.initState();
    getCredential();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Wallet"),
        actions: <Widget>[
          IconButton(
            icon: Icon(FontAwesomeIcons.bell),
            onPressed: () {},
          ),
        ],
        elevation: 0,
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
    
      body: Container(
        color: Color(0xFFbdc3c7),
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(


          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(
                  bottom: 10,
                ),
                decoration: BoxDecoration(
                    color: Color(0xFF042C63),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40),
                    )),
                child: Container(
                  child: Column(
                    children: <Widget>[
                      
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 20,vertical: 10,),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "Current Balance",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              "NGN",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                      ),

                      Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: 20,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            FutureBuilder(
                              future: fetchBal(),
                              builder: (BuildContext context,
                                  AsyncSnapshot snapshot) {
                                if (snapshot.data == null) {
                                  return CircularProgressIndicator();
                                } else {
                                  return Text(
                                    "\₦" + snapshot.data.toString(),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 40,
                                        fontWeight: FontWeight.bold),
                                  );
                                }
                              },
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Color(0xFF2ecc71),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              child: Text(
                                "Online",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 80,),

                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                        child: Row(
                          children: <Widget>[
                            Text(
                              "",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),

                    ],
                  ),
                  margin: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 40,
                  ),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFF042C63),
                        Color(0xFF042C63),
                      ],
                    ),
                  ),
                ),
              ),

              

              Container(
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20,),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[


                    Expanded(
                      child: RaisedButton.icon(
                        onPressed: () =>
                          Navigator.push(context, 
                          MaterialPageRoute(builder: (context) => AddfundPage())),
                        icon: Icon(
                          FontAwesomeIcons.levelUpAlt,
                          color: Colors.deepOrange,
                        ),
                        label: Text("Add Money"),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),

                    SizedBox(width: 20,),

                    // Expanded(
                    //   child: RaisedButton.icon(
                    //     onPressed: (){},
                    //     icon: Icon(FontAwesomeIcons.levelDownAlt, color: Color(0xFF2ecc71),),
                    //     label: Text("Receive"),
                    //     shape: RoundedRectangleBorder(
                    //       borderRadius: BorderRadius.circular(8),
                    //     ),
                    //   ),
                    // ),

                  ],
                ),
              ),


              Container(
                margin: EdgeInsets.symmetric(horizontal: 20,),
                alignment: Alignment.topLeft,
                child: Text("History", style: TextStyle(fontSize: 22,),),
              ),

              Container(
                margin: EdgeInsets.symmetric(horizontal: 20,vertical: 10,),
                alignment: Alignment.topLeft,
                child: Column(
                  children: <Widget>[
                  

                    // SizedBox(height: 10,),
                FutureBuilder(
                future: fetchWallethisaa(),
                builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                      controller: ScrollController(),
                      shrinkWrap: true,
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, index) {
                        MyWalletHis myWalletHis = snapshot.data[index];
                        return  Container(
                          child: Builder(
                                  builder: (context) {
                                    var newa = '${myWalletHis.status}';
                                    // print(newa);
                                    if (newa == 'cr') {
                                      return   Card(
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: ListTile(
                                          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                          leading: CircleAvatar(
                                            backgroundColor: Color(0xffecf0f1),
                                            child: Icon(FontAwesomeIcons.moneyBill, color: Color(0xff2ecc71),),
                                          ),
                                          title: Text("${myWalletHis.details}",style: TextStyle(color: Color(0xff2ecc71)),),
                                          trailing: Text("\₦"+'${myWalletHis.amount}', style: TextStyle(color: Color(0xff2ecc71)),),
                                      ),
                                    );
                                   }else{
                                      return   Card(
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: ListTile(
                                          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                          leading: CircleAvatar(
                                            backgroundColor: Color(0xffecf0f1),
                                            child: Icon(FontAwesomeIcons.moneyBill, color: Colors.red[600],),
                                          ),
                                          title: Text("${myWalletHis.details}", style: TextStyle(color: Colors.red), ),
                                          trailing: Text("\- ₦"+'${myWalletHis.amount}',style: TextStyle(color: Colors.red),),
                                      ),
                                    );
                                  }
                                  })
                          
                    //        Card(
                    //   shape: RoundedRectangleBorder(
                    //       borderRadius: BorderRadius.circular(8),
                    //   ),
                    //   child: ListTile(
                    //       contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    //       leading: CircleAvatar(
                    //         backgroundColor: Color(0xffecf0f1),
                    //         child: Icon(FontAwesomeIcons.creditCard, color: Color(0xff2ecc71),),
                    //       ),
                    //       title: Text("${riderhisTory.details}"),
                    //       trailing: Text("\₦"+'${riderhisTory.amount}'),
                    //   ),
                    // ),
                        );
                      });
                } else if (snapshot.hasError) {
                  return Text('No History Yet');
                }
                //return  a circular progress indicator.
                return Center(child: new CircularProgressIndicator());
              },
            ),

                    
//  FutureBuilder<List>(
//                       future: getData(),
//                       builder: (ctx, ss) {
//                         if (ss.hasError) {
//                           print("erorr");
//                         }
//                         if (ss.hasData) {
//                           return Center(child: Items(list: ss.data));
//                         } else {
//                           return CircularProgressIndicator();
//                         }
//                       },
//                     ),
                  ],
                ),
              ),


              SizedBox(height: 100,),


            ],
          ),
        ),
      ),
    );
  }
}