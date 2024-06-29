part of 'permissions_bloc.dart';

enum PermissionsStatus { initial, success, failure }

class PermissionsState extends Equatable {
  final PermissionsStatus status;
  final List<Permission> permissions;
  final int page;
  final int perPage;
  final bool hasReachedMax;
  final String message;

  const PermissionsState({
    required this.status,
    required this.permissions,
    required this.page,
    required this.perPage,
    required this.hasReachedMax,
    required this.message,
  });

  factory PermissionsState.initial() {
    return const PermissionsState(
      status: PermissionsStatus.initial,
      permissions: [],
      page: 1,
      perPage: 10,
      hasReachedMax: false,
      message: '',
    );
  }

  PermissionsState copyWith({
    PermissionsStatus? status,
    List<Permission>? permissions,
    int? page,
    int? perPage,
    bool? hasReachedMax,
    String? message,
  }) {
    return PermissionsState(
      status: status ?? this.status,
      permissions: permissions ?? this.permissions,
      page: page ?? this.page,
      perPage: perPage ?? this.perPage,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      message: message ?? this.message,
    );
  }

  @override
  List<Object> get props {
    return [
      status,
      permissions,
      page,
      perPage,
      hasReachedMax,
      message,
    ];
  }
}
