class HouseholdMapping{
  int ID;
  String dateContacted;
  String mothersName;
  String chuName;
  String hhNo;
  String yearBirth;
  String delivered;
  String dateDelivered;
  String deliveryPlace;
  String sex;
  String weightAtBirth;
  String supportGroup;
  String married;
  String spouseName;
  String spouseContact;
  String otherName;
  String otherContact;

  HouseholdMapping({
    required this.ID,
    required this.dateContacted,
    required this.mothersName,
    required this.chuName,
    required this.hhNo,
    required this.yearBirth,
    required this.delivered,
    required this.dateDelivered,
    required this.deliveryPlace,
    required this.sex,
    required this.weightAtBirth,
    required this.supportGroup,
    required this.married,
    required this.spouseName,
    required this.spouseContact,
    required this.otherName,
    required this.otherContact,
});

  factory HouseholdMapping.fromJson(Map<String, dynamic> json){
    return HouseholdMapping(
        ID: json["ID"],
        dateContacted: json["dateContacted"],
        mothersName: json["mothersName"],
        chuName: json["chuName"],
        hhNo: json["hhNo"],
        yearBirth: json["yearBirth"],
        delivered: json["delivered"],
        dateDelivered: json["dateDelivered"],
        deliveryPlace: json["deliveryPlace"],
        sex: json["sex"],
        weightAtBirth: json["weightAtBirth"],
        supportGroup: json["supportGroup"],
        married: json["married"],
        spouseName: json["spouseName"],
        spouseContact: json["spouseContact"],
        otherName: json["otherName"],
        otherContact: json["otherContact"],
    );
  }

}