import 'package:dream/app/core/state/view_state.dart';
import 'package:flutter/material.dart';

class ViewModelBuilder extends StatelessWidget {
  final Future<dynamic> init;
  final Widget errorWidget;
  final Widget loadingWidget;
  final AsyncWidgetBuilder builder;
  final Function getState;

  ViewModelBuilder(
      {required this.init,
      required this.errorWidget,
      required this.loadingWidget,
      required this.builder,
      required this.getState});
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: init,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return loadingWidget;
        } else if (snapshot.connectionState == ConnectionState.done) {
          if (getState() == ViewState.loaded) return builder(context, snapshot);
        }
        return errorWidget;
      },
    );
  }
}
