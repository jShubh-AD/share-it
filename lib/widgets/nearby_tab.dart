import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import 'device_tile.dart';

class NearbyTab extends StatefulWidget {
  const NearbyTab({super.key});

  @override
  State<NearbyTab> createState() => _NearbyTabState();
}

class _NearbyTabState extends State<NearbyTab> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StreamBuilder(
      stream: FlutterBluePlus.scanResults,
      builder: (c, snap) {
        if(snap.connectionState == ConnectionState.waiting){
          return Center(
              child: SizedBox(
                  height: 40,
                  width: 40,
                  child: CircularProgressIndicator(
                    strokeWidth: 4,
                  )
              )
          );
        }
        if(!snap.hasData || snap.data == null){
          log("${snap.data}");
          return Center(
            child: Text("No devices found"),
          );
        }

        return RefreshIndicator(
          onRefresh: ()async{
            await FlutterBluePlus.stopScan();
            await FlutterBluePlus.startScan(timeout: Duration(seconds: 10));
          },
          child: ListView.builder(
            physics: AlwaysScrollableScrollPhysics(),
            itemCount: snap.data?.length,
              itemBuilder: (c, i) {
                final result = snap.data![i];

                return StreamBuilder(
                  stream: result.device.connectionState,
                  builder: (c, stateSnap) {
                    final state = stateSnap.data;

                    return DeviceTile(
                      icon: state == BluetoothConnectionState.connected
                          ? Icon(Icons.link_off)
                          : Icon(Icons.link),
                      name: result.device.localName,
                      info: result.device.remoteId.str,
                      onConnect: () async {
                        try{
                          if (state != BluetoothConnectionState.connected) {
                            await result.device.connect(license: License.free);
                          } else {
                            await result.device.disconnect();
                          }
                        }catch(e,st){
                          log("connetc/disconnect",error: e,stackTrace: st);
                        }
                      },
                    );
                  },
                );
              }
          ),
        );
      },
    );
  }
}
