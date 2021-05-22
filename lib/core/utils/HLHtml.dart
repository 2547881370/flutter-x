class HlHtml {
  static String toHTml(String html) {
    // 替换text
    String text = html.replaceAll('text', 'p');
    String img = text.replaceAll('image', 'img');
    String _html = img.replaceAllMapped(
        new RegExp(
            r"<img>((http|ftp|https):\/\/[\w\-_]+(\.[\w\-_]+)+([\w\-\.,@?^=%&:/~\+#]*[\w\-\@?^=%&/~\+#])?),(\d*),(\d*)</img>",
            dotAll: true), (Match m) {
      return "<img src='${m[1]}' width='${m[5]}px' height='${m[6]}px'><img>";
    });
    return _html;
  }
}
