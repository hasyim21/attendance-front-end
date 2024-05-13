import 'package:equatable/equatable.dart';

import 'user.dart';

class Auth extends Equatable {
  final User user;
  final String token;

  const Auth({
    required this.user,
    required this.token,
  });

  @override
  List<Object> get props => [user, token];
}
