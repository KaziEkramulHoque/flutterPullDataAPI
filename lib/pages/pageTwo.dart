import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import 'package:google_fonts/google_fonts.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:pillar_test/model/post.dart';
import 'dart:convert';
import 'package:pillar_test/model/user.dart';
import 'package:pillar_test/services/http_service.dart';

class PageTwo extends StatefulWidget {
  const PageTwo({Key? key}) : super(key: key);

  @override
  _PageTwoState createState() => _PageTwoState();
}

class _PageTwoState extends State<PageTwo> {
  User user = Get.arguments;
  late HttpService http;
  late int userId = user.id;
  late String userName = user.name;
  var listener;
  bool isLoading = false;
  bool isInternet = true;
  bool error = false;

  late List<Post> postList = [];
  late Post post;
  Future getposts() async {
    late Response activeResponse;
    try {
      setState(() {
        isLoading = true;
      });

      //final isInternet = await InternetConnectionChecker().hasConnection;
      final response = await http.getRequest("posts?userId=$userId");

      response.when(
        (exception) => isLoading = false, // TODO: Handle exception
        (response) =>
            activeResponse = response, // TODO: Do something with location
      );
      setState(() {
        isLoading = false;
      });

      if (activeResponse.statusCode == 200) {
        setState(() {
          postList = Post.postlistFromJson(activeResponse.data);
          postList.sort((a, b) => a.title.length.compareTo(b.title.length));
        });
      } else {
        print("There is some problem status code not 200");
        isLoading = false;
      }
    } on Exception catch (e) {
      isLoading = false;
      print(e);
    }
  }

  Future getInternet() async {
    listener = InternetConnectionChecker().onStatusChange.listen((status) {
      switch (status) {
        case InternetConnectionStatus.connected:
          setState(() {
            isInternet = true;
            isLoading = false;
            getposts();
          });
          Get.snackbar("Online", "Internet Conneted");
          print('Data connection is available.');
          break;
        case InternetConnectionStatus.disconnected:
          setState(() {
            isInternet = false;
            error = true;
          });
          Get.snackbar("Offline", "Internet Disconneted");

          print('You are disconnected from the internet.');
          break;
      }
    });
  }

  @override
  void initState() {
    http = HttpService();
    getInternet();
    getposts();

    super.initState();
  }

  @override
  void dispose() {
    listener.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "$userName's Posts",
          style: GoogleFonts.didactGothic(
            color: Color.fromARGB(255, 100, 98, 98),
          ),
        ),
        backgroundColor: Color.fromARGB(255, 231, 33, 120),
        iconTheme: IconThemeData(
          color: Color.fromARGB(255, 100, 98, 98),
        ),
      ),
      body: SafeArea(
        child: !isInternet
            ? Align(
                alignment: Alignment.center,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        child: Text("No internet.Show Offline Data"),
                        onPressed: () {
                          setState(() {
                            isInternet = true;
                            getposts();
                          });
                          if (postList.isEmpty) {
                            isInternet = false;
                            Get.snackbar(
                                "Posts Empty", "No Offline Data Found");
                          }
                        }),
                  ],
                ),
              )
            : isLoading
                ? Center(child: CircularProgressIndicator())
                : isInternet
                    ? ListView.builder(
                        itemBuilder: (context, index) => Card(
                          //final post = postList[index];
                          elevation: 6,
                          margin: const EdgeInsets.all(10),
                          color: Color.fromARGB(255, 100, 98, 98),
                          child: ListTile(
                            title: Text(
                              postList[index].title.capitalize.toString(),

                              //textAlign: TextAlign.justify,
                              style: GoogleFonts.didactGothic(
                                fontSize: 20,
                                color: Color.fromARGB(255, 231, 33, 120),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              postList[index].body,
                              textAlign: TextAlign.justify,
                              style: GoogleFonts.didactGothic(
                                fontSize: 15,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        itemCount: postList.length,
                      )
                    : Center(
                        child: Text("No User Object"),
                      ),
      ),
    );
  }
}
