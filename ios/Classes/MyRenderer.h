//
//  MyRenderer.h
//  Pods
//
//  Created by 杨江龙 on 2021/12/3.
//

#ifndef MyRenderer_h
#define MyRenderer_h

@protocol MyGLRenderer <NSObject>
- (void)onCreated;
- (Boolean)onDraw;
- (void)onDispose;
@end
#endif /* MyRenderer_h */
