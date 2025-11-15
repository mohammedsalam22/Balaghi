import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_exceptions.dart';
import '../../domain/entities/complaint_entity.dart';
import '../../domain/repositories/complaint_repository.dart';
import '../datasources/complaint_remote_datasource.dart';
import '../models/complaint_model.dart';

class ComplaintRepositoryImpl implements ComplaintRepository {
  final ComplaintRemoteDataSource remoteDataSource;

  ComplaintRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, CreateComplaintResponse>> createComplaint(
    CreateComplaintRequest request,
  ) async {
    try {
      final requestModel = CreateComplaintRequestModel(
        type: request.type,
        assignedPart: request.assignedPart,
        location: request.location,
        description: request.description,
      );
      final response = await remoteDataSource.createComplaint(requestModel);
      return Right(
        CreateComplaintResponse(
          message: response.message,
          complaintNumber: response.complaintNumber,
          complaintId: response.complaintId,
          success: response.success,
        ),
      );
    } on NetworkException catch (e) {
      return Left(_mapNetworkExceptionToFailure(e));
    } catch (e) {
      return Left(UnknownFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<ComplaintEntity>>> getComplaints() async {
    try {
      final complaints = await remoteDataSource.getComplaints();
      return Right(complaints);
    } on NetworkException catch (e) {
      return Left(_mapNetworkExceptionToFailure(e));
    } catch (e) {
      return Left(UnknownFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> updateComplaintStatus(
    String complaintId,
    int status,
  ) async {
    try {
      await remoteDataSource.updateComplaintStatus(complaintId, status);
      return const Right(null);
    } on NetworkException catch (e) {
      return Left(_mapNetworkExceptionToFailure(e));
    } catch (e) {
      return Left(UnknownFailure('Unexpected error: ${e.toString()}'));
    }
  }

  Failure _mapNetworkExceptionToFailure(NetworkException exception) {
    switch (exception.statusCode) {
      case 400:
        return ValidationFailure(exception.message);
      case 401:
        return AuthenticationFailure(exception.message);
      case 403:
        return AuthorizationFailure(exception.message);
      case 404:
        return NotFoundFailure(exception.message);
      case 500:
        return ServerFailure(exception.message);
      default:
        if (exception.message.contains('timeout') ||
            exception.message.contains('connection')) {
          return NetworkFailure(exception.message);
        }
        return UnknownFailure(exception.message);
    }
  }
}

