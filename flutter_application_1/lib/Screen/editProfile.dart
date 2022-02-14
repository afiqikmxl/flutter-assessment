import 'package:flutter/material.dart';
import 'package:flutter_application_1/Model/userModel.dart';
import 'package:flutter_application_1/Screen/myContactScreen.dart';
import 'package:flutter_application_1/Screen/profileScreen.dart';
import 'package:flutter_application_1/Service/service.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sizer/sizer.dart';
import '../constant.dart';
import '../locator.dart';

class EditProfileScreen extends StatefulWidget {
  final fname, lname, email, image, id;
  EditProfileScreen(
      {Key key, this.fname, this.lname, this.email, this.image, this.id})
      : super(key: key);
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _fnameController = TextEditingController();
  final TextEditingController _lnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final ContactService _contactService = locator<ContactService>();

  @override
  void initState() {
    super.initState();
    _fnameController.text = widget.fname;
    _lnameController.text = widget.lname;
    _emailController.text = widget.email;
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
          "Profile",
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
                  height: 5.0.h,
                ),
                Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: Themes.primaryColor["bg"], width: 3)),
                  child: CircleAvatar(
                    radius: 65,
                    child: ClipOval(
                      child: new SizedBox(
                        height: 300,
                        width: 300,
                        child: Image(
                          image: (widget.image != null)
                              ? NetworkImage(widget.image)
                              : AssetImage('assets/newUser.png'),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 5.0.h,
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
                      // prefixIcon: Icon(Icons.mail),
                      filled: true,
                      // labelText: "First Name",
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
                      // prefixIcon: Icon(Icons.mail),
                      filled: true,
                      // labelText: "Last Name",
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
                      // prefixIcon: Icon(Icons.mail),
                      filled: true,
                      // labelText: "Email",
                      fillColor: Colors.white,
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(15.0),
                        borderSide: new BorderSide(),
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
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
                            .updateUser(
                                userInfo: User(data: [
                                  Data(
                                      id: widget.id,
                                      email: _emailController.text,
                                      firstName: _fnameController.text,
                                      lastName: _lnameController.text,
                                      avatar: widget.image)
                                ]),
                                id: widget.id)
                            .then((value) {
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
                      "Done",
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
}
