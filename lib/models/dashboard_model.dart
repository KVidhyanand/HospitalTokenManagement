import 'department_model.dart';

class DashboardModel {

  final DateTime lastUpdated;

  final List<DepartmentModel> departments;

  DashboardModel({

    required this.lastUpdated,

    required this.departments,

  });

  factory DashboardModel.fromJson(Map<String,dynamic> json){

    return DashboardModel(

      lastUpdated: DateTime.parse(json["lastUpdated"]),

      departments:(json["departments"] as List)

          .map((e)=>DepartmentModel.fromJson(e))

          .toList(),

    );

  }

}