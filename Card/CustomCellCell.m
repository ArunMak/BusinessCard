
#import "CustomCellCell.h"

@implementation CustomCellCell
@synthesize primaryLabel,delbutton,detailedLabel,qrbutton,mailbutton;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        primaryLabel = [[UILabel alloc]init];
        detailedLabel= [[UILabel alloc]init];
        mailbutton = [[UIButton alloc]init];
        delbutton = [[UIButton alloc]init];
        qrbutton = [[UIButton alloc]init];
        primaryLabel.backgroundColor = [UIColor clearColor];
        primaryLabel.textColor = [UIColor blackColor];
        detailedLabel.backgroundColor = [UIColor clearColor];
        detailedLabel.textColor = [UIColor darkGrayColor];
    
        [self.contentView addSubview:primaryLabel];
        [self.contentView addSubview:detailedLabel];
        [self.contentView addSubview:delbutton];
        [self.contentView addSubview:qrbutton];
        [self.contentView addSubview:mailbutton];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect frame;
    frame= CGRectMake(25,10, 250, 20);
    primaryLabel.frame = frame;
    [primaryLabel setFont:[UIFont fontWithName:@"Helvetica" size:18]];
    frame=CGRectMake(25,30, 250, 20);
    detailedLabel.frame=frame;
    [detailedLabel setFont:[UIFont fontWithName:@"Helvetica" size:14]];
    frame= CGRectMake(160, 75, 30, 30);
    mailbutton.frame = frame;
    [mailbutton setBackgroundImage:[UIImage imageNamed:@"mail-icon2.png"] forState:UIControlStateNormal];
    frame = CGRectMake(195, 75, 30, 30);
    qrbutton.frame=frame;
    [qrbutton setBackgroundImage:[UIImage imageNamed:@"QR-icon.png"] forState:UIControlStateNormal];
    frame=CGRectMake(230, 75, 30, 30);
    delbutton.frame=frame;
    [delbutton setBackgroundImage:[UIImage imageNamed:@"deletr-icon.png"] forState:UIControlStateNormal];

}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
