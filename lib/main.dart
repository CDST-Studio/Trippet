import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/all.dart';

void main() {
  KakaoContext.clientId = "26a4f0b7a791e339f773c42e9de5fc0f";
  KakaoContext.javascriptClientId = "29507a126b5fef23a99cd5dca4228d90";
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: KakaoLogin(),
    );
  }
}

class KakaoLogin extends StatefulWidget {
  _KakaoLoginState createState() => _KakaoLoginState();
}

class _KakaoLoginState extends State<KakaoLogin> {
  bool _isKakaoTalkInstalled = false;

  @override
  void initState() {
    _initKakaoTalkInstalled();
    super.initState();
  }

  _initKakaoTalkInstalled() async {
    final installed = await isKakaoTalkInstalled();
    print("kakao installed : " + installed.toString());

    setState(() {
      _isKakaoTalkInstalled = installed;
    });
  }

  _issueAccessToken(String authCode) async {
    try {
      var token = await AuthApi.instance.issueAccessToken(authCode);

      AccessTokenStore.instance.toStore(token);
      print("token = " + token.toString());

      /*
      Navigator.push(context, MaterialPageRoute(
          builder: (context) => Home(),
      ));
       */
    }catch (e) {
      print(e.toString());
    }
  }

  _loginWithKakao() async {
    try {
      var code = await AuthCodeClient.instance.request();
      await _issueAccessToken(code);
    }catch (e) {
      print(e.toString());
    }
  }

  _loginWithTalk() async {
    try {
      var code = await AuthCodeClient.instance.requestWithTalk();
      await _issueAccessToken(code);
    }catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("카카오 로그인 테스트"),
      ),
      body: Center(
        child: InkWell(
          onTap: () => _isKakaoTalkInstalled ? _loginWithTalk() : _loginWithKakao(),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.6,
            height: MediaQuery.of(context).size.height * 0.07,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.yellow
            ),
            child: Row (
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.chat_bubble, color: Colors.black54),
                SizedBox(width: 10,),
                Text(
                  "카카오계정 로그인",
                  style: TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.w900,
                      fontSize: 20
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
