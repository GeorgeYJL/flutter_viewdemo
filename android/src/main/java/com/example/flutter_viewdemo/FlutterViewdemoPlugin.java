package com.example.flutter_viewdemo;

import android.graphics.SurfaceTexture;

import androidx.annotation.NonNull;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.view.TextureRegistry;

/** FlutterViewdemoPlugin */
public class FlutterViewdemoPlugin implements FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private MethodChannel channel;

  // FlutterTextureRegistry 用来生成SurfaceTextureEntry  SurfaceTextureEntry 可以生成 SurfaceTexture
  // SurfaceTexture 就可以交给 原生的GL环境来渲染了。
  private TextureRegistry mTextRegistry;
  private TextureRegistry.SurfaceTextureEntry mSurfaceEntry;
  private MyGLThread glThread;


  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "flutter_viewdemo");
    channel.setMethodCallHandler(this);

    mTextRegistry = flutterPluginBinding.getTextureRegistry();
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    if (call.method.equals("getPlatformVersion")) {
      result.success("Android " + android.os.Build.VERSION.RELEASE);
    } else if (call.method.equals("createTexture")) {
      int width = call.argument("width");
      int height = call.argument("height");

      mSurfaceEntry = mTextRegistry.createSurfaceTexture();
      SurfaceTexture surfaceTexture = mSurfaceEntry.surfaceTexture();
      surfaceTexture.setDefaultBufferSize(width,height);

      glThread = new MyGLThread(new SimpleRender(),surfaceTexture);
      glThread.start();
      result.success(mSurfaceEntry.id());


    }else if (call.method.equals("dispose")) {

      glThread.dispose();
      mSurfaceEntry.release();

    }else{
      result.notImplemented();
    }
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }
}
