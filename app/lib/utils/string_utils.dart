extension StringExt on String {
  int toInt() {
    return int.tryParse(this) ?? 0;
  }

  double toDouble() {
    return double.tryParse(this) ?? 0;
  }

  bool toBool() {
    if (toLowerCase() == 'true') {
      return true;
    }
    return false;
  }

  RegExp toRegExp() {
    return RegExp(this);
  }

  String toFormattedAddress() {
    if (length < 10) {
      return this;
    }
    return '${substring(0, 6)}...${substring(length - 4)}';
  }

  String capitalize() {
    if (isEmpty) {
      return this;
    }
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }

  bool get isSupportedMedia => endsWith('.mp4') || endsWith('.mp3');

  String toObscure(int length) {
    return '\u2217' * length;
  }
}
