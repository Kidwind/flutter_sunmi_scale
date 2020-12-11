class SunmiScaleData {
  final int net;
  final int tare;
  final bool isStable;

  SunmiScaleData(this.net, this.tare, this.isStable) {}

  SunmiScaleData.fromJson(Map<String, dynamic> json)
      : net = json['net'],
        tare = json['tare'],
        isStable = json['isStable'];

  Map<String, dynamic> toJson() =>
      {
        'net': net,
        'tare': tare,
        'isStable': isStable
      };
}
