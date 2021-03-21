import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hoomee/widgets/dialogs.dart';
import 'package:intl/intl.dart';

import '../globals.dart';


class AppHelper {

  static double screenWidth(BuildContext context){
    return MediaQuery.of(context).size.width;
  }

  static double screenHeight(BuildContext context){
    return MediaQuery.of(context).size.height;
  }

  static double statusBarHeight(BuildContext context){
    return MediaQuery.of(context).padding.top;
  }

  /// set status bar style overlay ui
  static SystemUiOverlayStyle statusBarOverlayUI(Brightness androidBrightness){
    SystemUiOverlayStyle statusBarStyle;
    if(Platform.isIOS)
      statusBarStyle = (androidBrightness == Brightness.light) ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark;
    if(Platform.isAndroid){
      statusBarStyle = SystemUiOverlayStyle(statusBarColor: Colors.transparent, statusBarIconBrightness: androidBrightness ?? Brightness.light);
    }
    return statusBarStyle;
  }

  /// hide keyboard
  static void hideKeyboard(context) {
    FocusScope.of(context).unfocus();
  }

  /// network dialog
  static void showNetworkDialog(String title, String message) {
    if (AppGlobals.nav.overlay.context == null) return;
    showDialog(
      context: AppGlobals.nav.overlay.context,
      barrierDismissible: false,
      builder: (context) => AppAlertDialog(title: title,message: message),
    );
  }

  /// normal dialog
  static void showAppDialog(String title, String message) {
    if (AppGlobals.nav.overlay.context == null) return;
    showDialog(
      context: AppGlobals.nav.overlay.context,
      barrierDismissible: false,
      builder: (BuildContext context) => AppAlertDialog(title: title,message: message),
    );
  }

  /// normal dialog
  static void showConfirmDialog(String title, String message, Function buttonOKCallback) {
    if (AppGlobals.nav.overlay.context == null) return;
    showDialog(
      context: AppGlobals.nav.overlay.context,
      barrierDismissible: false,
      builder: (BuildContext context) => ConfirmAlertDialog(
        title: title,
        message: message,
        onOkPress: () => buttonOKCallback(),
      ),
    );
  }

  static void monkeyTapping(
      {@required Duration durationTapping,
        @required Function action}) {


    DateTime currentTime = DateTime.now();
    DateTime buttonPressTime;

    bool activeButtonPress = buttonPressTime == null || currentTime.difference(buttonPressTime) > durationTapping;

    if (activeButtonPress) {
      action();
    } else {
      return;
    }
  }

  static void showBottomSheet(context, Widget child, [isScrollControlled = false]) {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: isScrollControlled,
        builder: (context) {
          return isScrollControlled ? DraggableScrollableSheet(
            initialChildSize: 0.6, // half screen on load
            maxChildSize: 1,// full screen on scroll
            minChildSize: 0.25,
            builder: (BuildContext context, ScrollController scrollController) {
              return child;
            },
          ) : child;
        });
  }

  static String formatDateTime(DateTime dateTime){
    final DateFormat formatter = DateFormat('MMMM dd, yyyy');
    return formatter.format(dateTime);
  }

  static String getNameDaysOfWeek(DateTime dateTime){
    return DateFormat('EEEE').format(dateTime);
  }

  static String formatStringToDateTime(String dateTime){
    DateTime date = DateTime.parse(dateTime);
    final DateFormat formatter = DateFormat('MMMM dd, yyyy');
    return formatter.format(date);
  }

}

/// Log utils
class Logging {
  static int tet;

  static void log(dynamic data) {
    if (!kReleaseMode) print(data);
  }
}