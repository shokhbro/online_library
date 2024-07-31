import 'package:get_it/get_it.dart';
import 'package:kutubxona/blocs/book/book_bloc.dart';
import 'package:kutubxona/data/repositories/book_repository.dart';

final getIt = GetIt.instance;

void setUp() {
  getIt.registerSingleton(BookRepository());

  getIt.registerSingleton(
    BookBloc(
      bookRepository: getIt.get<BookRepository>(),
    ),
  );
}
