part of 'get_user_profile_bloc.dart';

abstract class GetUserProfileState extends Equatable {
  const GetUserProfileState();

  @override
  List<Object> get props => [];
}

class GetUserProfileInitial extends GetUserProfileState {}

class GetUserProfileLoading extends GetUserProfileState {}

class GetUserProfileSuccess extends GetUserProfileState {
  final User result;

  const GetUserProfileSuccess({required this.result});
}

class GetUserProfileError extends GetUserProfileState {
  final Failure failure;

  const GetUserProfileError({required this.failure});
}
