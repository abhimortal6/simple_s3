import 'dart:async';
import 'dart:io';
import 'package:mime_type/mime_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SimpleS3 {

  static const MethodChannel _methodChannel = const MethodChannel('simple_s3');

  static const EventChannel _eventChannel = const EventChannel("simple_s3_events");

  Stream get getUploadStatus => _eventChannel.receiveBroadcastStream();

  static Future<String> uploadFile(
    File file,
    String bucketName,
    String poolID,
    _AWSRegion region, {
    String s3FolderPath: "",
    String fileName,
      _AWSRegion subRegion,
    S3AccessControl accessControl: S3AccessControl.publicRead,
    bool useTimeStamp: false,
    TimestampLocation timeStampLocation: TimestampLocation.prefix,
    bool debugLog: false,
  }) async {
    Map<String, dynamic> args = <String, dynamic>{};
    var result;
    String contentType;


    if (!await file.exists()) throw SimpleS3Errors.FileDoesNotExistsError;

    if (!(fileName != null && fileName.length > 0)) {
      String originalFileName = file.path.split('/').last.replaceAll(" ", "");

      if (useTimeStamp) {
        int timestamp = DateTime.now().millisecondsSinceEpoch;

        if (timeStampLocation == TimestampLocation.prefix) {
          fileName = '$timestamp\_$originalFileName';
        } else {
          fileName = '${originalFileName.split(".").first}\_$timestamp\.${originalFileName.split(".").last}';
        }
      } else
        fileName = originalFileName;
    }

      contentType = mime(fileName);

    if (debugLog) {
      debugPrint('S3 Upload Started <-----------------');
      debugPrint(" ");
      debugPrint("File Name: $fileName");
      debugPrint(" ");
      debugPrint("Content Type: $contentType");
      debugPrint(" ");
    }

    args.putIfAbsent("filePath", () => file.path);
    args.putIfAbsent("poolID", () => poolID);
    args.putIfAbsent("region", () => region.region);
    args.putIfAbsent("bucketName", () => bucketName);
    args.putIfAbsent("fileName", () => fileName);
    args.putIfAbsent("s3FolderPath", () => s3FolderPath);
    args.putIfAbsent("debugLog", () => debugLog);
    args.putIfAbsent("contentType", () => contentType);
    args.putIfAbsent("subRegion", () => subRegion!= null ? subRegion.region : "");
    args.putIfAbsent("accessControl", () => accessControl.index);

    bool methodResult = await _methodChannel.invokeMethod('upload', args);

    if (methodResult) {

      String _region = subRegion != null ? subRegion.region : region.region;
      String _path = s3FolderPath != "" ? bucketName + "/" + s3FolderPath + "/" + fileName : bucketName + "/" + fileName;

      result = "https://s3-$_region.amazonaws.com/$_path";

      if (debugLog) {
        debugPrint("Status: Uploaded");
        debugPrint(" ");
        debugPrint("URL: $result");
        debugPrint(" ");
        debugPrint("Access Type: $accessControl");
        debugPrint(" ");
        debugPrint('S3 Upload Completed-------------->');
        debugPrint(" ");
      }
    } else {

      if (debugLog) {
        debugPrint("Status: Error");
        debugPrint(" ");
        debugPrint('S3 Upload Error------------------>');
      }
      throw SimpleS3Errors.UploadError;
    }

    return result;
  }

  static Future<bool> delete(
    String filePath,
    String bucketName,
    String poolID,
    _AWSRegion region, {
      _AWSRegion subRegion,
    bool debugLog: false,
  }) async {
    Map<String, dynamic> args = <String, dynamic>{};

    if (debugLog) {
      debugPrint('S3 Delete Object Started <--------------');
      debugPrint(" ");
      debugPrint("Object Path: $filePath");
      debugPrint(" ");
    }

    args.putIfAbsent("poolID", () => poolID);
    args.putIfAbsent("region", () => region.region);
    args.putIfAbsent("bucketName", () => bucketName);
    args.putIfAbsent("filePath", () => filePath);
    args.putIfAbsent("debugLog", () => debugLog);
    args.putIfAbsent("subRegion", () => subRegion!= null ? subRegion.region : "");

    bool methodResult = await _methodChannel.invokeMethod('delete', args);

    if (methodResult) {
      if (debugLog) {
        debugPrint(" ");
        debugPrint("S3 Delete Completed------------------>");
        debugPrint(" ");
      }
    } else {
      if (debugLog) {
        debugPrint("Status: Error");
        debugPrint(" ");
        debugPrint("S3 Object Deletion Error------------->");
      }
      throw SimpleS3Errors.DeleteError;
    }

    return methodResult;
  }
}

class _AWSRegion{
  String region;

  _AWSRegion(this.region);

}

class AWSRegions {

  static _AWSRegion get usEast1 => new _AWSRegion("us-east-1");
  static _AWSRegion get usEast2 => new _AWSRegion("us-east-2");
  static _AWSRegion get usWest1 => new _AWSRegion("us-west-1");
  static _AWSRegion get usWest2 => new _AWSRegion("us-west-2");
  static _AWSRegion get euWest1 => new _AWSRegion("eu-west-1");
  static _AWSRegion get euWest2 => new _AWSRegion("eu-west-2");
  static _AWSRegion get euWest3 => new _AWSRegion("eu-west-3");
  static _AWSRegion get euNorth1 => new _AWSRegion("eu-north-1");
  static _AWSRegion get euCentral1 => new _AWSRegion("eu-central-1");
  static _AWSRegion get apSouthEast1 => new _AWSRegion("ap-southeast-1");
  static _AWSRegion get apSouthEast2 => new _AWSRegion("ap-southeast-2");
  static _AWSRegion get apNorthEast1 => new _AWSRegion("ap-northeast-1");
  static _AWSRegion get apNorthEast2 => new _AWSRegion("ap-northeast-2");
  static _AWSRegion get apSouth1 => new _AWSRegion("ap-south-1");
  static _AWSRegion get apEast1 => new _AWSRegion("ap-east-1");
  static _AWSRegion get saEast1 => new _AWSRegion("sa-east-1");
  static _AWSRegion get cnNorth1 => new _AWSRegion("cn-north-1");
  static _AWSRegion get caCentral1 => new _AWSRegion("ca-central-1");
  static _AWSRegion get usGovWest1 => new _AWSRegion("us-gov-west-1");
  static _AWSRegion get usGovEast1 => new _AWSRegion("us-gov-east-1");
  static _AWSRegion get cnNorthWest1 => new _AWSRegion("cn-northwest-1");
  static _AWSRegion get meSouth1 => new _AWSRegion("me-south-1");


}





enum TimestampLocation { prefix, suffix }
enum SimpleS3Errors { FileDoesNotExistsError, UploadError, DeleteError }
enum S3AccessControl { unknown, private, publicRead, publicReadWrite, authenticatedRead, awsExecRead, bucketOwnerRead, bucketOwnerFullControl }


