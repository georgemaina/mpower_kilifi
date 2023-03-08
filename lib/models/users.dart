class Users {
   final int ID;
   final String username;
   final String password;
   final String usergroup;
   final String names;
   final String facility;
   final int mflcode;
   final String county;
   final String subCounty;

  Users({
    required this.ID,
    required this.username,
    required this.password,
    required this.usergroup,
    required this.names,
    required this.facility,
    required this.mflcode,
    required this.county,
    required this.subCounty,
  });

  factory Users.fromJson(Map<String, dynamic> json) {
    return Users(ID:json['ID'],username:json['username'],password:json['password'],usergroup:json['usergroup'],
      names:json['names'],facility:json['facility'],
      mflcode:json['mflcode'],county:json['county'],subCounty:json['subCounty'],
    );
  }

   static List<Users> fromJsonList(List list) {
     return list.map((item) => Users.fromJson(item)).toList();
   }
}