import 'package:rive/rive.dart';

class RiveModel {
  final String srcs, artboard, stateMachineName;
  late SMIBool? status;

  RiveModel(
      {required this.srcs,
      required this.artboard,
      required this.stateMachineName,
      this.status});

  set setState(SMIBool state) {
    status = state;
  }
}
