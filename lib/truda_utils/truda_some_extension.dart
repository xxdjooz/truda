extension CostomString on String {
  void log() {
    print("log---> $this ");
  }

  String toUpperCasForFirst() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }

  String replaceNumByStar() {
    // NewHitaLog.debug("去除尾部的空格符");
    String finalS = replaceAll(RegExp(r'\s*$'), "");
    return finalS.replaceAll(RegExp(r"\d"), "*");
  }
}
