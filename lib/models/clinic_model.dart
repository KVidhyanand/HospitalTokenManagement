class ClinicModel {
  final String clinicName;
  final String doctorName;
  final String opd;
  final String currentToken;
  final String nextToken;

  /// Optional status from API
  final bool isOnline;

  const ClinicModel({
    required this.clinicName,
    required this.doctorName,
    required this.opd,
    required this.currentToken,
    required this.nextToken,
    this.isOnline = true,
  });

  factory ClinicModel.fromJson(Map<String, dynamic> json) {
    return ClinicModel(
      clinicName: json["clinicName"] ?? "",
      doctorName: json["doctorName"] ?? "",
      opd: json["opd"] ?? "",
      currentToken: json["currentToken"].toString(),
      nextToken: json["nextToken"].toString(),
      isOnline: json["isOnline"] ?? true,
    );
  }
}
