import '../../../../core/network/dio_client.dart';
import '../../../../core/network/network_exceptions.dart';
import '../../../../core/network/api_endpoints.dart';
import 'package:dio/dio.dart';
import '../models/complaint_model.dart';
import '../models/government_agency_model.dart';

abstract class ComplaintRemoteDataSource {
  Future<CreateComplaintResponseModel> createComplaint(
    CreateComplaintRequestModel request,
  );
  Future<List<GovernmentAgencyModel>> getGovernmentAgenciesPicklist();
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
      final formData = FormData.fromMap(await request.toFormDataMap());
      final response = await dioClient.post(
        ApiEndpoints.submitComplaint,
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );
      return CreateComplaintResponseModel.fromJson(response.data);
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw NetworkException(message: 'Failed to create complaint: $e');
    }
  }

  @override
  Future<List<GovernmentAgencyModel>> getGovernmentAgenciesPicklist() async {
    try {
      final response = await dioClient.get(
        ApiEndpoints.governmentAgenciesPicklist,
      );
      final body = response.data;
      if (body is! Map<String, dynamic>) {
        throw NetworkException(message: 'Invalid agencies response format');
      }

      final success = body['success'] as bool? ?? false;
      if (!success) {
        throw NetworkException(
          message: (body['message'] as String?) ?? 'Failed to load agencies',
          statusCode: response.statusCode,
        );
      }

      final data = body['data'];
      final agenciesJson = (data is List) ? data : const [];
      return agenciesJson
          .whereType<Map<String, dynamic>>()
          .map(GovernmentAgencyModel.fromJson)
          .toList();
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw NetworkException(message: 'Failed to load agencies: $e');
    }
  }

  @override
  Future<List<ComplaintModel>> getComplaints() async {
    try {
      final response = await dioClient.get(ApiEndpoints.getComplaintsByUser);
      final body = response.data;
      if (body is! Map<String, dynamic>) {
        throw NetworkException(message: 'Invalid complaints response format');
      }

      final success = body['success'] as bool? ?? false;
      if (!success) {
        throw NetworkException(
          message: (body['message'] as String?) ?? 'Failed to get complaints',
          statusCode: response.statusCode,
        );
      }

      final data = body['data'];
      final complaintsJson = (data is List) ? data : const [];
      return complaintsJson
          .whereType<Map<String, dynamic>>()
          .map(ComplaintModel.fromJson)
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
        ApiEndpoints.complaintStatus(complaintId),
        data: UpdateComplaintStatusRequestModel(status: status).toJson(),
      );
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw NetworkException(message: 'Failed to update complaint status: $e');
    }
  }
}
