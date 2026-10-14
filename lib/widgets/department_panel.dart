import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hospital_token/models/department_model.dart';
import 'package:hospital_token/widgets/clinic_card.dart';
import 'package:intl/intl.dart';

import '../core/colors.dart';
import '../core/constants.dart';
import '../core/tv_sizes.dart';

class DepartmentPanel extends StatelessWidget {
  final DepartmentModel department;

  const DepartmentPanel({super.key, required this.department});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),

      child: Column(
        children: [
          /// Blue Department Header //55 to 40
          Container(
            height: 40,

            width: double.infinity,

            decoration: const BoxDecoration(
              color: Colors.blue,

              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            ),

            alignment: Alignment.center,

            child: Text(
              department.department,
              style: const TextStyle(
                fontSize: 28,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          Expanded(
            child: Column(
              children: department.clinics.map((clinic) {
                return Expanded(child: ClinicCard(clinic: clinic));
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
