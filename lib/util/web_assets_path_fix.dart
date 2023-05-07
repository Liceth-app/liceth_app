import 'package:flutter/foundation.dart' as foundation;

// Firebase Hosting path fix
const needsFullPath = !foundation.kIsWeb || foundation.kReleaseMode;

String imagePath(String imageFileName) {
  if (needsFullPath) {
    return 'assets/images/$imageFileName';
  }
  return 'images/$imageFileName';
}

String iconPath(String imageFileName) {
  if (needsFullPath) {
    return 'assets/icon/$imageFileName';
  }
  return 'icon/$imageFileName';
}

String svgPath(String svgFileName) {
  if (needsFullPath) {
    return 'assets/svg/$svgFileName';
  }
  return 'svg/$svgFileName';
}
