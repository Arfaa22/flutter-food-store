import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_application_1/resource/model/customer_model.dart';
import 'package:flutter_application_1/resource/remote/profile_remote_resource.dart';

part 'profile_event.dart';
part 'profile_state.dart';
part 'profile_bloc.freezed.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRemoteResource profileRemoteResource;

  ProfileBloc(this.profileRemoteResource) : super(const _Initial()) {
    on<_LoadProfile>(_onLoadProfile);
    on<_UpdateProfile>(_onUpdateProfile);
  }

  Future<void> _onLoadProfile(
    _LoadProfile event,
    Emitter<ProfileState> emit,
  ) async {
    emit(const ProfileState.loading());
    final result = await profileRemoteResource.fetchProfile();
    result.fold(
      (error) => emit(ProfileState.error(error)),
      (customer) => emit(ProfileState.loadedProfile(customer)),
    );
  }

  Future<void> _onUpdateProfile(
    _UpdateProfile event,
    Emitter<ProfileState> emit,
  ) async {
    emit(const ProfileState.loading());
    final result = await profileRemoteResource.updateProfile(
      name: event.name,
      email: event.email,
      image: event.image,
      password: event.password,
      passwordConfirmation: event.passwordConfirmation,
    );
    result.fold((error) {
      if (error is Map<String, dynamic>) {
        emit(ProfileState.failure(error: error));
      } else {
        emit(ProfileState.error(error.toString()));
      }
    }, (message) => emit(ProfileState.updatedProfile(message)));
  }
}
