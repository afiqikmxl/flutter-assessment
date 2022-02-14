import 'package:flutter_application_1/Model/userModel.dart';
import 'package:sizer/sizer.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Screen/editProfile.dart';
import 'package:flutter_application_1/Screen/profileScreen.dart';
import 'package:flutter_application_1/Service/service.dart';
import 'package:flutter_application_1/locator.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:page_transition/page_transition.dart';

import '../constant.dart';

class NewUser extends StatefulWidget {
  @override
  _NewUserState createState() => _NewUserState();
}

class _NewUserState extends State<NewUser> {
  final ContactService _contactService = locator<ContactService>();
  final TextEditingController _recipientController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();
  bool isHTML = false;
  List<String> attachments = [];
  @override
  Widget build(BuildContext context) {
    print("++++++++++++++++++++++++++++++++++++++++++");
    print(_contactService.listNewUser.length);
    print("++++++++++++++++++++++++++++++++++++++++++");

    return ListView.builder(
        shrinkWrap: true,
        itemCount: _contactService.listNewUser.length,
        physics: ClampingScrollPhysics(),
        itemBuilder: (context, idx) {
          final List<Data> data = _contactService.listNewUser[idx].data;
          return Container(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      PageTransition(
                          child: ProfileScreen(
                            fname: data[idx].firstName,
                            lname: data[idx].lastName,
                            email: data[idx].email,
                            id: data[idx].id,
                            image: null,
                            user: data[idx],
                          ),
                          type: PageTransitionType.fade));
                },
                child: Slidable(
                  actionPane: SlidableDrawerActionPane(),
                  actionExtentRatio: 0.25,
                  secondaryActions: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        border: Border(
                          right: BorderSide(
                              width: 2.0, color: Themes.primaryColor["bg"]),
                        ),
                      ),
                      child: IconSlideAction(
                        color: Themes.primaryColor["bg"].withOpacity(0.3),
                        icon: Icons.edit,
                        foregroundColor: Colors.yellow,
                        closeOnTap: true,
                        onTap: () {
                          Navigator.push(
                              context,
                              PageTransition(
                                  child: EditProfileScreen(
                                    fname: data[idx].firstName,
                                    lname: data[idx].lastName,
                                    email: data[idx].email,
                                    id: data[idx].id,
                                    image: null,
                                  ),
                                  type: PageTransitionType.fade));
                        },
                      ),
                    ),
                    Container(
                      child: IconSlideAction(
                        color: Themes.primaryColor["bg"].withOpacity(0.3),
                        icon: Icons.delete,
                        foregroundColor: Colors.red,
                        closeOnTap: true,
                        onTap: () {
                          showDialog(
                              context: context,
                              child: CupertinoAlertDialog(
                                title: Text(""),
                                content: Text(
                                    "Are you sure you want to delete this contact?"),
                                actions: <Widget>[
                                  CupertinoDialogAction(
                                    isDefaultAction: true,
                                    onPressed: () {
                                      setState(() {
                                        _contactService.listNewUser
                                            .removeAt(idx);
                                      });

                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      "Yes",
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                  CupertinoDialogAction(
                                      textStyle: TextStyle(color: Colors.red),
                                      isDefaultAction: true,
                                      onPressed: () async {
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        "No",
                                        style: TextStyle(
                                            color: Themes.primaryColor["bg"]),
                                      )),
                                ],
                              ));
                        },
                      ),
                    ),
                  ],
                  child: ListTile(
                    leading: ClipOval(
                      child: Image(
                        image: AssetImage('assets/newUser.png'),
                        fit: BoxFit.contain,
                      ),
                    ),
                    title: Text(data[idx].firstName),
                    subtitle: Text(data[idx].email),
                    trailing: GestureDetector(
                      onTap: () {
                        setState(() {
                          _recipientController.text = data[idx].email;
                          _subjectController.text = 'Hi!';
                          _bodyController.text = 'Let us be friends :)';
                        });
                        _contactService.sendEmail(
                            _bodyController.text,
                            _subjectController.text,
                            [_recipientController.text],
                            attachments,
                            isHTML);
                      },
                      child: Container(
                        width: 8.0.w,
                        height: 5.0.h,
                        child: Image(
                          image: AssetImage('assets/share.png'),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }
}
