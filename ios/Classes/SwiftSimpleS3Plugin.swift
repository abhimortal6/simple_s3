import Flutter
import UIKit

import AWSS3

enum FluterChannels {
    static let methods = "simple_s3"
    static let events = "simple_s3_events"
}

enum FluterMethods {
    static let upload = "upload"
    static let delete = "delete"
    
}

public class SwiftSimpleS3Plugin: NSObject, FlutterPlugin {
    private var events: FlutterEventSink?

    public static func register(with registrar: FlutterPluginRegistrar) {


        let channel = FlutterMethodChannel(name: FluterChannels.methods, binaryMessenger: registrar.messenger())
        let eventChannel = FlutterEventChannel(name: FluterChannels.events, binaryMessenger: registrar.messenger())
        let instance = SwiftSimpleS3Plugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
        eventChannel.setStreamHandler(instance)

    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch (call.method) {
        case FluterMethods.upload:
            self.upload(result: result, args: call.arguments)
            break;
        case FluterMethods.delete:
            self.delete(result: result, args: call.arguments)
            break;
        default:
            result(FlutterMethodNotImplemented)
        }
    }



    private func upload(result: @escaping FlutterResult, args: Any?) {

        let argsMap = args as! NSDictionary
        if  let filePath = argsMap["filePath"], let s3FolderPath = argsMap["s3FolderPath"], let subRegion = argsMap["subRegion"],
            let fileName = argsMap["fileName"], let poolID = argsMap["poolID"], let accessControl = argsMap["accessControl"],
            let bucketName = argsMap["bucketName"], let region = argsMap["region"], let contentType = argsMap["contentType"] {

            let parsedRegion = "\(region)".aws_regionTypeValue
            let parsedSubRegion = subRegion as! String != "" ? "\(subRegion)".aws_regionTypeValue : parsedRegion
            let url = NSURL(fileURLWithPath: filePath as! String)
            let folder = s3FolderPath as! String
            var acl = AWSS3ObjectCannedACL.unknown
            let acs = accessControl as! Int


            let credentialsProvider = AWSCognitoCredentialsProvider(regionType: parsedRegion(), identityPoolId: poolID as! String)
            let configuration = AWSServiceConfiguration(region: parsedSubRegion(), credentialsProvider: credentialsProvider)

            AWSServiceManager.default().defaultServiceConfiguration = configuration


            let uploadRequest = AWSS3TransferManagerUploadRequest()!

            uploadRequest.body = url as URL

            if(!folder.isEmpty && folder != "") {
                uploadRequest.key = folder + "/" + (fileName as! String)
            } else {
                uploadRequest.key = (fileName as! String)
            }





            switch acs {
            case 1:
                acl = AWSS3ObjectCannedACL.private
            case 2:
                acl = AWSS3ObjectCannedACL.publicRead
            case 3:
                acl = AWSS3ObjectCannedACL.publicReadWrite
            case 4:
                acl = AWSS3ObjectCannedACL.authenticatedRead
            case 5:
                acl = AWSS3ObjectCannedACL.awsExecRead
            case 6:
                acl = AWSS3ObjectCannedACL.bucketOwnerRead
            case 7:
                acl = AWSS3ObjectCannedACL.bucketOwnerFullControl
            default:
                acl = AWSS3ObjectCannedACL.unknown
            }


            uploadRequest.bucket = bucketName as? String
            uploadRequest.contentType = contentType as? String
            uploadRequest.acl = acl

            uploadRequest.uploadProgress = { (bytesSent, totalBytesSent,
                          totalBytesExpectedToSend) -> Void in
                          DispatchQueue.main.async(execute: {
                           let uploadedPercentage = (Float(totalBytesSent) / (Float(bytesSent) + 0.1)) * 100

                                self.events!(Int(uploadedPercentage))
                           })
                       }



            let transferManager = AWSS3TransferManager.default()
            transferManager.upload(uploadRequest).continueWith { (task) -> AnyObject? in
                if let error = task.error as NSError? {
                    if error.domain == AWSS3TransferManagerErrorDomain as String {
                        if let errorCode = AWSS3TransferManagerErrorType(rawValue: error.code) {
                            switch (errorCode) {
                            case .cancelled, .paused:
                                print("Native: Upload Cancelled or Paused")
                                result(false)
                                break;
                            default:
                                print("Native: Upload failed: \(error)")
                                result(false)
                                break;
                            }
                        } else {
                            print("Native: Upload failed: \(error)")
                            result(false)
                        }
                    } else {
                        print("Native: Upload failed:\(error)")
                        result(false)
                    }
                }

                if task.result != nil {
                    print("Native: Upload succesful")
                    result(true)
                }
                return nil
            }
        } else {
            print("Native: One or more arguments is missing while calling func()")
            result(nil)
        }
    }

    private func delete(result: @escaping FlutterResult, args: Any?) {
        let argsMap = args as! NSDictionary
        if  let filePath = argsMap["filePath"], let subRegion = argsMap["subRegion"],
            let poolID = argsMap["poolID"],
            let bucketName = argsMap["bucketName"], let region = argsMap["region"]{

            let parsedRegion = "\(region)".aws_regionTypeValue
            let parsedSubRegion = subRegion as! String != "" ? "\(subRegion)".aws_regionTypeValue : parsedRegion

            let credentialsProvider = AWSCognitoCredentialsProvider(regionType: parsedRegion(), identityPoolId: poolID as! String)
            let configuration = AWSServiceConfiguration(region: parsedSubRegion(), credentialsProvider: credentialsProvider)

            AWSServiceManager.default().defaultServiceConfiguration = configuration

            AWSS3.register(with: configuration!, forKey: "defaultKey")
            let s3 = AWSS3.s3(forKey: "defaultKey")
            let deleteObjectRequest = AWSS3DeleteObjectRequest()
            deleteObjectRequest?.bucket = (bucketName as! String)
            deleteObjectRequest?.key = (filePath as! String)
            s3.deleteObject(deleteObjectRequest!).continueWith { (task:AWSTask) -> AnyObject? in
                 if let error = task.error as NSError?{
                    print("Native: Failed: \(error)")
                    result(false)
                    return nil
                }

               if task.result != nil {
                    result(true)
                }
                return nil
            }

        }else {
            print("Native: One or more arguments is missing while calling func()")
            result(nil)
        }
    }

}

extension SwiftSimpleS3Plugin : FlutterStreamHandler {

    public func onListen(withArguments arguments: Any?,
                         eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        self.events = events
        return nil
    }

    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        self.events = nil
        return nil
    }
}
