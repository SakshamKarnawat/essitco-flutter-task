import 'dart:convert';

import 'package:essitco_flutter_task/features/employees/models/employee_model.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;

typedef EitherStringEmployees = Either<String, List<Employee>>;

abstract class EmployeeRepository {
  Future<EitherStringEmployees> fetchEmployees();
}

class EmployeeRepositoryImpl implements EmployeeRepository {
  @override
  Future<EitherStringEmployees> fetchEmployees() async {
    final Uri uri =
        Uri.parse('http://dummy.restapiexample.com/api/v1/employees');
    try {
      final response = await http.get(uri);
      final data = json.decode(response.body);
      final List<dynamic> employeeList = data['data'];
      final List<Employee> employees =
          employeeList.map((e) => Employee.fromJson(e)).toList();
      return Right(employees);
    } catch (e) {
      return const Left("Error fetching employees! Please try again later.");
    }
  }
}
