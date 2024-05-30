part of 'get_company_bloc.dart';

abstract class GetCompanyState extends Equatable {
  const GetCompanyState();

  @override
  List<Object> get props => [];
}

class GetCompanyInitial extends GetCompanyState {}

class GetCompanyLoading extends GetCompanyState {}

class GetCompanySuccess extends GetCompanyState {
  final Company result;

  const GetCompanySuccess({required this.result});
}

class GetCompanyError extends GetCompanyState {
  final Failure failure;

  const GetCompanyError({required this.failure});
}
