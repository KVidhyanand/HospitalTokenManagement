import 'package:flutter/material.dart';
import 'package:hospital_token/screens/hospital_token_dashboard.dart';

import 'core/theme.dart';
import 'screens/dashboard_screen.dart';

class HospitalTokenApp extends StatelessWidget {
  const HospitalTokenApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Hospital Token Display",
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: HospitalTokenDashboard(
        departments: departments,
      ), //const DashboardScreen(),
    );
  }
}

final departments = [
  Department(
    name: 'Orthopaedics',
    clinics: [
      Clinic(name: 'Clinic 1', doctor: 'Dr. Srinivas', token: '101'),
      Clinic(name: 'Clinic 2', doctor: 'Dr. Veera', token: '103'),
      Clinic(name: 'Clinic 3', doctor: 'Dr. Ramesh Babu', token: '105'),
      Clinic(name: 'Clinic 4', doctor: 'Dr. Sailaja', token: '107'),
      Clinic(name: 'Clinic 5', doctor: 'Dr. GK Sir', token: '109'),
      Clinic(name: 'Clinic 6', doctor: 'Dr. Naga Sai', token: '111'),
      Clinic(name: 'Clinic 7', doctor: 'Dr. Vinod', token: '113'),
      Clinic(name: 'Clinic 8', doctor: 'Dr. Nishant', token: '115'),
    ],
  ),

  Department(
    name: 'Cardiology',
    clinics: [
      Clinic(name: 'Clinic 1', doctor: 'Dr. Mallesh Sir', token: '101'),
      Clinic(name: 'Clinic 2', doctor: 'Dr. Sailaja', token: '103'),
      Clinic(name: 'Clinic 3', doctor: 'Dr. Sirisha', token: '105'),
      Clinic(name: 'Clinic 4', doctor: 'Dr. Sai', token: '107'),
      Clinic(name: 'Clinic 5', doctor: 'Dr. Surya Kiran', token: '109'),
      Clinic(name: 'Clinic 6', doctor: 'Dr. Dadi Srinivas', token: '111'),
      Clinic(name: 'Clinic 7', doctor: 'Dr. Vidhyanand', token: '113'),
      Clinic(name: 'Clinic 8', doctor: 'Dr. Arun Kumar', token: '115'),
    ],
  ),
];
