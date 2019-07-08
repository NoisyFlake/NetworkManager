#import "CCNetworkManager.h"

NSMutableDictionary *prefs, *defaultPrefs;
int selectedNetwork = 0;

@implementation CCNetworkManager

- (UIImage *)iconGlyph {
  UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
  label.textColor = [UIColor blackColor];
  label.backgroundColor=[UIColor clearColor];
  label.baselineAdjustment = UIBaselineAdjustmentAlignBaselines; // or UIBaselineAdjustmentAlignCenters, or UIBaselineAdjustmentNone
  label.adjustsFontSizeToFitWidth = YES;
  label.minimumScaleFactor = 10.0f/12.0f;
  label.clipsToBounds = YES;
  label.textAlignment = NSTextAlignmentCenter;

  if (selectedNetwork == 0) {
    label.font = [label.font fontWithSize:12];
    label.text = @"Auto\nNetwork";
    label.numberOfLines = 2;
  } else {
    label.font = [label.font fontWithSize:25];
    label.numberOfLines = 1;
  }

  if (selectedNetwork == 1) label.text= @"2G";
  if (selectedNetwork == 2) label.text= @"3G";
  if (selectedNetwork == 3) label.text= @"LTE";

  UIGraphicsBeginImageContextWithOptions(label.bounds.size, NO, 0.0);  // high res
  [[label layer] renderInContext: UIGraphicsGetCurrentContext()];
  UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();

  return image;
}

- (UIColor *)selectedColor {
  return [UIColor colorWithRed:1.00 green:0.58 blue:0.00 alpha:1.0];
}

- (BOOL)isSelected {
  return selectedNetwork > 0;
}

- (void)setSelected:(BOOL)selected {
  if (selectedNetwork == 0) {
    if (getBool(@"enable2G")) {
      selectedNetwork = 1;
    } else if (getBool(@"enable3G")) {
      selectedNetwork = 2;
    } else if (getBool(@"enableLTE")) {
      selectedNetwork = 3;
    }
  } else if (selectedNetwork == 1) {
    if (getBool(@"enable3G")) {
      selectedNetwork = 2;
    } else if (getBool(@"enableLTE")) {
      selectedNetwork = 3;
    } else {
      selectedNetwork = 0;
    }
  } else if (selectedNetwork == 2) {
    if (getBool(@"enableLTE")) {
      selectedNetwork = 3;
    } else {
      selectedNetwork = 0;
    }
  } else if (selectedNetwork == 3) {
    selectedNetwork = 0;
  }

  setSelectedNetwork();
  writeSelectedNetwork();

  [super reconfigureView];
}

@end

static void setSelectedNetwork() {
  CTServerConnectionRef cn = _CTServerConnectionCreate(kCFAllocatorDefault, callback, NULL);

  if (selectedNetwork == 0) {
    _CTServerConnectionSetRATSelection(cn, kAutomatic, 0);
  } else if (selectedNetwork == 1) {
      _CTServerConnectionSetRATSelection(cn, kGSM, 0);
  } else if (selectedNetwork == 2) {
      _CTServerConnectionSetRATSelection(cn, kUMTS, 0);
  } else if (selectedNetwork == 3) {
      _CTServerConnectionSetRATSelection(cn, kLTE, 0);
  }
}

// ----- PREFERENCE HANDLING ----- //

static BOOL getBool(NSString *key) {
  id ret = [prefs objectForKey:key];

  if(ret == nil) {
    ret = [defaultPrefs objectForKey:key];
  }

  return [ret boolValue];
}

static void writeSelectedNetwork() {
  [prefs setObject:[NSNumber numberWithInt:selectedNetwork] forKey:@"selectedNetwork"];
  [prefs writeToFile:@"/User/Library/Preferences/com.noisyflake.networkmanager.plist" atomically:YES];
}

static void loadPrefs() {
  prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.noisyflake.networkmanager.plist"];
  selectedNetwork = [[prefs objectForKey:@"selectedNetwork"] ?: [defaultPrefs objectForKey:@"selectedNetwork"] intValue];
}

static void initPrefs() {
  // Copy the default preferences file when the actual preference file doesn't exist
  NSString *path = @"/User/Library/Preferences/com.noisyflake.networkmanager.plist";
  NSString *pathDefault = @"/Library/PreferenceBundles/NetworkManagerPrefs.bundle/defaults.plist";
  NSFileManager *fileManager = [NSFileManager defaultManager];
  if (![fileManager fileExistsAtPath:path]) {
    [fileManager copyItemAtPath:pathDefault toPath:path error:nil];
  }

  defaultPrefs = [[NSMutableDictionary alloc] initWithContentsOfFile:pathDefault];

  CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)loadPrefs, CFSTR("com.noisyflake.networkmanager/prefsupdated"), NULL, CFNotificationSuspensionBehaviorCoalesce);
}

%ctor {
  initPrefs();
  loadPrefs();
}
