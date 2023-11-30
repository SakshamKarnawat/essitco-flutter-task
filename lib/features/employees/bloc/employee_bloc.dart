import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/employee_model.dart';
import '../repositories/employee_repository.dart';

part 'employee_event.dart';
part 'employee_state.dart';

class EmployeeBloc extends Bloc<EmployeeEvent, EmployeeState> {
  final EmployeeRepository employeeRepository;

  EmployeeBloc(this.employeeRepository) : super(EmployeeInitial()) {
    on<EmployeeEvent>((event, emit) async {
      if (event is FetchEmployeesEvent) {
        emit(EmployeeLoading());
        try {
          final response = await employeeRepository.fetchEmployees();
          response.fold(
            (l) => emit(EmployeeError(l)),
            (r) {
              final int minAge = r.map((e) => e.age).reduce(
                  (value, element) => value < element ? value : element);
              final int maxAge = r.map((e) => e.age).reduce(
                  (value, element) => value > element ? value : element);
              Map<String, List<Employee>> dynamicAgeGroupedEmployees = {};
              int startAge = minAge;
              while (startAge <= maxAge) {
                final int groupEndAge = startAge + 9;
                final String ageGroup = '$startAge-$groupEndAge';
                if (groupEndAge > maxAge) {
                  dynamicAgeGroupedEmployees['$startAge-$maxAge'] =
                      r.where((e) => e.age >= startAge).toList();
                } else {
                  dynamicAgeGroupedEmployees[ageGroup] = r
                      .where((e) => e.age >= startAge && e.age <= groupEndAge)
                      .toList();
                }
                startAge += 10;
              }
              emit(EmployeeLoaded(
                r,
                minAge: minAge,
                maxAge: maxAge,
                dynamicAgeGroupedEmployees: dynamicAgeGroupedEmployees,
              ));
            },
          );
        } catch (e) {
          emit(const EmployeeError("Failed to fetch employees"));
        }
      }
    });
  }
}
