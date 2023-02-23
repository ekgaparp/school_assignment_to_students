// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class NewScreen extends StatelessWidget {
  String payload;

  NewScreen({
    super.key,
    required this.payload,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(payload),
      ),
    );
  }
}
