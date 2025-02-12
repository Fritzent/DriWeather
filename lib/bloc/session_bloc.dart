import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

part 'session_event.dart';
part 'session_state.dart';

class SessionBloc extends Bloc<SessionEvent, SessionState> {
  SessionBloc() : super(SessionState()) {
    on<CheckSession>(sessionCheck);
  }

  FutureOr<void> sessionCheck(CheckSession event, Emitter<SessionState> emit) async {
    try {
      emit(SessionState(isLoading: true));
      final FlutterSecureStorage secureStorage = FlutterSecureStorage();
      String? userStatus = await secureStorage.read(key: 'isBoardingDone');

      if (userStatus!.isNotEmpty) {
        emit(SessionState(status: SessionStatus.found, isLoading: false));
      }
      else {
        emit(SessionState(status: SessionStatus.notFound, isLoading: false));
      }
    }
    catch (e) {
      emit(SessionState(status: SessionStatus.notFound, isLoading: false));
    }
  }
}
