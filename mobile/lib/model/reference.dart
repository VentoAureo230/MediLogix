class Reference {
  int id;
  String name;
  String cip7;
  String cip13;
  int quantity;
  DateTime created_at;
  DateTime updated_at;

  Reference(this.id, this.name, this.cip7, this.cip13, this.quantity, this.created_at, this.updated_at);

  factory Reference.fromJson(Map<String, dynamic> json) {
    return Reference(
      json['id'], 
      json['name'], 
      json['cip7'], 
      json['cip13'], 
      json['quantity'], 
      DateTime.parse(json['created_at']), 
      DateTime.parse(json['updated_at'])
    );
  }
}