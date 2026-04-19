import 'package:equatable/equatable.dart';
import 'package:nexus/models/user_model.dart';

// sealed = every subclass must be in this file
// compiler knows ALL possible states — no surprises
sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => []; // Equatable uses this to compare states
}

/// App just started — no action taken yet
final class AuthInitial extends AuthState {
  const AuthInitial();
}

/// Waiting for API response — show spinner
final class AuthLoading extends AuthState {
  const AuthLoading();
}

/// Login or register succeeded — carry the user forward
final class AuthSuccess extends AuthState {
  final User user;
  const AuthSuccess(this.user);

  @override
  List<Object?> get props => [user]; // two AuthSuccess with same user = equal
}

/// User is fully logged out — navigate to login screen
final class AuthLoggedOut extends AuthState {
  const AuthLoggedOut();
}

/// Something went wrong — show this message to the user
final class AuthError extends AuthState {
  final String message;
  const AuthError(this.message);

  @override
  List<Object?> get props => [message]; // two AuthError with same message = equal
}