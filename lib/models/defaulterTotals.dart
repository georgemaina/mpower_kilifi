class DefaulterTotals {
  final String Immunization;
  final String VitaminA;
  final String Dewarming;
  final String GrowthMonitoring;
  final String Anc;

  DefaulterTotals({
    required this.Immunization,
    required this.VitaminA,
    required this.Dewarming,
    required this.GrowthMonitoring,
    required this.Anc,
  });

  factory DefaulterTotals.fromJson(Map<String, dynamic> json) {
    return DefaulterTotals(
      Immunization: json['Immunization'].toString(),
      Dewarming: json['Dewarming'].toString(),
      VitaminA: json['VitaminA'].toString(),
      GrowthMonitoring: json['GrowthMonitoring'].toString(),
      Anc: json['Anc'].toString(),
    );
  }

  @override
  String toString() {
    return 'DefaulterTotals{Immunization: $Immunization, VitaminA: $VitaminA, GrowthMonitoring: $GrowthMonitoring, Anc: $Anc}';
  }
}
