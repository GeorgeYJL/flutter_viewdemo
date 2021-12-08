//
//  MyGLThread.h
//  flutter_viewdemo
//
//  Created by 杨江龙 on 2021/12/3.
//

#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>
#import "MyRenderer.h"
NS_ASSUME_NONNULL_BEGIN
typedef void(^FrameUpdateCallback)(void);
@interface MyGLThread : NSObject<FlutterTexture>
-(instancetype)initWithFrame:(CGSize)size Renderer:(NSObject<MyGLRenderer> *)renderer FrameUpdateCallback:(FrameUpdateCallback)callback;
-(void)start;
@end

NS_ASSUME_NONNULL_END
