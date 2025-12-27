import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/complaint_repository.dart';
import 'complaint_state.dart';

class ComplaintCubit extends Cubit<ComplaintState> {
  final ComplaintRepository repository;

  ComplaintCubit({required this.repository}) : super(ComplaintInitial());

  /// Load all complaints (cache-first strategy)
  Future<void> loadComplaints({bool forceRefresh = false}) async {
    // First, try to load cached data for immediate display
    if (!forceRefresh) {
      final cachedResult = await repository.getCachedComplaints();
      cachedResult.fold(
        (_) {
          // Cache failed, continue to loading state
        },
        (cachedComplaints) {
          if (cachedComplaints.isNotEmpty) {
            // Emit cached data immediately
            emit(ComplaintLoaded(cachedComplaints, isFromCache: true));
          }
        },
      );
    }

    // Then fetch fresh data from server
    emit(ComplaintLoading());
    final result = await repository.getComplaints();
    result.fold((failure) {
      // If we have cached data, show it with error message
      // Otherwise show error state
      if (state is ComplaintLoaded && (state as ComplaintLoaded).isFromCache) {
        // Keep showing cached data, error is handled by network failure
        return;
      }
      emit(ComplaintError(failure.message));
    }, (complaints) => emit(ComplaintLoaded(complaints, isFromCache: false)));
  }

  /// Create a new complaint
  Future<void> createComplaint({
    required String agencyId,
    required String complaintType,
    required String description,
    List<String> attachmentPaths = const [],
  }) async {
    emit(ComplaintLoading());
    final request = CreateComplaintRequest(
      agencyId: agencyId,
      complaintType: complaintType,
      description: description,
      attachmentPaths: attachmentPaths,
    );
    final result = await repository.createComplaint(request);
    result.fold((failure) => emit(ComplaintError(failure.message)), (response) {
      emit(ComplaintCreated(response));
      // Reload complaints after creating
      loadComplaints();
    });
  }

  /// Update complaint status (admin only)
  Future<void> updateComplaintStatus(String complaintId, int status) async {
    emit(ComplaintLoading());
    final result = await repository.updateComplaintStatus(complaintId, status);
    result.fold((failure) => emit(ComplaintError(failure.message)), (_) {
      emit(
        const ComplaintStatusUpdated('Complaint status updated successfully'),
      );
      // Reload complaints after updating
      loadComplaints();
    });
  }
}
