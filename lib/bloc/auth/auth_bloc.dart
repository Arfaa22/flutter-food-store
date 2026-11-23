import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_application_1/resource/local/auth_local_resource.dart';
import 'package:flutter_application_1/resource/remote/auth_remote_resource.dart';

part 'auth_event.dart';
part 'auth_state.dart';
part 'auth_bloc.freezed.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRemoteResource authRemoteResource;

  AuthBloc(this.authRemoteResource) : super(const Initial()) {
    on<_CheckLoginStatus>(_onCheckLoginStatus);
    on<_LoginRequested>(_onLoginRequested);
    on<_RegisterRequested>(_onRegisterRequested);
    on<_LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onCheckLoginStatus(
    _CheckLoginStatus event,
    Emitter<AuthState> emit,
  ) async {
    final token = await AuthLocalResource.getToken();
    if (token != null && token.isNotEmpty) {
      emit(const AuthState.authenticated());
    } else {
      emit(const AuthState.unauthenticated());
    }
  }

  Future<void> _onLoginRequested(
    _LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState.loading());
    final result = await authRemoteResource.login(event.email, event.password);
    result.fold(
      (error) => emit(AuthState.failure(error)),
      (data) => emit(const AuthState.authenticated()),
    );
  }

  Future<void> _onRegisterRequested(
    _RegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState.loading());
    final result = await authRemoteResource.register(
      event.name,
      event.email,
      event.password,
      event.passwordConfirmation,
    );
    result.fold((error) {
      final message = error is Map
          ? (error['message']?.toString() ?? 'Registrasi gagal')
          : error.toString();
      emit(AuthState.registerFailure(message));
    }, (message) => emit(AuthState.registerSuccess(message)));
  }

  Future<void> _onLogoutRequested(
    _LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState.loading());
    await authRemoteResource.logout();
    await AuthLocalResource.deleteToken();
    emit(const AuthState.unauthenticated());
  }
}
