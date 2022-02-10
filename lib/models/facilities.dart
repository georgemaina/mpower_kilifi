class FacilityModel {
  final int mflcode;
  final String facilityname;

  FacilityModel({required this.mflcode, required this.facilityname});

  factory FacilityModel.fromJson(Map<String, dynamic> json) {
    // if (json == null) return null;
    return FacilityModel(
      mflcode: json["mflcode"],
      facilityname: json["facilityname"]
    );
  }

  static List<FacilityModel> fromJsonList(List list) {
    return list.map((item) => FacilityModel.fromJson(item)).toList();
  }

  ///this method will prevent the override of toString
  String userAsString() {
    return '#${this.mflcode} ${this.facilityname}';
  }

  ///custom comparing function to check if two users are equal
  // bool isEqual(FacilityModel model) {
  //   return this?.mflcode == model?.mflcode;
  // }

  @override
  String toString() => facilityname;
}

class ChuModel {
  final int ID;
  final String chuNames;
  final String ward;
  final String linkFacility;

  ChuModel({
    required this.ID,
    required this.chuNames,
    required this.ward,
    required this.linkFacility});

  factory ChuModel.fromJson(Map<String, dynamic> json) {
    // if (json == null) return null;
    return ChuModel(
        ID: json["ID"],
        chuNames: json["chuNames"],
        ward: json["ward"],
        linkFacility: json["linkFacility"]
    );
  }

  static List<ChuModel> fromJsonList(List list) {
    return list.map((item) => ChuModel.fromJson(item)).toList();
  }

  ///this method will prevent the override of toString
  String userAsString() {
    return '#${this.ID} ${this.chuNames}';
  }

  ///custom comparing function to check if two users are equal
  // bool isEqual(FacilityModel model) {
  //   return this?.mflcode == model?.mflcode;
  // }

  @override
  String toString() => chuNames;
}