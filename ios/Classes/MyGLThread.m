//
//  MyGLThread.m
//  flutter_viewdemo
//
//  Created by 杨江龙 on 2021/12/3.
//

#import "MyGLThread.h"
#import "MyRenderer.h"
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES3/gl.h>
#import <OpenGLES/ES3/glext.h>

@implementation MyGLThread{
    NSObject<MyGLRenderer> *_myGLRenderer;
    
    EAGLContext *_context;
    
    CVOpenGLESTextureCacheRef _textureCache;
    
    CVOpenGLESTextureRef _texture;
    CVPixelBufferRef _target;
    
    CGSize _size;
    
    GLuint _frameBuffer;
    
    CADisplayLink *_displayLink;
    
    FrameUpdateCallback _callback;
}
-(instancetype)initWithFrame:(CGSize)size Renderer:(NSObject<MyGLRenderer> *)renderer FrameUpdateCallback:(FrameUpdateCallback)callback{
    self = [super init];
    if (self) {
        NSAssert(renderer, @"Renderer can not be null");
        _callback = callback;
        _size = size;
        _myGLRenderer =renderer;
        [self initGL];
        
    }
    return self;
}

-(void) initGL{
  
    // 创建GL 上下文
    _context = [[EAGLContext alloc]initWithAPI:kEAGLRenderingAPIOpenGLES3];
    [EAGLContext setCurrentContext:_context];
 
    [self createCVBufferWith:&_target withOutTexture:&_texture];
    
    
    // 创建帧缓冲区
    glGenFramebuffers(1, &_frameBuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, _frameBuffer);
       
    // 将纹理附加到帧缓冲区上
    glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, CVOpenGLESTextureGetName(_texture), 0);
       
    glViewport(0, 0, _size.width, _size.height);
       
    if (glCheckFramebufferStatus(GL_FRAMEBUFFER) != GL_FRAMEBUFFER_COMPLETE) {
       NSLog(@"failed to make complete framebuffer object %x", glCheckFramebufferStatus(GL_FRAMEBUFFER));
    }
    [_myGLRenderer onCreated];
    
}

- (void)createCVBufferWith:(CVPixelBufferRef *)target withOutTexture:(CVOpenGLESTextureRef *)texture {

    CVReturn err = CVOpenGLESTextureCacheCreate(kCFAllocatorDefault, NULL, _context, NULL, &_textureCache);
    
    if (err) {
        return;
    }
    
    
    CFDictionaryRef empty;
    CFMutableDictionaryRef attrs;
    empty = CFDictionaryCreate(kCFAllocatorDefault,
                               NULL,
                               NULL,
                               0,
                               &kCFTypeDictionaryKeyCallBacks,
                               &kCFTypeDictionaryValueCallBacks);
    
    attrs = CFDictionaryCreateMutable(kCFAllocatorDefault,
                                      1,
                                      &kCFTypeDictionaryKeyCallBacks,
                                      &kCFTypeDictionaryValueCallBacks);
    
    CFDictionarySetValue(attrs, kCVPixelBufferIOSurfacePropertiesKey, empty);
    
    CVPixelBufferCreate(kCFAllocatorDefault, _size.width, _size.height, kCVPixelFormatType_32BGRA, attrs, target);
    
    CVOpenGLESTextureCacheCreateTextureFromImage(kCFAllocatorDefault,
                                                 _textureCache,
                                                 *target,
                                                 NULL,
                                                 GL_TEXTURE_2D,
                                                 GL_RGBA,
                                                 _size.width,
                                                 _size.height,
                                                 GL_BGRA, GL_UNSIGNED_BYTE,
                                                 0,
                                                 texture);
    
    CFRelease(empty);
    CFRelease(attrs);
}
- (CVPixelBufferRef _Nullable)copyPixelBuffer {
    CVBufferRetain(_target);
    return _target;
}

- (void)dealloc{
    [_myGLRenderer onDispose];
       CFRelease(_target);
       CFRelease(_textureCache);
       CFRelease(_texture);
}


-(void)start{
    
    if(!_displayLink){
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(run)];
        if (@available(iOS 10.0, *)) {
            _displayLink.preferredFramesPerSecond = 60;
        } else {
            // Fallback on earlier versions
        }
        [_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
        
    }
}

-(void)run{
    [EAGLContext setCurrentContext:_context];
//    glClearColor(0.2, 0.2, 0.2, 1);
//    glClear(GL_COLOR_BUFFER_BIT);
    
    if( [_myGLRenderer onDraw]){
        glFlush();
        _callback();
//        dispatch_async(dispatch_get_main_queue(), _callback());
    }
    
   
    
    
    
    
}

@end
