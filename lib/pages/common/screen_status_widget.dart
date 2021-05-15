import 'package:dream/core/data_status/status_enum.dart';
import 'package:flutter/material.dart';

class DataStatusWidget extends StatelessWidget {
  final Function body;
  final Function error;
  final Function loading;
  final Function empty;
  final Function updating;
  final Status dataStatus;

  const DataStatusWidget(
      {Key key,
      @required this.body,
      @required this.error,
      @required this.loading,
      @required this.empty,
      @required this.dataStatus,
      @required this.updating})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (dataStatus) {
      case Status.initial:
      case Status.loading:
        return loading();
        break;
      case Status.error:
        return error();
        break;
      case Status.empty:
        return empty();
        break;
      case Status.updating:
        return updating();
        break;
      case Status.loaded:
        return body();
    }
    return error();
  }
}
