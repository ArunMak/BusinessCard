

#import "ContactViewController.h"

@interface ContactViewController ()

@end

@implementation ContactViewController
@synthesize contact_tableview,contact,cont_id,description,Inform_label;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.trackedViewName = @"ContactList Screen";
    contact_tableview.backgroundColor=[UIColor clearColor];
    contact_tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
   

    contact =[[NSMutableArray alloc]init];
    cont_id=[[NSMutableArray alloc]init];
    description=[[NSMutableArray alloc]init];
    strRecord=[[NSString alloc]init];

    
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = [dirPaths objectAtIndex:0];
    // Build the path to the database file
    
    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"bcontacts.sqlite"]];
    
    fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath: databasePath ] == NO)
    {
        
		const char *dbpath = [databasePath UTF8String];
        
        if (sqlite3_open(dbpath, &Bcontact) == SQLITE_OK)
        {
            char *errMsg;
            const char *sql_stmt = "CREATE TABLE IF NOT EXISTS VCONTACTS (ID INTEGER PRIMARY KEY AUTOINCREMENT, NAME TEXT, MOBNO TEXT, PMAIL TEXT , CMAIL TEXT , SID TEXT , CMPYNAM TEXT , DES TEXT , STREET1 TEXT, STREET2 TEXT ,CITY TEXT ,PIN TEXT,TEL TEXT )";
            
            if (sqlite3_exec(Bcontact, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK)
            {
                [self showAlert:@"Failed to create table."];            }
            
            sqlite3_close(Bcontact);
            
            
        } else {
            [self showAlert:@"Failed to open/create database."];
        }
    }
   
    [self loadcontact];
}

-(void)loadcontact
{
  
    [[Generic sharedMySingleton].IDArray removeAllObjects];
    [[Generic sharedMySingleton].NameARRAY  removeAllObjects];
    [contact removeAllObjects];
  
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &Bcontact) == SQLITE_OK)
    {
        querySQL = [NSString stringWithFormat: @"SELECT id,name,cmpynam FROM BCONTACTS  ORDER BY name COLLATE NOCASE"];
        
        const char *query_stmt = [querySQL UTF8String];
        
        sqlite3_stmt *compiledStatement = NULL;
        int result = sqlite3_prepare_v2(Bcontact, query_stmt, -1, &compiledStatement, NULL) ;
        if( result == SQLITE_OK)
        {
            while(sqlite3_step(compiledStatement) == SQLITE_ROW)
            {
                usernamedb = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
               
                [[Generic sharedMySingleton].IDArray addObject:usernamedb];
                usernamedb = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
                [contact addObject:usernamedb];
                [[Generic sharedMySingleton].NameARRAY addObject:usernamedb];
                usernamedb = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)];
                [description addObject:usernamedb];
    
            }
        }
        sqlite3_finalize(compiledStatement);
    }
    sqlite3_close(Bcontact);
     [contact_tableview reloadData];
   
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // We only have one section
   
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    table_bool = YES;
     Inform_label.hidden = NO;
    if ([contact count]!= 0) {
        Inform_label.hidden = YES;
    }
    return [contact count];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    return  130;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    CustomCellCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.userInteractionEnabled = YES;
    if(cell==nil){
        cell = [[CustomCellCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    cell.backgroundView = [[UIImageView alloc] initWithImage:[ [UIImage imageNamed:@"Listview-BG.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:5.0] ];
    cell.backgroundColor=[UIColor clearColor];
   // cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Listview-BG.png"]] ;
    NSString *cellValue = [contact objectAtIndex:indexPath.row];
    NSString *descriptionvalue=[description objectAtIndex:indexPath.row];
    cell.primaryLabel.text =cellValue;
    cell.detailedLabel.text=descriptionvalue;
    cell.mailbutton.tag=[[[Generic sharedMySingleton].IDArray objectAtIndex:indexPath.row]intValue];
    [cell.mailbutton addTarget:self action:@selector(sendMail:) forControlEvents:UIControlEventTouchUpInside];
    cell.qrbutton.tag=[[[Generic sharedMySingleton].IDArray objectAtIndex:indexPath.row]intValue];
    [cell.qrbutton addTarget:self action:@selector(sendQrpic:) forControlEvents:UIControlEventTouchUpInside];
    cell.delbutton.tag=[[[Generic sharedMySingleton].IDArray objectAtIndex:indexPath.row]intValue];
    [cell.delbutton addTarget:self action:@selector(deleteDB:) forControlEvents:UIControlEventTouchUpInside];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    id<GAITracker> tracker = [[GAI sharedInstance] trackerWithTrackingId:@"UA-47213637-1"];
    [tracker sendEventWithCategory:@"Contact Tap" withAction:@"ButtonPress" withLabel:@"Contact Tap Button" withValue:[NSNumber numberWithInt:104]];
    CardViewController *category = [self.storyboard instantiateViewControllerWithIdentifier:@"CardView"];
    category.idtag=indexPath.row;
    [self.navigationController pushViewController:category  animated:YES];
}


-(void)sendMail:(id)sender
{
     id<GAITracker> tracker = [[GAI sharedInstance] trackerWithTrackingId:@"UA-47213637-1"];
    [tracker sendEventWithCategory:@"SendMail" withAction:@"ButtonPress" withLabel:@"SendMail Button" withValue:[NSNumber numberWithInt:101]];
    if (![MFMailComposeViewController canSendMail]) {
        [self showAlert:@"Configure your email"];
        return;

    }
    UIButton* button = (UIButton*)sender;
     db_id = button.tag;
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &Bcontact) == SQLITE_OK)
    {
      querySQL = [NSString stringWithFormat: @"SELECT name FROM BCONTACTS where ID=%d",db_id];
        
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

    
    
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    picker.mailComposeDelegate = self;
    [picker setSubject:@"My Biz Card"];
    // Set up recipients
    NSArray *toRecipients = [NSArray arrayWithObject:@""];
    NSArray *ccRecipients = [NSArray arrayWithObjects:@"", nil];
    [picker setToRecipients:toRecipients];
    [picker setCcRecipients:ccRecipients];
    // Fill out the email body text
    NSString *emailBody =@"Please Find the attached Vcard.";
    
    
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,     NSUserDomainMask, YES);
    
   docsDir = [dirPaths objectAtIndex:0];
   filePath = [docsDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_%d.vcf",name,db_id]];
  
    myData = [NSData dataWithContentsOfFile:filePath];
    [picker addAttachmentData:myData mimeType:@"text/x-vcard" fileName:[NSString stringWithFormat:@"%@_%d.vcf",name,db_id]];
    [picker setMessageBody:emailBody isHTML:NO];
    [self presentViewController:picker animated:YES completion:nil];
   

    // Fill out the email body text
  
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
   
    [self dismissViewControllerAnimated:YES completion:nil];
    [self showAlert:str];
}
-(void)deleteDB :(id)sender
{
    
     id<GAITracker> tracker = [[GAI sharedInstance] trackerWithTrackingId:@"UA-47213637-1"];
    [tracker sendEventWithCategory:@"DeleteContact" withAction:@"ButtonPress" withLabel:@"Delete Button" withValue:[NSNumber numberWithInt:102]];
    UIButton* button = (UIButton*)sender;
    db_id = button.tag;
   [self showAlert1:@"Are you sure. you want to delete contact from the List"];
}
-(void)deletedata{

    const char *dbpath = [databasePath UTF8String];
   
    
    if (sqlite3_open(dbpath, &Bcontact) == SQLITE_OK)
    {
       querySQL = [NSString stringWithFormat: @"SELECT name FROM BCONTACTS where ID=%d",db_id];
        
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
    
    
    if (sqlite3_open(dbpath , &Bcontact) == SQLITE_OK) {
        
        querySQL = [NSString stringWithFormat: @"DELETE  FROM BCONTACTS where ID =\"%d\"",db_id];
        
         sqlite3_stmt    *statement = NULL;
        const char *query_stmt = [querySQL UTF8String];
        
        sqlite3_prepare_v2(Bcontact,  query_stmt, -1, & statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            
        } else {
            
        }
        sqlite3_finalize(statement);
        sqlite3_close(Bcontact);
        
        
    }
    fileManager = [NSFileManager defaultManager];
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,     NSUserDomainMask, YES);
    docsDir = [dirPaths objectAtIndex:0];
    filePath = [docsDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_%d.png",name,db_id]];
    [fileManager removeItemAtPath:filePath error:NULL];
    [[Generic sharedMySingleton].ContactARRAY removeObject:[NSString stringWithFormat:@"%@_%d",name,db_id]];
    [[Generic sharedMySingleton].content setObject:[Generic sharedMySingleton].ContactARRAY  forKey:@"QRPicname"];
    
 
    fileManager = [NSFileManager defaultManager];
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,     NSUserDomainMask, YES);
    docsDir = [dirPaths objectAtIndex:0];
    filePath = [docsDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_%d.vcf",name,db_id]];
    [fileManager removeItemAtPath:filePath error:NULL];
    [[Generic sharedMySingleton].CardARRAY removeObject:[NSString stringWithFormat:@"%@_%d",name,db_id]];
    [[Generic sharedMySingleton].filename setObject:[Generic sharedMySingleton].CardARRAY  forKey:@"Filename"];    
    [self loadcontact];
    [contact_tableview reloadData];
    [self viewWillAppear:YES ];
}


-(void)sendQrpic:(id)sender
{
    id<GAITracker> tracker = [[GAI sharedInstance] trackerWithTrackingId:@"UA-47213637-1"];
    [tracker sendEventWithCategory:@"QRCode create" withAction:@"ButtonPress" withLabel:@"ORCode Button" withValue:[NSNumber numberWithInt:103]];
    UIButton* button = (UIButton*)sender;
    QrcodeViewController *category =[self.storyboard instantiateViewControllerWithIdentifier:@"QRView"];
    category.qr_id = button.tag;
    [self.navigationController pushViewController:category  animated:YES];

}


-(void)showAlert:(NSString*)text{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"My Biz Card"
                                                    message:text
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}
-(void)showAlert1:(NSString*)text{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"My Biz Card"
                                                    message:text
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:@"Cancel",nil];
    [alert show];
}


- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    // the user clicked one of the OK/Cancel buttons
    if (buttonIndex == 0)
    {
        [self deletedata];
               
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
