#import "FlutterSunmiScalePlugin.h"
#if __has_include(<flutter_sunmi_scale/flutter_sunmi_scale-Swift.h>)
#import <flutter_sunmi_scale/flutter_sunmi_scale-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "flutter_sunmi_scale-Swift.h"
#endif

@implementation FlutterSunmiScalePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterSunmiScalePlugin registerWithRegistrar:registrar];
}
@end
