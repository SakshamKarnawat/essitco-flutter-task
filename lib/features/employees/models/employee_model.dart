import 'package:equatable/equatable.dart';

class Employee extends Equatable {
  const Employee({
    required this.name,
    required this.salary,
    required this.age,
    required this.image,
  });

  final String name;
  final num salary;
  final int age;
  final String image;

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      name: json['employee_name'] ?? "",
      salary: json['employee_salary'] as num,
      age: json['employee_age'] as int,
      image: json['profile_image'] ?? "",
    );
  }

  @override
  List<Object> get props => [name, salary, age, image];
}
