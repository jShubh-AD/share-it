import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:splitify/widgets/device_tile.dart';
import 'package:splitify/widgets/nearby_tab.dart';

class AddTask extends StatefulWidget {
  const AddTask({super.key});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  final searchCtrl = TextEditingController();
  late final state;

  @override
  void initState(){
    super.initState();
    startScan();
  }

  @override
  void dispose(){
    super.dispose();
    FlutterBluePlus.stopScan();
    searchCtrl.dispose();
  }

  Future<void> startScan() async{
    state = FlutterBluePlus.adapterState.first.asStream();
    state.listen((state) async {
      if (state == BluetoothAdapterState.on) {
        FlutterBluePlus.startScan(timeout: Duration(seconds: 10));
        setState(() {});
      } else {
        // Show dialog/snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Please turn on Bluetooth")),
        );

        await FlutterBluePlus.turnOn(); // Android only
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blue,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_new_outlined, color: Colors.white),
        ),
        title: Text("Add Task", style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Share with",
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: searchCtrl,
              decoration: InputDecoration(
                hintText: "Search",
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: DefaultTabController(
                length: 2,
                child: Column(
                  children: [
                    TabBar(
                      tabs: [
                        Tab(text: "Near by"),
                        Tab(text: "Recents"),
                      ],
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          NearbyTab(),
                          Text("Recents"),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
