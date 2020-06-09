
# simple_s3
  
An advance yet simple to use AWS S3 plugin for upload and deletion.  
  
**Simple S3** uses AWS Native SDKs for iOS and Android  

##  Getting started

Add  dependency in *pubspec.yaml*

`simple_s3: 0.1.0`

 [Follow @ab_hi_j on Twitter](https://twitter.com/ab_hi_j)


##  Features

| Feature | Description |
| ----- | ----------- |
| Supports all files | SimpleS3 auto detects content type of file by looking into extension |
| Set Access Type | Allows you to set access type of file ex. PublicRead, Private etc <br> Default is **Public Read** |
| Timestamp | Turned off by default if turned on  allows you to append timestamp in file name. <br>Location of timestamp can be changed to either **prefix** or **suffix** <br> Default is **prefix**|
|Custom File Name| Allows to change name of file about to upload. <br> **Note** : **File name must contain extension.**|
| Custom S3 folder path| Allows to upload file to specific folder in S3|
| Sub Region Support | Allows upload/delete operations on S3 having sub regions |
| Delete Object | Allows deletion of file object |
| Auto Generates URL| URL pointing to S3 file is auto generated. <br>  |

## Usage Examples


### Simple File Upload

```dart

// returns url pointing to S3 file

String result = await SimpleS3.uploadFile(
				file, <--------------- Selected File
				bucketName, <--------- Your Bucket Name
				poolID, <------------- Your POOL ID
				AWSRegions.apSouth1 <- S3 server region
				);

```

### Delete

```dart

// returns bool

bool result = await SimpleS3.delete(
				filePath, <---------------- S3 File Path
				bucketName, <-------------- Your Bucket Name
				poolID, <------------------ Your POOL ID
				AWSRegions.apSouth1, <----- S3 server region
				);

// delete also supports sub-regions

```


### Custom File Name

```dart

// returns url pointing to S3 file

String result = await SimpleS3.uploadFile(
				file, <------------------------------ Selected File
				bucketName, <------------------------ Your Bucket Name
				poolID, <---------------------------- Your POOL ID
				AWSRegions.apSouth1, <--------------- S3 server region
				fileName: "Dennis_ritchie.jpeg", <--- Custom file name
				);

```

### Custom S3 Path

```dart

// returns url pointing to S3 file

String result = await SimpleS3.uploadFile(
				file, <-------------------------------- Selected File
				bucketName, <--------------------------- Your Bucket Name
				poolID, <------------------------------- Your POOL ID
				AWSRegions.apSouth1, <------------------ S3 server region
				s3FolderPath: "users/profile_pics", <--- Custom S3 path
				);

// final path will be  "bucketName/users/profile_pics"

```


### Setting Access Control

```dart

// returns url pointing to S3 file

String result = await SimpleS3.uploadFile(
				file, <------------------------------------- Selected File
				bucketName, <------------------------------- Your Bucket Name
				poolID, <----------------------------------- Your POOL ID
				AWSRegions.apSouth1, <---------------------- S3 server region
				accessControl: S3AccessControl.private, <--- Setting access of uploaded file **private**
				);

// S3AccessControl have more types of AccessControl ex. .publicRead, .publicReadWrite etc...

```


### Using Timestamp

```dart

// returns url pointing to S3 file

String result = await SimpleS3.uploadFile(
				file, <------------------------------------- Selected File
				bucketName, <------------------------------- Your Bucket Name
				poolID, <----------------------------------- Your POOL ID
				AWSRegions.apSouth1, <---------------------- S3 server region
				useTimeStamp: true, <----------------------- Enable Timestamp
				);

// default location of timestamp is prefix
// if original file name = "Dennis_ritchie.jpeg"
// then the result will be = "1591705658_Dennis_ritchie.jpeg"


// Change Timestamp Location



String result = await SimpleS3.uploadFile(
				file, <--------------------------------------- Selected File
				bucketName, <--------------------------------- Your Bucket Name
				poolID, <------------------------------------- Your POOL ID
				AWSRegions.apSouth1, <------------------------ S3 server region
				useTimeStamp: true, <------------------------- Enable Timestamp
				timeStampLocation: TimestampLocation.suffix,<- Changes timestamp location to suffix
				);
// if original file name = "Dennis_ritchie.jpeg"
// then the result will be = "Dennis_ritchie_1591705658.jpeg"

```


### Using Sub-Region

```dart

// returns url pointing to S3 file

String result = await SimpleS3.uploadFile(
				file, <------------------------------------- Selected File
				bucketName, <------------------------------- Your Bucket Name
				poolID, <----------------------------------- Your POOL ID
				AWSRegions.apSouth1, <---------------------- S3 server region
				subRegion: AWSRegions.apNorthEast1 <-------- Sub region
				);

```

### Debug mode

```dart

// for security reasons plugin uses less logs, to enable full logs -

String result = await SimpleS3.uploadFile(
				file, <--------------- Selected File
				bucketName, <--------- Your Bucket Name
				poolID, <------------- Your POOL ID
				AWSRegions.apSouth1 <- S3 server region
				debugLog: true, <----- Enable full logs
				);

```
