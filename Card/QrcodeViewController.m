

#import "QrcodeViewController.h"
#import "Generic.h"

@interface QrcodeViewController ()

@end

@implementation QrcodeViewController
@synthesize Qr_scroll,qr_id;
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
  

    UIButton* sendmail = [UIButton buttonWithType:UIButtonTypeCustom];
    if ([UIScreen mainScreen].bounds.size.height == 568)
      sendmail.frame = CGRectMake(50,467,220, 44);
     else
      sendmail.frame = CGRectMake(50,387,220, 44);
    
    [sendmail setTitle:@"Send Mail" forState:UIControlStateNormal];
    [sendmail setTitleColor:[UIColor colorWithRed:85.0/255.0 green:85.0/255.0 blue:85.0/255.0 alpha:1] forState:UIControlStateNormal];
    [sendmail setBackgroundImage:[UIImage imageNamed:@"Business-card-Button1.png"] forState:UIControlStateNormal];
    [sendmail setBackgroundImage:[UIImage imageNamed:@"Business-card-Button-Hover.png"] forState:UIControlStateHighlighted];
    [sendmail addTarget:self action:@selector(sendMail) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sendmail];
 
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = [dirPaths objectAtIndex:0];
    
    // Build the path to the database file
    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"bcontacts.sqlite"]];
    
   filemgr = [NSFileManager defaultManager];
    
    if ([filemgr fileExistsAtPath: databasePath ] == NO)
    {
		const char *dbpath = [databasePath UTF8String];
        if (sqlite3_open(dbpath, &Bcontact) == SQLITE_OK)
        {
            char *errMsg;
            const char *sql_stmt = "CREATE TABLE IF NOT EXISTS BCONTACTS (ID INTEGER PRIMARY KEY AUTOINCREMENT, NAME TEXT, MOBNO TEXT, PMAIL TEXT , CMAIL TEXT , SID TEXT , CMPYNAM TEXT , DES TEXT , STREET1 TEXT, STREET2 TEXT ,CITY TEXT ,PIN TEXT,TEL TEXT , COUNTRY TEXT)";
            
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
       querySQL = [NSString stringWithFormat: @"SELECT name FROM BCONTACTS where ID=%d",qr_id];
        
        const char *query_stmt = [querySQL UTF8String];
        
        sqlite3_stmt *compiledStatement = NULL;
        int result = sqlite3_prepare_v2(Bcontact, query_stmt, -1, &compiledStatement, NULL) ;
        if( result == SQLITE_OK)
        {
            while(sqlite3_step(compiledStatement) == SQLITE_ROW)
            {
                name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
              
            }
        }
        sqlite3_finalize(compiledStatement);
    }
    sqlite3_close(Bcontact);
    bookThumb=[[Generic sharedMySingleton].ContactARRAY sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];

    Aindex = [bookThumb indexOfObject:[NSString stringWithFormat:@"%@_%d",name,qr_id]];
    nav = Aindex*220;
    cont_name=[[NSMutableArray alloc]init];
    com_name=[[NSMutableArray alloc]init];

 
    [self loadcontact];
    for (int i=0; i<[Generic sharedMySingleton].ContactARRAY.count; i++) {
       
       
        label = [[UILabel alloc]initWithFrame:CGRectMake((i*220)+5,5,220,20)];
        label.text= [NSString stringWithFormat:@"%@ ",[cont_name objectAtIndex:i]];
        label.textAlignment=1;
        label.numberOfLines=1;
        label.backgroundColor=[UIColor clearColor];
        label.textColor = [UIColor whiteColor];
        label.font =[UIFont fontWithName:@"Heiti TC Medium" size:23.0];
        [Qr_scroll  addSubview:label];
        
        label = [[UILabel alloc]initWithFrame:CGRectMake((i*220)+5,30,220,20)];
        label.text= [NSString stringWithFormat:@"%@ ",[com_name objectAtIndex:i]];
        label.textAlignment=1;
        label.numberOfLines=1;
         label.backgroundColor=[UIColor clearColor];
        label.textColor = [UIColor whiteColor];
        label.font =[UIFont fontWithName:@"Heiti TC Medium" size:20.0];
        [Qr_scroll  addSubview:label];
        
        if ([UIScreen mainScreen].bounds.size.height == 568)
            rect =CGRectMake((i*220)+15, 85, 184, 220);
        else
            rect =CGRectMake((i*220)+16, 70, 184, 180);
        
        imageView = [[UIImageView alloc]init];
        [imageView setFrame:rect];
        NSArray *savePaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [savePaths objectAtIndex:0];
        NSString *savedImagePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",bookThumb[i]]];
        filePath = savedImagePath;
        url = [NSURL fileURLWithPath:filePath];
        [imageView setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:url]]];
        Qr_scroll.pagingEnabled=YES;
        [ Qr_scroll setDelegate:self];
        [Qr_scroll addSubview:imageView];
        NSLog(@"%@",filePath);
    }
  
    [Qr_scroll setContentSize:CGSizeMake(220*[Generic sharedMySingleton].ContactARRAY.count,220)];
    [Qr_scroll setContentOffset:CGPointMake((Aindex*220), 0) animated:YES];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     self.trackedViewName = @"ScanVcard Screen";
   }
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if([scrollView isEqual:Qr_scroll]) {
        CGPoint offset = Qr_scroll.contentOffset;
        offset.x = Qr_scroll.contentOffset.x;
        nav=offset.x;
        [Qr_scroll setContentOffset:CGPointMake(nav, 0) animated:YES];
    }
}

-(void)loadcontact
{
    
    [cont_name removeAllObjects];
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &Bcontact) == SQLITE_OK)
    {
        querySQL = [NSString stringWithFormat: @"SELECT name,cmpynam FROM BCONTACTS ORDER BY name COLLATE NOCASE"];
        
        const char *query_stmt = [querySQL UTF8String];
        
        sqlite3_stmt *compiledStatement = NULL;
        int result = sqlite3_prepare_v2(Bcontact, query_stmt, -1, &compiledStatement, NULL) ;
        if( result == SQLITE_OK)
        {
            while(sqlite3_step(compiledStatement) == SQLITE_ROW)
            {
               
                usernamedb = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
                [cont_name addObject:usernamedb];
                usernamedb = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
                [com_name addObject:usernamedb];
            }
        }
        sqlite3_finalize(compiledStatement);
    }
    sqlite3_close(Bcontact);
}




-(void)sendMail{
   
     id<GAITracker> tracker = [[GAI sharedInstance] trackerWithTrackingId:@"UA-47213637-1"];
    [tracker sendEventWithCategory:@"SendMail QRCode" withAction:@"ButtonPress" withLabel:@"SendMailQRCode Button" withValue:[NSNumber numberWithInt:106]];
    if (![MFMailComposeViewController canSendMail]) {
        [self showAlert:@"Configure your email"];
        return;
        
    }
   UIGraphicsBeginImageContext(CGSizeMake(190, 190));
	viewImage = UIGraphicsGetImageFromCurrentImageContext();
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    picker.mailComposeDelegate = self;
    [picker setSubject:@"My Biz Card "];
    // Set up recipients
    NSArray *toRecipients = [NSArray arrayWithObject:@""];
    NSArray *ccRecipients = [NSArray arrayWithObjects:@"", nil];
    [picker setToRecipients:toRecipients];
    [picker setCcRecipients:ccRecipients];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,     NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *getImagePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_%@.png",[Generic sharedMySingleton].NameARRAY[(nav/220)],[Generic sharedMySingleton].IDArray[(nav/220)]]];
    filePath = getImagePath;
    url = [NSURL fileURLWithPath:filePath];
    viewImage=[UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
    NSData *myData = UIImagePNGRepresentation(viewImage);
    [picker addAttachmentData:myData mimeType:@"image/png" fileName:[NSString stringWithFormat:@"%@_%@.png",[Generic sharedMySingleton].NameARRAY[(nav/220)],[Generic sharedMySingleton].IDArray[(nav/220)]]];
    

    // Fill out the email body text
    NSString *emailBody = [NSString stringWithFormat:@"Please find Qrcode"];
    
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



-(void)showAlert:(NSString*)text{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"BCard!"
                                                    message:text
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
