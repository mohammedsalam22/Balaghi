import '../../domain/entities/complaint_entity.dart';

class ComplaintModel extends ComplaintEntity {
  const ComplaintModel({
    required super.id,
    required super.type,
    required super.assignedPart,
    required super.location,
    required super.description,
    required super.complaintNumber,
    required super.status,
    required super.userId,
    required super.createdAt,
  });

  factory ComplaintModel.fromJson(Map<String, dynamic> json) {
    return ComplaintModel(
      id: json['id'] as String,
      type: json['type'] as String,
      assignedPart: json['assignedPart'] as String,
      location: json['location'] as String,
      description: json['description'] as String,
      complaintNumber: json['complaintNumber'] as int,
      status: json['status'] as int,
      userId: json['userId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'assignedPart': assignedPart,
      'location': location,
      'description': description,
      'complaintNumber': complaintNumber,
      'status': status,
      'userId': userId,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

class CreateComplaintRequestModel {
  final String type;
  final String assignedPart;
  final String location;
  final String description;

  CreateComplaintRequestModel({
    required this.type,
    required this.assignedPart,
    required this.location,
    required this.description,
  });

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'assignedPart': assignedPart,
      'location': location,
      'description': description,
    };
  }
}

class CreateComplaintResponseModel {
  final String message;
  final int complaintNumber;
  final String complaintId;
  final bool success;

  CreateComplaintResponseModel({
    required this.message,
    required this.complaintNumber,
    required this.complaintId,
    required this.success,
  });

  factory CreateComplaintResponseModel.fromJson(Map<String, dynamic> json) {
    return CreateComplaintResponseModel(
      message: json['message'] as String,
      complaintNumber: json['complaintNumber'] as int,
      complaintId: json['complaintId'] as String,
      success: json['success'] as bool,
    );
  }
}

class UpdateComplaintStatusRequestModel {
  final int status;

  UpdateComplaintStatusRequestModel({required this.status});

  Map<String, dynamic> toJson() {
    return {
      'status': status,
    };
  }
}

