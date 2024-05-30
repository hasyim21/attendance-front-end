import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/core.dart';
import '../../../domain/entities/company.dart';
import '../../../domain/usecases/get_company.dart';

part 'get_company_event.dart';
part 'get_company_state.dart';

class GetCompanyBloc extends Bloc<GetCompanyEvent, GetCompanyState> {
  final GetCompany getCompany;
  GetCompanyBloc({required this.getCompany}) : super(GetCompanyInitial()) {
    on<GetCompanyEvent>((event, emit) async {
      emit(GetCompanyLoading());

      final result = await getCompany.call();

      result.fold(
        (l) => emit(
          GetCompanyError(
            failure: Failure(
              message: l.message,
            ),
          ),
        ),
        (r) => emit(GetCompanySuccess(result: r)),
      );
    });
  }
}
