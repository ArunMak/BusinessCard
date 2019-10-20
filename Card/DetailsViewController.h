

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <sqlite3.h>
#import "Generic.h"
#import "GAITrackedViewController.h"
#import "GAI.h"
@interface DetailsViewController : GAITrackedViewController<UITextFieldDelegate>
{
    
    sqlite3 *Bcontact;
    UITextField* Fname, *mobno, * pmail, *cmail, * sid, *cmpyname, *designation, *strt1, *strt2,*cityname,*pin,*tel;
    NSArray *dirPaths;
    NSString *string;
    NSFileManager *filemgr;
    UIImageView *imageView;
    UILabel *label;
}
@property (strong, nonatomic) IBOutlet UIScrollView *carddetail_scroll;
@property(nonatomic,retain)    NSMutableArray *contact , *tablecontact;
@property (nonatomic,retain) IBOutlet UIImageView *imageView;
@property(nonatomic ,retain)NSString *databasePath ,*docsDir, *card_id ,*idtag,*name,*mobile,* personal_mail,*company_mail,*company_name,*street_work,*street1,*street2,*city ,* pincode,*telephone,*designatn,* address;
@end
