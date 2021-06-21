import 'package:dream/core/data_status/viewmodel_result.dart';
import 'package:flutter/material.dart';

class ViewModelBuilder extends StatelessWidget {
  final Future<dynamic> init;
  final Widget errorWidget;
  final Widget loadingWidget;
  final AsyncWidgetBuilder builder;

  ViewModelBuilder(
      {required this.init,
      required this.errorWidget,
      required this.loadingWidget,
      required this.builder});
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: init,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return loadingWidget;
        } else if (snapshot.connectionState == ConnectionState.done) {
          if ((snapshot.data as ViewModelResult).isCompleted) {
            return builder(context, snapshot);
          }
        }
        return errorWidget;
      },
    );
  }
}
