class CsvReference {
  String name;
  String cip7;
  String cip13;

  CsvReference(this.name, this.cip7, this.cip13);

  factory CsvReference.fromCSV(List<dynamic> row) {
    return CsvReference(row[2].toString(), row[0].toString(), row[1].toString());
  }
}