package com.example.fix_it

import androidx.multidex.MultiDexApplication

class MainApplication : MultiDexApplication() {
    override fun onCreate() {
        super.onCreate()
        // Initialize any app-wide components here
    }
}
