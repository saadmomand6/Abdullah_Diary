import 'package:path/path.dart';
import 'package:share_plus/share_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';

Future<void> exportDatabase() async {
  final dbPath = await getDatabasesPath();
  final path = join(dbPath, 'your_database.db'); // 👈 Update this name
  await Share.shareXFiles([XFile(path)], text: 'DB Export');
}

Future<void> importDatabase() async {
  final result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['db'],
  );

  if (result != null) {
    final dbPath = await getDatabasesPath();
    final newPath = join(dbPath, 'your_database.db'); // 👈 Same name
    final importedFile = File(result.files.single.path!);

    await importedFile.copy(newPath);
  }
}
