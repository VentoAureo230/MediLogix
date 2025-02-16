import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:mobile/model/csv_reference.dart';
import 'package:collection/collection.dart';

Future<List<T>> extractListFromCSV<T>(String filePath, T Function(List<dynamic>) fromCsvRow) async {
  final csvString = await rootBundle.loadString(filePath);
  final List<List<dynamic>> list = const CsvToListConverter().convert(csvString, fieldDelimiter : ';');
  return list.map((row) => fromCsvRow(row)).toList();
}

Future<CsvReference?> searchReferenceInCSV(String filePath, String cip13) async {
  final allReferences = await extractListFromCSV<CsvReference>(filePath, CsvReference.fromCSV);
  return allReferences.firstWhereOrNull((ref) => ref.cip13 == cip13); 
}

void showSnackBar(BuildContext context, String message, {bool isError = false}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: isError ? Colors.red : Colors.green,
      duration: const Duration(seconds: 3),
    ),
  );
}


