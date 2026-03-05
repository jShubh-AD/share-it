import 'package:flutter/material.dart';

class DeviceTile extends StatelessWidget {
  final String name;
  final String info;
  final Widget icon;
  final VoidCallback onConnect;

  const DeviceTile({
    super.key,
    required this.name,
    required this.info,
    required this.icon,
    required this.onConnect,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.devices_outlined),
      title: Text(name.isEmpty ? "Unknown Device" : name),
      subtitle: Text(info),
      trailing: IconButton(icon: icon, onPressed: onConnect),
    );
  }
}
