import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:pyramid/components/ink_well_custom.dart';
import 'package:pyramid/components/inputDropdown.dart';
import 'package:pyramid/model/profileMode.dart';
import 'package:pyramid/screen/theme/style.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
import 'package:toast/toast.dart';
import 'dart:convert';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

const double _kPickerSheetHeight = 216.0;

class MyProfile extends StatefulWidget {
  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  final GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<Map<String, dynamic>> listGender = [
    {
      "id": '0',
      "name": 'Male',
    },
    {
      "id": '1',
      "name": 'Female',
    }
  ];
  String selectedGender;
  String lastSelectedValue;
  DateTime date = DateTime.now();
  var _image;
 var  selectedDate ;
  

  final fatherController = TextEditingController();
  final nameController = TextEditingController();
  final numberController = TextEditingController();
  final emailController = TextEditingController();

  @override
  void dispose() {
    fatherController.dispose();
    nameController.dispose();
    numberController.dispose();
    emailController.dispose();
    super.dispose();
  }

// fhgjjjjjjjjjj

  File _imageFile;
  // To track the file uploading state
  bool _isUploading = false;
  String baseUrl = 'http://chatitout.net/apiall/ppupdate.php';
  void _getImage(BuildContext context, ImageSource source) async {
    File image = await ImagePicker.pickImage(source: source);
    setState(() {
      _imageFile = image;
    });
    Navigator.pop(context);
  }

  Future<Map<String, dynamic>> _uploadImage(File image) async {
    String father = fatherController.text;
    String name = nameController.text;
    String number = numberController.text;
    String email = emailController.text;
    String dat = selectedDate ;
;

    setState(() {
      _isUploading = true;
    });
    final mimeTypeData =
        lookupMimeType(image.path, headerBytes: [0xFF, 0xD8]).split('/');
    final imageUploadRequest =
        http.MultipartRequest('POST', Uri.parse(baseUrl));
    final file = await http.MultipartFile.fromPath('image', image.path,
        contentType: MediaType(mimeTypeData[0], mimeTypeData[1]));
        imageUploadRequest.fields['ext'] = mimeTypeData[1];
        imageUploadRequest.fields['id'] = id;
        imageUploadRequest.fields['father'] = father;
        imageUploadRequest.fields['name'] = name;
        imageUploadRequest.fields['number'] = number;
        imageUploadRequest.fields['email'] = email; 
        // imageUploadRequest.fields['dob'] = dat; 
        imageUploadRequest.files.add(file);
    try {
      final streamedResponse = await imageUploadRequest.send();
      final response = await http.Response.fromStream(streamedResponse);
      if (response.statusCode != 200) {
        return null;
      }
      final Map<String, dynamic> responseData = json.decode(response.body);
      _resetState();
      return responseData;
    } catch (e) {
      print(e);
      return null;
    }
  }

  void _startUploading() async {
    final Map<String, dynamic> response = await _uploadImage(_imageFile);
    print(response);
    // Check if any error occured
    if (response == null || response.containsKey("error")) {
      Toast.show("Image Upload Failed!!!", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    } else {
      Toast.show("Image Uploaded Successfully!!!", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }

  void _resetState() {
    setState(() {
      _isUploading = false;
      _imageFile = null;
    });
  }

  void _openImagePickerModal(BuildContext context) {
    final flatButtonColor = Theme.of(context).primaryColor;
    print('Image Picker Modal Called');
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 150.0,
            padding: EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
                Text(
                  'Pick an image',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10.0,
                ),
                FlatButton(
                  textColor: flatButtonColor,
                  child: Text('Use Camera'),
                  onPressed: () {
                    _getImage(context, ImageSource.camera);
                  },
                ),
                FlatButton(
                  textColor: flatButtonColor,
                  child: Text('Use Gallery'),
                  onPressed: () {
                    _getImage(context, ImageSource.gallery);
                  },
                ),
              ],
            ),
          );
        });
  }

  Widget _buildUploadBtn() {
    Widget btnWidget = Container();
    if (_isUploading) {
      // File is being uploaded then show a progress indicator
      btnWidget = Container(
          margin: EdgeInsets.only(top: 10.0),
          child: CircularProgressIndicator());
    } else if (!_isUploading && _imageFile != null) {
      // If image is picked by the user then show a upload btn
      btnWidget = Container(
        margin: EdgeInsets.only(top: 10.0),
        child: RaisedButton(
          shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(10.0)),
          elevation: 0.0,
          color: Color(0xFF5DB09E),
          child: Text('Upload'),
          onPressed: () {
            _startUploading();
          },
          // color: Colors.pinkAccent,
          textColor: Colors.white,
        ),
      );
    }
    return btnWidget;
  }

// fhgkjhgjfjh

  Future getImageLibrary() async {
    var gallery =
        await ImagePicker.pickImage(source: ImageSource.gallery, maxWidth: 700);
    setState(() {
      _image = gallery;
    });
  }

  Future cameraImage() async {
    var image =
        await ImagePicker.pickImage(source: ImageSource.camera, maxWidth: 700);
    setState(() {
      _image = image;
    });
  }

  Widget _buildBottomPicker(Widget picker) {
    return Container(
      height: _kPickerSheetHeight,
      padding: const EdgeInsets.only(top: 6.0),
      color: CupertinoColors.white,
      child: DefaultTextStyle(
        style: const TextStyle(
          color: CupertinoColors.black,
          fontSize: 22.0,
        ),
        child: GestureDetector(
          // Blocks taps from propagating to the modal sheet and popping.
          onTap: () {},
          child: SafeArea(
            top: false,
            child: picker,
          ),
        ),
      ),
    );
  }

  void showDemoActionSheet({BuildContext context, Widget child}) {
    showCupertinoModalPopup<String>(
      context: context,
      builder: (BuildContext context) => child,
    ).then((String value) {
      if (value != null) {
        setState(() {
          lastSelectedValue = value;
        });
      }
    });
  }

  selectCamera() {
    showDemoActionSheet(
      context: context,
      child: CupertinoActionSheet(
          title: const Text('Select Camera'),
          actions: <Widget>[
            CupertinoActionSheetAction(
              child: const Text('Camera'),
              onPressed: () {
                Navigator.pop(context, 'Camera');
                cameraImage();
              },
            ),
            CupertinoActionSheetAction(
              child: const Text('Photo Library'),
              onPressed: () {
                Navigator.pop(context, 'Photo Library');
                getImageLibrary();
              },
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            child: const Text('Cancel'),
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context, 'Cancel');
            },
          )),
    );
  }

  submit() {
    final FormState form = formKey.currentState;
    form.save();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.white,
          title: Text(
            'My profile',
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: FutureBuilder(
          future: alridezpp(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  // scrollDirection: Axis.horizontal,
                  itemCount: snapshot.data.length,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, index) {
                    ProfileAcc profileAcc = snapshot.data[index];
                    return Scrollbar(
                      child: SingleChildScrollView(
                        child: InkWellCustom(
                            onTap: () => FocusScope.of(context)
                                .requestFocus(new FocusNode()),
                            child: Form(
                              key: formKey,
                              child: Container(
                                color: Color(0xffeeeeee),
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      color: whiteColor,
                                      padding: EdgeInsets.all(10.0),
                                      margin: EdgeInsets.only(bottom: 0.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: <Widget>[
                                          Material(
                                            elevation: 5.0,
                                            borderRadius:
                                                BorderRadius.circular(50.0),
                                            child: Column(
                                              children: <Widget>[
                                                new ClipRRect(
                                                  borderRadius:
                                                      new BorderRadius.circular(
                                                          100.0),
                                                  child: _image == null
                                                      ? new GestureDetector(
                                                          onTap: () {
                                                            selectCamera();
                                                          },
                                                          child: new Container(
                                                              height: 80.0,
                                                              width: 80.0,
                                                              color:
                                                                  primaryColor,
                                                              child: new Image
                                                                  .network(
                                                                '${profileAcc.image}',
                                                                fit: BoxFit
                                                                    .cover,
                                                                height: 80.0,
                                                                width: 80.0,
                                                              )))
                                                      : new GestureDetector(
                                                          onTap: () {
                                                            selectCamera();
                                                          },
                                                          child: new Container(
                                                            height: 80.0,
                                                            width: 80.0,
                                                            child: Image.file(
                                                              _image,
                                                              fit: BoxFit.cover,
                                                              height: 800.0,
                                                              width: 80.0,
                                                            ),
                                                          )),
                                                ),
                                                IconButton(
                                                  icon: Icon(
                                                      FontAwesomeIcons.camera),
                                                  // onPressed: () => _openImagePickerModal,
                                                  onPressed: () =>
                                                      _openImagePickerModal(
                                                          context),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                              child: Container(
                                            padding:
                                                EdgeInsets.only(left: 20.0),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                TextField(
                                                  style: textStyle,
                                                  decoration: InputDecoration(
                                                      fillColor: whiteColor,
                                                      labelStyle: textStyle,
                                                      hintStyle: TextStyle(
                                                          color: Colors.white),
                                                      counterStyle: textStyle,
                                                      hintText:
                                                          '${profileAcc.fullname}',
                                                      border: UnderlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                                  color: Colors
                                                                      .white))),
                                                  controller: fatherController
                                                    ..text =
                                                        '${profileAcc.gender}',
                                                  // controller:
                                                  //     new TextEditingController.fromValue(
                                                  //   new TextEditingValue(
                                                  //     text: '${profilePic.fatherName}',
                                                  //     selection: new TextSelection.collapsed(
                                                  //         offset: 11),
                                                  //   ),
                                                  // ),
                                                  onChanged:
                                                      (String _firstName) {},
                                                ),
                                                TextField(
                                                  style: textStyle,
                                                  decoration: InputDecoration(
                                                      fillColor: whiteColor,
                                                      labelStyle: textStyle,
                                                      hintStyle: TextStyle(
                                                          color: Colors.white),
                                                      counterStyle: textStyle,
                                                      hintText:
                                                          '${profileAcc.fullname}',
                                                      border: UnderlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                                  color: Colors
                                                                      .white))),
                                                  controller: nameController
                                                    ..text =
                                                        '${profileAcc.fullname}',
                                                  // controller:
                                                  //     new TextEditingController.fromValue(
                                                  //   new TextEditingValue(
                                                  //     text: '${profilePic.name}',
                                                  //     selection: new TextSelection.collapsed(
                                                  //         offset: 11),
                                                  //   ),
                                                  // ),
                                                  onChanged:
                                                      (String _lastName) {},
                                                ),
                                              ],
                                            ),
                                          ))
                                        ],
                                      ),
                                    ),
                                    Container(
                                      color: whiteColor,
                                      padding: EdgeInsets.all(10.0),
                                      margin: EdgeInsets.only(top: 10.0),
                                      child: Column(
                                        children: <Widget>[
                                          Container(
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: <Widget>[
                                                Expanded(
                                                  flex: 2,
                                                  child: Container(
                                                    padding: EdgeInsets.only(
                                                        right: 10.0),
                                                    child: Text(
                                                      "Phone Number",
                                                      style: textStyle,
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 4,
                                                  child: TextField(
                                                    style: textStyle,
                                                    keyboardType:
                                                        TextInputType.phone,
                                                    decoration: InputDecoration(
                                                        fillColor: whiteColor,
                                                        labelStyle: textStyle,
                                                        hintStyle: TextStyle(
                                                            color:
                                                                Colors.white),
                                                        counterStyle: textStyle,
                                                        border: UnderlineInputBorder(
                                                            borderSide: BorderSide(
                                                                color: Colors
                                                                    .white))),
                                                    controller: numberController
                                                      ..text =
                                                          '${profileAcc.phone}',
                                                    // controller: new TextEditingController.fromValue(
                                                    //   new TextEditingValue(
                                                    //     text: '${profilePic.number}',
                                                    //     selection: new TextSelection.collapsed(
                                                    //         offset: 11),
                                                    //   ),
                                                    // ),
                                                    onChanged:
                                                        (String _phone) {},
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          Container(
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: <Widget>[
                                                Expanded(
                                                  flex: 2,
                                                  child: Container(
                                                    padding: EdgeInsets.only(
                                                        right: 10.0),
                                                    child: Text(
                                                      "Email",
                                                      style: textStyle,
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 4,
                                                  child: TextField(
                                                    keyboardType: TextInputType
                                                        .emailAddress,
                                                    style: textStyle,
                                                    decoration: InputDecoration(
                                                        fillColor: whiteColor,
                                                        labelStyle: textStyle,
                                                        hintStyle: TextStyle(
                                                            color:
                                                                Colors.white),
                                                        counterStyle: textStyle,
                                                        border: UnderlineInputBorder(
                                                            borderSide: BorderSide(
                                                                color: Colors
                                                                    .white))),

                                                    controller: emailController
                                                      ..text = '${profileAcc.email}',
                                                    // controller: new TextEditingController.fromValue(
                                                    //   new TextEditingValue(
                                                    //     text: '${profilePic.email}',
                                                    //     selection: new TextSelection.collapsed(
                                                    //         offset: 11),
                                                    //   ),
                                                    // ),
                                                    onChanged:
                                                        (String _email) {},
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          Container(
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: <Widget>[
                                                Expanded(
                                                  flex: 2,
                                                  child: Container(
                                                    padding: EdgeInsets.only(
                                                        right: 10.0),
                                                    child: Text(
                                                      "Gender",
                                                      style: textStyle,
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 4,
                                                  child:
                                                      new DropdownButtonHideUnderline(
                                                          child: Container(
                                                    // padding: EdgeInsets.only(bottom: 12.0),
                                                    child: new InputDecorator(
                                                      decoration:
                                                          const InputDecoration(),
                                                      isEmpty: selectedGender ==
                                                          null,
                                                      child: new DropdownButton<
                                                          String>(
                                                        hint: new Text(
                                                          '${profileAcc.gender}',
                                                          style: textStyle,
                                                        ),
                                                        value: selectedGender,
                                                        isDense: true,
                                                        onChanged:
                                                            (String newValue) {
                                                          setState(() {
                                                            selectedGender =
                                                                newValue;
                                                            print(
                                                                selectedGender);
                                                          });
                                                        },
                                                        items: listGender
                                                            .map((value) {
                                                          return new DropdownMenuItem<
                                                              String>(
                                                            value: value['id'],
                                                            child: new Text(
                                                              value['name'],
                                                              style: textStyle,
                                                            ),
                                                          );
                                                        }).toList(),
                                                      ),
                                                    ),
                                                  )),
                                                )
                                              ],
                                            ),
                                          ),
                                          Container(
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: <Widget>[
                                                Expanded(
                                                  flex: 2,
                                                  child: Container(
                                                    padding: EdgeInsets.only(
                                                        right: 10.0),
                                                    child: Text(
                                                      "Birthday",
                                                      style: textStyle,
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 4,
                                                  child: GestureDetector(
                                                      onTap: () {
                                                        showCupertinoModalPopup<
                                                            void>(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return _buildBottomPicker(
                                                              CupertinoDatePicker(
                                                                mode:
                                                                    CupertinoDatePickerMode
                                                                        .date,
                                                                initialDateTime:
                                                                    date,
                                                                onDateTimeChanged:
                                                                    (DateTime
                                                                        newDateTime) {
                                                                  setState(() {
                                                                    selectedDate =  newDateTime;
                                                                  });
                                                                  print('$date');
                                                                },
                                                              ),
                                                            );
                                                          },
                                                        );
                                                      },
                                                      child: new InputDropdown(
                                                        valueText: 
                                                            DateFormat.yMMMMd()
                                                                .format(date),
                                                        valueStyle: TextStyle(
                                                            color: blackColor),
                                                      )
                                                      ),
                                                )
                                              ],
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.only(top: 20.0),
                                            child: Column(
                                              children: <Widget>[
                                                // new ButtonTheme(
                                                //   height: 45.0,
                                                //   minWidth: MediaQuery.of(context).size.width-50,
                                                //   child: RaisedButton.icon(
                                                //     shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10.0)),
                                                //     elevation: 0.0,
                                                //     color: Colors.deepOrange,
                                                //     icon: new Text(''),
                                                //     label: new Text('Update', style: headingBlack,),
                                                //     onPressed: (){
                                                //       submit();
                                                //     },
                                                //   ),
                                                // ),
                                                _buildUploadBtn()
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )),
                      ),
                    );
                  });
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            //return  a circular progress indicator.
            return Center(child: new CircularProgressIndicator());
          },
        ));
  }

  SharedPreferences sharedPreferences;

  String name = "", phone = "", email = "", id = "", profilepic = "";

  getCredential() async {
    sharedPreferences = await SharedPreferences.getInstance();

    setState(() {
      name = sharedPreferences.getString("name");
      phone = sharedPreferences.getString("phone");
      email = sharedPreferences.getString("email");
      id = sharedPreferences.getString("id");
      profilepic = sharedPreferences.getString("profilepic");
    });
  }

  final FocusNode myFocusNode = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCredential();
  }

  Future<List<ProfileAcc>> alridezpp() async {
    String url = "http://chatitout.net/apiall/profilepic.php?id=" + id;
    final response = await http.get(url);
    // print(response.body);
    return profileAccFromJson(response.body);
  }
}
