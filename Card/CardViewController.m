

#import "CardViewController.h"

@interface CardViewController ()

@end

@implementation CardViewController
@synthesize card_view,idtag,card_image,card_scroll;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self showAlert:@"Swipe right to go back "];

    iddata=[[Generic sharedMySingleton].IDArray objectAtIndex:idtag];
    name=[[NSString alloc]init];
    address=[[NSString alloc]init];
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = [dirPaths objectAtIndex:0];
  
    
    UISwipeGestureRecognizer *rightSwipe  =  [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(rightSwipe:)];
    [rightSwipe setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [card_view addGestureRecognizer:rightSwipe];
  
    // Build the path to the database file
    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"bcontacts.sqlite"]];
    
    filemgr = [NSFileManager defaultManager];
    
    if ([filemgr fileExistsAtPath: databasePath ] == NO)
    {
		const char *dbpath = [databasePath UTF8String];
        if (sqlite3_open(dbpath, &Bcontact) == SQLITE_OK)
        {
            char *errMsg;
            const char *sql_stmt = "CREATE TABLE IF NOT EXISTS BCONTACTS (ID INTEGER PRIMARY KEY AUTOINCREMENT, NAME TEXT, MOBNO TEXT, PMAIL TEXT , CMAIL TEXT , SID TEXT , CMPYNAM TEXT , DES TEXT , STREET1 TEXT, STREET2 TEXT ,CITY TEXT ,PIN TEXT,TEL TEXT )";
            
            if (sqlite3_exec(Bcontact, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK)
            {
                [self showAlert:@"Failed to create table."];
            }
            
            sqlite3_close(Bcontact);
            
        }
        else {
            [self showAlert:@"Failed to open/create database."];
        }
    }
    
    
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &Bcontact) == SQLITE_OK)
    {
        querySQL = [NSString stringWithFormat: @"SELECT * FROM BCONTACTS where ID=%@",iddata];

        
        const char *query_stmt = [querySQL UTF8String];
        
        sqlite3_stmt *compiledStatement = NULL;
        int result = sqlite3_prepare_v2(Bcontact, query_stmt, -1, &compiledStatement, NULL) ;
        if( result == SQLITE_OK)
        {
            while(sqlite3_step(compiledStatement) == SQLITE_ROW)
            {
                username = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
                NSString *mobileno = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)];
                NSString *pmailid=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 3)];
                NSString *cmailid = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 4)];
                NSString *skypeid = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 5)];
                NSString *cmpname = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 6)];
                NSString *designation = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 7)];
                NSString *addr1 = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 8)];
                NSString *addr2 = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 9)];
                NSString *cit = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 10)];
                NSString *pincode = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 11)];
                NSString *telno = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 12)];
                
                NSString *addr;
                pmailid=[pmailid stringByTrimmingCharactersInSet:
                        [NSCharacterSet whitespaceCharacterSet]];
                cmailid = [cmailid stringByTrimmingCharactersInSet:
                           [NSCharacterSet whitespaceCharacterSet]];
                skypeid = [skypeid stringByTrimmingCharactersInSet:
                           [NSCharacterSet whitespaceCharacterSet]];
                cmpname = [cmpname stringByTrimmingCharactersInSet:
                           [NSCharacterSet whitespaceCharacterSet]];
                designation = [designation stringByTrimmingCharactersInSet:
                               [NSCharacterSet whitespaceCharacterSet]];
                cit = [cit stringByTrimmingCharactersInSet:
                       [NSCharacterSet whitespaceCharacterSet]];
                pincode = [pincode stringByTrimmingCharactersInSet:
                           [NSCharacterSet whitespaceCharacterSet]];
                telno = [telno stringByTrimmingCharactersInSet:
                         [NSCharacterSet whitespaceCharacterSet]];
              
                if ([addr1 isEqualToString:@"(null)"] && [addr2 isEqualToString:@"(null)"]&& (addr1.length!=0)&& (addr2.length!=0))
                {
                    addr=@"(null)";
                }
               else if ([addr1 isEqualToString:@"(null)"]  && (addr1.length!=0))
                {
                    addr=addr2;
                    
                }
                else if ([addr2 isEqualToString:@"(null)"] && (addr2.length!=0) )
                {
                    addr=addr1;
                }
             
                else if ( (addr1.length!=0)&& (addr2.length!=0)){
                    
                    addr=[NSString stringWithFormat:@"%@ , %@",addr1,addr2];
                }
                addr = [addr stringByTrimmingCharactersInSet:
                        [NSCharacterSet whitespaceCharacterSet]];

    
                if( ![addr isEqualToString:@"(null)"] && (addr.length!=0))
                {
                    name = [name stringByAppendingString:[NSString stringWithFormat:@" %@",addr]];
                    
                }
                
                if ( ![cit isEqualToString:@"(null)"] && (cit.length!=0))
                    
                {
                    name =  [name stringByAppendingString:[NSString stringWithFormat:@"\n %@",cit]];
                }
                
                if ( ![pincode isEqualToString:@"(null)"] && (pincode.length!=0))
                    
                {
                    name =  [name stringByAppendingString:[NSString stringWithFormat:@" - %@",pincode]];
                }
        
                
            label = [[UILabel alloc]initWithFrame:CGRectMake(20, 15, 225, 25)];
            label.text =username;
            label.textColor=[UIColor blackColor];
            label.userInteractionEnabled = YES;
            label.backgroundColor=[UIColor clearColor];
            [label setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16]];
            [card_view addSubview:label];
                
            if( ![designation isEqualToString:@"(null)"] && (designation.length!=0))
            {
            label = [[UILabel alloc]initWithFrame:CGRectMake(20,35, 225, 20)];
            label.text =designation;
            label.textColor=[UIColor darkGrayColor];
            label.userInteractionEnabled = YES;
            label.backgroundColor=[UIColor clearColor];
            [label setFont:[UIFont fontWithName:@"Helvetica" size:15]];
            [card_view addSubview:label];
        
            label = [[UILabel alloc]initWithFrame:CGRectMake(20, 55, 225, 20)];
            label.text =cmpname;
            label.textColor=[UIColor grayColor];
            label.userInteractionEnabled = YES;
            label.backgroundColor=[UIColor clearColor];
            [label setFont:[UIFont fontWithName:@"Helvetica" size:14]];
            [card_view addSubview:label];
            }
            else{
                label = [[UILabel alloc]initWithFrame:CGRectMake(20, 35, 225, 20)];
                label.text =cmpname;
                label.textColor=[UIColor grayColor];
                label.userInteractionEnabled = YES;
                label.backgroundColor=[UIColor clearColor];
                [label setFont:[UIFont fontWithName:@"Helvetica" size:14]];
                [card_view addSubview:label];
            }
                
            rect =CGRectMake(-1, 85, 260, 1);
            imageView = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"sep.png"]];
            [imageView setFrame:rect];
            [card_view addSubview:imageView];
                
                
            rect =CGRectMake(15, 95, 35, 35);
            imageView = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"mobile-icon.png"]];
            [imageView setFrame:rect];
            [card_view addSubview:imageView];
                
            label = [[UILabel alloc]initWithFrame:CGRectMake(60, 100, 185, 20)];
            label.text =mobileno;
            label.textColor=[UIColor blackColor];
            label.userInteractionEnabled = YES;
            label.backgroundColor=[UIColor clearColor];
            [label setFont:[UIFont fontWithName:@"Helvetica" size:15]];
            [card_view addSubview:label];

            rect =CGRectMake(15, 145, 35, 35);
            imageView = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"mail-icon1.png"]];
            [imageView setFrame:rect];
            [card_view addSubview:imageView];
              
            label = [[UILabel alloc]initWithFrame:CGRectMake(60, 140, 180, 35)];
                if( ![cmailid isEqualToString:@"(null)"] && (cmailid.length==0)) {
                    label.text=pmailid;
                }else{
            label.text =cmailid;
                }
            label.textColor=[UIColor blackColor];
            label.numberOfLines=2;
            label.userInteractionEnabled = YES;
            label.backgroundColor=[UIColor clearColor];
            [label setFont:[UIFont fontWithName:@"Helvetica" size:14]];
            [card_view addSubview:label];
          

            if( ![telno isEqualToString:@"(null)"] && (telno.length!=0))
            {
            rect =CGRectMake(15, 195, 35, 35);
            imageView = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"phone-icon.png"]];
            [imageView setFrame:rect];
            [card_view addSubview:imageView];
                
            label = [[UILabel alloc]initWithFrame:CGRectMake(60, 200, 190, 20)];
            label.text =telno;
            label.textColor=[UIColor blackColor];
            label.userInteractionEnabled = YES;
            label.backgroundColor=[UIColor clearColor];
            [label setFont:[UIFont fontWithName:@"Helvetica" size:15]];
            [card_view addSubview:label];
                
            if( ![skypeid isEqualToString:@"(null)"] && (skypeid.length!=0))
            {
            rect =CGRectMake(15, 245, 35, 35);
            imageView = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"skype-icon.png"]];
            [imageView setFrame:rect];
            [card_view addSubview:imageView];
           
            label = [[UILabel alloc]initWithFrame:CGRectMake(60, 250, 190, 20)];
            label.text =skypeid;
            label.textColor=[UIColor blackColor];
            label.userInteractionEnabled = YES;
            label.backgroundColor=[UIColor clearColor];
            [label setFont:[UIFont fontWithName:@"Helvetica" size:15]];
            [card_view addSubview:label];
         
            }}
                
             else  if( ![skypeid isEqualToString:@"(null)"] && (skypeid.length!=0))
                {
                    rect =CGRectMake(15, 195, 35, 35);
                    imageView = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"skype-icon.png"]];
                    [imageView setFrame:rect];
                    [card_view addSubview:imageView];
                    
                    label = [[UILabel alloc]initWithFrame:CGRectMake(60, 200, 190, 20)];
                    label.text =skypeid;
                    label.textColor=[UIColor blackColor];
                    label.userInteractionEnabled = YES;
                    label.backgroundColor=[UIColor clearColor];
                    [label setFont:[UIFont fontWithName:@"Helvetica" size:15]];
                    [card_view addSubview:label];
                    
                }
                
      
             
            if( ![name isEqualToString:@"(null)"] && (name.length!=0))
                {
                    rect =CGRectMake(-1, 285, 260, 1);
                    imageView = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"sep.png"]];
                    [imageView setFrame:rect];
                    [card_view addSubview:imageView];
                    
                    
            rect =CGRectMake(15, 300, 35, 35);
            imageView = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"location-iocn.png"]];
            [imageView setFrame:rect];
            [card_view addSubview:imageView];
                    
            label = [[UILabel alloc]initWithFrame:CGRectMake(60, 285, 190, 60)];
            label.numberOfLines=3;
            label.text =name;
            label.userInteractionEnabled = YES;
            label.textColor=[UIColor blackColor];
            label.backgroundColor=[UIColor clearColor];
            [label setFont:[UIFont fontWithName:@"Helvetica" size:13]];
            [card_view addSubview:label];
           
             }
                

            }
        }
        sqlite3_finalize(compiledStatement);
    }
    
    sqlite3_close(Bcontact);
   

  
}
-(void)viewWillAppear:(BOOL)animated{
    self.trackedViewName = @"CardView Screen";
    [card_view.layer setCornerRadius:0.0f];
    [card_view.layer setBorderColor:[UIColor brownColor].CGColor];
    [card_view.layer setBorderWidth:0.0f];
    [card_view setBackgroundColor:[UIColor clearColor]];
}
-(void)showAlert:(NSString*)text{

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"BCard!"
                                                    message:text
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}




- (void)rightSwipe:(UISwipeGestureRecognizer *)recognizer
{
    CATransition* transition = [CATransition animation];
        transition.duration = .25;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionMoveIn; //kCATransitionMoveIn; //, kCATransitionPush, kCATransitionReveal, kCATransitionFade
        transition.subtype = kCATransitionFromLeft;
    [self.navigationController.view.layer addAnimation:transition
                                                                forKey:kCATransition];
    [self.navigationController pushViewController: [self.storyboard instantiateViewControllerWithIdentifier:@"Contact" ] animated:NO ];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)Sendmail:(id)sender
{
    id<GAITracker> tracker = [[GAI sharedInstance] trackerWithTrackingId:@"UA-47213637-1"];
    [tracker sendEventWithCategory:@"Send Mail" withAction:@"ButtonPress" withLabel:@"SendMail Button" withValue:[NSNumber numberWithInt:105]];
    if (![MFMailComposeViewController canSendMail]) {
        [self showAlert:@"Configure your email"];
        return;
        
    }
    
    UIImage *viewImage;
    UIGraphicsBeginImageContext(card_view.frame.size);
    [card_view.layer setCornerRadius:5.0f];
    [card_view.layer setBorderColor:[UIColor brownColor].CGColor];
    [card_view.layer setBorderWidth:0.5f];
    [card_view setBackgroundColor:[UIColor clearColor]];
	[card_view.layer renderInContext:UIGraphicsGetCurrentContext()];
	viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    picker.mailComposeDelegate = self;
    [picker setSubject:@"My Biz Card"];
    // Set up recipients
    NSArray *toRecipients = [NSArray arrayWithObject:@""];
    NSArray *ccRecipients = [NSArray arrayWithObjects:@"", nil];
    [picker setToRecipients:toRecipients];
    [picker setCcRecipients:ccRecipients];
    //[picker setBccRecipients:bccRecipients];
    
    // Attach an image to the email
   
    NSData *imageData = UIImagePNGRepresentation(viewImage);
    [picker addAttachmentData:imageData mimeType:@"image/png" fileName:[NSString stringWithFormat:@"%@_%@.png",username,iddata]];
    
    NSArray *savePaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [savePaths objectAtIndex:0];
    NSString *savedImagePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_%@.png",username,iddata]];
    filePath = savedImagePath;
    url = [NSURL fileURLWithPath:filePath];
   
    UIGraphicsBeginImageContext(CGSizeMake(160, 160));
	viewImage = UIGraphicsGetImageFromCurrentImageContext();
    viewImage=[UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
    NSData *myData = UIImagePNGRepresentation(viewImage);
    [picker addAttachmentData:myData mimeType:@"image/png" fileName:[NSString stringWithFormat:@"%@_%@.png",username,iddata]];
    
    // Fill out the email body text
    NSString *emailBody = @"Image Sent from My Biz Card";
    [picker setMessageBody:emailBody isHTML:NO];
    [self presentViewController:picker animated:YES completion:nil];
}

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    NSString* str;
    switch (result) {
        case 0:
            str=@"Mail Not Sent.";
            break;
        case 1:
            str=@"Mail Saved in Draft.";
            break;
        case 2:
            str=@"Mail Sent Successfully.";
            break;
        default:
            break;
    }
    // NEVER REACHES THIS PLACE
    [ self dismissViewControllerAnimated:YES completion:nil];
    [self showAlert:str];
}





@end
