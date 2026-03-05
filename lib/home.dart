import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ble_peripheral/flutter_ble_peripheral.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:splitify/add_task.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {


  @override
  Widget build(BuildContext context) {
    final devices = FlutterBluePlus.connectedDevices;
    return Scaffold(
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
              onPressed: () async{
                print("eye taped");
                final peripheral = FlutterBlePeripheral();
                // final service = FlutterBleServi(
                //   uuid: "serviceUuid",
                //   characteristics: [
                //     BleCharacteristic(
                //       uuid: charUuid,
                //       properties: [
                //         CharacteristicProperties.read,
                //         CharacteristicProperties.write,
                //         CharacteristicProperties.notify,
                //       ],
                //       permissions: [
                //         AttributePermissions.readable,
                //         AttributePermissions.writeable,
                //       ],
                //     ),
                //   ],
                // );

                final isAdv = await peripheral.isAdvertising;
                if(isAdv){
                  await peripheral.stop();
                }else{
                  const serviceUuid = "12345678-1234-1234-1234-123456789abc";
                  final shortId = "123456";

                  await peripheral.start(
                    advertiseData: AdvertiseData(
                      includeDeviceName: true,
                      localName: "Zplit_$shortId",
                      serviceUuids: [serviceUuid],
                      // manufacturerData: utf8.encode("ZPLIT_$shortId"),
                    ),
                  );

                  print("Advertising as: Zplit_$shortId");
                  print("Service UUID: $serviceUuid");
                }
              },
              child: Icon(Icons.remove_red_eye)
          ),
          SizedBox(height: 10,),
          FloatingActionButton(
            onPressed: () => Navigator.push(
              context,
              CupertinoPageRoute(builder: (c) => AddTask()),
            ),
            child: Icon(Icons.add),
          ),
        ],
      ),
      body: ListView.builder(
      itemCount: devices.length,
      itemBuilder: (c, i) {
        final d = devices[i];
        return ListTile(
          title: Text(d.advName),
          subtitle: Text(d.remoteId.str),
          trailing: IconButton(onPressed: (){}, icon: Icon(Icons.send)),
        );
      },
    )
    );
  }
}
