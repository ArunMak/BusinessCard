
#import <UIKit/UIKit.h>

@interface CustomCellCell : UITableViewCell{
    UILabel *primaryLabel,*detailedLabel;
    UIButton *mailbutton,*qrbutton,*delbutton;
}
@property(nonatomic,retain)UIButton *mailbutton,*qrbutton,*delbutton;
@property(nonatomic,retain)UILabel *primaryLabel,*detailedLabel;
@end
