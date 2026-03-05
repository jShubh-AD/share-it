package com.example.splitify

import android.bluetooth.*
import android.content.Context
import android.util.Log
import java.util.*

class BleServer(private val context: Context) {

    private val TAG = "BleServer"

    private val SERVICE_UUID =
        UUID.fromString("12345678-1234-1234-1234-123456789abc")

    private val CHAR_UUID =
        UUID.fromString("abcdefab-1234-1234-1234-abcdefabcdef")

    private var gattServer: BluetoothGattServer? = null
    private var bluetoothManager: BluetoothManager? = null

    fun startServer() {
        bluetoothManager =
            context.getSystemService(Context.BLUETOOTH_SERVICE) as BluetoothManager

        gattServer = bluetoothManager?.openGattServer(context, gattCallback)

        val service = BluetoothGattService(
            SERVICE_UUID,
            BluetoothGattService.SERVICE_TYPE_PRIMARY
        )

        val characteristic = BluetoothGattCharacteristic(
            CHAR_UUID,
            BluetoothGattCharacteristic.PROPERTY_READ or
                    BluetoothGattCharacteristic.PROPERTY_WRITE or
                    BluetoothGattCharacteristic.PROPERTY_NOTIFY,
            BluetoothGattCharacteristic.PERMISSION_READ or
                    BluetoothGattCharacteristic.PERMISSION_WRITE
        )

        service.addCharacteristic(characteristic)

        val result = gattServer?.addService(service)
        Log.d(TAG, "Service add requested: $result")
    }

    fun stopServer() {
        gattServer?.close()
        gattServer = null
        Log.d(TAG, "Server stopped")
    }

    private val gattCallback = object : BluetoothGattServerCallback() {

        override fun onServiceAdded(
            status: Int,
            service: BluetoothGattService
        ) {
            Log.d(TAG, "Service added status: $status")
        }

        override fun onConnectionStateChange(
            device: BluetoothDevice,
            status: Int,
            newState: Int
        ) {
            Log.d(TAG, "Connection state: $newState status: $status")
        }

        override fun onCharacteristicReadRequest(
            device: BluetoothDevice,
            requestId: Int,
            offset: Int,
            characteristic: BluetoothGattCharacteristic
        ) {
            Log.d(TAG, "Read request")

            val value = "Hello from Server".toByteArray()

            gattServer?.sendResponse(
                device,
                requestId,
                BluetoothGatt.GATT_SUCCESS,
                0,
                value
            )
        }

        override fun onCharacteristicWriteRequest(
            device: BluetoothDevice,
            requestId: Int,
            characteristic: BluetoothGattCharacteristic,
            preparedWrite: Boolean,
            responseNeeded: Boolean,
            offset: Int,
            value: ByteArray
        ) {
            val received = String(value)
            Log.d(TAG, "Received: $received")

            if (responseNeeded) {
                gattServer?.sendResponse(
                    device,
                    requestId,
                    BluetoothGatt.GATT_SUCCESS,
                    0,
                    value
                )
            }
        }

        override fun onDescriptorWriteRequest(
            device: BluetoothDevice,
            requestId: Int,
            descriptor: BluetoothGattDescriptor,
            preparedWrite: Boolean,
            responseNeeded: Boolean,
            offset: Int,
            value: ByteArray
        ) {
            Log.d(TAG, "Descriptor write (Notify enabled)")

            if (responseNeeded) {
                gattServer?.sendResponse(
                    device,
                    requestId,
                    BluetoothGatt.GATT_SUCCESS,
                    0,
                    value
                )
            }
        }
    }
}