
import 'dart:io' as io;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AvatarScreen extends StatelessWidget {
  final String? imagePath;

  const AvatarScreen({Key? key, this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        child: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: imagePath != null
              ? Image.file(io.File(imagePath!))
              : Container(),
        ),
      ),
    );
  }
}
