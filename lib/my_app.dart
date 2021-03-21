import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hoomee/provider/main_provider.dart';
import 'package:hoomee/screens/main.dart';
import 'package:hoomee/service/network_util.dart';
import 'package:hoomee/usecase/app_usecase.dart' as appUserCase;
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:ui' as ui;
import 'generated/l10n.dart';
import 'globals.dart';
import 'utils/app_helper.dart';
import 'utils/styles.dart';
import 'widgets/loading.dart';

void main() async {
  await initMyApp();
}

Future<void> initMyApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  Directory directory = await getApplicationDocumentsDirectory();
  Hive.init(directory.path);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MainProvider()),
      ],
      child: Builder(builder: (context) {
        appUserCase.setContext(context);
        return MyApp();
      }),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final mainAppBloc = MainAppBloc.instance;
  StreamSubscription networkSubscription;

  @override
  void dispose() {
    mainAppBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => postBuild(context));
    return MaterialApp(
      localizationsDelegates: [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      locale: Locale(ui.window.locale?.languageCode),
      supportedLocales: S.delegate.supportedLocales,
      navigatorKey: AppGlobals.rootNavKey,
      debugShowCheckedModeBanner: false,
      title: 'Flutter Provider Rx',
      builder: (context, child){
        return Stack(
          children: [
            child,
            StreamBuilder<bool>(
                stream: mainAppBloc.appLoading.stream,
                initialData: false,
                builder: (context, snapshot) {
                  return snapshot.data ? AppLoading() : SizedBox();
                }
            ),
          ],
        );
      },
      home: Scaffold(
        body: FutureBuilder(
          future: context.read<MainProvider>().delayTime(),
          builder:(context, state){

            if(state.connectionState == ConnectionState.done){

              final value = context.watch<MainProvider>().delayed;

              return value ? MainScreen() : Container(
                color: Colors.blueGrey,
                child: Center(
                  child: Text(
                    "HooMee",
                    style: AppTextStyle.bold.copyWith(fontSize: 28, color: Colors.white),
                  ),
                ),
              );
            }
            else{
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
          },
        ),
      ),
    );
  }


  void postBuild(BuildContext context) {
    checkNetworkResult();
  }

  void checkNetworkResult() {
    networkSubscription?.cancel();
    networkSubscription = NetworkingUtil().networkStatus.stream.distinct().listen((network){
      Logging.log('connect network: $network');
      if(!network){
        // show alert network
        AppHelper.showNetworkDialog("Network", "Network not connected");
      }
    });
  }

}

class MainAppBloc {
  MainAppBloc._private();
  static final instance = MainAppBloc._private();

  final appLoading = BehaviorSubject<bool>();
  final pageIndex = BehaviorSubject<int>();

  PageController _pageController;
  AnimationController _bottomAppBarController;

  bool showAlertTimeOut = false;

  void dispose(){
    appLoading.close();
    pageIndex.close();
    _pageController.dispose();
    _bottomAppBarController.dispose();
  }

  void initPageController(PageController controller, AnimationController bottomAppBarController){
    _pageController = controller;
    _bottomAppBarController = bottomAppBarController;
  }


}