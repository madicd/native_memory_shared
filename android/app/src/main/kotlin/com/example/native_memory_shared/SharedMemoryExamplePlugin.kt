package com.example.native_memory_shared

import io.flutter.plugin.common.MethodChannel
import io.flutter.embedding.engine.FlutterEngine

class SharedMemoryExamplePlugin {

    private val CHANNEL = "shared_memory_example"
    private lateinit var channel: MethodChannel

    fun registerMethodChannel(flutterEngine: FlutterEngine) {
        channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)

        channel.setMethodCallHandler { call, result ->
            when (call.method) {
                "writeData" -> {
                    val value = call.argument<Int>("value") ?: 0
                    NativeMemoryManager.writeData(value)
                    result.success(null)
                }
                "readData" -> {
                    val value = NativeMemoryManager.readData()
                    result.success(value)
                }
                else -> result.notImplemented()
            }
        }
    }

    fun unregisterMethodChannel() {
        channel.setMethodCallHandler(null)
    }
}