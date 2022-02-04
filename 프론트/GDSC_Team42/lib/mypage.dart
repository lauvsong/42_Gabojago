import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

import 'main.dart';

GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['profile', 'email']);

class MyInfoPage extends StatefulWidget {
  final GoogleSignInAccount? userInfo;
  final String tierInfo;


  const MyInfoPage( this. userInfo, this.tierInfo, {Key? key}) : super(key: key);

  @override
  _MyInfoPageState createState() => _MyInfoPageState(userInfo,tierInfo);
}

class _MyInfoPageState extends State<MyInfoPage> {
  final GoogleSignInAccount? userInfo;
  final String tierInfo;

  _MyInfoPageState(this.userInfo, this.tierInfo);

  String userMail = '';
  String userName = '';
  String userIDCode = '';
  double pointInfo = 0;

  @override
  void initState() {
    super.initState();
    _handleUserInfo();
  }

  Future<void> _handleUserInfo() async {

    setState(() {
      if (userInfo != null) {
        userMail = userInfo?.email ?? '';
        userIDCode = userInfo?.id ?? '';
        userName = userInfo?.displayName ?? '';
      }
    });
  }

  Widget _userTierIcon() {
    if (tierInfo == "seed") {
      return Container(
        margin: EdgeInsets.all(20),
        decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle),
        child: Image.asset(
          "img/seed.png",
          width: 50,
        ),
      );
    } else if (tierInfo == "sprout") {
      return Container(
        margin: EdgeInsets.all(20),
        decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle),
        child: Image.asset(
          "img/sprout.png",
          width: 50,
        ),
      );
    } else if (tierInfo == "leaf") {
      return Container(
        margin: EdgeInsets.all(20),
        decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle),
        child: Image.asset(
          "img/leaf.png",
          width: 50,
        ),
      );
    } else if (tierInfo == "grass") {
      return Container(
        margin: EdgeInsets.all(20),
        decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle),
        child: Image.asset(
          "img/grass.png",
          width: 50,
        ),
      );

    } else if (tierInfo == "tree") {
      return Container(
        margin: EdgeInsets.all(20),
        decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle),
        child: Image.asset(
          "img/tree.png",
          width: 50,
        ),
      );
    } else if (tierInfo == "forest") {
      return Container(
        margin: EdgeInsets.all(20),
        decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle),
        child: Image.asset(
          "img/forest.png",
          width: 50,
        ),
      );
    } else {
      return Container(
        margin: EdgeInsets.all(20),
        decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle),
        child: Image.asset(
          "img/seed.png",
          width: 50,
        ),
      );
    }
  }

  Widget _buildRewordInfoBox() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          alignment: Alignment.center,
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                      color: Colors.white, shape: BoxShape.circle),
                  child: _userTierIcon(),
                ),
                Padding(padding: EdgeInsets.all(5)),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("$userName님,",
                        style: TextStyle(fontSize: 15, color: Colors.white)),
                    Text("현재 $tierInfo 단계입니다!",
                        style: TextStyle(fontSize: 15, color: Colors.white)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _handleSignOut() async {
    _googleSignIn.disconnect();
    idLogOut();
    setState(() {
    });
  }

  Future<void> idLogOut() async {
    var url = Uri.parse(
        "http://d522-1-231-133-115.ngrok.io/user/logout");
    var response = await http.get(url);

    if (response.statusCode == 200) {
      setState(() {
        pointInfo = 0;
      });
    } else if (response.statusCode == 304) {
      setState(() {
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.green),
        backgroundColor: Colors.white,
        title: PreferredSize(
          preferredSize: Size.fromHeight(85),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Column(
                children: <Widget>[

                  Text("마이페이지",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[900])),
                ],
              ),
            ],
          ),
        ),
      ),
      body: ListView(
        children: <Widget>[

          Container(
            width: MediaQuery.of(context).size.width,
            height: 200,
            color: Color(0xff03511b),
            child: Center(child: _buildRewordInfoBox()),
          )
        ],
      ),
    );
  }
}
