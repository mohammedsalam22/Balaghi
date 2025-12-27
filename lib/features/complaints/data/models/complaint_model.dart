import 'package:dio/dio.dart';
import '../../domain/entities/complaint_entity.dart';
import '../../../../core/network/api_endpoints.dart';

class ComplaintAttachmentModel extends ComplaintAttachmentEntity {
  const ComplaintAttachmentModel({
    required super.id,
    required super.fileName,
    required super.url,
    required super.contentType,
    required super.uploadedAt,
  });

  factory ComplaintAttachmentModel.fromJson(Map<String, dynamic> json) {
    final rawUrl = (json['url'] as String?) ?? '';
    return ComplaintAttachmentModel(
      id: (json['id'] as String?) ?? '',
      fileName: (json['fileName'] as String?) ?? '',
      url: ApiEndpoints.resolveUrl(rawUrl),
      contentType: (json['contentType'] as String?) ?? '',
      uploadedAt:
          DateTime.tryParse((json['uploadedAt'] as String?) ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0, isUtc: true),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fileName': fileName,
      'url': url,
      'contentType': contentType,
      'uploadedAt': uploadedAt.toIso8601String(),
    };
  }
}

class ComplaintModel extends ComplaintEntity {
  const ComplaintModel({
    required super.id,
    required super.trackingNumber,
    required super.complaintType,
    required super.description,
    required super.agencyName,
    required super.status,
    required super.statusRaw,
    required super.createdAt,
    required super.attachmentsCount,
    required super.attachments,
  });

  factory ComplaintModel.fromJson(Map<String, dynamic> json) {
    final dynamic statusValue = json['status'];
    final statusRaw = statusValue is String
        ? statusValue
        : ((json['statusRaw'] as String?) ?? '');
    final statusInt = statusValue is int
        ? statusValue
        : _mapStatusToInt(statusRaw);

    final attachmentsJson = (json['attachments'] as List?) ?? const [];
    final attachments = attachmentsJson
        .whereType<Map<String, dynamic>>()
        .map(ComplaintAttachmentModel.fromJson)
        .toList();

    return ComplaintModel(
      id: (json['id'] as String?) ?? '',
      trackingNumber: (json['trackingNumber'] as String?) ?? '',
      complaintType: (json['complaintType'] as String?) ?? '',
      description: (json['description'] as String?) ?? '',
      agencyName: (json['agencyName'] as String?) ?? '',
      status: statusInt,
      statusRaw: statusRaw,
      createdAt:
          DateTime.tryParse((json['createdAt'] as String?) ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0, isUtc: true),
      attachmentsCount:
          (json['attachmentsCount'] as int?) ?? attachments.length,
      attachments: attachments,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'trackingNumber': trackingNumber,
      'complaintType': complaintType,
      'description': description,
      'agencyName': agencyName,
      'status': status,
      'statusRaw': statusRaw,
      'createdAt': createdAt.toIso8601String(),
      'attachmentsCount': attachmentsCount,
      'attachments': attachments
          .map(
            (a) => (a is ComplaintAttachmentModel)
                ? a.toJson()
                : ComplaintAttachmentModel(
                    id: a.id,
                    fileName: a.fileName,
                    url: a.url,
                    contentType: a.contentType,
                    uploadedAt: a.uploadedAt,
                  ).toJson(),
          )
          .toList(),
    };
  }

  static int _mapStatusToInt(String raw) {
    final s = raw.trim().toLowerCase();
    if (s.isEmpty) return 0;
    if (s.contains('pending') || s.contains('new')) return 0;
    if (s.contains('underreview') ||
        s.contains('under_review') ||
        s.contains('inprogress') ||
        s.contains('in_progress') ||
        s.contains('review')) {
      return 1;
    }
    if (s.contains('done') ||
        s.contains('resolved') ||
        s.contains('complete') ||
        s.contains('completed')) {
      return 2;
    }
    if (s.contains('reject') || s.contains('cancel')) return 3;
    return 0;
  }
}

class CreateComplaintRequestModel {
  final String agencyId;
  final String complaintType;
  final String description;
  final List<String> attachmentPaths;

  CreateComplaintRequestModel({
    required this.agencyId,
    required this.complaintType,
    required this.description,
    this.attachmentPaths = const [],
  });

  /// Map used to build Dio `FormData` for multipart submission.
  Future<Map<String, dynamic>> toFormDataMap() async {
    final map = <String, dynamic>{
      'agencyId': agencyId,
      'complaintType': complaintType,
      'description': description,
    };

    if (attachmentPaths.isNotEmpty) {
      map['attachments'] = await Future.wait(
        attachmentPaths.map((p) => MultipartFile.fromFile(p)),
      );
    }

    return map;
  }
}

class CreateComplaintResponseModel {
  final String message;
  final bool success;
  final String trackingNumber;
  final DateTime? submittedAt;
  final List<ComplaintAttachmentModel> attachments;

  CreateComplaintResponseModel({
    required this.message,
    required this.success,
    required this.trackingNumber,
    required this.submittedAt,
    required this.attachments,
  });

  factory CreateComplaintResponseModel.fromJson(Map<String, dynamic> json) {
    final data = (json['data'] is Map<String, dynamic>)
        ? (json['data'] as Map<String, dynamic>)
        : <String, dynamic>{};

    final trackingNumber =
        (data['TrackingNumber'] ?? data['trackingNumber']) as String? ?? '';
    final submittedAtRaw =
        (data['SubmittedAt'] ?? data['submittedAt']) as String?;
    final submittedAt = submittedAtRaw == null
        ? null
        : DateTime.tryParse(submittedAtRaw);

    final attachmentsJson = (data['attachments'] as List?) ?? const [];
    final attachments = attachmentsJson.whereType<Map<String, dynamic>>().map((
      a,
    ) {
      final fileName = (a['FileName'] ?? a['fileName']) as String? ?? '';
      final url = (a['Url'] ?? a['url']) as String? ?? '';
      return ComplaintAttachmentModel(
        id: '',
        fileName: fileName,
        url: ApiEndpoints.resolveUrl(url),
        contentType: '',
        uploadedAt:
            submittedAt ?? DateTime.fromMillisecondsSinceEpoch(0, isUtc: true),
      );
    }).toList();

    return CreateComplaintResponseModel(
      message: json['message'] as String? ?? '',
      success: json['success'] as bool? ?? false,
      trackingNumber: trackingNumber,
      submittedAt: submittedAt,
      attachments: attachments,
    );
  }
}

class UpdateComplaintStatusRequestModel {
  final int status;

  UpdateComplaintStatusRequestModel({required this.status});

  Map<String, dynamic> toJson() {
    return {'status': status};
  }
}
