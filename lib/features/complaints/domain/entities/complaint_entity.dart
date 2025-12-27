import 'package:equatable/equatable.dart';

class ComplaintAttachmentEntity extends Equatable {
  final String id;
  final String fileName;

  /// Fully-qualified URL (resolved from backend relative path).
  final String url;
  final String contentType;
  final DateTime uploadedAt;

  const ComplaintAttachmentEntity({
    required this.id,
    required this.fileName,
    required this.url,
    required this.contentType,
    required this.uploadedAt,
  });

  @override
  List<Object> get props => [id, fileName, url, contentType, uploadedAt];
}

class ComplaintEntity extends Equatable {
  final String id;
  final String trackingNumber;
  final String complaintType;
  final String description;
  final String agencyName;
  final int status; // 0: New, 1: InProgress, 2: Done, 3: Rejected
  /// Raw status string from backend (e.g. `Pending`, `UnderReview`).
  final String statusRaw;
  final DateTime createdAt;
  final int attachmentsCount;
  final List<ComplaintAttachmentEntity> attachments;

  const ComplaintEntity({
    required this.id,
    required this.trackingNumber,
    required this.complaintType,
    required this.description,
    required this.agencyName,
    required this.status,
    required this.statusRaw,
    required this.createdAt,
    required this.attachmentsCount,
    required this.attachments,
  });

  String get statusText {
    switch (status) {
      case 0:
        return 'New';
      case 1:
        return 'In Progress';
      case 2:
        return 'Done';
      case 3:
        return 'Rejected';
      default:
        return 'Unknown';
    }
  }

  @override
  List<Object> get props => [
    id,
    trackingNumber,
    complaintType,
    description,
    agencyName,
    status,
    statusRaw,
    createdAt,
    attachmentsCount,
    attachments,
  ];
}
