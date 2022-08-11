import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import 'package:google_fonts/google_fonts.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'dart:convert';
import 'package:pillar_test/model/user.dart';
import 'package:pillar_test/routes/routes.dart';
import 'package:pillar_test/services/http_service.dart';

class PageOne extends StatefulWidget {
  const PageOne({Key? key}) : super(key: key);

  @override
  _PageOneState createState() => _PageOneState();
}

class _PageOneState extends State<PageOne> {
  bool isLoading = false;
  bool isInternet = false;
  late HttpService http;
  var listener;
  // late ListUserResponse listUserResponse;
  //String json;
  late List<User> userList = [];
  //late User user;
  Future getListUser() async {
    Response response;
    try {
      //isLoading = true;
      // if (!isInternet) {
      //   isLoading = false;
      // }
      isInternet = await InternetConnectionChecker().hasConnection;
      // if (!isInternet) {
      //   isLoading = false;
      // }
      // isLoading = false;
      response = await http.getRequest("users");

      isLoading = false;

      if (response.statusCode == 200) {
        setState(() {
          userList = User.userlistFromJson(response.data);
          isLoading = false;
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

  // Future getInternet() async {
  //   //Response response;
  //   try {
  //     isLoading = true;
  //     isInternet = await InternetConnectionChecker().hasConnection;
  //     isLoading = false;
  //     if (!isInternet) {
  //       isLoading = false;
  //     } else {
  //       setState(() {
  //         getListUser();
  //         isLoading = false;
  //       });
  //     }
  //     // isLoading = false;
  //     // isLoading = false;

  //   } on Exception catch (e) {
  //     isLoading = false;
  //     print(e);
  //   }
  // }

  // Future getInternet() async {
  //   //isInternet = await InternetConnectionChecker().hasConnection;
  //   listener = InternetConnectionChecker().onStatusChange.listen((status) {
  //     switch (status) {
  //       case InternetConnectionStatus.connected:
  //         isInternet = true;
  //         isLoading = false;
  //         print('Data connection is available.');
  //         break;
  //       case InternetConnectionStatus.disconnected:
  //         isInternet = false;
  //         isLoading = false;
  //         print('You are disconnected from the internet.');
  //         break;
  //     }
  //   });
  // }

  @override
  void initState() {
    http = HttpService();
    //getInternet();
    getListUser();
    super.initState();
  }

  // @override
  // void dispose() {
  //   listener.cancel();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "U S E R S",
            style: GoogleFonts.didactGothic(
              color: Color.fromARGB(255, 100, 98, 98),
            ),
          ),
          backgroundColor: Color.fromARGB(255, 231, 33, 120),
          iconTheme: IconThemeData(
            color: Color.fromARGB(255, 100, 98, 98),
          ),
        ),
        body: !isInternet
            ? Align(
                alignment: Alignment.center,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        child: Text("No internet"),
                        onPressed: () {
                          //isInternet = true;
                          getListUser();
                        }),
                  ],
                ),
              )
            : userList != null
                ? ListView.builder(
                    itemBuilder: (context, index) => GestureDetector(
                      onTap: () {
                        Get.toNamed(RoutesClass.getPageTwoRoute(),
                            arguments: userList[index]);
                      },
                      child: Card(
                        //final user = userList[index];
                        elevation: 6,
                        margin: const EdgeInsets.all(10),
                        color: Color.fromARGB(255, 100, 98, 98),
                        child: ListTile(
                          title: Text(
                            userList[index].name,
                            textAlign: TextAlign.justify,
                            style: GoogleFonts.didactGothic(
                                // fontFamily: "Rbotoo",
                                fontSize: 20,
                                color: Color.fromARGB(255, 231, 33, 120)),
                          ),
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                                "https://w7.pngwing.com/pngs/627/97/png-transparent-avatar-web-development-computer-network-avatar-game-web-design-heroes-thumbnail.png"),
                          ),
                          subtitle: Text(
                            userList[index].email,
                            textAlign: TextAlign.justify,
                            style: GoogleFonts.didactGothic(
                                // fontFamily: "Rbotoo",
                                fontSize: 15,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    itemCount: userList.length,
                  )
                : Center(
                    child: Text("No User Object"),
                  ));
  }
}
