

#import "DetailsViewController.h"
#import "sqlite3.h"
#import "Barcode.h"
#import "FileManager.h"
#import "ViewController.h"
@interface DetailsViewController ()

@end

@implementation DetailsViewController
@synthesize carddetail_scroll,contact,tablecontact,imageView,databasePath,docsDir,card_id,idtag,name,mobile,personal_mail,company_mail,company_name,street_work,street1,street2,city,pincode,telephone,designatn,address;

- (void)viewDidLoad
{
    [super viewDidLoad];
    name = [[NSString alloc]init];
    mobile = [[NSString alloc]init];
    personal_mail =[[NSString alloc]init];
    company_mail =[[NSString alloc]init];
    company_name =[[NSString alloc]init];
    street_work=[[NSString alloc]init];
    street1 =[[NSString alloc]init];
    street2 =[[NSString alloc]init];
    city =[[NSString alloc]init];
    pincode =[[NSString alloc]init];
    telephone =[[NSString alloc]init];
    designatn =[[NSString alloc]init];
    address=[[NSString alloc]init];
   
    // Get the documents directory
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
 
    [self loadCardDetails];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     self.trackedViewName = @"Card Details Screen";
    
}

-(void)loadCardDetails{
    CGRect rect;
    UIView* cardDetails;
    
    rect = CGRectMake(10,5, 300, 950);
    cardDetails = [[UIView alloc]init];
    [cardDetails setFrame:rect];
    [cardDetails.layer setBorderColor: [[UIColor blackColor] CGColor]];
    
       
    Fname = [[UITextField alloc]initWithFrame:CGRectMake(20, 10, 260, 45)];
    Fname.borderStyle = UITextBorderStyleRoundedRect;
    Fname.returnKeyType =UIReturnKeyNext;
    Fname.placeholder=@"Name *";
    Fname.tag=101;
    Fname.delegate=self;
    Fname.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [cardDetails addSubview:Fname];
    
        
    mobno = [[UITextField alloc]initWithFrame:CGRectMake(20, 75, 260, 45)];
    mobno.borderStyle = UITextBorderStyleRoundedRect;
    mobno.placeholder=@"Mobile Number *";
    mobno.returnKeyType = UIReturnKeyNext;
    mobno.keyboardType=UIKeyboardTypePhonePad;
    mobno.tag=102;
    mobno.delegate = self;
    mobno.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [cardDetails addSubview:mobno];
    
   
    
    pmail = [[UITextField alloc]initWithFrame:CGRectMake(20, 140, 260, 45)];
    pmail.borderStyle = UITextBorderStyleRoundedRect;
    pmail.placeholder=@"Personal Email Id";
    pmail.keyboardType = UIKeyboardTypeEmailAddress;
    pmail.returnKeyType = UIReturnKeyNext;
    pmail.tag=103;
    pmail.delegate = self;
    pmail.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [cardDetails addSubview:pmail];
    
    
    
    cmail = [[UITextField alloc]initWithFrame:CGRectMake(20, 205, 260, 45)];
    cmail.borderStyle = UITextBorderStyleRoundedRect;
    cmail.placeholder=@"Company Email Id";
    cmail.keyboardType = UIKeyboardTypeEmailAddress;
    cmail.returnKeyType = UIReturnKeyNext;
    cmail.tag=104;
    cmail.delegate = self;
    cmail.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [cardDetails addSubview:cmail];
    
    
    sid = [[UITextField alloc]initWithFrame:CGRectMake(20, 270, 260, 45)];
    sid.borderStyle = UITextBorderStyleRoundedRect;
    sid.placeholder=@"Skype Id";
    sid.returnKeyType = UIReturnKeyNext;
    sid.tag=105;
    sid.delegate = self;
    sid.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [cardDetails addSubview:sid];
    
  
        
    cmpyname = [[UITextField alloc]initWithFrame:CGRectMake(20, 335, 260, 45)];
    cmpyname.borderStyle = UITextBorderStyleRoundedRect;
    cmpyname.placeholder=@"Company Name *";
    cmpyname.returnKeyType = UIReturnKeyNext;
    cmpyname.tag=106;
    cmpyname.delegate = self;
    cmpyname.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [cardDetails addSubview:cmpyname];
    
  
    
    designation = [[UITextField alloc]initWithFrame:CGRectMake(20, 400, 260, 45)];
    designation.borderStyle = UITextBorderStyleRoundedRect;
    designation.placeholder=@"Designation";
    designation.returnKeyType = UIReturnKeyNext;
    designation.tag=107;
    designation.delegate = self;
    designation.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [cardDetails addSubview:designation];
  
   
    
    strt1 = [[UITextField alloc]initWithFrame:CGRectMake(20,465, 260, 45)];
    strt1.borderStyle = UITextBorderStyleRoundedRect;
    strt1.placeholder=@"Door No and Details";
    strt1.returnKeyType = UIReturnKeyNext;
    strt1.tag=108;
    strt1.delegate = self;
    strt1.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [cardDetails addSubview:strt1];
    

    
    strt2 = [[UITextField alloc]initWithFrame:CGRectMake(20, 530, 260, 45)];
    strt2.borderStyle = UITextBorderStyleRoundedRect;
    strt2.placeholder=@"Street Name";
    strt2.returnKeyType = UIReturnKeyNext;
    strt2.tag=109;
    strt2.delegate = self;
    strt2.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [cardDetails addSubview:strt2];
    

    
    cityname = [[UITextField alloc]initWithFrame:CGRectMake(20,595, 260, 45)];
    cityname.borderStyle = UITextBorderStyleRoundedRect;
    cityname.placeholder=@"City";
    cityname.returnKeyType = UIReturnKeyNext;
    cityname.tag=110;
    cityname.delegate = self;
    cityname.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [cardDetails addSubview:cityname];
    
 
    
    pin = [[UITextField alloc]initWithFrame:CGRectMake(20, 660, 260, 45)];
    pin.borderStyle = UITextBorderStyleRoundedRect;
    pin.placeholder=@"Pincode";
    pin.returnKeyType = UIReturnKeyNext;
    pin.tag=111;
    pin.delegate = self;
    pin.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [cardDetails addSubview:pin];
    
 

    
    tel = [[UITextField alloc]initWithFrame:CGRectMake(20, 725, 260, 45)];
    tel.borderStyle = UITextBorderStyleRoundedRect;
    tel.placeholder=@"Telephone No";
    tel.keyboardType=UIKeyboardTypeNamePhonePad;
    tel.returnKeyType = UIReturnKeyDone;
    tel.tag=112;
    tel.delegate = self;
    tel.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [cardDetails addSubview:tel];
    
    
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(20, 815,260, 40);
    [button setTitle:@"Create Business Card" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithRed:85.0/255.0 green:85.0/255.0 blue:85.0/255.0 alpha:1] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"Business-card-Button1.png"] forState:UIControlStateNormal];
      [button setBackgroundImage:[UIImage imageNamed:@"Business-card-Button-Hover.png"] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(store) forControlEvents:UIControlEventTouchUpInside];
    [cardDetails addSubview:button];
    

    
    [carddetail_scroll addSubview:cardDetails];
    [carddetail_scroll setContentSize:CGSizeMake(300,1000)];
}

-(BOOL)validate
{
    bool boolval=YES;
    
    name=Fname.text;
    mobile=mobno.text;
    personal_mail=pmail.text;
    company_mail=cmail.text;
    designatn=designation.text;
    company_name=cmpyname.text;
    street1=strt1.text;
    street2=strt2.text;
    city=cityname.text;
    pincode=pin.text;
    telephone=tel.text;
    name = [name stringByTrimmingCharactersInSet:
            [NSCharacterSet whitespaceCharacterSet]];
    mobile = [mobile stringByTrimmingCharactersInSet:
            [NSCharacterSet whitespaceCharacterSet]];
    personal_mail = [personal_mail stringByTrimmingCharactersInSet:
                     [NSCharacterSet whitespaceCharacterSet]];
    company_mail = [company_mail stringByTrimmingCharactersInSet:
            [NSCharacterSet whitespaceCharacterSet]];
    designatn = [designatn stringByTrimmingCharactersInSet:
            [NSCharacterSet whitespaceCharacterSet]];
    company_name = [company_name stringByTrimmingCharactersInSet:
            [NSCharacterSet whitespaceCharacterSet]];
    city = [city stringByTrimmingCharactersInSet:
            [NSCharacterSet whitespaceCharacterSet]];
    pincode = [pincode stringByTrimmingCharactersInSet:
            [NSCharacterSet whitespaceCharacterSet]];
    telephone = [telephone stringByTrimmingCharactersInSet:
            [NSCharacterSet whitespaceCharacterSet]];

    if (name == NULL || name.length ==0)
    {
        [self showAlert:@"Enter Name"];
         [Fname becomeFirstResponder];
        boolval=NO;
    }
    else if (mobile == NULL || mobile.length ==0) {
        [self showAlert:@"Enter Mobile No"];
         [mobno becomeFirstResponder];
        boolval=NO;
    }
    else if (company_name == NULL || company_name.length ==0) {
        [self showAlert:@"Enter Company Name"];
         [cmpyname becomeFirstResponder];
        boolval=NO;
    }
    else if ((personal_mail == NULL || personal_mail.length == 0)&&((company_mail == NULL)||(company_mail.length==0)))
    {
        [self showAlert:@"Enter Mail id"];
        [pmail becomeFirstResponder];
        boolval=NO;
    }
       
    if ((street1.length)!=0 && ((street2.length)==0 || street2 == NULL) )
    {
        street_work=street1;
        
    }
    else if (((street1.length)==0 || street2 == NULL)&& (street2.length)!=0 )
    {
        street_work=street2;
    }
    else if (street1.length==0 && street2.length==0)
    {
        street_work=NULL;
    }
    else {
        
        street_work=[NSString stringWithFormat:@"%@ %@",street1,street2];
    }
    street_work = [street_work stringByTrimmingCharactersInSet:
            [NSCharacterSet whitespaceCharacterSet]];
    return boolval;
    
}

-(void)store
{
  
    if ([self validate]) {
        if (personal_mail.length !=0)
        {
            if (![self validateEmailWithString:personal_mail]) {
            [self showAlert:@"Enter Valid Mail id"];
            [pmail becomeFirstResponder];
            return;
            }
        }
        if (company_mail.length !=0) {

        if (![self validateEmailWithString:cmail.text]) {
            [self showAlert:@"Enter Valid Mail id"];
            [cmail becomeFirstResponder];
            return;
        }
        }
    sqlite3_stmt    *statement = NULL;
    id<GAITracker> tracker = [[GAI sharedInstance] trackerWithTrackingId:@"UA-47213637-1"];
    [tracker sendEventWithCategory:@"Create Businesscard" withAction:@"ButtonPress" withLabel:@"Create card Button" withValue:[NSNumber numberWithInt:100]];
    const char *dbpath = [databasePath UTF8String];
   
    if (sqlite3_open(dbpath, &Bcontact) == SQLITE_OK)
    {
        NSString *insertSQL = [NSString stringWithFormat: @"INSERT INTO BCONTACTS (name, mobno,pmail,cmail,sid,cmpynam,des,street1,street2,city,pin,tel) VALUES (\"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\")",Fname.text,mobno.text,pmail.text,cmail.text,sid.text,cmpyname.text,designation.text,strt1.text,strt2.text,cityname.text,pin.text,tel.text];
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(Bcontact, insert_stmt, -1, &statement, NULL);
    
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            
             [self showAlert1:@"Contact added successfully."];
                       
          
        } else {
           
            [self showAlert:@"Failed to add contact."];
            
        }
        sqlite3_finalize(statement);
        sqlite3_close(Bcontact);
    }

        [self drawQRCode];
    }

}
-(void)drawQRCode
{
    
    NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
    
    [mutableArray addObject:@"BEGIN:VCARD"];
    [mutableArray addObject:@"VERSION:4.0"];
    [mutableArray addObject:[NSString stringWithFormat:@"N:%@",name]];
    [mutableArray addObject:[NSString stringWithFormat:@"TEL;TYPE=MOBILE:%@",mobile]];
    if (personal_mail != NULL  && (personal_mail.length)!=0)
        
    {
        [mutableArray addObject:[NSString stringWithFormat:@"EMAIL;TYPE=HOME:%@",personal_mail]];
        
    }
    if (company_mail  != NULL && (company_mail.length)!=0)
        
    {
        [mutableArray addObject:[NSString stringWithFormat:@"EMAIL;TYPE=WORK:%@",company_mail]];
        
    }
    [mutableArray addObject:[NSString stringWithFormat:@"ORG: %@",company_name]];
    if (designatn !=NULL && (designatn.length)!=0) {
        [mutableArray addObject:[NSString stringWithFormat:@"TITLE: %@",designatn]];
    }
    
    if(street1  != NULL && (street1.length)!=0)
    {
        street1=[NSString stringWithFormat:@"%@;",street1];
        address=[address stringByAppendingString:street1];
    }
    else
    {
        address=[address stringByAppendingString:@" ;"];
    }
    
    
    if (city  != NULL  && (city.length)!=0)
        
    {    city=[NSString stringWithFormat:@"%@;",city];
        address= [address stringByAppendingString:city];
    }
    else
    {
        address=[address stringByAppendingString:@" ;"];
    }
    if(street2  != NULL && (street2.length)!=0)
    {
        street2=[NSString stringWithFormat:@"%@;",street2];
        address=[address stringByAppendingString:street2];
    }
    else
    {
        address=[address stringByAppendingString:@" ;"];
    }
    
    if (pincode  != NULL && (pincode.length)!=0)
        
    {    pincode=[NSString stringWithFormat:@"%@;",pincode];
        address=[address stringByAppendingString:pincode];
    }
    NSLog(@"%@",address);
    
    [mutableArray addObject:[NSString stringWithFormat:@"ADR;TYPE=work:;;%@",address]];
    if (telephone  != NULL && (telephone.length)!=0)
        
    {
        [mutableArray addObject:[NSString stringWithFormat:@"TEL;TYPE=WORK:%@",telephone]];
    }
    [mutableArray addObject:@"REV:20080424T195243Z" ];
    [mutableArray addObject:@"END:VCARD"];
    
    string = [mutableArray componentsJoinedByString:@"\n"];
    
    Barcode *barcode = [[Barcode alloc] init];
    self.view.backgroundColor = [UIColor whiteColor];
    [barcode setupQRCode:string];
    self.imageView.image = barcode.qRBarcode;
    [self loadcontactid];
    [self filestore];
}
-(void)loadcontactid
    {
        
        const char *dbpath = [databasePath UTF8String];
        
        if (sqlite3_open(dbpath, &Bcontact) == SQLITE_OK)
        {
            NSString *querySQL = [NSString stringWithFormat: @"SELECT MAX(id) FROM BCONTACTS "];
            
            const char *query_stmt = [querySQL UTF8String];
            
            sqlite3_stmt *compiledStatement = NULL;
            int result = sqlite3_prepare_v2(Bcontact, query_stmt, -1, &compiledStatement, NULL) ;
            if( result == SQLITE_OK)
            {
                while(sqlite3_step(compiledStatement) == SQLITE_ROW)
                {
                    idtag = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
                 
                }
            }
            sqlite3_finalize(compiledStatement);
        }
        sqlite3_close(Bcontact);
   
[self saveImage];
}

- (void)saveImage {
    NSString *picname=[NSString stringWithFormat:@"%@_%@",name,idtag];
    [[Generic sharedMySingleton].ContactARRAY addObject:picname];
    [[Generic sharedMySingleton].content setObject:[Generic sharedMySingleton].ContactARRAY forKey:@"QRPicname"];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *savedImagePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",picname]];
    UIImage *image = imageView.image;
    NSData *imageData = UIImagePNGRepresentation(image);
    [imageData writeToFile:savedImagePath atomically:YES];
  
}
-(void)filestore
{
  NSError* error = nil;
    NSString *cardname=[NSString stringWithFormat:@"%@_%@",name,idtag];
    [[Generic sharedMySingleton].CardARRAY addObject:cardname];
    [[Generic sharedMySingleton].filename setObject:[Generic sharedMySingleton].CardARRAY forKey:@"Filename"];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *savedImagePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.vcf",cardname]];
    [string writeToFile:savedImagePath atomically:YES encoding:NSASCIIStringEncoding error:&error];

}



- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    NSInteger nextTag = textField.tag + 1;
    // Try to find next responder
    UIResponder *nextResponder = [textField.superview viewWithTag:nextTag];
    
    if (nextResponder) {
        [carddetail_scroll setContentOffset:CGPointMake(0,textField.center.y-60) animated:YES];
        // Found next responder, so set it.
        [nextResponder becomeFirstResponder];
    } else {
        [carddetail_scroll setContentOffset:CGPointMake(0,600) animated:YES];
        [textField resignFirstResponder];
        return YES;
    }
    
    return NO;
}

- (BOOL)validateEmailWithString:(NSString*)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
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
                                          otherButtonTitles:nil];
    [alert show];
}


- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    // the user clicked one of the OK/Cancel buttons
    if (buttonIndex == 0)
    {
        
        ViewController *category =[self.storyboard instantiateViewControllerWithIdentifier:@"MoreDetailViewController"];

        [self.navigationController pushViewController:category  animated:YES];
  
    }
  
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
