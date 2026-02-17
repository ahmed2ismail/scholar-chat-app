import 'package:flutter/material.dart'; // أو import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SimpleBlocObserver extends BlocObserver {
  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    debugPrint('Change -- ${bloc.runtimeType} => $change');
    super.onChange(bloc, change);
  }

  @override
  void onTransition(Bloc<dynamic, dynamic> bloc, Transition<dynamic, dynamic> transition) {
    debugPrint('Transition -- ${bloc.runtimeType} => $transition');
    super.onTransition(bloc, transition);
  }
}