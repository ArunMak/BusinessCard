

#import <UIKit/UIKit.h>
#import "Generic.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import <sqlite3.h>
#import <CoreGraphics/CoreGraphics.h>
#import <QuartzCore/QuartzCore.h>
#import "GAI.h"
#import "GAITrackedViewController.h"
@interface CardViewController : GAITrackedViewController<NSFileManagerDelegate,MFMailComposeViewControllerDelegate>{
    sqlite3 *Bcontact;
    NSString *docsDir;
    NSArray *dirPaths;
    NSString *databasePath,*name,*address;
    UILabel *label;
    NSNumber *iddata;
    NSURL *url;
    NSString* filePath;
    NSString *username ,*querySQL;
    NSFileManager *filemgr;
    UIImageView *imageView;
    CGRect rect ;
}
@property (strong, nonatomic) IBOutlet UIView *card_view;
@property (nonatomic) int idtag;
- (IBAction)Sendmail:(id)sender;
@property (strong, nonatomic) IBOutlet UIImageView *card_image;
@property (strong, nonatomic) IBOutlet UIScrollView *card_scroll;

@end
