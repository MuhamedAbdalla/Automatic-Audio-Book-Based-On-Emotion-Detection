import 'package:flutter/material.dart';
import 'package:kid_entertain/src/ui/widgets/hidden_menu/controllers/simple_hidden_drawer_controller.dart';

class MyProvider extends InheritedWidget {
  final SimpleHiddenDrawerController controller;

  MyProvider({
    Key key,
    @required this.controller,
    Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;
}
