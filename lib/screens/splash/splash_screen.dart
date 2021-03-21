import 'package:flutter/material.dart';
import 'package:hoomee/screens/main.dart';
import 'package:hoomee/utils/app_routes.dart';
import 'package:hoomee/utils/app_screen_name.dart';
import 'package:hoomee/utils/styles.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: Future.delayed(Duration(seconds: 5)),
        builder:(context, state){
          if(state.connectionState == ConnectionState.done){
            AppRoutes.navigatePush(context, AppScreenName.main, MainScreen());
            return Container(
              color: Colors.blueGrey,
              child: Center(
                child: Text(
                  "HooMee",
                  style: AppTextStyle.bold.copyWith(fontSize: 28, color: Colors.white),
                ),
              ),
            );
          }
         return Container(
            color: Colors.blueGrey,
            child: Center(
              child: Text(
                "HooMee",
                style: AppTextStyle.bold.copyWith(fontSize: 28, color: Colors.white),
              ),
            ),
          );
        },
      ),
    );
  }


}
