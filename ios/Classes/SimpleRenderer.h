//
//  SimpleRenderer.h
//  flutter_viewdemo
//
//  Created by 杨江龙 on 2021/12/3.
//

#import <Foundation/Foundation.h>
#import "MyRenderer.h"
#import <Flutter/Flutter.h>
NS_ASSUME_NONNULL_BEGIN

@interface SimpleRenderer : NSObject<MyGLRenderer>
- (instancetype)initWithFrame:(CGSize)size;

@end

NS_ASSUME_NONNULL_END
