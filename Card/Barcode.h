
@class Barcode;


typedef enum
{
    EAN8 = 8,
    EAN13 = 13
} BarcodeType;


@interface Barcode : NSObject <UIWebViewDelegate>
{
    NSArray *encoding, *first, *code128Encoding;
}

@property (nonatomic, retain) UIImage *qRBarcode;


-(void)setupQRCode:(NSString *)code;


@end
