import 'package:only_u/app/common/utils/helper_methods.dart';

class ApiResponse {
  String? Status;
  int? Code;
  String? Message;
  dynamic Data;
  List<dynamic>? Errors;

  // Add getters for backward compatibility
  String? get status => Status;
  int? get code => Code;
  String? get message => Message;
  dynamic get data => Data;
  List<dynamic>? get errors => Errors;

  ApiResponse({this.Status, this.Code, this.Message, this.Data, this.Errors});

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      // Handle both uppercase and lowercase field names
      Status: json['Status'] ?? json['status'],
      Code: json['Code'] ?? json['code'],
      Message: json['Message'] ?? json['message'],
      Data: json['Data'] ?? json['data'] ?? [],
      // Fix the Errors field handling
      Errors: HelpersMethod.parseErrors(json),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Status': Status,
      'Code': Code,
      'Message': Message,
      'Data': Data,
      'Errors': Errors,
    };
  }

  @override
  String toString() {
    return 'ApiResponse{Status: $Status, Code: $Code, Message: $Message, Data: $Data, Errors: $Errors}';
  }
}
