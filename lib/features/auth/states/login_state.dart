import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserAuthenticationState extends Equatable {
  const UserAuthenticationState();

  @override
  List<Object> get props => [];
}

class UserAuthenticationStateInitial extends UserAuthenticationState {
  const UserAuthenticationStateInitial();

  @override
  List<Object> get props => [];
}

class UserAuthenticationStateLoading extends UserAuthenticationState {
  const UserAuthenticationStateLoading();

  @override
  List<Object> get props => [];
}

class UserAuthenticationStateSuccess extends UserAuthenticationState {
  final User user;
  final bool isEmailVerified; // Add this property

  const UserAuthenticationStateSuccess(this.user, {required this.isEmailVerified});

  @override
  List<Object> get props => [user, isEmailVerified];
}

class UserAuthenticationStateError extends UserAuthenticationState {
  final String error;

  const UserAuthenticationStateError(this.error);

  @override
  List<Object> get props => [error];
}
