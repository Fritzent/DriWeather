part of 'session_bloc.dart';

enum SessionStatus {
  checking, found, notFound
}

class SessionState {
  final SessionStatus status;
  final bool isLoading;

  const SessionState({this.status = SessionStatus.checking, this.isLoading = false});
}