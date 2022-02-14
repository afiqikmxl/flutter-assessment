import 'package:flutter/material.dart';
import 'package:flutter_application_1/Service/service.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer_util.dart';

import 'Model/modelService.dart';
import 'Screen/myContactScreen.dart';
import 'constant.dart';
import 'locator.dart';

void main() {
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final ContactService _service = locator<ContactService>();
  final GlobalKey<NavigatorState> navigatorKey =
      new GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return OrientationBuilder(
          builder: (context, orientation) {
            SizerUtil().init(constraints, orientation);
            return MultiProvider(
              providers: [
                StreamProvider<ServiceModel>.value(
                  value: _service.controller.stream,
                  initialData: ServiceModel(),
                ),
              ],
              child: Container(
                color: Themes.primaryColor['bg'],
                child: MaterialApp(
                  debugShowCheckedModeBanner: false,
                  theme: ThemeData(
                    primaryColor: Themes.primaryColor['default'],
                    fontFamily: Themes.fontFamily,
                  ),
                  home: MyContact(),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
