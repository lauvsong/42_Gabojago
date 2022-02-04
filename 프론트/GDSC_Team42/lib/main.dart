import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:beautifulsoup/beautifulsoup.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:convert';

GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['profile', 'email']);

class ReturnValue {
  String? returnID;
  String? returnPW;

  ReturnValue({this.returnID, this.returnPW});
}

class Arguments {
  String? sendID;
  String? sendPW;
  ReturnValue? returnValue;

  Arguments({this.sendID, this.sendPW, this.returnValue});
}

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _scanBarcode = 'Unknown';
  String _barcodeImg = 'Unknown';
  String userMail = '';
  String userIDCode = '';
  int _apiStatusCode = 200;
  String _errorMassage = '';
  double pointInfo = 0;
  String tierInfo = 'Unknown';
  bool isVisible = true;


  GoogleSignInAccount? _currentUser;

  @override
  void initState() {
    super.initState();
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      setState(() {
        _currentUser = account;
      });
    });
    _googleSignIn.signInSilently();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
      getBarcodePictureData();
    });
  }

  Future<void> getBarcodePictureData() async {
    int i, j;
    var _url =
        'http://www.koreannet.or.kr/home/hpisSrchGtin.gs1?gtin=$_scanBarcode';
    var response = await http.get(Uri.parse(_url));
    List<String> imageTable = [];
    List<String> imageTableLink = [];
    if (response.statusCode == 200) {
      var data = response.body;
      var soup = Beautifulsoup(data);
      var dataTable = soup.find_all("div").map((e) => (e.outerHtml)).toList();
      for (i = 0; i < dataTable.length; ++i) {
        var result = Beautifulsoup(dataTable[i]);
        if (result("div").attributes["class"] == "imgArea") {
          var barcodeImagesHtml = Beautifulsoup(result("div").outerHtml);
          var resultTable = barcodeImagesHtml
              .find_all("div")
              .map((e) => (e.outerHtml))
              .toList();
          for (j = 0; j < resultTable.length; ++j) {
            imageTableLink.add(Beautifulsoup(resultTable[j])("img")
                .attributes["src"]
                .toString());
          }
        }
      }
      setState(() {
        _barcodeImg = imageTableLink[0];
      });
      if (_scanBarcode != "Unknown" && _scanBarcode != "-1") {
        checkUserPoint(userMail);
        pointInfo = pointInfo + 1;
        addUserPoint(userMail, pointInfo);
      }
      print(imageTableLink);
    } else {
      print('response status code = ${response.statusCode}');
    }
  }

  Widget barcodeImageBox() {
    print(_barcodeImg);
    if (_barcodeImg != "Unknown" &&
        _barcodeImg != "/images/common/no_img.gif") {
      return SizedBox(
        width: 250,
        height: 160,
        child: Image.network(
          _barcodeImg,
        ),
      );
    } else {
      return Text("No Image Data");
    }
  }

  Widget barcodeResultBox() {
    if (_scanBarcode != "Unknown" && _scanBarcode != "-1") {
      return Container(
        color: Colors.white,
        height: 330,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(padding: EdgeInsets.all(5)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(padding: EdgeInsets.all(10)),
                Text("스캔 결과",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),
                Spacer(),
              ],
            ),
            Padding(padding: EdgeInsets.all(5)),
            Container(
              width: 300,
              height: 250,
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.only(
                left: 5,
                right: 5,
                top: 5,
                bottom: 5,
              ),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(18)),
                  boxShadow: [
                    BoxShadow(
                        color: Color(0x80cacaca),
                        offset: Offset(0, -1),
                        blurRadius: 10,
                        spreadRadius: 2)
                  ]),
              child: Container(
                padding: EdgeInsets.only(
                  left: 8,
                  right: 8,
                  top: 8,
                  bottom: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(18)),
                ),
                child: Column(
                  children: <Widget>[
                    Padding(padding: EdgeInsets.all(5)),
                    Text('코드번호 : $_scanBarcode\n',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[400])),
                    barcodeImageBox(),
                  ],
                ),
              ),
            ),
          ],
        )
      );
    } else {
      return Container();
    }
  }

  //google login
  Widget _buildLogInIcon() {
    GoogleSignInAccount? user = _currentUser;
    if (user != null) {
      return CupertinoButton(
        minSize: 0.0,
        padding: EdgeInsets.only(bottom: 10),
        onPressed: _handleSignOut,
        child: Container(
          color: Colors.white,
          width: 45,
          height: 45,
          child: GoogleUserCircleAvatar(
            identity: user,
          ),
        ),
      );
    } else {
      return CupertinoButton(
        minSize: 0.0,
        padding: EdgeInsets.only(bottom: 10),
        onPressed: _handleSignIn,
        child: Icon(CupertinoIcons.person, size: 50, color: Colors.grey),
      );
    }
  }

  Widget _buildRewordInfoBox(){
    if (userMail != "" ) {
      idResisterOrLogin(userMail, userIDCode);
      checkUserPoint(userMail);
    }
    return Column(
      children: <Widget>[
        Visibility(
          visible: !isVisible,
          child: Container(
            child: Column(
              children: <Widget>[
                Text("로그인하시면 당신의 등급과 그린포인트를 알수 있습니다"),
                ElevatedButton(
                  onPressed: _handleSignIn,
                  child: Text("로그인하기"),
                )
              ],
            ),
          ),
        ),
        Visibility(
          visible: isVisible,
          child: Container(
            child: Column(
              children: <Widget>[
                Text("당신의 그린포인트는 $pointInfo점 입니다."),
                Text("당신의 등급은 $tierInfo점 입니다."),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _handleSignIn() async {
    try {
      await _googleSignIn.signIn();
    } catch (error) {
      print(error);
    }
    GoogleSignInAccount? userInfo = _currentUser;
    setState(() {
      isVisible = true;
      if (userInfo != null) {
        userMail = userInfo.email;
        userIDCode = userInfo.id;
      }
    });
  }

  Future<void> _handleSignOut() async {
    _googleSignIn.disconnect();
    idLogOut();
    setState(() {
      isVisible = false;
      pointInfo = 0;
      tierInfo = 'Unknown';
    });
  }

  Future<void> idResisterOrLogin(String username, String pw) async {
    var url = Uri.parse(
        "https://app.swaggerhub.com/apis-docs/gabojago/gabojago/1.1.0/user/resister");

    Map data = {"username": username, "pw": pw};
    var body = json.encode(data);
    var response = await http.post(url,
        headers: {"Content-Type": "application/json"}, body: body);

    if (response.statusCode == 201) {
      setState(() {
        _errorMassage = "register success";
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
        "https://app.swaggerhub.com/apis-docs/gabojago/gabojago/1.1.0/user/login");

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

  Future<void> idLogOut() async {
    var url = Uri.parse(
        "https://app.swaggerhub.com/apis-docs/gabojago/gabojago/1.1.0/user/logout");
    var response = await http.get(url);

    if (response.statusCode == 200) {
      setState(() {
        _errorMassage = "logout success";
        _apiStatusCode = 200;
        pointInfo = 0;
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
        "https://app.swaggerhub.com/apis-docs/gabojago/gabojago/1.1.0/users/$username");
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var dataJsonUser = jsonDecode(response.body);
       var userPointData = dataJsonUser["point"];
       var userTierData = dataJsonUser["tier_id"];
      setState(() {
        pointInfo = userPointData;
        tierInfo = userTierData;
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
        "https://app.swaggerhub.com/apis-docs/gabojago/gabojago/1.1.0/user/$username/point");

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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
            appBar: AppBar(
              elevation: 0.0,
              backgroundColor: Colors.white,
              title: PreferredSize(
                preferredSize: Size.fromHeight(65),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        SizedBox(height: 15.0),
                        Text("녹색탐지기",
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.green[900])),
                      ],
                    ),
                    Spacer(),
                    Column(
                      children: <Widget>[
                        SizedBox(height: 20.0),
                        _buildLogInIcon(),
                      ],
                    ),
                  ],
                ),
              ),
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(45),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: TabBar(
                    tabs: [
                      Tab(child: Container(
                        child: Text("바코드 스캔",
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[500])),
                      ),),
                      Tab(child: Container(
                        child: Text("리워드",
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[500])),
                      ),),
                      Tab(child: Container(
                        child: Text("추천",
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[500])),
                      ),),
                    ],
                  ),
                ),
              ),
            ),
            body: TabBarView(
              children: [
                Builder(
                  builder: (BuildContext context) {
                    return ListView(
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 300,
                          color: Color(0xff03511b),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text("지금, 바코드를 스캔해보세요!",
                                  style:
                                  TextStyle(fontSize: 20, color: Colors.white)),
                              CupertinoButton(
                                minSize: 0.0,
                                padding: EdgeInsets.only(top: 20, bottom: 10),
                                onPressed: () => scanBarcodeNormal(),
                                child: Image.asset(
                                  "img/Cambutton.PNG",
                                  width: 100,
                                ),
                              ),
                              Text("Green Detector",
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.grey[600])),
                            ],
                          ),
                        ),
                        barcodeResultBox(),
                        Container(
                            color: Colors.white,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Padding(padding: EdgeInsets.all(10)),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Padding(padding: EdgeInsets.all(10)),
                                    Text("카테고리 랭킹",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black)),
                                    Spacer(),
                                    Text("더보기",
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey[400])),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      color: Colors.grey[400],
                                      size: 18,
                                    ),
                                    Padding(padding: EdgeInsets.all(10)),

                                  ],
                                ),
                                Padding(padding: EdgeInsets.all(8)),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    const Padding(padding: EdgeInsets.all(10)),
                                    Text("가전 / 테크",
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey[400])),
                                    const Spacer(),
                                    Text("옷",
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey[400])),
                                    const Spacer(),
                                    Text("가구",
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey[400])),
                                    const Spacer(),
                                    Text("생활 / 가공식품",
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey[400])),
                                    const Spacer(),
                                    Text("뷰티 / 미용",
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black)),
                                    const Spacer(),
                                    const Padding(padding: EdgeInsets.all(10)),
                                  ],
                                ),
                                const Padding(padding: EdgeInsets.all(10)),

                                Container(
                                  width: 360,
                                  height: 245,
                                  margin: EdgeInsets.all(1),
                                  padding:const  EdgeInsets.only(
                                    left: 1,
                                    right: 1,
                                    top: 1,
                                    bottom: 1,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                  ),
                                  child: Container(
                                    padding: const EdgeInsets.only(
                                      left: 8,
                                      right: 8,
                                      top: 8,
                                      bottom: 8,
                                    ),
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: <Widget>[
                                        const Spacer(),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Padding(padding: EdgeInsets.all(20)),
                                            Text("1",
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black)),
                                            SizedBox(width: 100.0),
                                            Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Text("네이쳐리퍼블릭",
                                                      style: TextStyle(
                                                          fontSize: 10,
                                                          color: Colors.grey[400])),
                                                  Text("클린 딥 클랜징",
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          color: Colors.black)),
                                                ]
                                            ),
                                            const Spacer(),
                                          ],
                                        ),
                                        const Spacer(),
                                        Divider(thickness: 1, color: Colors.grey[300],),
                                        const Spacer(),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Padding(padding: EdgeInsets.all(20)),
                                            Text("2",
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black)),
                                            SizedBox(width: 100.0),
                                            Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Text("베리썸",
                                                      style: TextStyle(
                                                          fontSize: 10,
                                                          color: Colors.grey[400])),
                                                  Text("리얼미 비오테놀 래쉬...",
                                                      overflow: TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          color: Colors.black)),
                                                ]
                                            ),
                                            const Spacer(),
                                          ],
                                        ),
                                        const Spacer(),
                                        Divider(thickness: 1, color: Colors.grey[300],),
                                        const Spacer(),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Padding(padding: EdgeInsets.all(20)),
                                            Text("3",
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black)),
                                            SizedBox(width: 100.0),
                                            Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Text("베리썸",
                                                      style: TextStyle(
                                                          fontSize: 10,
                                                          color: Colors.grey[400])),
                                                  Text("에코프랜들리 헤어 브...",
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          color: Colors.black)),
                                                ]
                                            ),
                                            const Spacer(),
                                          ],
                                        ),
                                        Spacer(),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(padding: EdgeInsets.all(20)),
                              ],
                            )
                        ),
                        Center(
                          child: Image.asset(
                            "img/rami.PNG",
                            width: MediaQuery.of(context).size.width,
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.width+20,
                          color: Colors.white,
                          child: Center(
                            child: Image.asset(
                              "img/whatcanwedo.PNG",
                              width: MediaQuery.of(context).size.width,
                            ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 80,
                          color: Colors.grey[100],
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              CupertinoButton(
                                minSize: 0.0,
                                padding: EdgeInsets.all(0),
                                onPressed: () {},
                                child: Row(
                                  children: <Widget>[
                                    Text("지금, 나의 환경등급 확인하러 가기",
                                        style:
                                        TextStyle(fontSize: 15, color: Colors.black)),
                                    Padding(padding: EdgeInsets.all(2)),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      color: Colors.blueGrey,
                                      size: 20,
                                    ),
                                    Padding(padding: EdgeInsets.all(7)),
                                  ],
                                ),

                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
                Builder(
                  builder: (BuildContext context) {
                    return ListView(
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 300,
                          color: Colors.yellow,
                          child: _buildRewordInfoBox(),

                        ),
                      ],
                    );
                  },
                ),
                Builder(
                  builder: (BuildContext context) {
                    return ListView(
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 300,
                          color: Color(0xff03511b),
                        ),
                      ],
                    );
                  },
                ),
              ],
            )
            /*Builder(
            builder: (BuildContext context) {
              return Container(
                alignment: Alignment.center,
                child: Flex(
                  direction: Axis.vertical,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _buildBody(),
                    Padding(padding: EdgeInsets.all(5)),
                    ElevatedButton(
                        onPressed: () => scanBarcodeNormal(),
                        child: Text('Start barcode scan')),
                    Text('Scan result : $_scanBarcode\n',
                        style: TextStyle(fontSize: 20)),
                    Padding(padding: EdgeInsets.all(5)),
                    barcodeImageBox(),
                  ],
                ),
              );
            },
          ),*/
            ),
      ),
    );
  }
}

