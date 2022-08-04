import 'package:intl/intl.dart';
import 'package:shopping/utils/apis/network_exceptions.dart';

extension DateTimeExtension on DateTime {
  String toStringWithCustomDate(String outputFormat) {
    if(this == null){
      return "";
    }
    return DateFormat(outputFormat).format(this);
  }
}