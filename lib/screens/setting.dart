import 'package:flutter/material.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('setting'),
            IconButton(
              onPressed: () => _backScreen(context),
              icon: const Icon(Icons.arrow_back),
            ),
          ],
        ),
      ),
    );
  }

  void _backScreen(BuildContext context) {
    Navigator.pop(context);
  }
}
