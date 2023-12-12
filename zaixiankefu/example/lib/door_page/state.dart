
import 'package:fish_redux/fish_redux.dart';

class DoorState implements Cloneable<DoorState> {


  @override
  DoorState clone() {
    return DoorState();
  }
}

DoorState initState(Map<String, dynamic> args) {
  DoorState newState = DoorState();

  return newState;
}
