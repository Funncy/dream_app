import 'package:dream/core/data_status/status_enum.dart';
import 'package:flutter/material.dart';

class DataStatusWidget extends StatelessWidget {
  final Widget body;
  final Widget error;
  final Widget loading;
  final Widget empty;
  final Widget updating;
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
//TODO: Empty or Error Widget에서 새로 고침 가능하게 해야함. refreshIndicator 등
  @override
  Widget build(BuildContext context) {
    switch (dataStatus) {
      case Status.initial:
      case Status.loading:
        return loading;
        break;
      case Status.error:
        return error;
        break;
      case Status.empty:
        return empty;
        break;
      case Status.updating:
        return updating;
        break;
      case Status.loaded:
        return body;
    }
    return error;
  }
}
