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

void main() => runApp(MaterialApp(
      title: "App",
      home: MyApp(),
    ));

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with TickerProviderStateMixin {
  String _scanBarcode = 'Unknown';
  String _barcodeImg = 'Unknown';
  String userMail = '';
  String userName = '';
  String userIDCode = '';
  int _apiStatusCode = 200;
  String _errorMassage = '';
  double pointInfo = 0;
  String tierInfo = 'Unknown';
  bool isVisible = false;
  List<String> itemNameList_CAT1 = [];
  List<String> itemCompanyNameList_CAT1 = [];
  List<String> itemBarcodeList_CAT1 = [];
  List<int> itemIDList_CAT1 = [];
  List<String> itemImageLink_CAT1 = ["", "", "", "", "", ""];

  List<String> itemNameList_CAT3 = [];
  List<String> itemCompanyNameList_CAT3 = [];
  List<String> itemBarcodeList_CAT3 = [];
  List<int> itemIDList_CAT3 = [];
  List<String> itemImageLink_CAT3 = ["", "", "", "", "", ""];

  List<String> itemNameList_CAT5 = [];
  List<String> itemCompanyNameList_CAT5 = [];
  List<String> itemBarcodeList_CAT5 = [];
  List<int> itemIDList_CAT5 = [];
  List<String> itemImageLink_CAT5 = ["", "", "", "", "", ""];

  late TabController _tabController1;
  late TabController _tabController2;
  late TabController _tabController3;
  List<String> barcodeImg = ["", "", "", "", "", ""];

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
    getProductData();
    getProductDataByCAT(1);
    getProductDataByCAT(3);
    getProductDataByCAT(5);

    print("아아아아아아${itemImageLink_CAT5[1]}");

    _tabController1 = TabController(
      length: 3,
      vsync: this,
    );
    _tabController2 = TabController(
      length: 3,
      vsync: this,
    );
    _tabController3 = TabController(
      length: 3,
      vsync: this,
    );
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
        getProductDataByBarcode(_scanBarcode);
        if (_apiStatusCode==200) {
          checkUserPoint(userMail);
          pointInfo = pointInfo + 30;
          addUserPoint(userMail, pointInfo);
        }else /*if (_apiStatusCode==405)*/ {
          checkUserPoint(userMail);
          pointInfo = pointInfo + 1;
          addUserPoint(userMail, pointInfo);
        }
      }
      print(imageTableLink);
    } else {
      print('response status code = ${response.statusCode}');
    }
  }


  Widget itemImageBox(String imgLink) {
    print(imgLink);
    if (imgLink != "Unknown" && imgLink != "" && imgLink != null &&
        imgLink != "/images/common/no_img.gif") {
      return Image.network(
        imgLink,
      );
    } else {
      return Center(child: Text("No Image Data"));
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
                      SizedBox(
                          width: 250, height: 160, child: itemImageBox(_barcodeImg)),
                    ],
                  ),
                ),
              ),
            ],
          ));
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
        child: Icon(CupertinoIcons.person, size: 40, color: Colors.grey),
      );
    }
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
    if (userMail != "") {
      idResisterOrLogin(userMail, userIDCode);
      checkUserPoint(userMail);
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Visibility(
          visible: !isVisible,
          child: Container(
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                      color: Colors.white, shape: BoxShape.circle),
                ),
                Padding(padding: EdgeInsets.all(5)),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("로그인하시면",
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                    Text("당신의 등급을 알수 있습니다",
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                    ElevatedButton(
                      onPressed: _handleSignIn,
                      child: Text("로그인하기"),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
        Visibility(
          visible: isVisible,
          child: Container(
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
                      ElevatedButton(
                        onPressed: () {
                          _handleSignOut();
                        },
                        child: Text("로그아웃"),
                      )
                    ],
                  ),
                ],
              ),
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
        userName = userInfo.displayName ?? '';
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
    var url = Uri.parse("http://d522-1-231-133-115.ngrok.io/user/register");

    Map data = {"username": username, "pw": pw};
    var body = json.encode(data);
    var response = await http.post(url,
        headers: {"Content-Type": "application/json"}, body: body);

    if (response.statusCode == 201) {
      setState(() {
        _errorMassage = "register success";
        _apiStatusCode = 201;
        print(_errorMassage);
      });
    } else if (response.statusCode == 304) {
      setState(() {
        _errorMassage = "userid already exist";
        _apiStatusCode = 304;
        idLogIn(username, pw);
        print(_errorMassage);
      });
    }
  }

  Future<void> idLogIn(String username, String pw) async {
    var url = Uri.parse("http://d522-1-231-133-115.ngrok.io/user/login");

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
    var url = Uri.parse("http://d522-1-231-133-115.ngrok.io/user/logout");
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

  Future<void> getProductData() async {
    int i;
    setState(() {});

    var url = Uri.parse("http://d522-1-231-133-115.ngrok.io/products/rank");
    var response = await http.get(url);
    print("아아아_________________");
    if (response.statusCode == 200) {
      var dataJsonProductList = jsonDecode(response.body);
      var firstProductName = dataJsonProductList[1]["name"];
      var firstProductCat = dataJsonProductList[0]["category_name"];
      var firstProductID = dataJsonProductList[0]["id"];
      var firstProductCompanyName = dataJsonProductList[0]["info"]["company"];
      print("아아아_________________$firstProductName");
      print("아아아_________________$firstProductCompanyName");

      for (i = 0; i < dataJsonProductList.length; ++i) {
        setState(() {});
      }
    }
  }

  Future<void> getProductDataByCAT(int CatNum) async {
    int i;
    if (CatNum == 1) {
      setState(() {
        itemNameList_CAT1 = [];
        itemCompanyNameList_CAT1 = [];
        itemIDList_CAT1 = [];
        itemBarcodeList_CAT1 = [];
      });
    } else if (CatNum == 3) {
      setState(() {
        itemNameList_CAT3 = [];
        itemCompanyNameList_CAT3 = [];
        itemIDList_CAT3 = [];
        itemBarcodeList_CAT3 = [];
      });
    } else if (CatNum == 5) {
      setState(() {
        itemNameList_CAT5 = [];
        itemCompanyNameList_CAT5 = [];
        itemIDList_CAT5 = [];
        itemBarcodeList_CAT5 = [];
      });
    }
    var url = Uri.parse(
        "http://d522-1-231-133-115.ngrok.io/products/category/$CatNum");
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var dataJsonProductList = jsonDecode(response.body);
      var firstProductName = dataJsonProductList[0]["name"];
      var firstProductCompanyName = dataJsonProductList[0]["info"]["company"];

      for (i = 0; i < dataJsonProductList.length; ++i) {
        if (CatNum == 1) {
          setState(() {
            itemNameList_CAT1.add(dataJsonProductList[i]["name"]);
            itemCompanyNameList_CAT1
                .add(dataJsonProductList[i]["info"]["company"]);
            itemIDList_CAT1.add(dataJsonProductList[i]["id"]);
            itemBarcodeList_CAT1.add(dataJsonProductList[i]["barcode"]);
            itemImageLink_CAT1[i] = (dataJsonProductList[i]["info"]["image"]);
          });
        } else if (CatNum == 3) {
          setState(() {
            itemNameList_CAT3.add(dataJsonProductList[i]["name"]);
            itemCompanyNameList_CAT3
                .add(dataJsonProductList[i]["info"]["company"]);
            itemIDList_CAT3.add(dataJsonProductList[i]["id"]);
            itemBarcodeList_CAT3.add(dataJsonProductList[i]["barcode"]);
            itemImageLink_CAT3[i] = (dataJsonProductList[i]["info"]["image"]);
          });
        }
        if (CatNum == 5) {
          setState(() {
            itemNameList_CAT5.add(dataJsonProductList[i]["name"]);
            itemCompanyNameList_CAT5
                .add(dataJsonProductList[i]["info"]["company"]);
            itemIDList_CAT5.add(dataJsonProductList[i]["id"]);
            itemBarcodeList_CAT5.add(dataJsonProductList[i]["barcode"]);
            itemImageLink_CAT5[i] = (dataJsonProductList[i]["info"]["image"]);

          });
        }
      }
    }
  }

  Future<void> getProductDataByBarcode(String BarcodeNum) async {
    var url = Uri.parse(
        "http://d522-1-231-133-115.ngrok.io/products/barcode/$BarcodeNum");
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var dataJsonProductList = jsonDecode(response.body);
      var firstProductName = dataJsonProductList["name"];
      var firstProductCompanyName = dataJsonProductList["info"]["company"];
      _apiStatusCode=response.statusCode;
    }else if(response.statusCode == 405){
      _apiStatusCode=response.statusCode;
    }
  }

  Future<void> getFavoriteProductData(String username) async {
    var url = Uri.parse(
        "http://d522-1-231-133-115.ngrok.io/user/$username/favorites");
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var dataJsonProductList = jsonDecode(response.body);
      var firstProductName = dataJsonProductList[0]["name"];
      var firstProductCat = dataJsonProductList[0]["category_name"];
      var firstProductCompanyName = dataJsonProductList[0]["info"]["company"];
    }
  }

  Future<void> getFavoriteProductDataWithCat(
      String username, int CatNum) async {
    var url = Uri.parse(
        "http://d522-1-231-133-115.ngrok.io/user/$username/favorites/groups");
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var dataJsonProductList = jsonDecode(response.body);
      var firstProductName = dataJsonProductList[0]["data"][0]["name"];
      var firstProductCat = dataJsonProductList[0]["data"][0]["category_name"];
      var firstProductCompanyName =
          dataJsonProductList[0]["data"][0]["info"]["company"];
    }
  }

  Future<void> addFavoriteProductData(
      String username, String product_id) async {
    var url = Uri.parse(
        "http://d522-1-231-133-115.ngrok.io/user/$username/favorites");

    Map data = {"product_id": product_id};
    var body = json.encode(data);
    var response = await http.post(url,
        headers: {"Content-Type": "application/json"}, body: body);
  }

  Future<void> deleteFavoriteProductData(
      String username, String product_id) async {
    var url = Uri.parse(
        "http://d522-1-231-133-115.ngrok.io/user/$username/favorites");

    var response = await http.delete(
      url,
    );
  }

  Future<void> checkUserPoint(String username) async {
    var url = Uri.parse("http://d522-1-231-133-115.ngrok.io/users/$username");
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var dataJsonUser = jsonDecode(response.body);
      var userPointData = dataJsonUser["point"];
      var userTierData = dataJsonUser["tier_id"];
      print("__아아아아아아$userPointData");

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
    var url =
        Uri.parse("http://d522-1-231-133-115.ngrok.io/user/$username/point");

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
      home: Scaffold(
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
              child: Container(
                width: 268,
                child: TabBar(
                  controller: _tabController1,
                  tabs: [
                    Tab(
                      child: Container(
                        child: Text("바코드 스캔",
                            style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[500])),
                      ),
                    ),
                    Tab(
                      child: Container(
                        child: Text("랭크",
                            style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[500])),
                      ),
                    ),
                    Tab(
                      child: Container(
                        child: Text("추천",
                            style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[500])),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        body: TabBarView(
          controller: _tabController1,
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
                                CupertinoButton(
                                  minSize: 0.0,
                                  padding: EdgeInsets.only(bottom: 0),
                                  onPressed: () {},
                                  child: Row(
                                    children: <Widget>[
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
                                    ],
                                  ),
                                ),
                                Padding(padding: EdgeInsets.all(10)),
                              ],
                            ),
                            Padding(padding: EdgeInsets.all(8)),
                            TabBar(
                              controller: _tabController2,
                              tabs: [
                                //3
                                Tab(
                                  child: Container(
                                    child: Text("생활용품",
                                        style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey[500])),
                                  ),
                                ),
                                //5
                                Tab(
                                  child: Container(
                                    child: Text("식가공품",
                                        style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey[500])),
                                  ),
                                ),
                                //1
                                Tab(
                                  child: Container(
                                    child: Text("기타",
                                        style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey[500])),
                                  ),
                                ),
                              ],
                            ),
                            const Padding(padding: EdgeInsets.all(10)),
                            Container(
                              width: 370,
                              height: 300,
                              child: TabBarView(
                                  controller: _tabController2,
                                  children: [
                                    Container(
                                      width: 360,
                                      height: 245,
                                      margin: EdgeInsets.all(1),
                                      padding: const EdgeInsets.only(
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            const Spacer(),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Padding(
                                                    padding:
                                                        EdgeInsets.all(20)),
                                                Text("1",
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black)),
                                                Padding(
                                                    padding: EdgeInsets.all(7)),
                                                SizedBox(
                                                  width: 100.0, height:80,
                                                  child: itemImageBox(itemImageLink_CAT3[0]),
                                                ),
                                                Container(
                                                  width: 180,
                                                  child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Text(
                                                            "${itemCompanyNameList_CAT3[0]}",
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                                fontSize: 10,
                                                                color:
                                                                    Colors.grey[
                                                                        400])),
                                                        Text(
                                                            "${itemNameList_CAT3[0]}",
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                                fontSize: 15,
                                                                color: Colors
                                                                    .black)),
                                                      ]),
                                                ),
                                                const Spacer(),
                                              ],
                                            ),
                                            const Spacer(),
                                            Divider(
                                              thickness: 1,
                                              color: Colors.grey[300],
                                            ),
                                            const Spacer(),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Padding(
                                                    padding:
                                                        EdgeInsets.all(20)),
                                                Text("2",
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black)),
                                                Padding(
                                                    padding: EdgeInsets.all(7)),
                                                SizedBox(
                                                  width: 100.0, height:80,
                                                  child: itemImageBox(itemImageLink_CAT3[1]),
                                                ),
                                                Container(
                                                  width: 180,
                                                  child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Text(
                                                            "${itemCompanyNameList_CAT3[1]}",
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                                fontSize: 10,
                                                                color:
                                                                    Colors.grey[
                                                                        400])),
                                                        Text(
                                                            "${itemNameList_CAT3[1]}",
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                                fontSize: 15,
                                                                color: Colors
                                                                    .black)),
                                                      ]),
                                                ),
                                                const Spacer(),
                                              ],
                                            ),
                                            const Spacer(),
                                            Divider(
                                              thickness: 1,
                                              color: Colors.grey[300],
                                            ),
                                            const Spacer(),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Padding(
                                                    padding:
                                                        EdgeInsets.all(20)),
                                                Text("3",
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black)),
                                                Padding(
                                                    padding: EdgeInsets.all(7)),
                                                SizedBox(
                                                  width: 100.0, height:80,
                                                  child: itemImageBox(itemImageLink_CAT3[2]),
                                                ),
                                                Container(
                                                  width: 180,
                                                  child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Text(
                                                            "${itemCompanyNameList_CAT3[2]}",
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                                fontSize: 10,
                                                                color:
                                                                    Colors.grey[
                                                                        400])),
                                                        Text(
                                                            "${itemNameList_CAT3[2]}",
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                                fontSize: 15,
                                                                color: Colors
                                                                    .black)),
                                                      ]),
                                                ),
                                                const Spacer(),
                                              ],
                                            ),
                                            Spacer(),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 360,
                                      height: 245,
                                      margin: EdgeInsets.all(1),
                                      padding: const EdgeInsets.only(
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            const Spacer(),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Padding(
                                                    padding:
                                                        EdgeInsets.all(20)),
                                                Text("1",
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black)),
                                                Padding(
                                                    padding: EdgeInsets.all(7)),
                                                SizedBox(
                                                  width: 100.0, height:80,
                                                  child: itemImageBox(itemImageLink_CAT5[0]),
                                                ),
                                                Container(
                                                  width: 180,
                                                  child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Text(
                                                            "${itemCompanyNameList_CAT5[0]}",
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                                fontSize: 10,
                                                                color:
                                                                    Colors.grey[
                                                                        400])),
                                                        Text(
                                                            "${itemNameList_CAT5[0]}",
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                                fontSize: 15,
                                                                color: Colors
                                                                    .black)),
                                                      ]),
                                                ),
                                                const Spacer(),
                                              ],
                                            ),
                                            const Spacer(),
                                            Divider(
                                              thickness: 1,
                                              color: Colors.grey[300],
                                            ),
                                            const Spacer(),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Padding(
                                                    padding:
                                                        EdgeInsets.all(20)),
                                                Text("2",
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black)),
                                                Padding(
                                                    padding: EdgeInsets.all(7)),
                                                SizedBox(
                                                  width: 100.0, height:80,
                                                  child: itemImageBox(itemImageLink_CAT5[1]),
                                                ),
                                                Container(
                                                  width: 180,
                                                  child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Text(
                                                            "${itemCompanyNameList_CAT5[1]}",
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                                fontSize: 10,
                                                                color:
                                                                    Colors.grey[
                                                                        400])),
                                                        Text(
                                                            "${itemNameList_CAT5[1]}",
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                                fontSize: 15,
                                                                color: Colors
                                                                    .black)),
                                                      ]),
                                                ),
                                                const Spacer(),
                                              ],
                                            ),
                                            const Spacer(),
                                            Divider(
                                              thickness: 1,
                                              color: Colors.grey[300],
                                            ),
                                            const Spacer(),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Padding(
                                                    padding:
                                                        EdgeInsets.all(20)),
                                                Text("3",
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black)),
                                                Padding(
                                                    padding: EdgeInsets.all(7)),
                                                SizedBox(
                                                  width: 100.0, height:80,
                                                  child: itemImageBox(itemImageLink_CAT5[2]),
                                                ),
                                                Container(
                                                  width: 180,
                                                  child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Text(
                                                            "${itemCompanyNameList_CAT5[2]}",
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                                fontSize: 10,
                                                                color:
                                                                    Colors.grey[
                                                                        400])),
                                                        Text(
                                                            "${itemNameList_CAT5[2]}",
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                                fontSize: 15,
                                                                color: Colors
                                                                    .black)),
                                                      ]),
                                                ),
                                                const Spacer(),
                                              ],
                                            ),
                                            Spacer(),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 360,
                                      height: 245,
                                      margin: EdgeInsets.all(1),
                                      padding: const EdgeInsets.only(
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
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                          children: <Widget>[
                                            const Spacer(),
                                            Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.start,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Padding(
                                                    padding:
                                                    EdgeInsets.all(20)),
                                                Text("1",
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                        FontWeight.bold,
                                                        color: Colors.black)),
                                                Padding(
                                                    padding: EdgeInsets.all(7)),
                                                SizedBox(
                                                  width: 100.0, height:80,
                                                  child: itemImageBox(itemImageLink_CAT1[0]),
                                                ),
                                                Container(
                                                  width: 180,
                                                  child: Column(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .center,
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .start,
                                                      children: <Widget>[
                                                        Text(
                                                            "${itemCompanyNameList_CAT1[0]}",
                                                            overflow:
                                                            TextOverflow
                                                                .ellipsis,
                                                            style: TextStyle(
                                                                fontSize: 10,
                                                                color:
                                                                Colors.grey[
                                                                400])),
                                                        Text(
                                                            "${itemNameList_CAT1[0]}",
                                                            overflow:
                                                            TextOverflow
                                                                .ellipsis,
                                                            style: TextStyle(
                                                                fontSize: 15,
                                                                color: Colors
                                                                    .black)),
                                                      ]),
                                                ),
                                                const Spacer(),
                                              ],
                                            ),
                                            const Spacer(),
                                            Divider(
                                              thickness: 1,
                                              color: Colors.grey[300],
                                            ),
                                            const Spacer(),
                                            Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.start,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Padding(
                                                    padding:
                                                    EdgeInsets.all(20)),
                                                Text("2",
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                        FontWeight.bold,
                                                        color: Colors.black)),
                                                Padding(
                                                    padding: EdgeInsets.all(7)),
                                                SizedBox(
                                                  width: 100.0, height:80,
                                                  child: itemImageBox(itemImageLink_CAT1[1]),
                                                ),
                                                Container(
                                                  width: 180,
                                                  child: Column(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .center,
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .start,
                                                      children: <Widget>[
                                                        Text(
                                                            "${itemCompanyNameList_CAT1[1]}",
                                                            overflow:
                                                            TextOverflow
                                                                .ellipsis,
                                                            style: TextStyle(
                                                                fontSize: 10,
                                                                color:
                                                                Colors.grey[
                                                                400])),
                                                        Text(
                                                            "${itemNameList_CAT1[1]}",
                                                            overflow:
                                                            TextOverflow
                                                                .ellipsis,
                                                            style: TextStyle(
                                                                fontSize: 15,
                                                                color: Colors
                                                                    .black)),
                                                      ]),
                                                ),
                                                const Spacer(),
                                              ],
                                            ),
                                            const Spacer(),
                                            Divider(
                                              thickness: 1,
                                              color: Colors.grey[300],
                                            ),
                                            const Spacer(),
                                            Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.start,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Padding(
                                                    padding:
                                                    EdgeInsets.all(20)),
                                                Text("3",
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                        FontWeight.bold,
                                                        color: Colors.black)),
                                                Padding(
                                                    padding: EdgeInsets.all(7)),
                                                SizedBox(
                                                  width: 100.0, height:80,
                                                  child: itemImageBox(itemImageLink_CAT1[2]),
                                                ),
                                                Container(
                                                  width: 180,
                                                  child: Column(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .center,
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .start,
                                                      children: <Widget>[
                                                        Text(
                                                            "${itemCompanyNameList_CAT1[2]}",
                                                            overflow:
                                                            TextOverflow
                                                                .ellipsis,
                                                            style: TextStyle(
                                                                fontSize: 10,
                                                                color:
                                                                Colors.grey[
                                                                400])),
                                                        Text(
                                                            "${itemNameList_CAT1[2]}",
                                                            overflow:
                                                            TextOverflow
                                                                .ellipsis,
                                                            style: TextStyle(
                                                                fontSize: 15,
                                                                color: Colors
                                                                    .black)),
                                                      ]),
                                                ),
                                                const Spacer(),
                                              ],
                                            ),
                                            Spacer(),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ]),
                            ),
                            Padding(padding: EdgeInsets.all(20)),
                          ],
                        )),
                    Center(
                      child: Image.asset(
                        "img/rami.PNG",
                        width: MediaQuery.of(context).size.width,
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.width + 20,
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
                                    style: TextStyle(
                                        fontSize: 15, color: Colors.black)),
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
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 130,
                      color: Color(0xff03511b),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text("녹색탐지기",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                          Text("copyright (c) green_dectorer",
                              style:
                                  TextStyle(fontSize: 15, color: Colors.grey)),
                          Text("all rights reserved",
                              style:
                                  TextStyle(fontSize: 15, color: Colors.grey)),
                          const Padding(padding: EdgeInsets.all(5)),
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
                      height: 200,
                      color: Color(0xff03511b),
                      child: Center(child: _buildRewordInfoBox()),
                    ),
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
                                Text("랭크",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black)),
                                Spacer(),
                              ],
                            ),
                            const Padding(padding: EdgeInsets.all(20)),
                            Container(
                              width: 320,
                              height: 700,
                              margin: EdgeInsets.all(0),
                              padding: const EdgeInsets.only(
                                left: 1,
                                right: 1,
                                top: 1,
                                bottom: 1,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Padding(padding: EdgeInsets.all(5)),
                                      Image.asset(
                                        "img/seed.png",
                                        width: 40,
                                      ),
                                      Padding(padding: EdgeInsets.all(10)),
                                      Container(
                                        width: 60,
                                        child: Text("seed",
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.black)),
                                      ),
                                      const Spacer(),
                                      Text("녹색포인트 50점이하",
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey)),
                                      const Spacer(),
                                    ],
                                  ),
                                  const Padding(padding: EdgeInsets.all(5)),
                                  Divider(
                                    thickness: 1,
                                    color: Colors.grey[300],
                                  ),
                                  const Padding(padding: EdgeInsets.all(5)),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Padding(padding: EdgeInsets.all(5)),
                                      Image.asset(
                                        "img/sprout.png",
                                        width: 40,
                                      ),
                                      Padding(padding: EdgeInsets.all(10)),
                                      Container(
                                        width: 60,
                                        child: Text("sprout",
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.black)),
                                      ),
                                      const Spacer(),
                                      Text("녹색포인트 50점이상",
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey)),
                                      const Spacer(),
                                    ],
                                  ),
                                  const Padding(padding: EdgeInsets.all(5)),
                                  Divider(
                                    thickness: 1,
                                    color: Colors.grey[300],
                                  ),
                                  const Padding(padding: EdgeInsets.all(5)),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Padding(padding: EdgeInsets.all(5)),
                                      Image.asset(
                                        "img/leaf.png",
                                        width: 40,
                                      ),
                                      Padding(padding: EdgeInsets.all(10)),
                                      Container(
                                        width: 60,
                                        child: Text("leaf",
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.black)),
                                      ),
                                      const Spacer(),
                                      Text("녹색포인트 100점이상",
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey)),
                                      const Spacer(),
                                    ],
                                  ),
                                  const Padding(padding: EdgeInsets.all(5)),
                                  Divider(
                                    thickness: 1,
                                    color: Colors.grey[300],
                                  ),
                                  const Padding(padding: EdgeInsets.all(5)),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Padding(padding: EdgeInsets.all(5)),
                                      Image.asset(
                                        "img/grass.png",
                                        width: 40,
                                      ),
                                      Padding(padding: EdgeInsets.all(10)),
                                      Container(
                                        width: 60,
                                        child: Text("grass",
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.black)),
                                      ),
                                      const Spacer(),
                                      Text("녹색포인트 150점이상",
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey)),
                                      const Spacer(),
                                    ],
                                  ),
                                  const Padding(padding: EdgeInsets.all(5)),
                                  Divider(
                                    thickness: 1,
                                    color: Colors.grey[300],
                                  ),
                                  const Padding(padding: EdgeInsets.all(5)),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Padding(padding: EdgeInsets.all(5)),
                                      Image.asset(
                                        "img/tree.png",
                                        width: 40,
                                      ),
                                      Padding(padding: EdgeInsets.all(10)),
                                      Container(
                                        width: 60,
                                        child: Text("tree",
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.black)),
                                      ),
                                      const Spacer(),
                                      Text("녹색포인트 200점이상",
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey)),
                                      const Spacer(),
                                    ],
                                  ),
                                  const Padding(padding: EdgeInsets.all(5)),
                                  Divider(
                                    thickness: 1,
                                    color: Colors.grey[300],
                                  ),
                                  const Padding(padding: EdgeInsets.all(5)),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Padding(padding: EdgeInsets.all(5)),
                                      Image.asset(
                                        "img/forest.png",
                                        width: 40,
                                      ),
                                      Padding(padding: EdgeInsets.all(10)),
                                      Container(
                                        width: 60,
                                        child: Text("forest",
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.black)),
                                      ),
                                      const Spacer(),
                                      Text("녹색포인트 250점이상",
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey)),
                                      const Spacer(),
                                    ],
                                  ),
                                  const Padding(padding: EdgeInsets.all(40)),
                                  Container(
                                    width: 300,
                                    height: 20,
                                    alignment: Alignment.center,
                                    child: Text("환경제품 스캔으로 점수를 올릴 수 있습니다!",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black)),
                                  )
                                ],
                              ),
                            ),
                            Padding(padding: EdgeInsets.all(20)),
                          ],
                        )),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 130,
                      color: Colors.grey[100],
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text("녹색탐지기",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff03511b))),
                          Text("copyright (c) green_dectorer",
                              style:
                                  TextStyle(fontSize: 15, color: Colors.grey)),
                          Text("all rights reserved",
                              style:
                                  TextStyle(fontSize: 15, color: Colors.grey)),
                          const Padding(padding: EdgeInsets.all(5)),
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
                                Padding(padding: EdgeInsets.all(10)),
                              ],
                            ),
                            Padding(padding: EdgeInsets.all(8)),
                            TabBar(
                              controller: _tabController3,
                              tabs: [
                                //3
                                Tab(
                                  child: Container(
                                    child: Text("생활용품",
                                        style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey[500])),
                                  ),
                                ),
                                //5
                                Tab(
                                  child: Container(
                                    child: Text("식가공품",
                                        style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey[500])),
                                  ),
                                ),
                                //1
                                Tab(
                                  child: Container(
                                    child: Text("기타",
                                        style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey[500])),
                                  ),
                                ),
                              ],
                            ),
                            const Padding(padding: EdgeInsets.all(10)),
                            Container(
                              width: 370,
                              height: 600,
                              child: TabBarView(
                                  controller: _tabController3,
                                  children: [
                                    Container(
                                      width: 360,
                                      height: 245,
                                      margin: EdgeInsets.all(1),
                                      padding: const EdgeInsets.only(
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            const Spacer(),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Padding(
                                                    padding:
                                                        EdgeInsets.all(20)),
                                                Text("1",
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black)),
                                                Padding(
                                                    padding: EdgeInsets.all(7)),
                                                SizedBox(
                                                  width: 100.0, height:80,
                                                  child: itemImageBox(itemImageLink_CAT3[0]),
                                                ),
                                                Container(
                                                  width: 180,
                                                  child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Text(
                                                            "${itemCompanyNameList_CAT3[0]}",
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                                fontSize: 10,
                                                                color:
                                                                    Colors.grey[
                                                                        400])),
                                                        Text(
                                                            "${itemNameList_CAT3[0]}",
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                                fontSize: 15,
                                                                color: Colors
                                                                    .black)),
                                                      ]),
                                                ),
                                                const Spacer(),
                                              ],
                                            ),
                                            const Spacer(),
                                            Divider(
                                              thickness: 1,
                                              color: Colors.grey[300],
                                            ),
                                            const Spacer(),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Padding(
                                                    padding:
                                                        EdgeInsets.all(20)),
                                                Text("2",
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black)),
                                                Padding(
                                                    padding: EdgeInsets.all(7)),
                                                SizedBox(
                                                  width: 100.0, height:80,
                                                  child: itemImageBox(itemImageLink_CAT3[1]),
                                                ),
                                                Container(
                                                  width: 180,
                                                  child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Text(
                                                            "${itemCompanyNameList_CAT3[1]}",
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                                fontSize: 10,
                                                                color:
                                                                    Colors.grey[
                                                                        400])),
                                                        Text(
                                                            "${itemNameList_CAT3[1]}",
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                                fontSize: 15,
                                                                color: Colors
                                                                    .black)),
                                                      ]),
                                                ),
                                                const Spacer(),
                                              ],
                                            ),
                                            const Spacer(),
                                            Divider(
                                              thickness: 1,
                                              color: Colors.grey[300],
                                            ),
                                            const Spacer(),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Padding(
                                                    padding:
                                                        EdgeInsets.all(20)),
                                                Text("3",
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black)),
                                                Padding(
                                                    padding: EdgeInsets.all(7)),
                                                SizedBox(
                                                  width: 100.0, height:80,
                                                  child: itemImageBox(itemImageLink_CAT3[2]),
                                                ),
                                                Container(
                                                  width: 180,
                                                  child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Text(
                                                            "${itemCompanyNameList_CAT3[2]}",
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                                fontSize: 10,
                                                                color:
                                                                    Colors.grey[
                                                                        400])),
                                                        Text(
                                                            "${itemNameList_CAT3[2]}",
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                                fontSize: 15,
                                                                color: Colors
                                                                    .black)),
                                                      ]),
                                                ),
                                                const Spacer(),
                                              ],
                                            ),
                                            const Spacer(),
                                            Divider(
                                              thickness: 1,
                                              color: Colors.grey[300],
                                            ),
                                            const Spacer(),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Padding(
                                                    padding:
                                                        EdgeInsets.all(20)),
                                                Text("4",
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black)),
                                                Padding(
                                                    padding: EdgeInsets.all(7)),
                                                SizedBox(
                                                  width: 100.0, height:80,
                                                  child: itemImageBox(itemImageLink_CAT3[3]),
                                                ),
                                                Container(
                                                  width: 180,
                                                  child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Text(
                                                            "${itemCompanyNameList_CAT3[3]}",
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                                fontSize: 10,
                                                                color:
                                                                    Colors.grey[
                                                                        400])),
                                                        Text(
                                                            "${itemNameList_CAT3[3]}",
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                                fontSize: 15,
                                                                color: Colors
                                                                    .black)),
                                                      ]),
                                                ),
                                                const Spacer(),
                                              ],
                                            ),
                                            const Spacer(),
                                            Divider(
                                              thickness: 1,
                                              color: Colors.grey[300],
                                            ),
                                            const Spacer(),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Padding(
                                                    padding:
                                                        EdgeInsets.all(20)),
                                                Text("5",
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black)),
                                                Padding(
                                                    padding: EdgeInsets.all(7)),
                                                SizedBox(
                                                  width: 100.0, height:80,
                                                  child: itemImageBox(itemImageLink_CAT3[4]),
                                                ),
                                                Container(
                                                  width: 180,
                                                  child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Text(
                                                            "${itemCompanyNameList_CAT3[4]}",
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                                fontSize: 10,
                                                                color:
                                                                    Colors.grey[
                                                                        400])),
                                                        Text(
                                                            "${itemNameList_CAT3[4]}",
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                                fontSize: 15,
                                                                color: Colors
                                                                    .black)),
                                                      ]),
                                                ),
                                                const Spacer(),
                                              ],
                                            ),
                                            Spacer(),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 360,
                                      height: 245,
                                      margin: EdgeInsets.all(1),
                                      padding: const EdgeInsets.only(
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            const Spacer(),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Padding(
                                                    padding:
                                                        EdgeInsets.all(20)),
                                                Text("1",
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black)),
                                                Padding(
                                                    padding: EdgeInsets.all(7)),
                                                SizedBox(
                                                  width: 100.0, height:80,
                                                  child: itemImageBox(itemImageLink_CAT5[0]),
                                                ),
                                                Container(
                                                  width: 180,
                                                  child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Text(
                                                            "${itemCompanyNameList_CAT5[0]}",
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                                fontSize: 10,
                                                                color:
                                                                    Colors.grey[
                                                                        400])),
                                                        Text(
                                                            "${itemNameList_CAT5[0]}",
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                                fontSize: 15,
                                                                color: Colors
                                                                    .black)),
                                                      ]),
                                                ),
                                                const Spacer(),
                                              ],
                                            ),
                                            const Spacer(),
                                            Divider(
                                              thickness: 1,
                                              color: Colors.grey[300],
                                            ),
                                            const Spacer(),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Padding(
                                                    padding:
                                                        EdgeInsets.all(20)),
                                                Text("2",
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black)),
                                                Padding(
                                                    padding: EdgeInsets.all(7)),
                                                SizedBox(
                                                  width: 100.0, height:80,
                                                  child: itemImageBox(itemImageLink_CAT5[1]),
                                                ),
                                                Container(
                                                  width: 180,
                                                  child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Text(
                                                            "${itemCompanyNameList_CAT5[1]}",
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                                fontSize: 10,
                                                                color:
                                                                    Colors.grey[
                                                                        400])),
                                                        Text(
                                                            "${itemNameList_CAT5[1]}",
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                                fontSize: 15,
                                                                color: Colors
                                                                    .black)),
                                                      ]),
                                                ),
                                                const Spacer(),
                                              ],
                                            ),
                                            const Spacer(),
                                            Divider(
                                              thickness: 1,
                                              color: Colors.grey[300],
                                            ),
                                            const Spacer(),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Padding(
                                                    padding:
                                                        EdgeInsets.all(20)),
                                                Text("3",
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black)),
                                                Padding(
                                                    padding: EdgeInsets.all(7)),
                                                SizedBox(
                                                  width: 100.0, height:80,
                                                  child: itemImageBox(itemImageLink_CAT5[2]),
                                                ),
                                                Container(
                                                  width: 180,
                                                  child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Text(
                                                            "${itemCompanyNameList_CAT5[2]}",
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                                fontSize: 10,
                                                                color:
                                                                    Colors.grey[
                                                                        400])),
                                                        Text(
                                                            "${itemNameList_CAT5[2]}",
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                                fontSize: 15,
                                                                color: Colors
                                                                    .black)),
                                                      ]),
                                                ),
                                                const Spacer(),
                                              ],
                                            ),
                                            const Spacer(),
                                            Divider(
                                              thickness: 1,
                                              color: Colors.grey[300],
                                            ),
                                            const Spacer(),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Padding(
                                                    padding:
                                                        EdgeInsets.all(20)),
                                                Text("4",
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black)),
                                                Padding(
                                                    padding: EdgeInsets.all(7)),
                                                SizedBox(
                                                  width: 100.0, height:80,
                                                  child: itemImageBox(itemImageLink_CAT5[3]),
                                                ),
                                                Container(
                                                  width: 180,
                                                  child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Text(
                                                            "${itemCompanyNameList_CAT5[3]}",
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                                fontSize: 10,
                                                                color:
                                                                    Colors.grey[
                                                                        400])),
                                                        Text(
                                                            "${itemNameList_CAT5[3]}",
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                                fontSize: 15,
                                                                color: Colors
                                                                    .black)),
                                                      ]),
                                                ),
                                                const Spacer(),
                                              ],
                                            ),
                                            const Spacer(),
                                            Divider(
                                              thickness: 1,
                                              color: Colors.grey[300],
                                            ),
                                            const Spacer(),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Padding(
                                                    padding:
                                                        EdgeInsets.all(20)),
                                                Text("5",
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black)),
                                                Padding(
                                                    padding: EdgeInsets.all(7)),
                                                SizedBox(
                                                  width: 100.0, height:80,
                                                  child: itemImageBox(itemImageLink_CAT5[4]),
                                                ),
                                                Container(
                                                  width: 180,
                                                  child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Text(
                                                            "${itemCompanyNameList_CAT5[4]}",
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                                fontSize: 10,
                                                                color:
                                                                    Colors.grey[
                                                                        400])),
                                                        Text(
                                                            "${itemNameList_CAT5[4]}",
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                                fontSize: 15,
                                                                color: Colors
                                                                    .black)),
                                                      ]),
                                                ),
                                                const Spacer(),
                                              ],
                                            ),
                                            Spacer(),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 360,
                                      height: 245,
                                      margin: EdgeInsets.all(1),
                                      padding: const EdgeInsets.only(
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
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                          children: <Widget>[
                                            const Spacer(),
                                            Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.start,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Padding(
                                                    padding:
                                                    EdgeInsets.all(20)),
                                                Text("1",
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                        FontWeight.bold,
                                                        color: Colors.black)),
                                                Padding(
                                                    padding: EdgeInsets.all(7)),
                                                SizedBox(
                                                  width: 100.0, height:80,
                                                  child: itemImageBox(itemImageLink_CAT1[0]),
                                                ),
                                                Container(
                                                  width: 180,
                                                  child: Column(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .center,
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .start,
                                                      children: <Widget>[
                                                        Text(
                                                            "${itemCompanyNameList_CAT1[0]}",
                                                            overflow:
                                                            TextOverflow
                                                                .ellipsis,
                                                            style: TextStyle(
                                                                fontSize: 10,
                                                                color:
                                                                Colors.grey[
                                                                400])),
                                                        Text(
                                                            "${itemNameList_CAT1[0]}",
                                                            overflow:
                                                            TextOverflow
                                                                .ellipsis,
                                                            style: TextStyle(
                                                                fontSize: 15,
                                                                color: Colors
                                                                    .black)),
                                                      ]),
                                                ),
                                                const Spacer(),
                                              ],
                                            ),
                                            const Spacer(),
                                            Divider(
                                              thickness: 1,
                                              color: Colors.grey[300],
                                            ),
                                            const Spacer(),
                                            Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.start,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Padding(
                                                    padding:
                                                    EdgeInsets.all(20)),
                                                Text("2",
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                        FontWeight.bold,
                                                        color: Colors.black)),
                                                Padding(
                                                    padding: EdgeInsets.all(7)),
                                                SizedBox(
                                                  width: 100.0, height:80,
                                                  child: itemImageBox(itemImageLink_CAT1[1]),
                                                ),
                                                Container(
                                                  width: 180,
                                                  child: Column(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .center,
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .start,
                                                      children: <Widget>[
                                                        Text(
                                                            "${itemCompanyNameList_CAT1[1]}",
                                                            overflow:
                                                            TextOverflow
                                                                .ellipsis,
                                                            style: TextStyle(
                                                                fontSize: 10,
                                                                color:
                                                                Colors.grey[
                                                                400])),
                                                        Text(
                                                            "${itemNameList_CAT1[1]}",
                                                            overflow:
                                                            TextOverflow
                                                                .ellipsis,
                                                            style: TextStyle(
                                                                fontSize: 15,
                                                                color: Colors
                                                                    .black)),
                                                      ]),
                                                ),
                                                const Spacer(),
                                              ],
                                            ),
                                            const Spacer(),
                                            Divider(
                                              thickness: 1,
                                              color: Colors.grey[300],
                                            ),
                                            const Spacer(),
                                            Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.start,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Padding(
                                                    padding:
                                                    EdgeInsets.all(20)),
                                                Text("3",
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                        FontWeight.bold,
                                                        color: Colors.black)),
                                                Padding(
                                                    padding: EdgeInsets.all(7)),
                                                SizedBox(
                                                  width: 100.0, height:80,
                                                  child: itemImageBox(itemImageLink_CAT1[2]),
                                                ),
                                                Container(
                                                  width: 180,
                                                  child: Column(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .center,
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .start,
                                                      children: <Widget>[
                                                        Text(
                                                            "${itemCompanyNameList_CAT1[2]}",
                                                            overflow:
                                                            TextOverflow
                                                                .ellipsis,
                                                            style: TextStyle(
                                                                fontSize: 10,
                                                                color:
                                                                Colors.grey[
                                                                400])),
                                                        Text(
                                                            "${itemNameList_CAT1[2]}",
                                                            overflow:
                                                            TextOverflow
                                                                .ellipsis,
                                                            style: TextStyle(
                                                                fontSize: 15,
                                                                color: Colors
                                                                    .black)),
                                                      ]),
                                                ),
                                                const Spacer(),
                                              ],
                                            ),
                                            const Spacer(),
                                            Divider(
                                              thickness: 1,
                                              color: Colors.grey[300],
                                            ),
                                            const Spacer(),
                                            Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.start,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Padding(
                                                    padding:
                                                    EdgeInsets.all(20)),
                                                Text("4",
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                        FontWeight.bold,
                                                        color: Colors.black)),
                                                Padding(
                                                    padding: EdgeInsets.all(7)),
                                                SizedBox(
                                                  width: 100.0, height:80,
                                                  child: itemImageBox(itemImageLink_CAT1[3]),
                                                ),
                                                Container(
                                                  width: 180,
                                                  child: Column(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .center,
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .start,
                                                      children: <Widget>[
                                                        Text(
                                                            "${itemCompanyNameList_CAT1[3]}",
                                                            overflow:
                                                            TextOverflow
                                                                .ellipsis,
                                                            style: TextStyle(
                                                                fontSize: 10,
                                                                color:
                                                                Colors.grey[
                                                                400])),
                                                        Text(
                                                            "${itemNameList_CAT1[3]}",
                                                            overflow:
                                                            TextOverflow
                                                                .ellipsis,
                                                            style: TextStyle(
                                                                fontSize: 15,
                                                                color: Colors
                                                                    .black)),
                                                      ]),
                                                ),
                                                const Spacer(),
                                              ],
                                            ),
                                            const Spacer(),
                                            Divider(
                                              thickness: 1,
                                              color: Colors.grey[300],
                                            ),
                                            const Spacer(),
                                            Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.start,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Padding(
                                                    padding:
                                                    EdgeInsets.all(20)),
                                                Text("5",
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                        FontWeight.bold,
                                                        color: Colors.black)),
                                                Padding(
                                                    padding: EdgeInsets.all(7)),
                                                SizedBox(
                                                  width: 100.0, height:80,
                                                  child: itemImageBox(itemImageLink_CAT1[4]),
                                                ),
                                                Container(
                                                  width: 180,
                                                  child: Column(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .center,
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .start,
                                                      children: <Widget>[
                                                        Text(
                                                            "${itemCompanyNameList_CAT1[4]}",
                                                            overflow:
                                                            TextOverflow
                                                                .ellipsis,
                                                            style: TextStyle(
                                                                fontSize: 10,
                                                                color:
                                                                Colors.grey[
                                                                400])),
                                                        Text(
                                                            "${itemNameList_CAT1[4]}",
                                                            overflow:
                                                            TextOverflow
                                                                .ellipsis,
                                                            style: TextStyle(
                                                                fontSize: 15,
                                                                color: Colors
                                                                    .black)),
                                                      ]),
                                                ),
                                                const Spacer(),
                                              ],
                                            ),
                                            Spacer(),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ]),
                            ),
                            Padding(padding: EdgeInsets.all(20)),
                          ],
                        )),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
