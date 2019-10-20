
#import <UIKit/UIKit.h>

@interface Generic : NSObject
{
    NSUserDefaults * content;
    NSMutableArray * ContactARRAY ;
    NSMutableArray * IDArray;
}
@property(nonatomic)NSMutableArray* ContactARRAY ,*IDArray ,*CardARRAY,*NameARRAY;
@property(nonatomic)NSUserDefaults * content,*filename;

+(Generic*)sharedMySingleton;

@end
