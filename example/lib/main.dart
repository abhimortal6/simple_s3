import 'dart:async';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

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
  File selectedFile;

  bool isLoading = false;
  bool uploaded = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: new Text(
          "Simple S3 Test",
        ),
      ),
      body: Center(
        child: selectedFile != null
            ? isLoading ? CircularProgressIndicator() : Image.file(selectedFile)
            : GestureDetector(
                onTap: () async {
                  File _file = await FilePicker.getFile(type: FileType.image);
                  setState(() {
                    selectedFile = _file;
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
//                  print(await SimpleS3.delete(filePath, bucketName, poolID, AWSRegions.apSouth1, debugLog: true));
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

  Future<String> _upload() async {
    String result;

    if (result == null) {
      try {
        setState(() {
          isLoading = true;
        });
//        String result = await SimpleS3.uploadFile(selectedFile, bucketName, poolID, AWSRegions.apSouth1,
//            debugLog: true, s3FolderPath: "test", accessControl: S3AccessControl.publicRead);

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
