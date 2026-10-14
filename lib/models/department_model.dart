import 'clinic_model.dart';

class DepartmentModel {

  final String department;

  final List<ClinicModel> clinics;

  DepartmentModel({
    required this.department,
    required this.clinics,
  });

  factory DepartmentModel.fromJson(Map<String,dynamic> json){

    return DepartmentModel(

      department: json["department"],

      clinics: (json["clinics"] as List)

          .map((e)=>ClinicModel.fromJson(e))

          .toList(),

    );

  }

}