import 'package:flutter/material.dart';
import 'package:flutter_application_1/Model/userModel.dart';
import 'package:flutter_application_1/Screen/editProfile.dart';
import 'package:flutter_application_1/Screen/myContactScreen.dart';
import 'package:flutter_application_1/Service/service.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:page_transition/page_transition.dart';

import '../constant.dart';
import 'package:sizer/sizer.dart';

import '../locator.dart';

class ProfileScreen extends StatefulWidget {
  final fname, lname, email, image, id;
  final Data user;
  ProfileScreen(
      {Key key,
      this.fname,
      this.lname,
      this.email,
      this.image,
      this.id,
      this.user})
      : super(key: key);
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ContactService _contactService = locator<ContactService>();
  final TextEditingController _recipientController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();
  bool isHTML = false;
  List<String> attachments = [];

  @override
  void initState() {
    super.initState();
    if (_contactService.favListID.contains(widget.id)) {
      _contactService.fav = true;
    } else {
      _contactService.fav = false;
    }
    _recipientController.text = widget.email;
    _subjectController.text = 'Hi!';
    _bodyController.text = 'Let us be friends :)';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pushAndRemoveUntil(
                context,
                PageTransition(
                    child: MyContact(), type: PageTransitionType.leftToRight),
                (route) => false);
          },
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
      body: Column(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  PageTransition(
                      child: EditProfileScreen(
                        fname: widget.fname,
                        lname: widget.lname,
                        email: widget.email,
                        image: widget.image,
                        id: widget.id,
                      ),
                      type: PageTransitionType.fade));
            },
            child: Container(
              child: Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 15.0, vertical: 12),
                  child: Text(
                    "Edit",
                    style: TextStyle(color: Themes.primaryColor["bg"]),
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              if (_contactService.favListID.contains(widget.id)) {
                _contactService.favList
                    .removeWhere((element) => element.id == widget.id);
                _contactService.favListID
                    .removeWhere((element) => element == widget.id);
                setState(() {
                  _contactService.fav = false;
                });
              } else {
                _contactService.favList.add(widget.user);
                _contactService.favListID.add(widget.id);
                setState(() {
                  _contactService.fav = true;
                });
              }
            },
            child: Stack(
              children: [
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
                Positioned(
                    bottom: 7,
                    right: 0,
                    child: (_contactService.fav == true)
                        ? Container(
                            height: 3.0.h,
                            width: 10.0.w,
                            child: Image(image: AssetImage('assets/fav.png')),
                          )
                        : Container())
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              child: Text(widget.fname),
            ),
          ),
          Container(
            width: 100.0.w,
            color: Color(0xFFE5E5E5),
            child: Column(
              children: [
                Container(
                  width: 12.0.w,
                  height: 7.0.h,
                  child: Image(
                    image: AssetImage('assets/mail.png'),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 8.0),
                  child: Text(widget.email),
                )
              ],
            ),
          ),
          SizedBox(
            height: 2.0.h,
          ),
          Container(
            width: 60.0.w,
            height: 5.0.h,
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              color: Themes.primaryColor["bg"],
              onPressed: () {
                _contactService.sendEmail(
                  _bodyController.text,
                  _subjectController.text,
                  [_recipientController.text],
                  attachments,
                  isHTML,
                );
              },
              child: Text(
                "Send Email",
                style: TextStyle(color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }
}
