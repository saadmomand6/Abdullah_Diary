import 'dart:io';
import 'package:path/path.dart' as p; // ✅ for `p.join(...)`
import 'package:share_plus/share_plus.dart'; // ✅ for Share.shareXFiles
import 'package:path_provider/path_provider.dart'; // ✅ for app directory
import 'package:file_picker/file_picker.dart'; // ✅ for picking .db file
import 'package:flutter/foundation.dart'; // ✅ for debugPrint
import 'package:flutter/services.dart'; // ✅ for PlatformException
import 'package:flutter/material.dart'; // ✅ for XFile
import 'package:sqflite/sqflite.dart'; // for getDatabasesPath()
import 'package:cross_file/cross_file.dart';


Future<void> exportDatabase() async {
  try {
    final dbPath = await getDatabasesPath();
    final filePath = p.join(dbPath, 'abdullah_diary.db');
    final directory = await getApplicationDocumentsDirectory();
    final exportPath = p.join(directory.path, 'abdullah_diary_backup.db');

    final File originalDb = File(filePath);
    await originalDb.copy(exportPath);

    final backupFile = File(exportPath);
    await Share.shareXFiles([XFile(backupFile.path)]);
  } catch (e) {
    debugPrint('Export failed: $e');
  }
}

Future<void> importDatabase() async {
  try {
    FilePickerResult? result;

    if (Platform.isAndroid) {
      result = await FilePicker.platform.pickFiles(
        type: FileType.any,
      );
    } else {
      result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['db'],
      );
    }

    if (result != null && result.files.single.path != null) {
      final String pickedPath = result.files.single.path!;

      if (!pickedPath.endsWith('.db')) {
        debugPrint("❌ Invalid file type selected");
        return;
      }

      final String dbPath = p.join(await getDatabasesPath(), 'abdullah_diary.db');

      // Optional: Close DB before overwrite (if you're using a singleton DBHelper)
      // await DBHelper.instance.closeDatabase();

      await File(pickedPath).copy(dbPath);
      debugPrint("✅ Database imported and copied to $dbPath");

      // Optional: Re-open DB after import
      // await DBHelper.instance.getDatabase();
    } else {
      debugPrint("❌ No file selected");
    }
  } catch (e) {
    debugPrint("❌ Error importing database: $e");
  }
}