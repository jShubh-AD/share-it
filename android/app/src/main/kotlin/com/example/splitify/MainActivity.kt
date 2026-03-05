package com.example.splitify

import io.flutter.embedding.android.FlutterActivity
import android.os.Bundle

class MainActivity : FlutterActivity() {

    private lateinit var bleServer: BleServer

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        bleServer = BleServer(this)
        bleServer.startServer()
    }

    override fun onDestroy() {
        super.onDestroy()
        bleServer.stopServer()
    }
}