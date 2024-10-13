package com.example.native_memory_shared

import android.util.Log

object NativeMemoryManager {
    private var value: Int = 0

    fun writeData(value: Int) {
        this.value = value
        Log.d("MemoryPlugin", "Wrote $value to shared memory")
    }

    fun readData(): Int {
        Log.d("MemoryPlugin", "Read $value from shared memory")
        return value
    }
}
