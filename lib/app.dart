import 'package:essitco_flutter_task/core/auth/bloc/auth_bloc.dart';
import 'package:essitco_flutter_task/features/employees/bloc/employee_bloc.dart';
import 'package:essitco_flutter_task/features/employees/repositories/employee_repository.dart';
import 'package:essitco_flutter_task/views/dashboard_view.dart';
import 'package:essitco_flutter_task/views/login_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class App extends StatelessWidget {
  const App({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RepositoryProvider(
        create: (context) => EmployeeRepositoryImpl(),
        child: BlocProvider(
          create: (context) => AuthBloc(context.read<EmployeeRepositoryImpl>()),
          child: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state is AuthUnauthenticated) {
                return const LoginView();
              } else if (state is AuthAuthenticated) {
                return BlocProvider(
                  create: (context) =>
                      EmployeeBloc(context.read<EmployeeRepositoryImpl>())
                        ..add(FetchEmployeesEvent()),
                  child: const DashboardView(),
                );
              } else if (state is AuthError) {
                return Center(
                  child: Text('Error: ${state.error}'),
                );
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ),
      ),
    );
  }
}
