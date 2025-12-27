import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';
import '../../../../l10n/app_localizations.dart';
import '../cubit/complaints/complaint_cubit.dart';
import '../cubit/complaints/complaint_state.dart';
import '../../domain/entities/government_agency_entity.dart';

class CreateComplaintDialog extends StatefulWidget {
  const CreateComplaintDialog({super.key});

  @override
  State<CreateComplaintDialog> createState() => _CreateComplaintDialogState();
}

class _CreateComplaintDialogState extends State<CreateComplaintDialog> {
  final _formKey = GlobalKey<FormState>();
  final _typeController = TextEditingController();
  final _descriptionController = TextEditingController();
  String? _selectedAgencyId;
  late final Future<List<GovernmentAgencyEntity>> _agenciesFuture;
  List<PlatformFile> _selectedFiles = [];

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
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _agenciesFuture = _loadAgencies();
  }

  Future<List<GovernmentAgencyEntity>> _loadAgencies() async {
    final repo = context.read<ComplaintCubit>().repository;
    final result = await repo.getGovernmentAgenciesPicklist();
    return result.fold(
      (failure) => throw Exception(failure.message),
      (agencies) => agencies,
    );
  }

  Future<void> _pickAttachments() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      withData: false,
    );
    if (result == null) return;
    setState(() {
      _selectedFiles = result.files;
    });
  }

  void _submitComplaint() {
    if (_formKey.currentState!.validate()) {
      context.read<ComplaintCubit>().createComplaint(
        agencyId: _selectedAgencyId!,
        complaintType: _typeController.text.trim(),
        description: _descriptionController.text.trim(),
        attachmentPaths: _selectedFiles
            .where((f) => f.path != null && f.path!.isNotEmpty)
            .map((f) => f.path!)
            .toList(),
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
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
                  FutureBuilder<List<GovernmentAgencyEntity>>(
                    future: _agenciesFuture,
                    builder: (context, snapshot) {
                      final agencies =
                          snapshot.data ?? const <GovernmentAgencyEntity>[];
                      final isLoading =
                          snapshot.connectionState == ConnectionState.waiting;
                      final hasError = snapshot.hasError;
                      return DropdownButtonFormField<String>(
                        value: _selectedAgencyId,
                        decoration: InputDecoration(
                          labelText: '${l10n.agencyName} *',
                          border: const OutlineInputBorder(),
                          prefixIcon: const Icon(Icons.account_balance),
                          helperText: hasError
                              ? l10n.failedToLoadAgencies
                              : null,
                        ),
                        items: agencies
                            .map(
                              (a) => DropdownMenuItem(
                                value: a.id,
                                child: Text(a.name),
                              ),
                            )
                            .toList(),
                        onChanged: isLoading
                            ? null
                            : (value) {
                                setState(() {
                                  _selectedAgencyId = value;
                                });
                              },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return l10n.agencyRequired;
                          }
                          return null;
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 16),
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
                      return DropdownMenuItem(value: type, child: Text(type));
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
                  const SizedBox(height: 16),
                  OutlinedButton.icon(
                    onPressed: _pickAttachments,
                    icon: const Icon(Icons.attach_file),
                    label: Text(l10n.addAttachments),
                  ),
                  if (_selectedFiles.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    ..._selectedFiles.map(
                      (f) => Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Row(
                          children: [
                            const Icon(Icons.insert_drive_file, size: 18),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                f.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close, size: 18),
                              onPressed: () {
                                setState(() {
                                  _selectedFiles.remove(f);
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
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
