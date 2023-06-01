package com.chat.truda

import io.flutter.app.FlutterApplication

class TrudaApp: FlutterApplication() {
    override fun onCreate() {
        super.onCreate()
        TrudaActivityManager.INSTANCE.initActivityManager(this)
    }
}