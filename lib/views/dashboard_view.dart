import 'package:essitco_flutter_task/core/auth/bloc/auth_bloc.dart';
import 'package:essitco_flutter_task/features/employees/bloc/employee_bloc.dart';
import 'package:essitco_flutter_task/widgets/employee_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  String query = "";
  String ageGroupFilter = "";

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Employee Dashboard'),
          centerTitle: false,
          actions: [
            IconButton(
              onPressed: () {
                BlocProvider.of<EmployeeBloc>(context)
                    .add(FetchEmployeesEvent());
              },
              icon: const Icon(Icons.refresh),
            ),
            IconButton(
              onPressed: () {
                BlocProvider.of<AuthBloc>(context).add(LogoutEvent());
              },
              icon: const Icon(Icons.logout),
            ),
          ],
        ),
        body: BlocBuilder<EmployeeBloc, EmployeeState>(
          builder: (context, state) {
            if (state is EmployeeLoaded) {
              final employees = state.employees
                  .where((e) => e.name.toLowerCase().contains(query))
                  .where((e) => ageGroupFilter.isEmpty
                      ? true
                      : state.dynamicAgeGroupedEmployees[ageGroupFilter]!
                          .contains(e))
                  .toList();
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            onChanged: (q) {
                              setState(() {
                                query = q.toLowerCase();
                              });
                            },
                            decoration: const InputDecoration(
                              labelText: 'Search by employee name',
                              prefixIcon: Icon(Icons.search),
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return SimpleDialog(
                                    title: const Text('Filter by age'),
                                    children: state
                                        .dynamicAgeGroupedEmployees.keys
                                        .map((ageGroup) {
                                      return ListTile(
                                        title: Text(ageGroup),
                                        onTap: () {
                                          setState(() {
                                            ageGroupFilter = ageGroup;
                                          });
                                          Navigator.of(context).pop();
                                        },
                                      );
                                    }).toList(),
                                  );
                                });
                          },
                          icon: const Icon(Icons.filter_list),
                        ),
                        if (ageGroupFilter.isNotEmpty)
                          IconButton(
                            onPressed: () {
                              setState(() {
                                ageGroupFilter = "";
                              });
                            },
                            icon: const Icon(Icons.close),
                          ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: employees.length,
                      itemBuilder: (context, index) {
                        return EmployeeTile(employees[index]);
                      },
                    ),
                  ),
                ],
              );
            } else if (state is EmployeeError) {
              return Center(
                child: Text('Error: ${state.error}'),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
