import '../../../../core/network/dio_client.dart';
import '../../../../core/network/network_exceptions.dart';
import '../models/complaint_model.dart';

abstract class ComplaintRemoteDataSource {
  Future<CreateComplaintResponseModel> createComplaint(
    CreateComplaintRequestModel request,
  );
  Future<List<ComplaintModel>> getComplaints();
  Future<void> updateComplaintStatus(String complaintId, int status);
}

class ComplaintRemoteDataSourceImpl implements ComplaintRemoteDataSource {
  final DioClient dioClient;

  ComplaintRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<CreateComplaintResponseModel> createComplaint(
    CreateComplaintRequestModel request,
  ) async {
    try {
      final response = await dioClient.post(
        '/api/complaints',
        data: request.toJson(),
      );
      return CreateComplaintResponseModel.fromJson(response.data);
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw NetworkException(message: 'Failed to create complaint: $e');
    }
  }

  @override
  Future<List<ComplaintModel>> getComplaints() async {
    try {
      final response = await dioClient.get('/api/complaints');
      final complaintsJson = response.data['complaints'] as List;
      return complaintsJson
          .map((json) => ComplaintModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw NetworkException(message: 'Failed to get complaints: $e');
    }
  }

  @override
  Future<void> updateComplaintStatus(String complaintId, int status) async {
    try {
      await dioClient.put(
        '/api/complaints/$complaintId/status',
        data: UpdateComplaintStatusRequestModel(status: status).toJson(),
      );
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw NetworkException(message: 'Failed to update complaint status: $e');
    }
  }
}

