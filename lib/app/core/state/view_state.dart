import 'package:dream/app/core/error/failure.dart';

abstract class ViewState {}

class Initial extends ViewState {}

class Loading extends ViewState {}

class Loaded extends ViewState {}

class Error extends ViewState {
  Failure failure;
  Error(this.failure);
}
