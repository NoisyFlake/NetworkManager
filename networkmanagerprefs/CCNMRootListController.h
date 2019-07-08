#import <Preferences/PSListController.h>
#import <Preferences/PSSpecifier.h>

@interface CCNMRootListController : PSListController

@end

@interface CCNMRedditCell : PSTableCell
@property (nonatomic, retain) NSBundle *bundle;
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier specifier:(PSSpecifier *)specifier;
- (void)openReddit;
@end

@interface CCNMTwitterCell : PSTableCell
@property (nonatomic, retain) NSBundle *bundle;
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier specifier:(PSSpecifier *)specifier;
- (void)openTwitter;
@end

@interface NetworkManagerLogo : PSTableCell {
	UILabel *background;
	UILabel *tweakName;
	UILabel *version;
}
@end
