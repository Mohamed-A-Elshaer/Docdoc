package com.example.docdoc

import io.flutter.embedding.android.FlutterFragmentActivity

class MainActivity : FlutterFragmentActivity(){
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        Notifications.createNotificationChannels(this)
    }

}
