//
//  SimpleRenderer.m
//  flutter_viewdemo
//
//  Created by 杨江龙 on 2021/12/3.
//

#import "SimpleRenderer.h"
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES3/gl.h>
#import <OpenGLES/ES3/glext.h>
@implementation SimpleRenderer{
    CGSize _size;
    NSObject<FlutterTextureRegistry> *_textures;
}


- (instancetype)initWithFrame:(CGSize)size
{
    self = [super init];
    if (self) {
        _size = size;
    }
    return self;
}

- (void)onCreated {
}

- (void)onDispose {
    
}

- (Boolean)onDraw {
    glClearColor(arc4random_uniform(256)/ 255.0, arc4random_uniform(256)/ 255.0, arc4random_uniform(256)/ 255.0, 1);
    glClear(GL_COLOR_BUFFER_BIT);
    
    return true;
}

@end
