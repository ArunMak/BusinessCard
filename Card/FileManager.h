

#import <Foundation/Foundation.h>

@interface FileManager : NSObject
{
 NSString *qrCode;
}
@property (nonatomic,copy) NSString *qrCode;

+(FileManager*)sharedFileManager;

@end
