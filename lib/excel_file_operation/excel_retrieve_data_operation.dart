import 'dart:io';

import 'package:excel/excel.dart';
import 'package:flutter/services.dart' show ByteData, Uint8List, rootBundle;

Future<List<dynamic>> readExcel(String _filePath) async {
  var bytes = File(_filePath).readAsBytesSync();
  var excel = Excel.decodeBytes(bytes);
  var _excelData = [];
  var count = 0;
  for (var table in excel.tables.keys) {
    for (var row in excel.tables[table]!.rows) {
      List<String> rowData = [];
      for (var cell in row) {
        if (cell?.value != null) {
          rowData.add(cell!.value.toString().trim());
        }
      }
      count++;
      if (rowData.length != 0 && count > 1) {
        _excelData.add(rowData);
      }
    }
  }

  _excelData.removeAt(0);
  print(_excelData);
  return _excelData;
}

void excel_assets() async {
  var count = 0;
  ByteData data = await rootBundle.load('assets/excel/Book1.xlsx');
  var bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  var excel = Excel.decodeBytes(bytes);
  for (var table in excel.tables.keys) {
    for (var row in excel.tables[table]!.rows) {
      if (count > 1) {}
      count++;
    }
  }
}
