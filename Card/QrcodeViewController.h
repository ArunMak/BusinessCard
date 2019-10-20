

#import <UIKit/UIKit.h>
#import "Generic.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import <sqlite3.h>
#import <CoreGraphics/CoreGraphics.h>
#import <QuartzCore/QuartzCore.h>
#import "GAITrackedViewController.h"
#import "GAI.h"
@interface QrcodeViewController : GAITrackedViewController<NSFileManagerDelegate,MFMailComposeViewControllerDelegate,UIScrollViewDelegate>

{
    int nav,qr_id;
    NSURL *url;
    NSString* filePath;
    UIImage *viewImage;
    UILabel *label;
    NSMutableArray *cont_name ,*com_name;
    sqlite3 *Bcontact;
    NSString *docsDir;
    NSArray *dirPaths;
    NSString *databasePath;
    NSString *usernamedb,*name;
    NSInteger Aindex;
    UIImageView *imageView;
    CGRect rect ;
    NSFileManager *filemgr;
    NSString *querySQL;
     NSArray* bookThumb;
}
@property (strong, nonatomic) IBOutlet UIScrollView *Qr_scroll;
@property(nonatomic)int qr_id;


@end
