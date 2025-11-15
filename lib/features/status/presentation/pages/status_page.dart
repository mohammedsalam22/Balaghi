import 'package:flutter/material.dart';
import '../../../../l10n/app_localizations.dart';

class StatusPage extends StatelessWidget {
  const StatusPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.status),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            const SizedBox(height: 16),
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.info_outline,
                          color: Colors.blue,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          l10n.reportStatus,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildStatusItem(
                      context,
                      l10n.inProgress,
                      '3',
                      Colors.orange,
                      Icons.hourglass_empty,
                    ),
                    const Divider(),
                    _buildStatusItem(
                      context,
                      l10n.underReview,
                      '2',
                      Colors.blue,
                      Icons.visibility_outlined,
                    ),
                    const Divider(),
                    _buildStatusItem(
                      context,
                      l10n.completed,
                      '5',
                      Colors.green,
                      Icons.check_circle_outline,
                    ),
                    const Divider(),
                    _buildStatusItem(
                      context,
                      l10n.cancelled,
                      '1',
                      Colors.red,
                      Icons.cancel_outlined,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusItem(
    BuildContext context,
    String title,
    String count,
    Color color,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              count,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

