import 'package:flutter/material.dart';
import '../../../../l10n/app_localizations.dart';

class ReportsPage extends StatelessWidget {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.reports),
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
              child: ListTile(
                leading: const Icon(Icons.description_outlined),
                title: Text(l10n.myReports),
                subtitle: Text(l10n.viewAllSentReports),
                trailing: const Icon(Icons.chevron_left),
                onTap: () {
                  // Handle tap
                },
              ),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 2,
              child: ListTile(
                leading: const Icon(Icons.history_outlined),
                title: Text(l10n.history),
                subtitle: Text(l10n.viewPreviousReports),
                trailing: const Icon(Icons.chevron_left),
                onTap: () {
                  // Handle tap
                },
              ),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 2,
              child: ListTile(
                leading: const Icon(Icons.download_outlined),
                title: Text(l10n.downloadReports),
                subtitle: Text(l10n.downloadReportsPdf),
                trailing: const Icon(Icons.chevron_left),
                onTap: () {
                  // Handle tap
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

