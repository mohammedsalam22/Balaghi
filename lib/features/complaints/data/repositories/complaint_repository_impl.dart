import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_exceptions.dart';
import '../../domain/entities/complaint_entity.dart';
import '../../domain/repositories/complaint_repository.dart';
import '../datasources/complaint_local_datasource.dart';
import '../datasources/complaint_remote_datasource.dart';
import '../models/complaint_model.dart';

class ComplaintRepositoryImpl implements ComplaintRepository {
  final ComplaintRemoteDataSource remoteDataSource;
  final ComplaintLocalDataSource localDataSource;

  ComplaintRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

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
      // Invalidate cache after creating new complaint
      await localDataSource.clearCache();
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
      // Try to fetch from remote
      final complaints = await remoteDataSource.getComplaints();
      // Cache the fresh data
      await localDataSource.cacheComplaints(complaints);
      return Right(complaints);
    } on NetworkException catch (e) {
      // If network fails, try to return cached data
      try {
        final cachedComplaints = await localDataSource.getCachedComplaints();
        if (cachedComplaints.isNotEmpty) {
          // Return cached data but still report the network error
          // The UI can show a warning that data might be stale
          return Right(cachedComplaints);
        }
      } catch (_) {
        // Cache read failed, continue to return network error
      }
      return Left(_mapNetworkExceptionToFailure(e));
    } catch (e) {
      return Left(UnknownFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<ComplaintEntity>>> getCachedComplaints() async {
    try {
      final cachedComplaints = await localDataSource.getCachedComplaints();
      return Right(cachedComplaints);
    } catch (e) {
      return Left(
        CacheFailure('Failed to load cached complaints: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, void>> updateComplaintStatus(
    String complaintId,
    int status,
  ) async {
    try {
      await remoteDataSource.updateComplaintStatus(complaintId, status);
      // Invalidate cache after status update to force refresh
      await localDataSource.clearCache();
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
