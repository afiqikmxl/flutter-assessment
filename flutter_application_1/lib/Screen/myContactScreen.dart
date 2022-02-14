import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Model/userModel.dart';
import 'package:flutter_application_1/widget/addUser.dart';
import 'package:flutter_application_1/Screen/favScreen.dart';
import 'package:flutter_application_1/Screen/newUser.dart';
import 'package:flutter_application_1/Screen/profileScreen.dart';
import 'package:flutter_application_1/Service/service.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:page_transition/page_transition.dart';

import '../constant.dart';
import 'package:sizer/sizer.dart';

import '../locator.dart';
import 'editProfile.dart';

class MyContact extends StatefulWidget {
  @override
  _MyContactState createState() => _MyContactState();
}

class _MyContactState extends State<MyContact> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _searchController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final TextEditingController _recipientController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();
  final ContactService _contactService = locator<ContactService>();
  int selected = 0;
  String title;
  bool isHTML = false;
  List<String> attachments = [];

  _MyContactState() {
    _searchController.addListener(() {
      if (_searchController.text.isEmpty) {
        setState(() {
          _contactService.isSearching = false;
          _contactService.searchText = "";
        });
      } else {
        setState(() {
          _contactService.isSearching = true;
          _contactService.searchText = _searchController.text;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    if (_contactService.userData == null || _contactService.syncr == false) {
      _contactService.userData = _contactService.getUser(_contactService.page);
    } else {
      _contactService.userData = _contactService.userData;
    }
  }

  void _handleSearch() {
    setState(() {
      _contactService.isSearching = true;
    });
  }

  void searching(String searchText) {
    _contactService.searchresult.clear();
    if (_contactService.isSearching != false) {
      for (int i = 0; i < _contactService.data.length; i++) {
        _contactService.data = _contactService.userList.data
            .where((u) => (u.email
                    .toLowerCase()
                    .contains(_searchController.text.toLowerCase()) ||
                u.firstName
                    .toLowerCase()
                    .contains(_searchController.text.toLowerCase()) ||
                u.lastName
                    .toLowerCase()
                    .contains(_searchController.text.toLowerCase())))
            .toList();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: Themes.primaryColor["bg"],
          title: Text(
            "My Contacts",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          centerTitle: true,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: GestureDetector(
                onTap: () {
                  _contactService.title == "All"
                      ? setState(() {
                          _contactService.syncr = true;
                          _contactService
                              .getUser(_contactService.page)
                              .then((value) {
                            _contactService.syncr = false;
                            Navigator.pushAndRemoveUntil(
                                context,
                                PageTransition(
                                    child: MyContact(),
                                    type: PageTransitionType.leftToRight),
                                (route) => false);
                          });
                          _scaffoldKey.currentState.showSnackBar(
                            SnackBar(
                              duration: Duration(seconds: 2),
                              backgroundColor: Themes.primaryColor["bg"],
                              content: Text("List Updated"),
                            ),
                          );
                        })
                      : DoNothingAction();
                },
                child: Icon(
                  Icons.sync,
                  color: Themes.primaryColor["default"],
                ),
              ),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Themes.primaryColor["bg"],
          onPressed: () {
            Navigator.push(
                context,
                PageTransition(
                    child: AddUser(), type: PageTransitionType.rightToLeft));
          },
          child: Icon(Icons.add),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 12.0.h,
                color: Color(0xFFE5E5E5),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 25),
                    child: Form(
                      key: _formKey,
                      child: Container(
                        width: 100.0.h,
                        height: 8.0.h,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Themes.primaryColor["default"]),
                        child: Row(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(right: 8.0, left: 10.0),
                              child: Container(
                                width: 70.0.w,
                                height: 6.0.h,
                                padding: EdgeInsets.only(left: 12.0),
                                child: TextFormField(
                                  controller: _searchController,
                                  decoration: new InputDecoration(
                                    // prefixIcon: Icon(Icons.mail),
                                    filled: true,
                                    hintText: "Search Contact",
                                    hintStyle:
                                        TextStyle(fontWeight: FontWeight.w300),
                                    fillColor: Colors.white,
                                    border: InputBorder.none,
                                  ),
                                  keyboardType: TextInputType.text,
                                  onChanged: searching,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: GestureDetector(
                                onTap: () {
                                  _handleSearch();
                                },
                                child: Container(
                                    width: 10.0.w, child: Icon(Icons.search)),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  Container(
                    height: 9.0.h,
                    width: 70.0.w,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        physics: BouncingScrollPhysics(),
                        itemCount: 2,
                        itemBuilder: (context, index) {
                          if (index == 0) {
                            title = "All";
                          } else {
                            title = "Favourite";
                          }
                          return Padding(
                            padding: EdgeInsets.only(left: index == 0 ? 10 : 0),
                            child: buttonBuilder(title, index),
                          );
                        }),
                  ),
                ],
              ),
              _contactService.title == "All"
                  ? Column(
                      children: [
                        Container(
                          width: 100.0.w,
                          // height: 65.0.h,
                          child: FutureBuilder<User>(
                            future: _contactService.userData,
                            builder: (context, snapshot) {
                              if (snapshot.hasData &&
                                  _contactService.isSearching == false) {
                                _contactService.userList = snapshot.data;
                                _contactService.data =
                                    _contactService.userList.data;
                              } else if (snapshot.hasData &&
                                  _contactService.isSearching == true) {
                                _contactService.userList = snapshot.data;
                                _contactService.data = _contactService
                                    .userList.data
                                    .where((u) => (u.email
                                            .toLowerCase()
                                            .contains(_searchController.text
                                                .toLowerCase()) ||
                                        u.firstName.toLowerCase().contains(
                                            _searchController.text
                                                .toLowerCase()) ||
                                        u.lastName.toLowerCase().contains(
                                            _searchController.text
                                                .toLowerCase())))
                                    .toList();
                              }

                              return _contactService.data != null
                                  ? ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: _contactService.data.length,
                                      physics: ClampingScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0, vertical: 10),
                                          child: GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  PageTransition(
                                                      child: ProfileScreen(
                                                        fname: _contactService
                                                            .data[index]
                                                            .firstName,
                                                        lname: _contactService
                                                            .data[index]
                                                            .lastName,
                                                        email: _contactService
                                                            .data[index].email,
                                                        image: _contactService
                                                            .data[index].avatar,
                                                        id: _contactService
                                                            .data[index].id,
                                                        user: _contactService
                                                            .data[index],
                                                      ),
                                                      type: PageTransitionType
                                                          .fade));
                                            },
                                            child: Slidable(
                                              actionPane:
                                                  SlidableDrawerActionPane(),
                                              actionExtentRatio: 0.25,
                                              secondaryActions: <Widget>[
                                                Container(
                                                  decoration: BoxDecoration(
                                                    border: Border(
                                                      right: BorderSide(
                                                          width: 2.0,
                                                          color: Themes
                                                                  .primaryColor[
                                                              "bg"]),
                                                    ),
                                                  ),
                                                  child: IconSlideAction(
                                                    color: Themes
                                                        .primaryColor["bg"]
                                                        .withOpacity(0.3),
                                                    icon: Icons.edit,
                                                    foregroundColor:
                                                        Colors.yellow,
                                                    closeOnTap: true,
                                                    onTap: () {
                                                      Navigator.push(
                                                          context,
                                                          PageTransition(
                                                              child:
                                                                  EditProfileScreen(
                                                                fname: _contactService
                                                                    .data[index]
                                                                    .firstName,
                                                                lname: _contactService
                                                                    .data[index]
                                                                    .lastName,
                                                                email:
                                                                    _contactService
                                                                        .data[
                                                                            index]
                                                                        .email,
                                                                image:
                                                                    _contactService
                                                                        .data[
                                                                            index]
                                                                        .avatar,
                                                                id: _contactService
                                                                    .data[index]
                                                                    .id,
                                                              ),
                                                              type:
                                                                  PageTransitionType
                                                                      .fade));
                                                    },
                                                  ),
                                                ),
                                                Container(
                                                  child: IconSlideAction(
                                                    color: Themes
                                                        .primaryColor["bg"]
                                                        .withOpacity(0.3),
                                                    icon: Icons.delete,
                                                    foregroundColor: Colors.red,
                                                    closeOnTap: true,
                                                    onTap: () {
                                                      showDialog(
                                                          context: context,
                                                          child:
                                                              CupertinoAlertDialog(
                                                            title: Text(""),
                                                            content: Text(
                                                                "Are you sure you want to delete this contact?"),
                                                            actions: <Widget>[
                                                              CupertinoDialogAction(
                                                                isDefaultAction:
                                                                    true,
                                                                onPressed: () {
                                                                  setState(() {
                                                                    _contactService.deleteUser(
                                                                        _contactService
                                                                            .data[index]
                                                                            .id,
                                                                        context);
                                                                    if (_contactService
                                                                        .favListID
                                                                        .contains(_contactService
                                                                            .data[index]
                                                                            .id)) {
                                                                      _contactService
                                                                          .favList
                                                                          .removeAt(
                                                                              index);
                                                                      _contactService
                                                                          .favListID
                                                                          .removeAt(
                                                                              index);
                                                                    }
                                                                    _contactService
                                                                        .data
                                                                        .removeAt(
                                                                            index);
                                                                  });

                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                child: Text(
                                                                  "Yes",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .red),
                                                                ),
                                                              ),
                                                              CupertinoDialogAction(
                                                                  textStyle: TextStyle(
                                                                      color: Colors
                                                                          .red),
                                                                  isDefaultAction:
                                                                      true,
                                                                  onPressed:
                                                                      () async {
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                  child: Text(
                                                                    "No",
                                                                    style: TextStyle(
                                                                        color: Themes
                                                                            .primaryColor["bg"]),
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
                                                    image: (_contactService
                                                                .data[index]
                                                                .avatar !=
                                                            null)
                                                        ? NetworkImage(
                                                            _contactService
                                                                .data[index]
                                                                .avatar)
                                                        : AssetImage(
                                                            'assets/addImage.png'),
                                                  ),
                                                ),
                                                title: Row(
                                                  children: [
                                                    Text(_contactService
                                                        .data[index].firstName),
                                                    (_contactService.favListID
                                                            .contains(
                                                                _contactService
                                                                    .data[index]
                                                                    .id))
                                                        ? Container(
                                                            height: 2.0.h,
                                                            width: 7.0.w,
                                                            child: Image(
                                                                image: AssetImage(
                                                                    'assets/fav.png')),
                                                          )
                                                        : Container()
                                                  ],
                                                ),
                                                subtitle: Text(_contactService
                                                    .data[index].email),
                                                trailing: GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      _recipientController
                                                              .text =
                                                          _contactService
                                                              .data[index]
                                                              .email;
                                                      _subjectController.text =
                                                          'Hi!';
                                                      _bodyController.text =
                                                          'Let us be friends :)';
                                                    });
                                                    _contactService.sendEmail(
                                                        _bodyController.text,
                                                        _subjectController.text,
                                                        [
                                                          _recipientController
                                                              .text
                                                        ],
                                                        attachments,
                                                        isHTML);
                                                  },
                                                  child: Container(
                                                    width: 8.0.w,
                                                    height: 5.0.h,
                                                    child: Image(
                                                      image: AssetImage(
                                                          'assets/share.png'),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    )
                                  : Column(
                                      children: [
                                        SizedBox(
                                          height: 10.0.h,
                                        ),
                                        Image(
                                            image: AssetImage(
                                                'assets/noContact.png')),
                                        SizedBox(
                                          height: 10.0.h,
                                        ),
                                      ],
                                    );
                            },
                          ),
                        ),
                        (_contactService.listNewUser.length != 0)
                            ? NewUser()
                            : Container()
                      ],
                    )
                  : FavScreen(),
            ],
          ),
        ));
  }

  Widget buttonBuilder(String title, int index) {
    return GestureDetector(
      onTap: () => {
        setState(
          () {
            selected = index;
            _contactService.title = title;
          },
        ),
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Material(
              elevation: 4,
              borderRadius: BorderRadius.circular(7),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7),
                  color: selected == index
                      ? Themes.primaryColor["bg"]
                      : Themes.primaryColor["default"],
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Text(
                    title,
                    style: selected == index
                        ? TextStyle(color: Themes.primaryColor["default"])
                        : TextStyle(color: Colors.black),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
