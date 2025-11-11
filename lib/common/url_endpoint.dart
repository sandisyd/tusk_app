class Url {
  static const baseurl = 'http://localhost:8080';
  static String image(String filename) => '${baseurl}/attachment/${filename}';
}
