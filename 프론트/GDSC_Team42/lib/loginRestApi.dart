import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rflutter_alert/rflutter_alert.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  String _username = "";
  String _pw = "";
  int? _apiStatusCode;
  String? _errorMassage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          children: <Widget>[
            SizedBox(height: 80.0),
            Column(
              children: <Widget>[
                SizedBox(height: 16.0),
                Text('로그인'),
              ],
            ),
            SizedBox(height: 10.0),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                filled: true,
                labelText: 'Username',
              ),
            ),
            SizedBox(height: 12.0),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                filled: true,
                labelText: 'Password',
              ),
              obscureText: true,
            ),
            ButtonBar(
              children: <Widget>[
                TextButton(
                  child: Text('CANCEL'),
                  onPressed: () {
                    _usernameController.clear();
                    _passwordController.clear();
                  },
                ),
                ElevatedButton(
                  child: Text('NEXT'),
                  onPressed: () {
                    setState(() {
                      _username = _usernameController.text;
                      _pw = _passwordController.text;
                      idLogIn(_username, _pw);
                    });
                    if (_apiStatusCode == 200) {
                      Navigator.pop(context);
                    } else if (_apiStatusCode == 304) {
                      _onBasicAlertPressed(context);
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _onBasicAlertPressed(context) {
    Alert(
      context: context,
      title: _errorMassage,
    ).show();
  }

  Future<void> idResister(String username, String pw) async {
    var url = Uri.parse(
        "https://app.swaggerhub.com/apis-docs/gabojago/gabojago/1.0.0/user/resister");

    Map data = {"username": username, "pw": pw};
    var body = json.encode(data);
    var response = await http.post(url,
        headers: {"Content-Type": "application/json"}, body: body);

    if (response.statusCode == 201) {
      setState(() {
        //register success
        _apiStatusCode = 201;
      });
    } else if (response.statusCode == 304) {
      setState(() {
        _errorMassage = "userid already exist";
        _apiStatusCode = 304;
        idLogIn(username, pw);
      });
    }
  }

  Future<void> idLogIn(String username, String pw) async {
    var url = Uri.parse(
        "https://app.swaggerhub.com/apis-docs/gabojago/gabojago/1.0.0/user/login");

    Map data = {"username": username, "pw": pw};
    var body = json.encode(data);
    var response = await http.post(url,
        headers: {"Content-Type": "application/json"}, body: body);

    if (response.statusCode == 200) {
      setState(() {
        _errorMassage = "login success";
        _apiStatusCode = 200;
      });
    } else if (response.statusCode == 304) {
      setState(() {
        _errorMassage = "No Authentication";
        _apiStatusCode = 304;
      });
    }
  }

  Future<void> idLogOut(String username, String pw) async {
    var url = Uri.parse(
        "https://app.swaggerhub.com/apis-docs/gabojago/gabojago/1.0.0/user/logout");
    var response = await http.get(url);

    if (response.statusCode == 200) {
      setState(() {
        _errorMassage = "logout success";
        _apiStatusCode = 200;
      });
    } else if (response.statusCode == 304) {
      setState(() {
        _errorMassage = "No Authentication";
        _apiStatusCode = 304;
      });
    }
  }

  Future<void> checkUserPoint(String username) async {
    var url = Uri.parse(
        "https://app.swaggerhub.com/apis-docs/gabojago/gabojago/1.0.0/users/$username");
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var dataJsonUser = jsonDecode(response.body);
      var userPointData = dataJsonUser["point"];
      var userTierData = dataJsonUser["tier_id"];
      setState(() {
        String pointInfo = userPointData;
        String tierInfo = userTierData;
        _apiStatusCode = 200;
      });
    } else if (response.statusCode == 400) {
      setState(() {
        _errorMassage = "user do not exist";
        _apiStatusCode = 400;
      });
    } else if (response.statusCode == 400) {
      setState(() {
        _errorMassage = "server error";
        _apiStatusCode = 500;
      });
    }
  }

  Future<void> addUserPoint(String username, double point) async {
    var url = Uri.parse(
        "https://app.swaggerhub.com/apis-docs/gabojago/gabojago/1.0.0/user/$username/point");

    Map data = {"point": point};
    var body = json.encode(data);
    var response = await http.post(url,
        headers: {"Content-Type": "application/json"}, body: body);

    if (response.statusCode == 200) {
      setState(() {
        // point 정보 업데이트 success
        _apiStatusCode = 200;
      });
    }
  }
}

/*
Future<void> get190BusData() async {
  final Xml2Json xml2Json = Xml2Json();
  var _url =
      'http://apis.data.go.kr/6260000/BusanBIMS/busStopArrByBstopidLineid?serviceKey=%2BoLdAEy1lYzMNqpTpH608vmo3zRFriIQQxT8zryz1HVXCjYC%2FfKYrkiefaKwMOHGQ0hO0C8Fdg%2Bz2e20E82Rrw%3D%3D&lineid=5200190000&bstopid=167850202';
  var response2 = await http.get(Uri.parse(_url));

  if (response2.statusCode == 200) {
    xml2Json.parse(response2.body);
    var data190 = xml2Json.toParker();
    var dataJson190 = jsonDecode(data190); // string to json
    //print('$dataJson190');

  } else {
    //print('response status code = ${response2.statusCode}');
  }
}*/
