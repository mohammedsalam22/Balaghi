import 'package:equatable/equatable.dart';

class ComplaintEntity extends Equatable {
  final String id;
  final String type;
  final String assignedPart;
  final String location;
  final String description;
  final int complaintNumber;
  final int status; // 0: New, 1: InProgress, 2: Done, 3: Rejected
  final String userId;
  final DateTime createdAt;

  const ComplaintEntity({
    required this.id,
    required this.type,
    required this.assignedPart,
    required this.location,
    required this.description,
    required this.complaintNumber,
    required this.status,
    required this.userId,
    required this.createdAt,
  });

  String get statusText {
    switch (status) {
      case 0:
        return 'New';
      case 1:
        return 'In Progress';
      case 2:
        return 'Done';
      case 3:
        return 'Rejected';
      default:
        return 'Unknown';
    }
  }

  @override
  List<Object> get props => [
        id,
        type,
        assignedPart,
        location,
        description,
        complaintNumber,
        status,
        userId,
        createdAt,
      ];
}

