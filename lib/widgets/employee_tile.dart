import 'package:essitco_flutter_task/features/employees/models/employee_model.dart';
import 'package:flutter/material.dart';

class EmployeeTile extends StatelessWidget {
  const EmployeeTile(this.employee, {super.key});

  final Employee employee;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              icon: SizedBox(
                width: 48,
                height: 48,
                child: CircleAvatar(
                  radius: 24,
                  child: Image.network(employee.image,
                      errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.person);
                  }),
                ),
              ),
              iconPadding: const EdgeInsets.only(top: 24),
              title: const Center(
                child: Text("Employee Details"),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Name: ${employee.name}'),
                  Text('Age: ${employee.age}'),
                  Text('Salary: ${employee.salary}'),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Close'),
                ),
              ],
            );
          },
        );
      },
      child: ListTile(
        title: Text(employee.name),
        subtitle: Text('Age: ${employee.age}'),
      ),
    );
  }
}
