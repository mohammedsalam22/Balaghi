import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/complaint_entity.dart';
import '../entities/government_agency_entity.dart';

abstract class ComplaintRepository {
  Future<Either<Failure, CreateComplaintResponse>> createComplaint(
    CreateComplaintRequest request,
  );

  Future<Either<Failure, List<GovernmentAgencyEntity>>>
  getGovernmentAgenciesPicklist();

  Future<Either<Failure, List<ComplaintEntity>>> getComplaints();

  /// Get cached complaints (for immediate display while fetching fresh data)
  Future<Either<Failure, List<ComplaintEntity>>> getCachedComplaints();

  /// Update complaint status (admin only)
  Future<Either<Failure, void>> updateComplaintStatus(
    String complaintId,
    int status,
  );
}

class CreateComplaintRequest {
  final String agencyId;
  final String complaintType;
  final String description;

  /// File paths to be sent as multipart attachments (optional).
  final List<String> attachmentPaths;

  CreateComplaintRequest({
    required this.agencyId,
    required this.complaintType,
    required this.description,
    this.attachmentPaths = const [],
  });
}

class CreateComplaintResponse {
  final String message;
  final bool success;
  final String trackingNumber;
  final DateTime? submittedAt;

  CreateComplaintResponse({
    required this.message,
    required this.success,
    required this.trackingNumber,
    this.submittedAt,
  });
}
