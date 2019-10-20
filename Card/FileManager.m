import "FileManager.h"

@implementation FileManager
@synthesize qrCode;
static FileManager* _sharedFileManager = nil;

+(FileManager*)sharedFileManager
{
	@synchronized([FileManager class])
	{
		if (!_sharedFileManager)
			[[self alloc] init];
  
		return _sharedFileManager;
	}
	return nil;
}



+(id)alloc
{
	@synchronized([FileManager class])
	{
		NSAssert(_sharedFileManager == nil, @"Attempted to allocate a second instance of a singleton.");
		_sharedFileManager = [super alloc];
		return _sharedFileManager;
	}
 
	return nil;
}



-(id)init
{
 if ((self = [super init]))
 {
  NSString *doc = [NSSearchPathForDirectoriesInDomains( NSApplicationSupportDirectory, NSUserDomainMask, YES ) objectAtIndex:0];
  NSString *dir = [NSString stringWithFormat:@"%@/Sybrant_M1", doc];
  [[NSFileManager defaultManager] createDirectoryAtPath:dir 
         withIntermediateDirectories:YES 
                          attributes:nil
                               error:nil];
  self.qrCode = [dir stringByAppendingPathComponent:@"qrcode.png"];
 }
 return self;
}




@end
