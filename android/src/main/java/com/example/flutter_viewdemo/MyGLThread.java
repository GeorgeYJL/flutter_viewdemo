package com.example.flutter_viewdemo;

import android.graphics.SurfaceTexture;
import android.opengl.EGL14;
import android.opengl.GLUtils;
import android.util.Log;

import javax.microedition.khronos.egl.*;

/**
 * @Project：android
 * @Package：com.example.flutter_viewdemo
 * @CreateDate:2021/12/2
 * @author: yangjianglong
 */
public class MyGLThread implements Runnable{

    private EGL10 egl;
    private EGLDisplay eglDisplay;
    private EGLContext eglContext;
    private EGLSurface eglSurface;


    private MyGLRenderer myGLRenderer;
    private SurfaceTexture surfaceTexture;


    private int[] configAttribList = new int[]{
            EGL10.EGL_RENDERABLE_TYPE,4,
            EGL10.EGL_RED_SIZE,8,
            EGL10.EGL_GREEN_SIZE,8,
            EGL10.EGL_BLUE_SIZE,8,
            EGL10.EGL_ALPHA_SIZE,8,
            EGL10.EGL_DEPTH_SIZE,16,
            EGL10.EGL_STENCIL_SIZE,0,
            EGL10.EGL_SAMPLE_BUFFERS,1,
            EGL10.EGL_SAMPLES,4,
            EGL10.EGL_NONE
    };

    private static final String TAG = "MyGLThread";

    private boolean running = true;

    public MyGLThread(MyGLRenderer myGLRenderer, SurfaceTexture surfaceTexture) {
        this.myGLRenderer = myGLRenderer;
        this.surfaceTexture = surfaceTexture;
    }

    @Override
    public void run() {
        //初始化EGL 环境
        initEGL();
        //开始绘制
        myGLRenderer.onCreate();
        while (running){
            if(myGLRenderer.onDraw()){
                if(!egl.eglSwapBuffers(eglDisplay,eglSurface)){
                    //绘制出错
                    Log.d(TAG, "eglSwapBuffers error : "+egl.eglGetError());
                }
            }
        }
        //结束绘制
        myGLRenderer.onDispose();
        disposeEGL();

    }

    void initEGL(){

        // 1.获取egl
        egl = (EGL10) EGLContext.getEGL();

        // 2.创建与原生窗口的连接
        eglDisplay = egl.eglGetDisplay(EGL10.EGL_DEFAULT_DISPLAY);
        if(eglDisplay == EGL10.EGL_NO_DISPLAY){
            throw new RuntimeException("eglGetDisplay Failed");
        }

        // 3.初始化  获取EGL 版本
        int[] version = new int[2];  // majorVersion minorVersion
        boolean initSuccess = egl.eglInitialize(eglDisplay,version);
        if(!initSuccess)throw new RuntimeException("eglInitialize Failed");

        //////////////////////////////////////////////////////////////////////
        //// 	确定可用Surface配置 有两种方法。
        //      1. 先使用 eglGetConfigs 查询每个配置，再使用 eglGetConfigAttrib 找出最好的选择
        //	    2. 指定一组需求，使用 eglChooseChofig 让 EGL 推荐最佳配置
        /////////////////////////////////////////////////////////////////////

        // 4.通过指定 需求的方式 让EGL 推荐最佳配置
        EGLConfig [] configs = new EGLConfig[1]; // 用于接收符合条件的configs
        int[]configCount = new int[1];   // 设置 需要符合条件的配置个数  只需要一个
        boolean chooseConfigSuccess = egl.eglChooseConfig(eglDisplay,configAttribList,configs,1,configCount);
        if(!chooseConfigSuccess) throw new RuntimeException("Failed to choose config");
        EGLConfig config;
        if(configCount[0]>0){
            config = configs[0];
        }else{
            config = null;
        }

        // 5.创建EgLContext
        int [] attribList = new int[]{
             EGL14.EGL_CONTEXT_CLIENT_VERSION,2,EGL10.EGL_NONE
        };
        eglContext = egl.eglCreateContext(eglDisplay,config,EGL10.EGL_NO_CONTEXT,attribList);
        if(eglContext == EGL10.EGL_NO_CONTEXT){

        }

        // 6.创建 eglSurface
        eglSurface = egl.eglCreateWindowSurface(eglDisplay,config,surfaceTexture,null);
        if(eglSurface ==null||eglSurface == EGL10.EGL_NO_SURFACE){
            throw new RuntimeException("GL Error: " + GLUtils.getEGLErrorString(egl.eglGetError()));
        }

        // 7.关联上下文
        //////////////////////////////////////////////////////////////////////
        //// 关联上下文，
        // 参数二 表示绘制的Surface
        // 参数三 表示读取的Surface
        // 可以设置为同一个Surface
        /////////////////////////////////////////////////////////////////////

        boolean makeCurrentSuccess = egl.eglMakeCurrent(eglDisplay,eglSurface,eglSurface,eglContext);
        if(!makeCurrentSuccess) throw new RuntimeException("GL make current error: " + GLUtils.getEGLErrorString(egl.eglGetError()));



    }

    void disposeEGL(){
        //重置关联上下文
        egl.eglMakeCurrent(eglDisplay,EGL10.EGL_NO_SURFACE,EGL10.EGL_NO_SURFACE,EGL10.EGL_NO_CONTEXT);

        egl.eglDestroySurface(eglDisplay,eglSurface);

        egl.eglDestroyContext(eglDisplay,eglContext);

        egl.eglTerminate(eglDisplay);
    }


    void start(){
        new Thread(this).start();
    }
    void dispose(){
        running = false;
    }





    interface MyGLRenderer{
       void onCreate();
       boolean onDraw();
       void onDispose();
   }
}
