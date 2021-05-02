

# simple_s3
  
An advance yet simple to use AWS S3 plugin for upload and deletion.  
  
**Simple S3** uses AWS Native SDKs for iOS and Android  

##  Getting started

Add  dependency in *pubspec.yaml*

`simple_s3: 0.3.0`

 [Follow @ab_hi_j on Twitter](https://twitter.com/ab_hi_j)


##  Features

| Feature | Description |
| ----- | ----------- |
| Null Safe | :white_check_mark: |
| Upload Percentage | :white_check_mark: |
| Supports all files | SimpleS3 auto detects content type of file by looking into extension |
| Set Access Type | Allows you to set access type of file ex. PublicRead, Private etc <br> Default is **Public Read** |
| Timestamp | Turned off by default if turned on  allows you to append timestamp in file name. <br>Location of timestamp can be changed to either **prefix** or **suffix** <br> Default is **prefix**|
|Custom File Name| Allows to change name of file about to upload. <br> **Note** : **File name must contain extension.**|
| Custom S3 folder path| Allows to upload file to specific folder in S3|
| Sub Region Support | Allows upload/delete operations on S3 having sub regions |
| Delete Object | Allows deletion of file object |
| Auto Generates URL| URL pointing to S3 file is auto generated. <br>  |


### Not working in Android Release mode ?


If your Android app is not working in release mode please check [this section](#android-proguard-settings-for-release-mode) 

## Usage Examples


### Simple File Upload

```dart

// returns url pointing to S3 file

SimpleS3 _simpleS3 = SimpleS3();
String result = await _simpleS3.uploadFile(
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
### File Upload with Percentage

```dart

// returns url pointing to S3 file

SimpleS3 _simpleS3 = SimpleS3();
//Upload function
String result = await _simpleS3.uploadFile(
				file, <--------------- Selected File
				bucketName, <--------- Your Bucket Name
				poolID, <------------- Your POOL ID
				AWSRegions.apSouth1 <- S3 server region
				);

//Widget
child: StreamBuilder<dynamic>(  
    stream: _simpleS3.getUploadPercentage,  
    builder: (context, snapshot) {  
      return new Text(  
        snapshot.data != null ? "Uploaded: ${snapshot.data}" : "Simple S3",  
    );  
  }),

```

### Custom File Name

```dart

// returns url pointing to S3 file

SimpleS3 _simpleS3 = SimpleS3();
String result = await _simpleS3.uploadFile(
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

SimpleS3 _simpleS3 = SimpleS3();
String result = await _simpleS3.uploadFile(
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

SimpleS3 _simpleS3 = SimpleS3();
String result = await _simpleS3.uploadFile(
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

SimpleS3 _simpleS3 = SimpleS3();
String result = await _simpleS3.uploadFile(
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



SimpleS3 _simpleS3 = SimpleS3();
String result = await _simpleS3.uploadFile(
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

SimpleS3 _simpleS3 = SimpleS3();
String result = await _simpleS3.uploadFile(
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

SimpleS3 _simpleS3 = SimpleS3();
String result = await _simpleS3.uploadFile(
				file, <--------------- Selected File
				bucketName, <--------- Your Bucket Name
				poolID, <------------- Your POOL ID
				AWSRegions.apSouth1 <- S3 server region
				debugLog: true, <----- Enable full logs
				);

```


## Android Proguard settings for release mode

```dart

// add these lines in your app/build.gradle

		minifyEnabled true  
		useProguard true  
		proguardFiles getDefaultProguardFile('proguard-android.txt'),  
		        'proguard-aws-2.1.5.pro'

//EXAMPLE
		buildTypes {  
		  release {  
		  signingConfig signingConfigs.release  
		  minifyEnabled true  
		  useProguard true  
		  proguardFiles getDefaultProguardFile('proguard-android.txt'),  
		                'proguard-aws-2.1.5.pro'  
		  }  
		}
```

Now copy contents of this file [proguard-aws-2.1.5.pro](https://github.com/abhimortal6/simple_s3/blob/master/proguard-aws-2.1.5.pro)
Create a new file with name "proguard-aws-2.1.5.pro" at the same location as app/build.gradle and paste the copied contents into this file.

Your release mode APK should work now.
