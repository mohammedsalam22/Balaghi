import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../l10n/app_localizations.dart';
import '../cubit/complaints/complaint_cubit.dart';
import '../cubit/complaints/complaint_state.dart';

class CreateComplaintDialog extends StatefulWidget {
  const CreateComplaintDialog({super.key});

  @override
  State<CreateComplaintDialog> createState() => _CreateComplaintDialogState();
}

class _CreateComplaintDialogState extends State<CreateComplaintDialog> {
  final _formKey = GlobalKey<FormState>();
  final _typeController = TextEditingController();
  final _assignedPartController = TextEditingController();
  final _locationController = TextEditingController();
  final _descriptionController = TextEditingController();

  // Predefined complaint types (will be localized in build method)
  List<String> _getComplaintTypes(AppLocalizations l10n) {
    return [
      l10n.complaintTypeInfrastructure,
      l10n.complaintTypeHealth,
      l10n.complaintTypeEducation,
      l10n.complaintTypeTransportation,
      l10n.complaintTypeEnvironment,
      l10n.complaintTypeSecurity,
      l10n.complaintTypeOther,
    ];
  }

  @override
  void dispose() {
    _typeController.dispose();
    _assignedPartController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submitComplaint() {
    if (_formKey.currentState!.validate()) {
      context.read<ComplaintCubit>().createComplaint(
            type: _typeController.text.trim(),
            assignedPart: _assignedPartController.text.trim(),
            location: _locationController.text.trim(),
            description: _descriptionController.text.trim(),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final complaintTypes = _getComplaintTypes(l10n);
    
    return BlocListener<ComplaintCubit, ComplaintState>(
      listener: (context, state) {
        if (state is ComplaintCreated) {
          Navigator.of(context).pop(true);
        } else if (state is ComplaintError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.createNewComplaint,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  DropdownButtonFormField<String>(
                    value: _typeController.text.isEmpty
                        ? null
                        : _typeController.text,
                    decoration: InputDecoration(
                      labelText: '${l10n.complaintType} *',
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.category),
                    ),
                    items: complaintTypes.map((type) {
                      return DropdownMenuItem(
                        value: type,
                        child: Text(type),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _typeController.text = value ?? '';
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return l10n.complaintTypeRequired;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _assignedPartController,
                    decoration: InputDecoration(
                      labelText: '${l10n.assignedDepartment} *',
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.business),
                      hintText: l10n.assignedDepartmentExample,
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return l10n.assignedDepartmentRequired;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _locationController,
                    decoration: InputDecoration(
                      labelText: '${l10n.location} *',
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.location_on),
                      hintText: l10n.locationExample,
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return l10n.locationRequired;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      labelText: '${l10n.description} *',
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.description),
                      hintText: l10n.descriptionHint,
                    ),
                    maxLines: 4,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return l10n.descriptionRequired;
                      }
                      if (value.trim().length < 10) {
                        return l10n.descriptionMinLength;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  BlocBuilder<ComplaintCubit, ComplaintState>(
                    builder: (context, state) {
                      final isLoading = state is ComplaintLoading;
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: isLoading
                                ? null
                                : () => Navigator.of(context).pop(false),
                            child: Text(l10n.cancel),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: isLoading ? null : _submitComplaint,
                            child: isLoading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(l10n.submit),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

