import 'package:kutubxona/data/models/book.dart';

sealed class BookEvent {}

final class GetBooks extends BookEvent {}

final class DownloadBook extends BookEvent {
  final Book book;

  DownloadBook({required this.book});
}

final class OpenBook extends BookEvent {
  final String path;

  OpenBook({required this.path});
}

final class SearchBookEvent extends BookEvent {
  final String query;

  SearchBookEvent({required this.query});
}
