import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Model/modelService.dart';
import 'package:flutter_application_1/Model/userModel.dart';
import 'package:flutter_application_1/Screen/profileScreen.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';

class ContactService {
  StreamController<ServiceModel> controller =
      StreamController<ServiceModel>.broadcast();
  ServiceModel serviceModel = ServiceModel();
  final client = Dio();
  String title = "All";
  User userList = new User();
  Future<User> userData;
  List<Data> data = new List<Data>();
  List<Data> data2 = new List<Data>();
  int page = 1;
  List<Data> favList = new List<Data>();
  List<int> favListID = [];
  bool fav = false;
  User retrievedUser;
  User updatedUser;
  bool isSearching = false;
  String searchText = "";
  List<User> searchresult;
  File image;
  bool imageIsLoading = false;
  ImagePicker imagePicker = ImagePicker();
  PickedFile pickedFile;
  List<User> listNewUser = [];
  bool syncr = false;

  Future<User> getUser(page) async {
    final url = 'https://reqres.in/api/users?page=$page';
    final response = await client.get(url);

    if (response.statusCode == 200) {
      return User.fromJson(response.data);
    } else {
      print('${response.statusCode} : ${response.data.toString()}');
      throw response.statusCode;
    }
  }

  Future<void> deleteUser(int id, context) async {
    final url = 'https://reqres.in/api/users/$id';
    try {
      await client.delete(url);
      print('Done');
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<User> updateUser({User userInfo, int id, context}) async {
    try {
      Response response = await client.put(
        'https://reqres.in/api/users/$id',
        data: userInfo.toJson(),
      );
      updatedUser = User.fromJson(response.data);
    } catch (e) {
      print('Error updating user: $e');
    }

    return updatedUser;
  }

  Future<User> addUser(User userInfo) async {
    Response response = await client.post(
      'https://reqres.in/api/users',
      data: userInfo.toJson(),
    );
    retrievedUser = User.fromJson(response.data);
    print('User created: ${response.data}');

    return retrievedUser;
  }

  Future<void> sendEmail(body, subj, List<String> recipient,
      List<String> attachments, html) async {
    final Email email = Email(
      body: body,
      subject: subj,
      recipients: recipient,
      attachmentPaths: attachments,
      isHTML: html,
    );

    try {
      await FlutterEmailSender.send(email);
    } catch (error) {
      print('$error');
    }
  }
}
