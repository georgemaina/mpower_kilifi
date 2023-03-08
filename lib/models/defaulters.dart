class Client {
  int ID;
  String names;
  String age;
  String sex;
  String serviceDefaulted;
  String village;
  String guardian;
  // int contacts;
  String chvName;
  String contacted;

  Client({
    required this.ID,
    required this.names,
    required this.age,
    required this.sex,
    required this.serviceDefaulted,
    required this.village,
    required this.guardian,
    // this.contacts,
    required this.chvName,
    required this.contacted,
  });

  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
      ID: json["ID"],
      names: json["names"],
      age: ["age"].toString(),
      sex: json["sex"],
      serviceDefaulted: json["serviceDefaulted"],
      village: json["village"],
      guardian: json["guardian"],
      // contacts: json["contacts"],
      chvName: json["chvName"],
      contacted: json['contacted'].toString(),
    );
  }
}
