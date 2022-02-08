// @dart=2.9

class Client {
  int id;
  String names;
  String dob;
  String sex;
  String serviceDefaulted;
  String village;
  String guardian;
  String contact;
  String chvname;

  Client({
    this.id,
    this.names,
    this.dob,
    this.sex,
    this.serviceDefaulted,
    this.village,
    this.guardian,
    this.contact,
    this.chvname
  });

  factory Client.fromJson(Map<String, dynamic> json){
    return Client(
      id: json["id"],
      names: json["first_name"],
      dob: json["dob"],
      sex: json["sex"],
      serviceDefaulted: json["serviceDefaulted"],
      village: json["village"],
      guardian: json["guardian"],
      contact: json["contact"],
      chvname: json["chvname"],
    );
  }
}


