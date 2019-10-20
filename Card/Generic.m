

#import "Generic.h"

@implementation Generic
@synthesize ContactARRAY,content,IDArray,CardARRAY,filename,NameARRAY;

static Generic* _sharedGeneric = nil;

+(Generic*)sharedMySingleton
{
	@synchronized([Generic class])
	{
		if (!_sharedGeneric){
			[[self alloc] init];
            
        }
		return _sharedGeneric;
	}
    
	return nil;
}

+(id)alloc
{
	@synchronized([Generic class])
	{
		NSAssert(_sharedGeneric == nil, @"Attempted to allocate a second instance of a singleton.");
		_sharedGeneric = [super alloc];
		return _sharedGeneric;
	}
    
	return nil;
}

-(id)init {
	self = [super init];
	if (self != nil) {
		// initialize stuff here
       
        content = [NSUserDefaults standardUserDefaults];
        filename=[NSUserDefaults standardUserDefaults];
        CardARRAY= [[NSMutableArray alloc]initWithArray:[filename objectForKey:@"Filename"]];
        ContactARRAY= [[NSMutableArray alloc]initWithArray:[content objectForKey:@"QRPicname"]];
        IDArray= [[NSMutableArray alloc]init];
        NameARRAY= [[NSMutableArray alloc]init];
	}
    
	return self;
}

@end
