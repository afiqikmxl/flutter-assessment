import 'dart:io';

import 'package:flutter/material.dart';
// import 'package:flutter_application_1/Model/userAddModel.dart';
import 'package:flutter_application_1/Model/userModel.dart';
import 'package:flutter_application_1/Screen/myContactScreen.dart';
import 'package:flutter_application_1/Service/service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';

import '../constant.dart';
import '../locator.dart';
import 'package:sizer/sizer.dart';
import 'package:path/path.dart';

class AddUser extends StatefulWidget {
  @override
  _AddUserState createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _fnameController = TextEditingController();
  final TextEditingController _lnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  final ContactService _contactService = locator<ContactService>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(
            Icons.chevron_left,
            color: Themes.primaryColor["default"],
            size: 32,
          ),
        ),
        backgroundColor: Themes.primaryColor["bg"],
        title: Text(
          "Add Contact",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.0.w),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 10.0.h,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 3),
                    child: Text("First Name"),
                  ),
                ),
                Container(
                  child: new TextFormField(
                    controller: _fnameController,
                    decoration: new InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(15.0),
                        borderSide: new BorderSide(),
                      ),
                    ),
                    keyboardType: TextInputType.text,
                  ),
                ),
                SizedBox(
                  height: 2.0.h,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 3),
                    child: Text("Last Name"),
                  ),
                ),
                Container(
                  child: new TextFormField(
                    controller: _lnameController,
                    decoration: new InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(15.0),
                        borderSide: new BorderSide(),
                      ),
                    ),
                    keyboardType: TextInputType.text,
                  ),
                ),
                SizedBox(
                  height: 2.0.h,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 3),
                    child: Text("Email"),
                  ),
                ),
                Container(
                  child: new TextFormField(
                    controller: _emailController,
                    decoration: new InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(15.0),
                        borderSide: new BorderSide(),
                      ),
                    ),
                    keyboardType: TextInputType.text,
                  ),
                ),
                SizedBox(
                  height: 2.0.h,
                ),
                Container(
                  width: 100.0.w,
                  height: 5.0.h,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    color: Themes.primaryColor["bg"],
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        _formKey.currentState.save();
                        _contactService
                            .addUser(User(data: [
                          Data(
                              id: _contactService.data.length + 1,
                              firstName: _fnameController.text,
                              lastName: _lnameController.text,
                              email: _emailController.text)
                        ]))
                            .then((value) {
                          _contactService.listNewUser.add(value);
                          _contactService.syncr = true;
                          Navigator.pushAndRemoveUntil(
                              context,
                              PageTransition(
                                  child: MyContact(),
                                  type: PageTransitionType.leftToRight),
                              (route) => false);
                        });
                      }
                    },
                    child: Text(
                      "Add",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future showCameraOrGallery(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (_) {
          return Container(
            height: 18.0.h,
            padding: EdgeInsets.all(1.5.h),
            color: Color(0xFFF8E8F91),
            child: Column(
              children: [
                Container(
                  width: 100.0.w,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () => getImage(context),
                          borderRadius: BorderRadius.vertical(
                              bottom: Radius.circular(10.0)),
                          child: Container(
                            width: 100.0.w,
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(top: 1.0.h, bottom: 2.0.h),
                            child: Text("Gallery"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Spacer(),
                Container(
                  width: 100.0.w,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () => Navigator.pop(context),
                          borderRadius: BorderRadius.circular(10.0),
                          child: Container(
                            width: 100.0.w,
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(top: 2.0.h, bottom: 2.0.h),
                            child: Text("Cancel"),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        });
  }

  Future getImage(BuildContext context) async {
    try {
      _contactService.pickedFile = await _contactService.imagePicker
          .getImage(source: ImageSource.gallery, imageQuality: 25);

      if (_contactService.pickedFile != null) {
        File _attachment = File(_contactService.pickedFile.path);
        setState(() {
          _contactService.image = _attachment;
          _contactService.imageIsLoading = true;
        });
        String imgName = basename(_contactService.image.uri.toFilePath());
        setState(() {
          _contactService.imageIsLoading = false;
        });

        print("+++++++++++++++++++++++++++++");
        print(imgName);
        print(_contactService.image.uri.toFilePath());
        print("+++++++++++++++++++++++++++++");
      } else {
        print('image not selected');
      }
    } catch (e) {
      print(e);
    }

    Navigator.pop(context);
  }
}
