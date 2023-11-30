import 'package:equatable/equatable.dart';
import 'package:essitco_flutter_task/features/employees/repositories/employee_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final EmployeeRepository employeeRepository;

  AuthBloc(this.employeeRepository) : super(AuthUnauthenticated()) {
    on<AuthEvent>((event, emit) async {
      if (event is LoginEvent) {
        emit(AuthLoading());
        await Future.delayed(const Duration(seconds: 2));
        emit(AuthAuthenticated(event.email));
      } else if (event is LogoutEvent) {
        emit(AuthLoading());
        await Future.delayed(const Duration(seconds: 2));
        emit(AuthUnauthenticated());
      }
    });
  }
}
