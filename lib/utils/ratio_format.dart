extension RatioFormat on double{
  String toFormatRatio({ bool reverse = false }) =>
    !reverse ? '${(this * 10).floor()}：${10 - (this * 10).floor()}' : '${10 - (this * 10).floor()}：${(this * 10).floor()}';
  
  num toPercentage ({ bool floor = true }) => floor ? (this * 100).floor() : (this * 100);
  String toFormatPercentage ({ bool floor = true }) => '${toPercentage(floor: floor)}%';
}