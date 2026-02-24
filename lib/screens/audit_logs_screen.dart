import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:retailsaas/data/database/app_database.dart';
import 'package:retailsaas/locator.dart';
import 'package:intl/intl.dart';
import 'package:drift/drift.dart' hide Column;

class AuditLogsScreen extends StatefulWidget {
  const AuditLogsScreen({super.key});

  @override
  State<AuditLogsScreen> createState() => _AuditLogsScreenState();
}

class _AuditLogsScreenState extends State<AuditLogsScreen> {
  final _db = getIt<AppDatabase>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      appBar: AppBar(
        title: Text(
          'Audit Logs',
          style: GoogleFonts.inter(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: StreamBuilder<List<AuditLog>>(
        stream: (_db.select(
          _db.auditLogs,
        )..orderBy([(t) => OrderingTerm.desc(t.timestamp)])).watch(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final logs = snapshot.data!;

          if (logs.isEmpty) {
            return const Center(child: Text('No audit logs found.'));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: logs.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final log = logs[index];
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.02),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          log.action,
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.bold,
                            color: _getActionColor(log.action),
                          ),
                        ),
                        Text(
                          DateFormat('MMM dd, hh:mm a').format(log.timestamp),
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        if (log.userId != null) ...[
                          const Icon(
                            Icons.person,
                            size: 14,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: FutureBuilder<User?>(
                              future:
                                  (_db.select(
                                        _db.users,
                                      )..where((u) => u.id.equals(log.userId!)))
                                      .getSingleOrNull(),
                              builder: (context, userSnap) {
                                return Text(
                                  userSnap.data?.name ??
                                      'Unknown User (${log.userId})',
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    color: Colors.grey.shade700,
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ],
                    ),
                    if (log.details != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        log.details!,
                        style: GoogleFonts.inter(fontSize: 14),
                      ),
                    ],
                    if (log.entityType != null && log.recordId != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        'Entity: ${log.entityType} #${log.recordId}',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Color _getActionColor(String action) {
    if (action == 'LOGIN') return Colors.green;
    if (action == 'LOGOUT') return Colors.orange;
    if (action.contains('SALE')) return Colors.blue;
    if (action.contains('DELETE') || action.contains('VOID')) return Colors.red;
    return Colors.black;
  }
}
