

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "QrcodeViewController.h"
#import "CardViewController.h"
#import "Generic.h"
#import "CustomCellCell.h"
#import "CardViewController.h"
#import "GAI.h"
#import "GAITrackedViewController.h"
@interface ContactViewController : GAITrackedViewController<NSFileManagerDelegate,MFMailComposeViewControllerDelegate>
{
    sqlite3 *Bcontact;
    NSString *docsDir,*databasePath;
    NSArray *dirPaths;
    NSString* filePath,*usernamedb,*strRecord;
    NSString *name,*querySQL;
    int db_id;
    BOOL table_bool;
    NSFileManager *fileManager;
    NSData *myData;
}
@property (strong, nonatomic) IBOutlet UITableView *contact_tableview;
@property(nonatomic,retain)    NSMutableArray *contact,*cont_id,*description;
@property (nonatomic, retain) MFMailComposeViewController *mfMailComposeViewController;
@property (strong, nonatomic) IBOutlet UILabel *Inform_label;

@end
