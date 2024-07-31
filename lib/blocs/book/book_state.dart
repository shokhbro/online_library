import 'package:kutubxona/data/models/book.dart';

final class BookState {
  List<Book>? books;
  Book? book;
  String? errorMessage;
  bool isLoading;

  BookState({
    this.books,
    this.book,
    this.errorMessage,
    this.isLoading = false,
  });

  BookState copyWith({
    List<Book>? books,
    Book? book,
    String? errorMessage,
    bool? isLoading,
  }) {
    return BookState(
      books: books ?? this.books,
      book: book ?? this.book,
      errorMessage: errorMessage ?? this.errorMessage,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
