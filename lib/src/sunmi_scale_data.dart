class SunmiScaleData {
  final bool isCanUse;

  final int net;
  final int tare;
  final bool isStable;

  final bool isLightWeight;
  final bool overload;
  final bool clearZeroErr;
  final bool calibrationErr;

  SunmiScaleData(
      this.isCanUse,
      this.net, this.tare, this.isStable,
      this.isLightWeight, this.overload, this.clearZeroErr, this.calibrationErr
  ) {}

  SunmiScaleData.fromJson(Map<String, dynamic> json)
      : isCanUse = json['isCanUse'],
        net = json['net'],
        tare = json['tare'],
        isStable = json['isStable'],

        isLightWeight = json['isLightWeight'],
        overload = json['overload'],
        clearZeroErr = json['clearZeroErr'],
        calibrationErr = json['calibrationErr'];

  Map<String, dynamic> toJson() =>
      {
        'isCanUse': isCanUse,

        'net': net,
        'tare': tare,
        'isStable': isStable,

        'isLightWeight': isLightWeight,
        'overload': overload,
        'clearZeroErr': clearZeroErr,
        'calibrationErr': calibrationErr,
      };
}
