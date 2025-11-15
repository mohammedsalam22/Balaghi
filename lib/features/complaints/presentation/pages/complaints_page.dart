import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/storage/secure_storage_service.dart';
import '../../../../core/utils/jwt_decoder.dart';
import '../../../../l10n/app_localizations.dart';
import '../cubit/complaints/complaint_cubit.dart';
import '../cubit/complaints/complaint_state.dart';
import '../widgets/complaint_card.dart';
import '../widgets/create_complaint_dialog.dart';

class ComplaintsPage extends StatefulWidget {
  const ComplaintsPage({super.key});

  @override
  State<ComplaintsPage> createState() => _ComplaintsPageState();
}

class _ComplaintsPageState extends State<ComplaintsPage> {
  bool _isAdmin = false;
  int? _selectedStatusFilter; // null means "All"

  @override
  void initState() {
    super.initState();
    _checkAdminStatus();
    context.read<ComplaintCubit>().loadComplaints();
  }

  Future<void> _checkAdminStatus() async {
    final storageService = SecureStorageService();
    final token = await storageService.getAccessToken();
    final isAdmin = JwtDecoder.isAdmin(token);
    setState(() {
      _isAdmin = isAdmin;
    });
  }

  Future<void> _showCreateComplaintDialog() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => const CreateComplaintDialog(),
    );
    if (result == true) {
      // Refresh complaints list
      if (mounted) {
        context.read<ComplaintCubit>().loadComplaints();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<ComplaintCubit, ComplaintState>(
        listener: (context, state) {
          if (state is ComplaintError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is ComplaintCreated) {
            final l10n = AppLocalizations.of(context)!;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  l10n.complaintCreatedSuccessfully(
                    state.response.complaintNumber,
                  ),
                ),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state is ComplaintStatusUpdated) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
          }
        },
        builder: (context, state) {
          final l10n = AppLocalizations.of(context)!;

          if (state is ComplaintLoading && state is! ComplaintLoaded) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ComplaintLoaded) {
            final allComplaints = state.complaints;
            final filteredComplaints = _selectedStatusFilter == null
                ? allComplaints
                : allComplaints
                      .where((c) => c.status == _selectedStatusFilter)
                      .toList();

            return Column(
              children: [
                // Status filter chips
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildFilterChip(
                          context,
                          l10n,
                          null,
                          l10n.all,
                          Icons.filter_list,
                          allComplaints.length,
                        ),
                        const SizedBox(width: 8),
                        _buildFilterChip(
                          context,
                          l10n,
                          0,
                          l10n.statusNew,
                          Icons.new_releases,
                          allComplaints.where((c) => c.status == 0).length,
                          Colors.blue,
                        ),
                        const SizedBox(width: 8),
                        _buildFilterChip(
                          context,
                          l10n,
                          1,
                          l10n.statusInProgress,
                          Icons.hourglass_empty,
                          allComplaints.where((c) => c.status == 1).length,
                          Colors.orange,
                        ),
                        const SizedBox(width: 8),
                        _buildFilterChip(
                          context,
                          l10n,
                          2,
                          l10n.statusDone,
                          Icons.check_circle,
                          allComplaints.where((c) => c.status == 2).length,
                          Colors.green,
                        ),
                        const SizedBox(width: 8),
                        _buildFilterChip(
                          context,
                          l10n,
                          3,
                          l10n.statusRejected,
                          Icons.cancel,
                          allComplaints.where((c) => c.status == 3).length,
                          Colors.red,
                        ),
                      ],
                    ),
                  ),
                ),
                // Complaints list
                Expanded(
                  child: filteredComplaints.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.filter_alt_off,
                                size: 64,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                _selectedStatusFilter == null
                                    ? l10n.noComplaintsYet
                                    : l10n.noFilteredComplaints(
                                        _getStatusText(
                                          l10n,
                                          _selectedStatusFilter!,
                                        ),
                                      ),
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _selectedStatusFilter == null
                                    ? l10n.createFirstComplaint
                                    : l10n.tryDifferentFilter,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[500],
                                ),
                              ),
                            ],
                          ),
                        )
                      : RefreshIndicator(
                          onRefresh: () async {
                            context.read<ComplaintCubit>().loadComplaints();
                          },
                          child: ListView.builder(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                            itemCount: filteredComplaints.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: ComplaintCard(
                                  complaint: filteredComplaints[index],
                                  isAdmin: _isAdmin,
                                  onStatusUpdate: (complaintId, status) {
                                    context
                                        .read<ComplaintCubit>()
                                        .updateComplaintStatus(
                                          complaintId,
                                          status,
                                        );
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                ),
              ],
            );
          }

          if (state is ComplaintError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                  const SizedBox(height: 16),
                  Text(
                    l10n.errorLoadingComplaints,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[800],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.message,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      context.read<ComplaintCubit>().loadComplaints();
                    },
                    icon: const Icon(Icons.refresh),
                    label: Text(l10n.retry),
                  ),
                ],
              ),
            );
          }

          return Center(child: Text(l10n.noComplaintsToDisplay));
        },
      ),
      floatingActionButton: Builder(
        builder: (context) {
          final l10n = AppLocalizations.of(context)!;
          return FloatingActionButton.extended(
            onPressed: _showCreateComplaintDialog,
            icon: const Icon(Icons.add),
            label: Text(l10n.newComplaint),
          );
        },
      ),
    );
  }

  String _getStatusText(AppLocalizations l10n, int status) {
    switch (status) {
      case 0:
        return l10n.statusNew;
      case 1:
        return l10n.statusInProgress;
      case 2:
        return l10n.statusDone;
      case 3:
        return l10n.statusRejected;
      default:
        return '';
    }
  }

  Widget _buildFilterChip(
    BuildContext context,
    AppLocalizations l10n,
    int? status,
    String label,
    IconData icon,
    int count, [
    Color? color,
  ]) {
    final theme = Theme.of(context);
    final isSelected = _selectedStatusFilter == status;
    final chipColor = color ?? theme.colorScheme.primary;

    return FilterChip(
      selected: isSelected,
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: isSelected ? chipColor : null),
          const SizedBox(width: 6),
          Text(label),
          const SizedBox(width: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: isSelected
                  ? chipColor.withValues(alpha: 0.2)
                  : Colors.grey.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              count.toString(),
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: isSelected ? chipColor : Colors.grey[700],
              ),
            ),
          ),
        ],
      ),
      onSelected: (selected) {
        setState(() {
          _selectedStatusFilter = selected ? status : null;
        });
      },
      selectedColor: chipColor.withValues(alpha: 0.15),
      checkmarkColor: chipColor,
      side: BorderSide(
        color: isSelected
            ? chipColor
            : theme.colorScheme.outline.withValues(alpha: 0.3),
        width: isSelected ? 2 : 1,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    );
  }
}
