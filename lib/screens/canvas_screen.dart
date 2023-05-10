// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, sort_child_properties_last, prefer_final_fields, unused_element, unused_field, library_private_types_in_public_api

import 'dart:math';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class CanvasScreen extends StatefulWidget {
  const CanvasScreen({super.key});

  @override
  _CanvasScreenState createState() => _CanvasScreenState();
}

class _CanvasScreenState extends State<CanvasScreen> {
  // text field controller
  TextEditingController textController = TextEditingController();
  // image picker package
  final picker = ImagePicker();
  // image path
  File? _image;
  // text over image position
  double left = 50, top = 50;
  // when add Text Button is clicked the TextField will Visible & it will inVisible after add text
  bool _isTextFieldVisible = false;
  // text which is display over image
  String textOverImage = '';

// FUNCTIONS
  void textFieldVisibility() {
    setState(() {
      _isTextFieldVisible = !_isTextFieldVisible;
    });
  }

  void submitText(String text) {
    setState(() {
      textOverImage = text;
      _isTextFieldVisible = false;
    });
  }

// request for storage permission
  Future<void> requestStoragePermission() async {
    PermissionStatus status = await Permission.storage.request();
    if (status.isGranted) {
      getImage();
    }
  }

// get image from device
  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black87,
        body: Stack(
          children: [
            _image != null
                ? Image.file(
                    _image!,
                    width: double.infinity,
                  )
                : Center(
                    child: Text(
                      'Select Image',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
            Center(
              child: SizedBox(
                width: 200,
                child: Visibility(
                  visible: _isTextFieldVisible,
                  child: TextField(
                    controller: textController,
                    autofocus: true,
                    cursorColor: Colors.amber,
                    style: TextStyle(color: Colors.amber, fontSize: 30),
                    onSubmitted: submitText,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'text',
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: left,
              top: top,
              child: GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    left = max(0, left + details.delta.dx);
                    top = max(0, top + details.delta.dy);
                  });
                },
                child: Text(
                  textOverImage,
                  style: TextStyle(color: Colors.amber, fontSize: 30),
                ),
              ),
            ),
            BackButton(),
            Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: ElevatedButton(
                        onPressed: requestStoragePermission,
                        child: Text('Select Image'),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: ElevatedButton(
                        onPressed: () {
                          _isTextFieldVisible
                              ? submitText(textController.text)
                              : textFieldVisibility();
                        },
                        child: Text('Add Text'),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class BackButton extends StatelessWidget {
  const BackButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        margin: EdgeInsets.only(top: 30, left: 30),
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 5,
              blurRadius: 10,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Icon(Icons.arrow_back),
      ),
    );
  }
}
