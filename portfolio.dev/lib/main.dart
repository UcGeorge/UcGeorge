import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_assist/util/log.util.dart';
import 'package:go_router/go_router.dart';
import 'package:scaled_app/scaled_app.dart';

import 'src/alert/alert.dart';
import 'src/home/home.flow.dart';
import 'src/home/home.view.dart';
import 'src/usm-demo/usm_demo.flow.dart';
import 'src/usm-demo/usm_demo.view.dart';

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

  if (defaultTargetPlatform == TargetPlatform.android ||
      defaultTargetPlatform == TargetPlatform.iOS) {
    LogUtil.devLog("main", message: "Presetting allowed orientations");
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  LogUtil.devLog("main", message: "Running app");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  // GoRouter configuration
  final _router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => HomeView(flow: HomeFlow()),
      ),
      GoRoute(
        path: '/usm-demo',
        builder: (context, state) => UsmDemoView(flow: UsmDemoFlow()),
      ),
    ],
  );

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
      child: AlertWrapper(
        app: MaterialApp.router(
          title: 'UcGeorge',
          debugShowCheckedModeBanner: false,
          routerConfig: _router,
        ),
      ),
    );
  }
}
