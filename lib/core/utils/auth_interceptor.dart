import 'package:dio/dio.dart';
import 'package:flutter_application_1/bloc/auth/auth_bloc.dart';
import 'package:flutter_application_1/resource/local/auth_local_resource.dart';

class AuthInterceptor extends Interceptor {
  final AuthBloc authBloc;

  AuthInterceptor(this.authBloc);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await AuthLocalResource.getToken();
    options.headers['Accept'] = 'application/json';
    options.headers['Content-Type'] = 'application/json';
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      await AuthLocalResource.deleteToken();
      authBloc.add(const AuthEvent.checkLoginStatus());
    }
    super.onError(err, handler);
  }
}
