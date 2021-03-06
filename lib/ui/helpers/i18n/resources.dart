import 'package:flutter/widgets.dart';

import 'strings/strings.dart';

class R {
  static Translations strings = EnUs();

  static void load(Locale locale) {
    switch (locale.toString()) {
      case 'pt_BR':
        strings = PtBr();
        break;
      default:
        strings = EnUs();
    }
  }
}
