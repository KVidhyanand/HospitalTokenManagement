import 'package:flutter/material.dart';

import '../core/colors.dart';
import '../core/constants.dart';
import '../core/tv_sizes.dart';
import '../models/clinic_model.dart';
import 'token_box.dart';

class ClinicCard extends StatelessWidget {
  final ClinicModel clinic;

  const ClinicCard({super.key, required this.clinic});

  @override
  Widget build(BuildContext context) {
    final is4K = TvSizes.is4K(context);

    //12
    return Card(
      elevation: 5,
      margin: const EdgeInsets.all(1),

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
      ),

      //padding: EdgeInsets.all(is4K ? 24 : 16),
      child: Container(
        padding: EdgeInsets.all(is4K ? 24 : 1),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Header Row
            const SizedBox(height: 3),
            Row(
              children: [
                const SizedBox(width: 10),
                const Icon(Icons.local_hospital, color: AppColors.primary),
                const SizedBox(width: 10),

                SizedBox(
                  width: 100, // Adjust the width as needed
                  child: Text(
                    clinic.clinicName,
                    style: TextStyle(
                      fontSize: TvSizes.clinicTitle(context),
                      fontWeight: FontWeight.bold,
                      color: AppColors.title,
                    ),
                  ),
                ),

                //const Icon(Icons.local_hospital, color: AppColors.primary),
                const SizedBox(width: 5),
                Expanded(
                  child:
                      /// Doctor
                      Text(
                        clinic.doctorName,
                        style: TextStyle(
                          fontSize: TvSizes.doctorName(context),
                          color: AppColors.body,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                ),

                const SizedBox(width: 10),

                SizedBox(
                  height: 40,
                  child: TokenBox(
                    token: clinic.currentToken,
                    color: AppColors.currentToken,
                  ),
                ),

                Icon(
                  Icons.circle,
                  size: is4K ? 16 : 12,
                  color: clinic.isOnline ? AppColors.online : AppColors.offline,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
