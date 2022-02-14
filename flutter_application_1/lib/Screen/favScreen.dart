import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Screen/profileScreen.dart';
import 'package:flutter_application_1/Service/service.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sizer/sizer.dart';
import '../constant.dart';
import '../locator.dart';
import 'editProfile.dart';

class FavScreen extends StatefulWidget {
  @override
  _FavScreenState createState() => _FavScreenState();
}

class _FavScreenState extends State<FavScreen> {
  final ContactService _contactService = locator<ContactService>();

  @override
  Widget build(BuildContext context) {
    return (_contactService.favList.length != 0)
        ? Container(
            width: 100.0.w,
            height: 65.0.h,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _contactService.favList.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          PageTransition(
                              child: ProfileScreen(
                                fname: _contactService.data[index].firstName,
                                lname: _contactService.data[index].lastName,
                                email: _contactService.data[index].email,
                                image: _contactService.data[index].avatar,
                                id: _contactService.data[index].id,
                                user: _contactService.data[index],
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
                                        fname: _contactService
                                            .data[index].firstName,
                                        lname: _contactService
                                            .data[index].lastName,
                                        email:
                                            _contactService.data[index].email,
                                        image:
                                            _contactService.data[index].avatar,
                                        id: _contactService.data[index].id,
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
                                        "Are you sure you want to delete this contact from your favourite?"),
                                    actions: <Widget>[
                                      CupertinoDialogAction(
                                        isDefaultAction: true,
                                        onPressed: () {
                                          setState(() {
                                            _contactService.favList
                                                .removeAt(index);
                                            _contactService.favListID
                                                .removeAt(index);
                                          });

                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                          "Yes",
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ),
                                      CupertinoDialogAction(
                                          textStyle:
                                              TextStyle(color: Colors.red),
                                          isDefaultAction: true,
                                          onPressed: () async {
                                            Navigator.pop(context);
                                          },
                                          child: Text(
                                            "No",
                                            style: TextStyle(
                                                color:
                                                    Themes.primaryColor["bg"]),
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
                            image: NetworkImage(
                                _contactService.favList[index].avatar),
                          ),
                        ),
                        title: Text(_contactService.favList[index].firstName),
                        subtitle: Text(_contactService.favList[index].email),
                        trailing: Container(
                          width: 8.0.w,
                          height: 5.0.h,
                          child: Image(
                            image: AssetImage('assets/share.png'),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ))
        : Container(
            width: 100.0.w,
            height: 65.0.h,
            child: Column(
              children: [
                SizedBox(
                  height: 10.0.h,
                ),
                Image(image: AssetImage('assets/noContact.png')),
                SizedBox(
                  height: 10.0.h,
                ),
              ],
            ));
  }
}
