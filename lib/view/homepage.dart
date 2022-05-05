import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:toast/toast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iot_refridgerator/view/utils/colours.dart';
import 'package:iot_refridgerator/view/utils/styles.dart';
import 'package:iot_refridgerator/view/widget/text_field.dart';
import 'package:sizer/sizer.dart';
import 'package:iot_refridgerator/constants.dart';
import 'widget/dht_data_container.dart';

class HomePage extends StatefulWidget {
  TextEditingController temperature = TextEditingController();
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dht1GetTempAndHumidity();
    dht2GetTempAndHumidity();
    getUpdatedTemp();
    getSwitch1Status();
    getSwitch2Status();
    getLM35Stats();
  }

  @override
  final databaseRefferal = FirebaseDatabase.instance.ref();
  String dht1Temp = '';
  String dht1Humidity = '';
  String dht2Temp = '';
  String dht2Humidity = '';
  String UpdatedTemp = '';
  String lm35Temp = '';
  int lm35TempInt = 0;

  getSwitch1Status() {
    databaseRefferal
        .child("Switch Status")
        .child("Switch 1")
        .once()
        .then((value) {
      if (value.snapshot.value.toString() == "true") {
        setState(() {
          switch1 = true;
        });
      } else {
        setState(() {
          switch1 = false;
        });
      }
    });
    Timer(const Duration(seconds: 1), () => getSwitch1Status());
  }

  getSwitch2Status() {
    databaseRefferal
        .child("Switch Status")
        .child("Switch 2")
        .once()
        .then((value) {
      if (value.snapshot.value.toString() == "true") {
        setState(() {
          switch2 = true;
        });
      } else {
        setState(() {
          switch2 = false;
        });
      }
    });
    Timer(const Duration(seconds: 1), () => getSwitch2Status());
  }

  Future<void> getLM35Stats() async {
    databaseRefferal
        .child("Data")
        .child('LM35')
        .child("Temperature")
        .once()
        .then((value) {
      setState(() {
        lm35Temp = value.snapshot.value.toString();
        // lm35TempInt =
        //     int.parse(double.parse(value.snapshot.value.toString()).toString());
      });
    });
    Timer(const Duration(seconds: 1), () => getLM35Stats());
  }

  Future<void> dht1GetTempAndHumidity() async {
    databaseRefferal
        .child("Data")
        .child('DHT1')
        .child("Humidity")
        .once()
        .then((value) {
      setState(() {
        dht1Humidity = value.snapshot.value.toString();
      });
    });
    databaseRefferal
        .child("Data")
        .child('DHT1')
        .child("Temperature")
        .once()
        .then((value) {
      setState(() {
        dht1Temp = value.snapshot.value.toString();
      });
    });

    Timer(const Duration(seconds: 1), () => dht1GetTempAndHumidity());
  }

  Future<void> dht2GetTempAndHumidity() async {
    databaseRefferal
        .child("Data")
        .child('DHT2')
        .child("Humidity")
        .once()
        .then((value) {
      setState(() {
        dht2Humidity = value.snapshot.value.toString();
      });
    });
    databaseRefferal
        .child("Data")
        .child('DHT2')
        .child("Temperature")
        .once()
        .then((value) {
      setState(() {
        dht2Temp = value.snapshot.value.toString();
      });
    });

    Timer(const Duration(seconds: 1), () => dht2GetTempAndHumidity());
  }

  Future<void> getUpdatedTemp() async {
    databaseRefferal
        .child("Data")
        .child("Updated Temperature")
        .once()
        .then((value) {
      setState(() {
        UpdatedTemp = value.snapshot.value.toString();
      });
    });
    Timer(const Duration(seconds: 1), () => getUpdatedTemp());
  }

  Widget build(BuildContext context) {
    ToastContext().init(context);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return StreamBuilder<Object>(
        stream: databaseRefferal.child("Data").onValue,
        builder: (context, snapshot) {
          if (snapshot.hasData && !snapshot.hasError) {
            return Scaffold(
              appBar: AppBar(
                title: const Center(
                  child: Text(
                    'IOT Refrigerator',
                    style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ),
              body: SafeArea(
                  child: Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      DTHDataContainer(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'DHT 1',
                              style: heading,
                            ),
                            SizedBox(
                              height: 2.h,
                            ),
                            Row(
                              children: [
                                const FaIcon(
                                  FontAwesomeIcons.temperatureQuarter,
                                  // color: Colors.white70,
                                  color: Colors.black,
                                  size: 30,
                                ),
                                SizedBox(
                                  width: 3.w,
                                ),
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'Temperature : ',
                                        style: label,
                                      ),
                                      TextSpan(
                                        text: dht1Temp + '°C',
                                        style: label,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 1.5.h,
                            ),
                            Row(
                              children: [
                                const FaIcon(
                                  FontAwesomeIcons.droplet,
                                  // color: Colors.white70,
                                  color: Colors.black,
                                  size: 30,
                                ),
                                SizedBox(
                                  width: 3.w,
                                ),
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'Humidity       : ',
                                        style: label,
                                      ),
                                      TextSpan(
                                        text: dht1Humidity + ' %',
                                        style: label,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      DTHDataContainer(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'DHT 2',
                              style: heading,
                            ),
                            SizedBox(
                              height: 2.h,
                            ),
                            Row(
                              children: [
                                const FaIcon(
                                  FontAwesomeIcons.temperatureQuarter,
                                  // color: Colors.white70,
                                  color: Colors.black,
                                  size: 30,
                                ),
                                SizedBox(
                                  width: 3.w,
                                ),
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'Temperature : ',
                                        style: label,
                                      ),
                                      TextSpan(
                                        text: dht2Temp + '°C',
                                        style: label,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 1.5.h,
                            ),
                            Row(
                              children: [
                                const FaIcon(
                                  FontAwesomeIcons.droplet,
                                  // color: Colors.white70,
                                  color: Colors.black,
                                  size: 30,
                                ),
                                SizedBox(
                                  width: 3.w,
                                ),
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'Humidity       : ',
                                        style: label,
                                      ),
                                      TextSpan(
                                        text: dht2Humidity + ' %',
                                        style: label,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 11.h,
                        width: 100.w,
                        margin: EdgeInsets.symmetric(vertical: 0.5.h),
                        padding: EdgeInsets.symmetric(
                            vertical: 1.h, horizontal: 1.h),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: containerColor,
                        ),
                        // alignment: Alignment.,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'LM35',
                              style: heading,
                            ),
                            const Spacer(),
                            Row(
                              children: [
                                const FaIcon(
                                  FontAwesomeIcons.temperatureQuarter,
                                  // color: Colors.white70,
                                  color: Colors.black,
                                  size: 30,
                                ),
                                SizedBox(
                                  width: 3.w,
                                ),
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'Temperature : ',
                                        style: label,
                                      ),
                                      TextSpan(
                                        text: lm35Temp.toString() + '°C',
                                        style: label,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 2.h,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Set Temperature',
                            style: labelTextField,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextInputField(
                                hintText: 'Temperature : $UpdatedTemp',
                                controller: widget.temperature,
                              ),
                              InkWell(
                                onTap: () {
                                  if (widget.temperature.text.isNotEmpty) {
                                    setTemp(int.parse(widget.temperature.text));
                                    Toast.show(
                                      "Temp. set to  " +
                                          widget.temperature.text +
                                          '°C',
                                      textStyle: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 24),
                                      duration: 3,
                                      gravity: 2,
                                      backgroundColor:
                                          Color.fromARGB(255, 190, 181, 181),
                                    );
                                    widget.temperature.clear();
                                  } else {
                                    Toast.show(
                                      'Opps! temp. not added',
                                      textStyle: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                      duration: 3,
                                      gravity: 2,
                                      backgroundColor:
                                          Color.fromARGB(255, 190, 181, 181),
                                    );
                                  }
                                },
                                child: Container(
                                  margin: EdgeInsets.symmetric(vertical: 1.h),
                                  decoration: BoxDecoration(
                                      color: lightTealColor,
                                      borderRadius: BorderRadius.circular(5)),
                                  // padding: EdgeInsets.only(left: 3.w),
                                  height: 5.h,
                                  width: 20.w,
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Set',
                                    style: label,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 2.h,
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 1.h),
                        padding: EdgeInsets.symmetric(
                            vertical: 1.h, horizontal: 3.w),
                        height: 10.h,
                        width: 100.w,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.teal),
                        child: Row(
                          children: [
                            Container(
                              height: 8.h,
                              width: 8.h,
                              decoration: const BoxDecoration(
                                // color: powerContainerColor,
                                image: DecorationImage(
                                  image: AssetImage(
                                      'assets/images/power_button.png'),
                                  fit: BoxFit.cover,
                                ),
                                shape: BoxShape.circle,
                                // border: Border.all(
                                //   color: Colors.blue,
                                //   width: 2,
                                // ),
                              ),
                            ),
                            SizedBox(
                              width: 5.w,
                            ),
                            Text(
                              'Switch 1',
                              style: label,
                            ),
                            const Spacer(),
                            InkWell(
                              highlightColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              splashColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              onTap: () {
                                setState(() {
                                  switch1 = !switch1;
                                });
                                writeData(switch1, switch2);
                              },
                              child: SizedBox(
                                height: 7.h,
                                width: 16.w < 65 ? 65 : 16.w,
                                child: Stack(
                                  children: [
                                    Align(
                                      alignment: Alignment.center,
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: const Color.fromARGB(
                                                255, 184, 183, 183),
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        height: 15,
                                        width: 18.w,
                                      ),
                                    ),
                                    Align(
                                      alignment: switch1
                                          ? Alignment.centerRight
                                          : Alignment.centerLeft,
                                      child: Container(
                                        height: 4.h < 33 ? 33 : 4.h,
                                        width: 4.h < 33 ? 33 : 4.h,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: switch1
                                                ? Colors.green
                                                : const Color.fromARGB(
                                                    255, 233, 233, 233)),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 5.w,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 1.h),
                        padding: EdgeInsets.symmetric(
                            vertical: 1.h, horizontal: 3.w),
                        height: 10.h,
                        width: 100.w,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.teal),
                        child: Row(
                          children: [
                            Container(
                              height: 8.h,
                              width: 8.h,
                              decoration: const BoxDecoration(
                                // color: powerContainerColor,
                                image: DecorationImage(
                                  image: AssetImage(
                                      'assets/images/power_button.png'),
                                  fit: BoxFit.cover,
                                ),
                                shape: BoxShape.circle,
                                // border: Border.all(
                                //   color: Colors.blue,
                                //   width: 2,
                                // ),
                              ),
                            ),
                            SizedBox(
                              width: 5.w,
                            ),
                            Text(
                              'Switch 2',
                              style: label,
                            ),
                            const Spacer(),
                            InkWell(
                              highlightColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              splashColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              onTap: () {
                                setState(() {
                                  switch2 = !switch2;
                                });
                                writeData(switch1, switch2);
                              },
                              child: SizedBox(
                                height: 7.h,
                                width: 16.w < 65 ? 65 : 16.w,
                                child: Stack(
                                  children: [
                                    Align(
                                      alignment: Alignment.center,
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: const Color.fromARGB(
                                                255, 184, 183, 183),
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        height: 15,
                                        width: 18.w,
                                      ),
                                    ),
                                    Align(
                                      alignment: switch2
                                          ? Alignment.centerRight
                                          : Alignment.centerLeft,
                                      child: Container(
                                        height: 4.h < 33 ? 33 : 4.h,
                                        width: 4.h < 33 ? 33 : 4.h,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: switch2
                                                ? Colors.green
                                                : const Color.fromARGB(
                                                    255, 233, 233, 233)),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 5.w,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              )),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  Future<void> writeData(
    bool switchStat1,
    bool switchStat2,
  ) async {
    databaseRefferal.child("Switch Status").set({
      "Switch 1": (switchStat1).toString(),
      "Switch 2": (switchStat2).toString(),
    });
  }

  Future<void> DHTStats(int temp, int humidity, String dhtName) async {
    databaseRefferal.child('Data').child(dhtName).set({
      "Temperature": temp,
      "Humidity": humidity,
    });
  }

  Future<void> setTemp(int temp) async {
    databaseRefferal.child('Data').update({
      "Updated Temperature": temp,
    });
  }

  Future<void> dht1Data(
    bool switchStat1,
    bool switchStat2,
  ) async {
    databaseRefferal.child("Switch Status").set({
      "Switch 1": (switchStat1).toString(),
      "Switch 2": (switchStat2).toString(),
    });
  }
}
