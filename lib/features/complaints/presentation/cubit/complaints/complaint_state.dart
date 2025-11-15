import 'package:equatable/equatable.dart';
import '../../../domain/entities/complaint_entity.dart';
import '../../../domain/repositories/complaint_repository.dart';

abstract class ComplaintState extends Equatable {
  const ComplaintState();

  @override
  List<Object?> get props => [];
}

class ComplaintInitial extends ComplaintState {}

class ComplaintLoading extends ComplaintState {}

class ComplaintLoaded extends ComplaintState {
  final List<ComplaintEntity> complaints;

  const ComplaintLoaded(this.complaints);

  @override
  List<Object?> get props => [complaints];
}

class ComplaintCreated extends ComplaintState {
  final CreateComplaintResponse response;

  const ComplaintCreated(this.response);

  @override
  List<Object?> get props => [response];
}

class ComplaintStatusUpdated extends ComplaintState {
  final String message;

  const ComplaintStatusUpdated(this.message);

  @override
  List<Object?> get props => [message];
}

class ComplaintError extends ComplaintState {
  final String message;

  const ComplaintError(this.message);

  @override
  List<Object?> get props => [message];
}

