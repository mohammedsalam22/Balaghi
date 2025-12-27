import '../../domain/entities/government_agency_entity.dart';

class GovernmentAgencyModel extends GovernmentAgencyEntity {
  const GovernmentAgencyModel({required super.id, required super.name});

  factory GovernmentAgencyModel.fromJson(Map<String, dynamic> json) {
    return GovernmentAgencyModel(
      id: (json['id'] as String?) ?? '',
      name: (json['name'] as String?) ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }
}

