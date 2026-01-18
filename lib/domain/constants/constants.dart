import 'package:trip_planner/domain/constants/keys.dart';
import 'package:trip_planner/domain/constants/routing.dart';
import 'package:trip_planner/domain/constants/strings.dart';

import 'integers.dart';

abstract class Constants {
  static final keys = ConstantsKeys();
  static final routing = RoutingConstants();
  static final strings = ConstantsStrings();
  static final integers = ConstantsIntegers();
}
