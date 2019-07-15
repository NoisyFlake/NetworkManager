#import <ControlCenterUIKit/CCUIToggleModule.h>

@interface CCNetworkManager : CCUIToggleModule
@end

static BOOL getBool(NSString *key);
static NSString* getValue(NSString *key);
static void writeSelectedNetwork();

static void setSelectedNetwork();

typedef void* CTServerConnectionRef;

extern CTServerConnectionRef _CTServerConnectionCreate(CFAllocatorRef, void *, void*);
extern void* _CTServerConnectionSetRATSelection(CTServerConnectionRef, CFStringRef, void*);

extern CFStringRef kCTRegistrationRATSelection0;
#define kGSM kCTRegistrationRATSelection0

extern CFStringRef kCTRegistrationRATSelection1;
#define kUMTS kCTRegistrationRATSelection1

extern CFStringRef kCTRegistrationRATSelection3;
#define kCDMA kCTRegistrationRATSelection3

extern CFStringRef kCTRegistrationRATSelection4;
#define kEVDO kCTRegistrationRATSelection4

extern CFStringRef kCTRegistrationRATSelection6;
#define kLTE kCTRegistrationRATSelection6

extern CFStringRef kCTRegistrationRATSelection7;
#define kAutomatic kCTRegistrationRATSelection7

static void callback() {};
