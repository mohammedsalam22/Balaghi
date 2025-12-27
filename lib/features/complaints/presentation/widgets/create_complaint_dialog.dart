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
  List<PlatformFile> _selectedFiles = [];

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

    return BlocConsumer<ComplaintCubit, ComplaintState>(
      listener: (context, state) {
        if (state is ComplaintCreated) {
          Navigator.of(context).pop(true);
        } else if (state is ComplaintError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      builder: (context, state) {
        return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.9,
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
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
                    const SizedBox(height: 20),
                    FutureBuilder<List<GovernmentAgencyEntity>>(
                      future: context.read<ComplaintCubit>().agencies.isEmpty
                          ? null
                          : Future.value(context.read<ComplaintCubit>().agencies),
                      builder: (context, snapshot) {
                        final agencies = snapshot.data ?? 
                            context.read<ComplaintCubit>().agencies;
                        final isLoading = agencies.isEmpty;
                        final hasError = snapshot.hasError;
                        return DropdownButtonFormField<String>(
                          value: _selectedAgencyId,
                          isExpanded: true,
                          decoration: InputDecoration(
                            labelText: '${l10n.agencyName} *',
                            border: const OutlineInputBorder(),
                            prefixIcon: const Icon(Icons.account_balance),
                            helperText: hasError
                                ? l10n.failedToLoadAgencies
                                : null,
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 12,
                            ),
                          ),
                          items: agencies
                              .map(
                                (a) => DropdownMenuItem<String>(
                                  value: a.id,
                                  child: Text(
                                    a.name,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    softWrap: false,
                                  ),
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
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: _typeController.text.isEmpty
                          ? null
                          : _typeController.text,
                      decoration: InputDecoration(
                        labelText: '${l10n.complaintType} *',
                        border: const OutlineInputBorder(),
                        prefixIcon: const Icon(Icons.category),
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                      ),
                      items: complaintTypes.map((type) {
                        return DropdownMenuItem<String>(
                          value: type,
                          child: Text(
                            type,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            softWrap: false,
                          ),
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
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: InputDecoration(
                        labelText: '${l10n.description} *',
                        border: const OutlineInputBorder(),
                        prefixIcon: const Icon(Icons.description),
                        hintText: l10n.descriptionHint,
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                      ),
                      maxLines: 3,
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
                    const SizedBox(height: 12),
                    OutlinedButton.icon(
                      onPressed: _pickAttachments,
                      icon: const Icon(Icons.attach_file),
                      label: Text(l10n.addAttachments),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                      ),
                    ),
                    if (_selectedFiles.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      ..._selectedFiles.map(
                        (f) => Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Row(
                            children: [
                              const Icon(Icons.insert_drive_file, size: 16),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  f.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.close, size: 16),
                                onPressed: () {
                                  setState(() {
                                    _selectedFiles.remove(f);
                                  });
                                },
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(
                                  minWidth: 32,
                                  minHeight: 32,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 16),
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
                                      width: 16,
                                      height: 16,
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

      },
    );
  }
}
