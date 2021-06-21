// enum ViewState { initial, loading, loaded, error }

import 'package:dream/app/core/error/error_model.dart';

abstract class ViewState {}

class Initial extends ViewState {}

class Loading extends ViewState {}

class Loaded extends ViewState {}

class Error extends ViewState {
  ErrorModel errorModel;
  Error(this.errorModel);
}
