import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:kutubxona/blocs/book/book_bloc.dart';
import 'package:kutubxona/blocs/book/book_event.dart';
import 'package:kutubxona/blocs/book/book_state.dart';
import 'package:kutubxona/ui/screens/book_details_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Book Junction",
          style: TextStyle(fontFamily: 'Lato'),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Gap(20),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: TextField(
              onChanged: (value) {
                context.read<BookBloc>().add(
                      SearchBookEvent(query: value),
                    );
              },
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(10),
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(color: Colors.grey[200]!),
                ),
                hintText: "Search for books",
                prefixIcon: const Icon(Icons.search),
                suffixIcon: const Icon(Icons.mic_none),
              ),
            ),
          ),
          const Gap(30),
          const Padding(
            padding: EdgeInsets.only(left: 12),
            child: Text(
              "Best Sellers",
              style: TextStyle(
                fontFamily: 'Playfair',
                fontSize: 18,
              ),
            ),
          ),
          const Gap(10),
          BlocBuilder<BookBloc, BookState>(
              bloc: context.read<BookBloc>()..add(GetBooks()),
              builder: (context, state) {
                if (state.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (state.errorMessage != null) {
                  return Center(
                    child: Text(state.errorMessage!),
                  );
                }

                if (state.books == null || state.books!.isEmpty) {
                  return const Center(
                    child: Text('Kitoblar mavjud emas!'),
                  );
                }

                final books = state.books!;
                return Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisExtent: 245,
                      mainAxisSpacing: 20,
                      crossAxisSpacing: 10,
                    ),
                    itemCount: books.length,
                    itemBuilder: (context, index) {
                      final book = books[index];
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          children: [
                            Container(
                              height: 155,
                              decoration: BoxDecoration(
                                color: Colors.orange[200],
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(15),
                                  topRight: Radius.circular(15),
                                  bottomLeft: Radius.circular(7),
                                  bottomRight: Radius.circular(7),
                                ),
                                image: DecorationImage(
                                  image: NetworkImage(book.imageurl),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  right: 10, left: 10, top: 5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          book.title,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontFamily: 'Playfair',
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: 40,
                                        height: 18,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.orange[100],
                                        ),
                                        child: const Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Icon(
                                              Icons.star,
                                              size: 14,
                                              color: Colors.amber,
                                            ),
                                            Text(
                                              "4.8",
                                              style: TextStyle(fontSize: 11),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    book.author,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: Colors.black38,
                                      fontSize: 13,
                                    ),
                                  ),
                                  const Gap(5),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        book.price,
                                        style: const TextStyle(
                                          fontFamily: 'Lato',
                                          fontSize: 16,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(context,
                                              MaterialPageRoute(builder: (ctx) {
                                            return BookDetailsScreen(
                                              book: book,
                                            );
                                          }));
                                        },
                                        child: const Icon(
                                          Icons.arrow_circle_right_outlined,
                                          color: Colors.black26,
                                          size: 30,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              }),
        ],
      ),
    );
  }
}
