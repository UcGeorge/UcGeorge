import 'package:flutter/material.dart';
import 'package:flutter_assist/flutter_assist.dart';

import 'home.view.dart';

class HomeFlow {
  static void start(BuildContext context) {
    FlowUtil.moveTo(
      context: context,
      page: HomeView(flow: HomeFlow()),
      transition: FlowTransition.fade,
    );
  }
}
