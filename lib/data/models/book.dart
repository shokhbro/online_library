class Book {
  final String title;
  final String author;
  String price;
  final String imageurl;
  final String pdfUrl;
  String savePath;
  double progress;
  bool isLoading;
  bool isDownloaded;

  Book({
    required this.title,
    required this.author,
    required this.price,
    required this.imageurl,
    required this.pdfUrl,
    required this.savePath,
    required this.progress,
    required this.isLoading,
    required this.isDownloaded,
  });
}
