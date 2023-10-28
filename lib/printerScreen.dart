import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';


import 'package:permission_handler/permission_handler.dart';

class PrinterScreen extends StatefulWidget {
  const PrinterScreen({super.key});

  @override
  State<PrinterScreen> createState() => _PrinterScreenState();
}

class _PrinterScreenState extends State<PrinterScreen> {
  // Initial Selected Value
  final List<String> items = [
    'Item1',
    'Item2',
    'Item3',
    'Item4',
  ];
  String? selectedValue;

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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(left: 4.w, right: 4.w),
                width: 100.w,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(2.w)),
                child: Column(
                  children: [
                    SizedBox(
                      height: 6.w,
                    ),
                    Text(
                      "Connection: Connecting.....",
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: "Imprima",
                          fontSize: 12.sp),
                    ),
                    SizedBox(
                      height: 4.w,
                    ),
                    Container(
                      width: 100.w,
                      padding: EdgeInsets.all(3.w),
                      margin: EdgeInsets.only(left: 1.w, right: 1.w),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.w),
                          border:
                              Border.all(color: Color(0xffF8F1F1), width: 2)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "KOT Printer (captain)",
                            style: TextStyle(
                                fontFamily: "Imprima",
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            height: 5.w,
                          ),
                          Text(
                            "Select Printer",
                            style: TextStyle(
                                fontFamily: "Imprima",
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            height: 3.w,
                          ),
                          Container(
                            width: 100.w,
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton2<String>(
                                isExpanded: true,
                                iconStyleData: IconStyleData(
                                  iconSize: 10,
                                  icon: Container(
                                      height: 40,
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          color: Color(0xffD9D9D9),
                                          borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(7),
                                            bottomRight: Radius.circular(7),
                                          )),
                                      child: Image.asset(
                                        "assets/images/downArrow.png",
                                        fit: BoxFit.fill,
                                      )),
                                ),
                                hint: Padding(
                                  padding: EdgeInsets.only(top: 8),
                                  child: Text(
                                    'Select Item',
                                    style: TextStyle(
                                      fontSize: 30,
                                      fontFamily: "Katibeh",
                                      color: Theme.of(context).hintColor,
                                    ),
                                  ),
                                ),
                                items: items
                                    .map((String item) =>
                                        DropdownMenuItem<String>(
                                          value: item,
                                          child: Padding(
                                            padding: EdgeInsets.only(top: 8),
                                            child: Text(
                                              item,
                                              style: const TextStyle(
                                                  fontSize: 30,
                                                  fontFamily: "Katibeh"),
                                            ),
                                          ),
                                        ))
                                    .toList(),
                                value: selectedValue,
                                onChanged: (String? value) {
                                  setState(() {
                                    selectedValue = value;
                                  });
                                },
                                buttonStyleData: ButtonStyleData(
                                  padding: EdgeInsets.only(left: 16),
                                  height: 40,
                                  decoration: BoxDecoration(
                                      color: Color(0xffB4B6BD),
                                      borderRadius: BorderRadius.circular(7)),
                                  width: 140,
                                ),
                                menuItemStyleData: const MenuItemStyleData(
                                  height: 40,
                                ),
                              ),
                            ),
                          ),

                          SizedBox(
                            height: 10.w,
                          ),
                          GestureDetector(
                              onTap: () async {
// listen to *any device* connection state changes
                                // check if bluetooth is supported by your hardware
// Note: The platform is initialized on the first call to any FlutterBluePlus method.
                                if (await FlutterBluePlus.isSupported == false) {
                                  print("Bluetooth not supported by this device");
                                  return;
                                }
                                await FlutterBluePlus.startScan();

// handle bluetooth on & off
// note: for iOS the initial state is typically BluetoothAdapterState.unknown
// note: if you have permissions issues you will get stuck at BluetoothAdapterState.unauthorized
                                FlutterBluePlus.adapterState.listen((BluetoothAdapterState state) {
                                  print(state);
                                  if (state == BluetoothAdapterState.on) {
                                    // usually start scanning, connecting, etc
                                  } else {
                                    // show an error to the user, etc
                                  }
                                });

// turn on bluetooth ourself if we can
// for iOS, the user controls bluetooth enable/disable
                                if (Platform.isAndroid) {
                                  await FlutterBluePlus.turnOn();
                                }
                                var status = await Permission.bluetooth.status;
                                print(status);
                                if (status.isDenied) {
                                  await [
                                    Permission.bluetooth,
                                  ].request();
                                  // We didn't ask for permission yet or the permission has been denied before, but not permanently.
                                }



                                // Setup Listener for scan results.
// device not found? see "Common Problems" in the README

                                Set<DeviceIdentifier> seen = {};
                                var subscription = FlutterBluePlus.scanResults.listen(
                                        (results) {
                                      for (ScanResult r in results) {
                                        if (seen.contains(r.device.remoteId) == false) {
                                          print('${r.device.remoteId}: "${r.advertisementData.localName}" found! rssi: ${r.rssi}');
                                          seen.add(r.device.remoteId);
                                          print(seen.length);
                                        }
                                      }
                                    },
                                );

// Start scanning
                                List<BluetoothDevice> devs = FlutterBluePlus.connectedDevices;
                                print(devs);
// Stop scanning
//                                 await FlutterBluePlus.stopScan();
//                                 for (var d in devs) {
//                                   print(d.servicesList);
//                                 }

                              },
                              child: Container(
                                padding: EdgeInsets.all(1.w),
                                margin: EdgeInsets.only(right: 8.w),
                                width: 100.w,
                                decoration: BoxDecoration(
                                    color: Color(0xffB4B6BD),
                                    borderRadius: BorderRadius.circular(3.w)),
                                child: Center(
                                    child: Text(
                                      "Submit",
                                      style: TextStyle(
                                          color: Color(0xff464446),
                                          fontFamily: "Fredoka",
                                          fontSize: 20.sp),
                                    )),
                              ))
                        ],
                      ),
                    ),

                    SizedBox(
                      height: 4.w,
                    ),
                  ],
                ),
              )
            ],
          )),
    );
  }
}
