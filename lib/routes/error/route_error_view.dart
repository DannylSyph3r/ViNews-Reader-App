import 'package:flutter/material.dart';
import 'package:vinews_news_reader/utils/widget_extensions.dart';

class RouteErrorScreen extends StatelessWidget {
  final String errorMessage;
  const RouteErrorScreen({super.key, required this.errorMessage});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: "Route Error".txtStyled() ,
      ),
    body: Center(
      child: Column(
        children: [
          errorMessage.txtStyled(fontSize: 16)
        ],)),
    );
  }
}