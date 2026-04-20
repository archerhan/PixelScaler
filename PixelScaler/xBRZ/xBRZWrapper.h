#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface xBRZWrapper : NSObject

// 暴露给 Swift 的超级放大接口
+ (void)scaleImageWithSource:(const uint32_t *)source
                      target:(uint32_t *)target
                       width:(int)width
                      height:(int)height
                 scaleFactor:(int)scaleFactor;

@end

NS_ASSUME_NONNULL_END
