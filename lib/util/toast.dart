import 'package:oktoast/oktoast.dart';

void toast(String msg,
    {ToastPosition? position,
    Duration? duration = const Duration(seconds: 3)}) {
  showToast(msg, position: position, duration: duration);
}
