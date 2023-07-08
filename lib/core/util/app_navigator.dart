import 'package:flutter/material.dart';

import '../../main.dart';

class AppNavigator {
  static Future<void> push(
      {required BuildContext context, required Widget screen}) async {
    await Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => screen));
  }

  static dynamic pop({required BuildContext context, dynamic object}) {
    return Navigator.of(context).pop<dynamic>(object);
  }

  static dynamic popToFrist({required BuildContext context, dynamic object}) {
    return Navigator.of(context).popUntil((rout) => rout.isFirst);
  }

  static dynamic pushReplacement(
      {required BuildContext context, required Widget screen}) async {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => screen),
        (Route<dynamic> route) => false);
  }

  static dynamic popToMyApp({required BuildContext context, dynamic object}) {
    return Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (BuildContext context) => const MyApp()),
        (Route<dynamic> route) => route.isFirst);
  }
}
