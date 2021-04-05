import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pyramid/screen/pAGES/NewShop/model/productModel.dart';
import 'package:pyramid/screen/pAGES/NewShop/network/network.dart';
import 'package:http/http.dart' as http;
import 'package:pyramid/screen/theme/style.dart';
import 'package:pyramid/screen/welcomeScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:somedialog/somedialog.dart';
import 'package:toast/toast.dart';

class ProductDetail extends StatefulWidget {
  final ProductModel model;
  ProductDetail(this.model);

  @override
  _ProductDetailState createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  final price = NumberFormat("#,###0", "en_US");

    TextEditingController idsController = new TextEditingController();
    TextEditingController pnameController = new TextEditingController();
    TextEditingController pamountController = new TextEditingController();
  @override
  void initState() {
    super.initState();
    getCredential();
  }
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF5DB09E),
        title: Text("${widget.model.productName}"),
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Expanded(
              child: ListView(
                padding: EdgeInsets.all(10),
                children: <Widget>[
                  Image.network(
                    NetworkUrl.baseUrl + "product/${widget.model.cover}",
                    fit: BoxFit.cover,
                    height: 200,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "${widget.model.productName}",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "${widget.model.description}",
                    style: TextStyle(fontSize: 16),
                  ),
                      Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 2.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Visibility(
                                     visible: false,
                                    child: new TextField(
                                      enabled: false,
                                      controller: idsController
                                        ..text = "${widget.model.id}",
                                      decoration: const InputDecoration(
                                        hintText: "Destination",
                                      ),
                                      // enabled: !_status,
                                      // autofocus: !_status,
                                    ),
                                  ),
                                ],
                              )
                              ),
                        Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 2.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Visibility(
                                     visible: false,
                                    child: new TextField(
                                      enabled: false,
                                      controller: pnameController
                                        ..text = "${widget.model.productName}",
                                      decoration: const InputDecoration(
                                        hintText: "Destination",
                                      ),
                                      // enabled: !_status,
                                      // autofocus: !_status,
                                    ),
                                  ),
                                ],
                              )
                              ),
                              Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 2.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Visibility(
                                     visible: false,
                                    child: new TextField(
                                      enabled: false,
                                      controller: pamountController
                                        ..text = "${widget.model.sellingPrice}",
                                      decoration: const InputDecoration(
                                        hintText: "Destination",
                                      ),
                                      // enabled: !_status,
                                      // autofocus: !_status,
                                    ),
                                  ),
                                ],
                              )
                              ),                     
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.all(8),
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(8)),
                  child: Text(
                    "\₦ "+" ${price.format(widget.model.sellingPrice)}",
                    style: TextStyle(
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                  
                ),
                // InkWell(
                //   onTap: () {},
                //   child: Container(
                //     margin: EdgeInsets.all(8),
                //     padding: EdgeInsets.all(15),
                //     decoration: BoxDecoration(
                //         color: Colors.orange,
                //         borderRadius: BorderRadius.circular(8)),
                //     child: Text(
                //       "Purchase now",
                //       style: TextStyle(
                //           color: Colors.white,
                //           fontWeight: FontWeight.bold,
                //           fontSize: 16),
                //     ),
                //   ),
                  
                // ),
               
                FlatButton(
                color: Colors.red,
              child: Text("Purchase now",
                 style: TextStyle(
                   color: Colors.white,
                   fontWeight: FontWeight.bold,
                   fontSize: 12
                 ),),
              onPressed: () {
                //  oderData();
                SomeDialog(
                  context: context,
                  path: "assets/report.json",
                  mode: SomeMode.Lottie,
                  

                  content:
                      "Please before Procceeding, double-check the product you choosed!",
                  title: "Are you sure ?",
                  submit: () {
                    oderData();
                  }
                );
              },
            )
              ],
            )
          ],
        ),
      ),
    );
  }
    oderData() async {
    String productid = idsController.text;
    String productname = pnameController.text;
    String amount = pamountController.text;
    print(productid + productname + amount);//pyramidpharmacy.com/rxcare/api/mshop/api/buyproduct.php';
    var url = Uri.parse(NetworkUrl.orderProduct);
    print(url);
    final response = await http
      .post(url, body: {
      'productid': productid,
      'productname': productname,
      'username': fullname,
       'amount': amount,
       'user_id': id,
       
     }
     );
    final data = jsonDecode(response.body);
    int value = data['value'];
    var mes = data['message'];

    print(data);

    if (value == 2) {
      Toast.show(mes, context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.TOP,
          backgroundColor: Colors.red,
          textColor: Colors.white);
      //  });
    } else {
      Toast.show(
          mes,
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.TOP,
          backgroundColor: Colors.green,
          textColor: Colors.white);
      Navigator.push(
          context, new MaterialPageRoute(builder: (context) => WelcomScreen()));
    }
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
    print(fullname);
    print(id);
  }
}


