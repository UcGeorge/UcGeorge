import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_assist/util/log.util.dart';
import 'package:scaled_app/scaled_app.dart';

import 'app/cache_manager.dart';
import 'app/database_manager.dart';
import 'app/remote_methods.dart';
import 'src/alert/alert.dart';
import 'src/home/home.view.dart';

void main() async {
  LogUtil.init();

  LogUtil.devLog("main", message: "Initializing Scaled App");
  ScaledWidgetsFlutterBinding.ensureInitialized(
    scaleFactor: (deviceSize) {
      // screen width used in your UI design
      const double widthOfDesign = 1920;
      return deviceSize.width / widthOfDesign;
    },
  );
  //? Then, use MediaQueryData.scale to scale size, viewInsets, viewPadding, etc.
  //* class PageRoute extends StatelessWidget {
  //*   const PageRoute({Key? key}) : super(key: key);

  //*   @override
  //*   Widget build(BuildContext context) {
  //*     return MediaQuery(
  //*       data: MediaQuery.of(context).scale(),
  //*       child: const Scaffold(...),
  //*     );
  //*   }
  //* }

  //? This makes all animations from flutter_animate restart on hot reload
  // Animate.restartOnHotReload = true;

  LogUtil.devLog("main", message: "Initializing Cache manager");
  await CacheManager.init();

  if (defaultTargetPlatform == TargetPlatform.android ||
      defaultTargetPlatform == TargetPlatform.iOS) {
    LogUtil.devLog("main", message: "Initializing database manager");
    await DatabaseManager.init();

    LogUtil.devLog("main", message: "Initializing Remote methods");
    RemoteMethods.init();

    LogUtil.devLog("main", message: "Presetting allowed orientations");
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  LogUtil.devLog("main", message: "Running app");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
          SystemChannels.textInput.invokeMethod('TextInput.hide');
        }
      },
      child: const AlertWrapper(
        app: MaterialApp(
          title: 'UcGeorge',
          debugShowCheckedModeBanner: false,
          home: HomeView(),
        ),
      ),
    );
  }
}
