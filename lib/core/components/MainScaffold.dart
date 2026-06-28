import 'package:flutter/material.dart';

class MainScaffold extends StatelessWidget {
  final String title;
  final Widget content;
  final Alignment contentAlignment;
  final Color? backgroundColor;

  const MainScaffold({
    super.key,
    required this.title,
    required this.content,
    this.contentAlignment = Alignment.topCenter,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: title.isEmpty 
          ? null 
          : AppBar(
              title: Text(
                title,
                style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
              backgroundColor: Colors.transparent,
              elevation: 0,
              iconTheme: const IconThemeData(color: Colors.black),
            ),
      body: SafeArea(
        child: Align(
          alignment: contentAlignment,
          child: content,
        ),
      ),
    );
  }
}
