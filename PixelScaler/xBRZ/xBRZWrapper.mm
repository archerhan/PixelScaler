#import "xBRZWrapper.h"
#import "xbrz.h" // 引入 C++ 引擎头文件

@implementation xBRZWrapper

+ (void)scaleImageWithSource:(const uint32_t *)source target:(uint32_t *)target width:(int)width height:(int)height scaleFactor:(int)scaleFactor {
    
    // 直接呼叫 C++ 底层！
    // 注意：我们传入了 xbrz::ColorFormat::argb，完美适配 Mac 的底层图片格式
    xbrz::scale(scaleFactor, source, target, width, height, xbrz::ColorFormat::argb);
    
}

@end
