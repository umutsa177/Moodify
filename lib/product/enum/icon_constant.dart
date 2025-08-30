import 'package:flutter_svg/flutter_svg.dart';

enum IconConstant {
  feed('feed'),
  profile('profile');

  const IconConstant(this.value);
  final String value;

  String get toSvg => 'assets/icons/$value.svg';
  String get toSelectedSvg => 'assets/icons/selected_$value.svg';

  SvgPicture get toIcon => SvgPicture.asset(toSvg);
  SvgPicture get toSelectedIcon => SvgPicture.asset(toSelectedSvg);
}
