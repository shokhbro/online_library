import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:kutubxona/blocs/book/book_bloc.dart';
import 'package:kutubxona/blocs/book/book_event.dart';
import 'package:kutubxona/data/models/book.dart';

class BookDetailsScreen extends StatefulWidget {
  final Book book;

  const BookDetailsScreen({
    required this.book,
    super.key,
  });

  @override
  State<BookDetailsScreen> createState() => _BookDetailsScreenState();
}

class _BookDetailsScreenState extends State<BookDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: double.infinity,
                height: 400,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.8),
                  image: DecorationImage(
                    image: NetworkImage(widget.book.imageurl),
                    colorFilter: const ColorFilter.mode(
                      Colors.white70,
                      BlendMode.lighten,
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                left: 10,
                top: 30,
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(
                    Icons.arrow_circle_left_outlined,
                    color: Colors.black38,
                    size: 40,
                  ),
                ),
              ),
              Positioned(
                left: 50,
                right: 50,
                top: 40,
                child: Column(
                  children: [
                    Text(
                      widget.book.title,
                      style: const TextStyle(
                        fontFamily: 'Playfair',
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      overflow: TextOverflow.ellipsis,
                      widget.book.author,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                left: 105,
                top: 110,
                child: Container(
                  width: 150,
                  height: 210,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.1),
                    image: DecorationImage(
                      image: NetworkImage(widget.book.imageurl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 30,
                bottom: -30,
                child: Container(
                  width: 295,
                  height: 54,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        width: 49,
                        height: 20,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.orange[50],
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                      Container(
                        width: 66,
                        height: 23,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color(0xffE2FCFB),
                        ),
                        child: const Center(
                          child: Text(
                            "Fantasy",
                            style: TextStyle(fontSize: 11),
                          ),
                        ),
                      ),
                      Container(
                        width: 62,
                        height: 15,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Center(
                          child: Text(
                            "432 pages",
                            style: TextStyle(fontSize: 11),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const Gap(20),
          Expanded(
            child: ListView(
              children: const [
                Padding(
                  padding: EdgeInsets.only(left: 15),
                  child: Text(
                    "Synopsis",
                    style: TextStyle(
                      fontFamily: 'Playfair',
                      fontSize: 20,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Text(
                      "Elspeth needs a monster. The monster might be her. Elspeth Spindle needs more than luck to stay safe in the eerie, mist-locked kingdom of Blunder—she needs a monster. She calls him the Nightmare, an ancient, mercurial spirit trapped in her head. He protects her. He keeps her secrets."),
                ),
                Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Text(
                      "But nothing comes for free, especially magic. When Elspeth meets a mysterious highwayman on the forest road, her life takes a drastic turn. Thrust into a world of shadow and deception, she joins a dangerous quest to cure Blunder from the dark magic infecting it. And the highwayman? He just so happens to be the King’s nephew, Captain of the most dangerous men in Blunder…and guilty of high treason."),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: SizedBox(
        width: double.infinity,
        height: 70,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Book is archived"),
                  ),
                );
              },
              child: Container(
                width: 52,
                height: 52,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: Center(
                  child: SvgPicture.asset("assets/icons/save.svg"),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                if (widget.book.isDownloaded) {
                  context
                      .read<BookBloc>()
                      .add(OpenBook(path: widget.book.savePath));
                } else {
                  context.read<BookBloc>().add(DownloadBook(book: widget.book));
                }
                setState(() {});
              },
              child: Container(
                width: 280,
                height: 52,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: widget.book.isDownloaded
                      ? Colors.blueGrey[200]
                      : const Color(0xff404066),
                ),
                child: Center(
                  child: Text(
                    widget.book.isDownloaded ? "Downloaded" : "Download",
                    style: const TextStyle(
                      fontFamily: 'Lato',
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
