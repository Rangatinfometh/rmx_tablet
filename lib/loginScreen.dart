import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:rmx_tablet/myParameter.dart';
import 'package:rmx_tablet/printerScreen.dart';
import 'package:sizer/sizer.dart';
import 'package:encrypt/encrypt.dart';
import 'package:flutter/material.dart' hide Key;
import 'package:flutter/foundation.dart';
import 'package:flutter/src/foundation/key.dart';

import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  TextEditingController userName = TextEditingController();
  TextEditingController password = TextEditingController();


  late StompClient stompClient;

  dynamic onConnect(StompFrame frame) {
    print(".....Connected.....");
    stompClient.subscribe(
        destination: "/print/kot/subscribe/Iskon Branch1",
        callback: (_1) {
          print("body:  " + _1.body.toString());
        });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadAsset();

    stompClient = StompClient(
      config: StompConfig.sockJS(
        url: 'https://infomeths.in/rm-socket',
        onConnect: onConnect,
        beforeConnect: () async {
          print('waiting to connect...');
          await Future.delayed(const Duration(milliseconds: 200));
          print('connecting...');
        },
        onWebSocketError: (dynamic error) => print(error.toString()),
        stompConnectHeaders: {'Authorization': 'Bearer yourToken'},
        webSocketConnectHeaders: {'Authorization': 'Bearer yourToken'},
      ),
    );
    stompClient.activate();
    final cipher = 'Xg4+gtUDU0Hd9uMUWU7IJtjxvocKzIOJwumyzbY5n40=';
    // final k = Key.fromUtf8('1234567891011123');
    final iv = IV.fromLength(16);
  }
  Future<String> loadAsset() async {
    print(abc);
    print(host);
    print(port);
    print(clientCode);
    var s = await rootBundle.loadString('assets/printer_config.props');
    // final key = Key.fromUtf8('YOUR_ENCRYPTION_KEY'); // Replace with your encryption key
    // final iv = IV.fromUtf8('YOUR_INITIALIZATION_VECTOR'); // Replace with your initialization vector
    // final encrypter = Encrypter(AES(key));
    //
    // final encryptedText = 'ENCRYPTED_DATA'; // Replace with your encrypted data
    //
    // final decrypted = encrypter.decrypt(Encrypted.fromBase64(encryptedText), iv: iv);
    //
    // print('Decrypted Text: $decrypted');
    print(s); //for debug
    // const cipher = 'Xg4+gtUDU0Hd9uMUWU7IJtjxvocKzIOJwumyzbY5n40=';
    // final k = Key.fromUtf8('1234567891011123');
    // final iv = IV.fromLength(16);

    // final encrypter = Encrypter(AES(k));

    // final decrypted = encrypter.decrypt(Encrypted.fromBase64(cipher), iv: iv);
    return s;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          height: 100.h,
          width: 100.w,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/login.jpg"),
                  fit: BoxFit.fill)),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 4.w, right: 4.w),
                  padding: EdgeInsets.symmetric(vertical: 8.w),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(2.w)),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 6.w,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 7.w, right: 7.w),
                        child: TextFormField(
                          controller: userName,
                          decoration: InputDecoration(
                              hintText: "Enter user name",
                              filled: true,
                              hintStyle: TextStyle(
                                  fontFamily: "Imprima", fontSize: 14.sp),
                              fillColor: Color(0xffD9D9D9),
                              prefixIcon: Image.asset(
                                "assets/images/user.png",
                                height: 3.w,
                                width: 3.w,
                              ),
                              contentPadding: EdgeInsets.only(
                                left: 10,
                                right: 0,
                                top: 0,
                                bottom: 0,
                              ),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(3.w))),
                          validator: (val) {
                            if (val.toString().isEmpty) {
                              return "Enter username";
                            }
                          },
                        ),
                      ),
                      SizedBox(
                        height: 4.w,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 7.w, right: 7.w),
                        child: TextFormField(
                          controller: password,
                          decoration: InputDecoration(
                              prefixIcon: Image.asset(
                                "assets/images/lock.png",
                                height: 3.w,
                                width: 3.w,
                              ),
                              filled: true,
                              fillColor: Color(0xffD9D9D9),
                              hintText: "Enter user password",
                              hintStyle: TextStyle(
                                  fontFamily: "Imprima", fontSize: 14.sp),
                              contentPadding: EdgeInsets.only(
                                left: 10,
                                top: 0,
                                bottom: 0,
                              ),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(3.w))),
                          validator: (val) {
                            if (val.toString().isEmpty) {
                              return "Enter password";
                            }
                          },
                        ),
                      ),
                      SizedBox(
                        height: 2.w,
                      ),
                      SizedBox(
                        height: 6.w,
                      ),
                      GestureDetector(
                          onTap: () {
                            authentication();
                            // Get.to(PrinterScreen());
                            //
                            // if (formKey.currentState!.validate()) {}
                          },
                          child: Container(
                            padding: EdgeInsets.only(top: 2.sp),
                            margin: EdgeInsets.symmetric(horizontal: 7.w),
                            width: 100.w,
                            decoration: BoxDecoration(
                                color: Color(0xff0F0BB9),
                                borderRadius: BorderRadius.circular(3.w)),
                            child: Center(
                                child: Text(
                              "Submit",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: "Jomhuria",
                                  fontWeight: FontWeight.w500,
                                  fontSize: 35.sp),
                            )),
                          )),
                      SizedBox(
                        height: 6.w,
                      ),
                    ],
                  ),
                )
              ],
            ),
          )),
    );
  }

  authentication() async {
    if (userName.text.toString().isEmpty) {
    } else if (userName.text.toString().isEmpty) {
    } else {
      var url = Uri.parse("put here url");
      var response =
          await http.post(url, body: {'name': 'doodle', 'color': 'blue'});
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  }
}
