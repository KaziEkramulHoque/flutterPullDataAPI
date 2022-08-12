import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import 'package:google_fonts/google_fonts.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:multiple_result/multiple_result.dart';
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
  // bool isLoading = false;
  bool isInternet = false;
  late HttpService http;
  var listener;
  // late ListUserResponse listUserResponse;
  //String json;
  late List<User> userList = [];

  bool error = false; //for error status
  bool loading = false; //for data featching status
  String errmsg = ""; //to assing any error message from API/runtime
  //var apidata; //for decoded JSON data
  bool refresh = false; //for forcing refreshing cache
  ConnectivityResult result = ConnectivityResult.none;
  void startApplication() async {
    await Future.wait([
      getInternet(),
      getListUser(),
    ]);
  }

  // wait() async {
  //   setState(() {
  //     isLoading = true;
  //   });
  //   await Future.delayed(const Duration(seconds: 5));
  //   setState(() {
  //     isLoading = false;
  //   });
  // }

  //late User user;
  Future getListUser() async {
    late Response activeResponse;

    try {
      loading = true;
      // if (!isInternet) {
      //   isLoading = false;
      // }
      //isInternet = await InternetConnectionChecker().hasConnection;
      // if (!isInternet) {
      //isLoading = false;
      // }
      // isLoading = false;
      final response = await http.getRequest("users");
      loading = false;
      response.when(
        (exception) => loading = false, // TODO: Handle exception
        (response) =>
            activeResponse = response, // TODO: Do something with location
      );

      if (activeResponse.statusCode == 200) {
        setState(() {
          userList = User.userlistFromJson(activeResponse.data);
          loading = false;
        });
      } else {
        error = true;

        loading = false;
      }
      // loading = false;
      // refresh = false;
      // setState(() {});
    } on Exception catch (e) {
      error = true;
      loading = false;
      print(e);
    }
  }

  // Future getInternet() async {
  //   //Response response;
  //   try {
  //     //isLoading = true;
  //     // var listioner = InternetConnectionStatus.values;
  //     // isInternet = await InternetConnectionChecker().hasConnection;
  //     // isLoading = false;

  //     result = await Connectivity().checkConnectivity();

  //     // if (!isInternet) {
  //     //   isLoading = false;
  //     // } else {
  //     //   setState(() {
  //     //     getListUser();
  //     //     isLoading = false;
  //     //   });
  //     // }
  //     loading = false;
  //     // isLoading = false;

  //   } on Exception catch (e) {
  //     loading = false;
  //     error = true;
  //   }
  // }

  Future getInternet() async {
    //isInternet = await InternetConnectionChecker().hasConnection;
    listener = InternetConnectionChecker().onStatusChange.listen((status) {
      switch (status) {
        case InternetConnectionStatus.connected:
          isInternet = true;
          //error = true;
          //isLoading = false;
          print('Data connection is available.');
          break;
        case InternetConnectionStatus.disconnected:
          isInternet = false;
          error = true;
          print('You are disconnected from the internet.');
          break;
      }
    });
  }

  @override
  void initState() {
    //wait();
    http = HttpService();
    //startApplication();
    getListUser();
    getInternet();

    // isLoading = false;
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
                      child: Text("No internet! Refresh"),
                      onPressed: () {
                        isInternet = true;
                        getListUser();
                      }),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: () async {
                refresh = true;
                getListUser();
              },
              child: ListView.builder(
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
              )),

      // : Center(
      //     child: Text("No User Object"),
      //   )
    );
  }
}
