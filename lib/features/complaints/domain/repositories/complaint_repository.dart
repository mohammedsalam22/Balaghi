import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/complaint_entity.dart';

abstract class ComplaintRepository {
  Future<Either<Failure, CreateComplaintResponse>> createComplaint(
    CreateComplaintRequest request,
  );

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
  final String type;
  final String assignedPart;
  final String location;
  final String description;

  CreateComplaintRequest({
    required this.type,
    required this.assignedPart,
    required this.location,
    required this.description,
  });
}

class CreateComplaintResponse {
  final String message;
  final int complaintNumber;
  final String complaintId;
  final bool success;

  CreateComplaintResponse({
    required this.message,
    required this.complaintNumber,
    required this.complaintId,
    required this.success,
  });
}

