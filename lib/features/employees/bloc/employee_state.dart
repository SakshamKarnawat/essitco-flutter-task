part of 'employee_bloc.dart';

sealed class EmployeeState extends Equatable {
  const EmployeeState();

  @override
  List<Object> get props => [];
}

final class EmployeeInitial extends EmployeeState {}

final class EmployeeLoading extends EmployeeState {}

final class EmployeeLoaded extends EmployeeState {
  final List<Employee> employees;
  final int? minAge;
  final int? maxAge;
  final Map<String, List<Employee>> dynamicAgeGroupedEmployees;

  const EmployeeLoaded(
    this.employees, {
    this.minAge,
    this.maxAge,
    this.dynamicAgeGroupedEmployees = const {},
  });

  @override
  List<Object> get props => [employees];
}

final class EmployeeError extends EmployeeState {
  final String error;

  const EmployeeError(this.error);

  @override
  List<Object> get props => [error];
}
