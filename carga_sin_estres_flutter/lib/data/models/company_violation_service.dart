class CompanyViolationService {
  final int id;
  final int companyId;
  final String reason;
  final String violationDate;

  CompanyViolationService({
    required this.id,
    required this.companyId,
    required this.reason,
    required this.violationDate,
  });

  factory CompanyViolationService.fromJson(Map<String, dynamic> json) {
    return CompanyViolationService(
      id: json['id'],
      companyId: json['companyId'],
      reason: json['reason'],
      violationDate: json['violationDate'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'companyId': companyId,
      'reason': reason,
      'violationDate': violationDate,
    };
  }
}
