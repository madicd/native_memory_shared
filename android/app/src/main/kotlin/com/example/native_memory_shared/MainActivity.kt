package com.example.native_memory_shared

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity: FlutterActivity() {
    private val sharedMemoryExamplePlugin = SharedMemoryExamplePlugin()

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        sharedMemoryExamplePlugin.registerMethodChannel(flutterEngine)
    }

    override fun onDestroy() {
        super.onDestroy()
        sharedMemoryExamplePlugin.unregisterMethodChannel()
    }
}
