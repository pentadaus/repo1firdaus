import 'dart:convert';

import 'package:book_appp/controllers/book_controller.dart';
import 'package:book_appp/model/book_detail_response.dart';
import 'package:book_appp/model/book_list_response.dart';
import 'package:book_appp/views/image_view_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class DetailBookPage extends StatefulWidget {
  const DetailBookPage({super.key, required this.isbn});
  final String isbn;

  @override
  State<DetailBookPage> createState() => _DetailBookPageState();
}

class _DetailBookPageState extends State<DetailBookPage> {
  BookController? controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = Provider.of<BookController>(context, listen: false);
    controller!.fetchDetailBookApi(widget.isbn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detail"),
      ),
      body: Consumer<BookController>(builder: (context, controller, child) {
        return controller.detailBook == null
            ? Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ImageViewScreen(
                                      imageUrl: controller.detailBook!.image!)),
                            );
                          },
                          child: Image.network(
                            controller.detailBook!.image!,
                            height: 150,
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  controller.detailBook!.title!,
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  controller.detailBook!.authors!,
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.grey),
                                ),
                                Row(
                                  children: List.generate(
                                      5,
                                      (index) => Icon(
                                            Icons.star,
                                            color: index <
                                                    int.parse(controller
                                                        .detailBook!.rating!)
                                                ? Colors.yellow
                                                : Colors.grey,
                                          )),
                                ),
                                Text(
                                  controller.detailBook!.subtitle!,
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey),
                                ),
                                Text(
                                  controller.detailBook!.price!,
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    // SizedBox(
                    //   height: 5,
                    // ), ini saya komen, di device saya terlalu kebawah jika menggunakan sizedbox disini
                    Container(
                      width: double.infinity,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(),
                          onPressed: () async {
                            print("url");
                            Uri uri = Uri.parse(controller.detailBook!.url!);
                            try {
                              (await canLaunchUrl(uri))
                                  ? launchUrl(uri)
                                  : print("tidak berhasil navigasi");
                            } catch (e) {
                              print("error");
                              print(e);
                            }
                          },
                          child: Text("BUY")),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(controller.detailBook!.desc!),
                    SizedBox(
                      height: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text("Year: " + controller.detailBook!.year!),
                        Text("ISBN" + controller.detailBook!.isbn13!),
                        Text(controller.detailBook!.pages! + " Page"),
                        Text("Publisher: " + controller.detailBook!.publisher!),
                        Text("Language: " + controller.detailBook!.language!),

                        // Text(detailBook!.rating!),
                      ],
                    ),
                    Divider(),
                    controller.similiarBooks == null
                        ? CircularProgressIndicator()
                        : Container(
                            height: 130,
                            child: ListView.builder(
                              // shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount:
                                  controller.similiarBooks!.books!.length,
                              // physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                final current =
                                    controller.similiarBooks!.books![index];
                                return Container(
                                  width: 80,
                                  child: Column(
                                    children: [
                                      Image.network(
                                        current.image!,
                                        height: 80,
                                      ),
                                      // untuk width atau height yang saya pakai ini menyesuaikan ukuran
                                      // device hp saya
                                      Text(
                                        current.title!,
                                        maxLines: 3,
                                        textAlign: TextAlign.center,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(fontSize: 12),
                                      )
                                    ],
                                  ),
                                );
                              },
                            ),
                          )
                  ],
                ),
              );
      }),
    );
  }
}
