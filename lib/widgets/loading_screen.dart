import 'package:flutter/material.dart';

class ViNewsLoadingScreen extends StatelessWidget {
  const ViNewsLoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
