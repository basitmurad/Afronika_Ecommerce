//package com.benjamin_pro.afronika_app
//
//import io.flutter.embedding.android.FlutterActivity
//
//class MainActivity : FlutterActivity()
package com.benjamin_pro.afronika_app

import android.os.Build
import android.os.Bundle
import android.webkit.WebView
import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
            // This turns off extra logging from WebView
            WebView.setWebContentsDebuggingEnabled(false)
        }
    }
}
