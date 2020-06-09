#import "SimpleS3Plugin.h"
#if __has_include(<simple_s3/simple_s3-Swift.h>)
#import <simple_s3/simple_s3-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "simples3Swift.h"
#endif

@implementation SimpleS3Plugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftSimpleS3Plugin registerWithRegistrar:registrar];
}
@end
