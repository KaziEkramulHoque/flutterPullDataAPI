import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import 'package:google_fonts/google_fonts.dart';
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

  late HttpService http;

  // late ListUserResponse listUserResponse;
  //String json;
  late List<User> userList = [];
  //late User user;
  Future getListUser() async {
    Response response;
    try {
      isLoading = true;

      response = await http.getRequest("users");

      isLoading = false;

      if (response.statusCode == 200) {
        setState(() {
          userList = User.userlistFromJson(response.data);
        });
      } else {
        print("There is some problem status code not 200");
      }
    } on Exception catch (e) {
      isLoading = false;
      print(e);
    }
  }

  @override
  void initState() {
    http = HttpService();

    getListUser();

    super.initState();
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
      body: isLoading
          ? Center(child: CircularProgressIndicator())
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
                ),
    );
  }
}
