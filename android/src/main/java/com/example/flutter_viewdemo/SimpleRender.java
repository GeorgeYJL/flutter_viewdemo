package com.example.flutter_viewdemo;

import android.opengl.GLES30;

import java.util.Random;

/**
 * @Project：android
 * @Package：com.example.flutter_viewdemo
 * @CreateDate:2021/12/2
 * @author: yangjianglong
 */
public class SimpleRender implements MyGLThread.MyGLRenderer {
    @Override
    public void onCreate() {

    }

    @Override
    public boolean onDraw() {
        GLES30.glClearColor(new Random().nextFloat(),new Random().nextFloat(),new Random().nextFloat(),1);
        GLES30.glClear(GLES30.GL_COLOR_BUFFER_BIT);


        return true;
    }

    @Override
    public void onDispose() {

    }
}
