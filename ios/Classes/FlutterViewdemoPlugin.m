#import "FlutterViewdemoPlugin.h"
#import "MyGLThread.h"
#import "MyRenderer.h"
#import "SimpleRenderer.h"


@interface FlutterViewdemoPlugin()
@property (nonatomic, strong) NSObject<FlutterTextureRegistry> *mTextureRegistry;
@property (nonatomic, strong) MyGLThread *mGLThread;
@end

@implementation FlutterViewdemoPlugin

- (instancetype)initWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    self = [super self];
    
    NSAssert(self,@"super init cannot be nil");
    // 通过registrar 获取FlutterTextureRegistry 类似Android平台flutterPluginBinding.getTextureRegistry()
    // FlutterTextureRegistry 用来生成SurfaceTexture 有了 SurfaceTexture就可以使用原生的GL环境进行绘制了
    _mTextureRegistry = registrar.textures;
    
    
    return  self;
}
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"flutter_viewdemo"
            binaryMessenger:[registrar messenger]];
  FlutterViewdemoPlugin* instance = [[FlutterViewdemoPlugin alloc] initWithRegistrar:registrar];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([@"getPlatformVersion" isEqualToString:call.method]) {
        result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
    } else if ([@"createTexture" isEqualToString:call.method]) {
        int width = [call.arguments[@"width"] intValue];
        int  height = [call.arguments[@"height"] intValue];
        
        float w = (float) width;
        float h = (float) height;
        CGSize size = CGSizeMake(w, h);
        SimpleRenderer *render = [[SimpleRenderer alloc]initWithFrame:size];
        __block int64_t textureID = 0;
        __weak typeof(self) wself = self;
        _mGLThread = [[MyGLThread alloc]initWithFrame:size Renderer:render FrameUpdateCallback:^{
            [wself.mTextureRegistry textureFrameAvailable:textureID];
        }];
        
       textureID = [_mTextureRegistry registerTexture:_mGLThread];

        [_mGLThread start];
        
        result(@(textureID));
        
    
       

    } else if ([@"dispose" isEqualToString:call.method]) {
        int textureID = [call.arguments[@"textureID"] intValue];
        
    } else{
        result(FlutterMethodNotImplemented);
    }
}

@end
