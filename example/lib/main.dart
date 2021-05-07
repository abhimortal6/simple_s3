import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:simple_s3/simple_s3.dart';
import 'package:simple_s3_example/Credentials.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "S3 Upload/Delete Demo",
      home: Scaffold(body: SimpleS3Test()),
    );
  }
}

class SimpleS3Test extends StatefulWidget {
  @override
  SimpleS3TestState createState() => SimpleS3TestState();
}

class SimpleS3TestState extends State<SimpleS3Test> {
  File? selectedFile;

  SimpleS3 _simpleS3 = SimpleS3();
  bool isLoading = false;
  bool uploaded = false;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: StreamBuilder<dynamic>(
            stream: _simpleS3.getUploadPercentage,
            builder: (context, snapshot) {
              return new Text(
                snapshot.data == null ? "Simple S3 Test" : "Uploaded: ${snapshot.data}",
              );
            }),
      ),
      body: Center(
        child: selectedFile != null
            ? isLoading
                ? CircularProgressIndicator()
                : Image.file(selectedFile!)
            : GestureDetector(
                onTap: () async {
                  PickedFile _pickedFile = (await ImagePicker().getImage(source: ImageSource.gallery))!;
                  setState(() {
                    selectedFile = File(_pickedFile.path);
                  });
                },
                child: Icon(
                  Icons.add,
                  size: 30,
                ),
              ),
      ),
      floatingActionButton: !isLoading
          ? FloatingActionButton(
              backgroundColor: uploaded ? Colors.green : Colors.blue,
              child: Icon(
                uploaded ? Icons.delete : Icons.arrow_upward,
                color: Colors.white,
              ),
              onPressed: () async {
                if (uploaded) {
                  print(await SimpleS3.delete(
                      "test/${selectedFile!.path.split("/").last}", Credentials.s3_bucketName, Credentials.s3_poolD, AWSRegions.apSouth1,
                      debugLog: true));
                  setState(() {
                    selectedFile = null;
                    uploaded = false;
                  });
                }
                if (selectedFile != null) _upload();
              },
            )
          : null,
    );
  }

  Future<String?> _upload() async {
    String? result;

    if (result == null) {
      try {
        setState(() {
          isLoading = true;
        });
        result = await _simpleS3.uploadFile(
          selectedFile!,
          Credentials.s3_bucketName,
          Credentials.s3_poolD,
          AWSRegions.apSouth1,
          debugLog: true,
          s3FolderPath: "test",
          accessControl: S3AccessControl.publicRead,
        );

        setState(() {
          uploaded = true;
          isLoading = false;
        });
      } catch (e) {
        print(e);
      }
    }
    return result;
  }
}
