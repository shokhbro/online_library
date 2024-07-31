import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kutubxona/blocs/book/book_event.dart';
import 'package:kutubxona/blocs/book/book_state.dart';
import 'package:kutubxona/data/models/book.dart';
import 'package:kutubxona/data/repositories/book_repository.dart';
import 'package:kutubxona/services/permission_service.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

class BookBloc extends Bloc<BookEvent, BookState> {
  BookBloc({required this.bookRepository}) : super(BookState()) {
    on<GetBooks>(_ongetBooks);
    on<DownloadBook>(_onDownloadBooks);
    on<OpenBook>(_onOpenBooks);
    on<SearchBookEvent>(_onSearch);
  }

  final BookRepository bookRepository;

  void _ongetBooks(GetBooks event, Emitter<BookState> emit) async {
    emit(state.copyWith(isLoading: true));

    try {
      for (var book in bookRepository.books) {
        final fullPath = await _getSavePath(book);
        if (_checkBookExists(fullPath)) {
          book = book
            ..savePath = fullPath
            ..isDownloaded = true;
        }
      }

      emit(state.copyWith(
        books: bookRepository.books,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      ));
    }
  }

  void _onDownloadBooks(DownloadBook event, Emitter<BookState> emit) async {
    final book = event.book;
    book.isLoading = true;

    emit(state.copyWith(book: book));

    final dio = Dio();

    if (await PermissionService.requestStoragePermission()) {
      try {
        final fullPath = await _getSavePath(book);

        if (_checkBookExists(fullPath)) {
          add(OpenBook(path: fullPath));
          emit(
            state.copyWith(
              book: state.book!
                ..savePath = fullPath
                ..isDownloaded = true,
            ),
          );
        } else {
          final response = await dio.download(
            book.pdfUrl,
            fullPath,
            onReceiveProgress: (count, total) {
              emit(state.copyWith(
                book: state.book!..progress = count / total,
              ));
            },
          );

          print(response);

          emit(
            state.copyWith(
              book: state.book!
                ..savePath = fullPath
                ..isLoading = false
                ..isDownloaded = true,
            ),
          );
        }
      } on DioException catch (e) {
        print("DIO EXCEPTION");
        emit(
          state.copyWith(
            book: state.book!..isLoading = false,
            errorMessage: e.response?.data,
          ),
        );
      } catch (e) {
        print("CATCH EXCEPTION");
        emit(
          state.copyWith(
            book: state.book!..isLoading = false,
            errorMessage: e.toString(),
          ),
        );
      }
    }
  }

  void _onOpenBooks(OpenBook event, Emitter<BookState> emit) async {
    await OpenFilex.open(event.path);
  }

  bool _checkBookExists(String filePath) {
    final file = File(filePath);

    return file.existsSync();
  }

  void _onSearch(SearchBookEvent event, Emitter<BookState> emit) {
    try {
      emit(state.copyWith(
          books: bookRepository.books
              .where(
                (element) => element.title
                    .toLowerCase()
                    .contains(event.query.toLowerCase()),
              )
              .toList()));
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  Future<String> _getSavePath(Book file) async {
    final savePath =
        await getApplicationDocumentsDirectory(); // iphone/application/documents
    final fileExtension =
        file.pdfUrl.split('.').last; // https://www.hp.com/video.mp4
    final fileName = "${file.title}.$fileExtension"; // Harry Potter Video.mp4
    final fullPath = "${savePath.path}/$fileName";

    return fullPath;
  }
}
