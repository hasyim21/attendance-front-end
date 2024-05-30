import 'package:equatable/equatable.dart';

import '../../../auth/domain/entities/user.dart';

class FaceEmbedding extends Equatable {
  final User user;

  const FaceEmbedding({
    required this.user,
  });

  @override
  List<Object> get props => [user];
}
