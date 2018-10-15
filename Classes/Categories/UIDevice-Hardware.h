/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 6.x Edition
 BSD License, Use at your own risk
 */

#import <UIKit/UIKit.h>
#define IFPGA_NAMESTRING                @"iFPGA"

#define IPHONE_1G_NAMESTRING            @"iPhone 1G"
#define IPHONE_3G_NAMESTRING            @"iPhone 3G"
#define IPHONE_3GS_NAMESTRING           @"iPhone 3GS"
#define IPHONE_4_NAMESTRING             @"iPhone 4"
#define IPHONE_4S_NAMESTRING            @"iPhone 4S"
#define IPHONE_5_NAMESTRING             @"iPhone 5"
#define IPHONE_5S_NAMESTRING            @"iPhone 5S"
#define IPHONE_5C_NAMESTRING            @"iPhone 5C"
#define IPHONE_UNKNOWN_NAMESTRING       @"Unknown iPhone"

#define IPOD_1G_NAMESTRING              @"iPod touch 1G"
#define IPOD_2G_NAMESTRING              @"iPod touch 2G"
#define IPOD_3G_NAMESTRING              @"iPod touch 3G"
#define IPOD_4G_NAMESTRING              @"iPod touch 4G"
#define IPOD_5G_NAMESTRING              @"iPod touch 5G"
#define IPOD_UNKNOWN_NAMESTRING         @"Unknown iPod"

#define IPAD_1G_NAMESTRING              @"iPad 1G"
#define IPAD_2G_NAMESTRING              @"iPad 2G"
#define IPAD_3G_NAMESTRING              @"iPad 3G"
#define IPAD_4G_NAMESTRING              @"iPad 4G"
#define IPAD_UNKNOWN_NAMESTRING         @"Unknown iPad"

#define APPLETV_2G_NAMESTRING           @"Apple TV 2G"
#define APPLETV_3G_NAMESTRING           @"Apple TV 3G"
#define APPLETV_4G_NAMESTRING           @"Apple TV 4G"
#define APPLETV_UNKNOWN_NAMESTRING      @"Unknown Apple TV"

#define IOS_FAMILY_UNKNOWN_DEVICE       @"Unknown iOS device"

#define SIMULATOR_NAMESTRING            @"iPhone Simulator"
#define SIMULATOR_IPHONE_NAMESTRING     @"iPhone Simulator"
#define SIMULATOR_IPAD_NAMESTRING       @"iPad Simulator"
#define SIMULATOR_APPLETV_NAMESTRING    @"Apple TV Simulator" // :)

typedef enum {
  UIDeviceUnknown,
  
  UIDeviceSimulator,
  UIDeviceSimulatoriPhone,
  UIDeviceSimulatoriPad,
  UIDeviceSimulatorAppleTV,
  
  UIDevice1GiPhone,
  UIDevice3GiPhone,
  UIDevice3GSiPhone,
  UIDevice1GiPod,
  UIDevice2GiPod,
  UIDevice3GiPod,
  UIDevice4GiPod,
  UIDevice5GiPod,
  UIDevice4iPhone,
  
  UIDevice1GiPad,
  UIDevice2GiPad,
  
  
  UIDeviceAppleTV2,
  UIDeviceAppleTV3,
  UIDeviceAppleTV4,
  
  UIDevice4SiPhone,
  UIDevice5iPhone,
  UIDevice5SiPhone,
  UIDevice5CiPhone,
  UIDevice6iPhone,
  UIDevice6PlusiPhone,
  UIDevice3GiPad,
  UIDevice4GiPad,
  
  
  
  UIDeviceUnknowniPhone,
  UIDeviceUnknowniPod,
  UIDeviceUnknowniPad,
  UIDeviceUnknownAppleTV,
  UIDeviceIFPGA,
  
} UIDevicePlatform;
typedef enum
{
  UIDeviceHigh,
  UIDeviceLow,
  UIDeviceMid
}UIDevicePerformance;
typedef enum {
  UIDeviceFamilyiPhone,
  UIDeviceFamilyiPod,
  UIDeviceFamilyiPad,
  UIDeviceFamilyAppleTV,
  UIDeviceFamilyUnknown,
  
} UIDeviceFamily;

typedef enum{
  UIDEVICE_35INCH = 0,
  UIDEVICE_4INCH = 1,
  UIDEVICE_4_7_INCH = 2,
  UIDEVICE_5_5_INCH = 3,
  UIDEVICE_5_8_INCH = 4,
  UIDEVICE_6_5_INCH = 5,
}UIDeviceSreenType;

@interface UIDevice (Hardware)
- (NSString *)platform;
- (NSString *)hwmodel;
- (NSUInteger)platformType;
- (BOOL)isHigerThanIphone4;
- (NSString *)platformString;

- (NSUInteger)cpuFrequency;
- (NSUInteger)busFrequency;
- (NSUInteger)cpuCount;
- (NSUInteger)totalMemory;
- (NSUInteger)userMemory;

- (NSNumber *)totalDiskSpace;
- (NSNumber *)freeDiskSpace;

- (NSString *)macaddress;

- (BOOL)hasRetinaDisplay;
- (UIDeviceFamily)deviceFamily;
- (UIDevicePerformance)performace;
- (BOOL)isIOS7;
- (BOOL)isIOS8;
- (BOOL)isIOS9;
- (BOOL)isIOS10;
- (BOOL)isIOS11;
- (UIDeviceSreenType) screenType;
@end
