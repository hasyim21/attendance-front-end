import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/core.dart';
import '../../../../auth/domain/entities/user.dart';
import '../../../domain/usecases/get_user_profile.dart';

part 'get_user_profile_event.dart';
part 'get_user_profile_state.dart';

class GetUserProfileBloc
    extends Bloc<GetUserProfileEvent, GetUserProfileState> {
  final GetUserProfile _getUserProfile;

  GetUserProfileBloc(this._getUserProfile) : super(GetUserProfileInitial()) {
    on<GetUserProfileEvent>((event, emit) async {
      emit(GetUserProfileLoading());

      final result = await _getUserProfile.call();

      result.fold(
        (l) => emit(
          GetUserProfileError(
            failure: Failure(message: l.message),
          ),
        ),
        (r) => emit(GetUserProfileSuccess(result: r)),
      );
    });
  }
}
