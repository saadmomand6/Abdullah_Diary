import 'package:flutter/material.dart';
import '../db/db_helper.dart'; // If you need DB access
import '../utils/db_export_import.dart'; // If you extract import/export logic

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.upload_file),
            title: const Text('Export Database'),
            onTap: () async {
              await exportDatabase();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Database exported')),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.download),
            title: const Text('Import Database'),
            onTap: () async {
              await importDatabase();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Database imported. Please restart app.')),
              );
            },
          ),
        ],
      ),
    );
  }
}
