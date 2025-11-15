import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/complaint_repository.dart';
import 'complaint_state.dart';

class ComplaintCubit extends Cubit<ComplaintState> {
  final ComplaintRepository repository;

  ComplaintCubit({required this.repository}) : super(ComplaintInitial());

  /// Load all complaints
  Future<void> loadComplaints() async {
    emit(ComplaintLoading());
    final result = await repository.getComplaints();
    result.fold(
      (failure) => emit(ComplaintError(failure.message)),
      (complaints) => emit(ComplaintLoaded(complaints)),
    );
  }

  /// Create a new complaint
  Future<void> createComplaint({
    required String type,
    required String assignedPart,
    required String location,
    required String description,
  }) async {
    emit(ComplaintLoading());
    final request = CreateComplaintRequest(
      type: type,
      assignedPart: assignedPart,
      location: location,
      description: description,
    );
    final result = await repository.createComplaint(request);
    result.fold(
      (failure) => emit(ComplaintError(failure.message)),
      (response) {
        emit(ComplaintCreated(response));
        // Reload complaints after creating
        loadComplaints();
      },
    );
  }

  /// Update complaint status (admin only)
  Future<void> updateComplaintStatus(String complaintId, int status) async {
    emit(ComplaintLoading());
    final result = await repository.updateComplaintStatus(complaintId, status);
    result.fold(
      (failure) => emit(ComplaintError(failure.message)),
      (_) {
        emit(const ComplaintStatusUpdated('Complaint status updated successfully'));
        // Reload complaints after updating
        loadComplaints();
      },
    );
  }
}

