package com.example.flow

import android.Manifest
import android.content.pm.PackageManager
import android.database.Cursor
import android.net.Uri
import android.widget.Toast
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity(){
    private val channelName = "uniqueChannel"
    private val SMS_PERMISSION_REQUEST_CODE = 1001

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        val method = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelName)

        method.setMethodCallHandler { call, result ->
            when (call.method) {
                "userName" -> {
                    val userName = call.argument<String>("name")
                    Toast.makeText(this, "From Native $userName", Toast.LENGTH_LONG).show()
                    result.success(userName)
                }
                "getAllSMS" -> {
                    if (checkSMSPermission()) {
                        val smsList = getSIBSMSMessages()
                        result.success(smsList)
                    } else {
                        requestSMSPermission()
                        result.error("PERMISSION_DENIED", "SMS permission not granted", null)
                    }
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    private fun checkSMSPermission(): Boolean {
        return ContextCompat.checkSelfPermission(
            this,
            Manifest.permission.READ_SMS
        ) == PackageManager.PERMISSION_GRANTED
    }

    private fun requestSMSPermission() {
        ActivityCompat.requestPermissions(
            this,
            arrayOf(Manifest.permission.READ_SMS),
            SMS_PERMISSION_REQUEST_CODE
        )
    }

    private fun getSIBSMSMessages(): List<Map<String, Any>> {
        val smsList = mutableListOf<Map<String, Any>>()

        try {
            val uri = Uri.parse("content://sms/inbox")
            val cursor: Cursor? = contentResolver.query(
                uri,
                arrayOf("_id", "address", "body", "date", "type"),
                "address LIKE ?",
                arrayOf("%SIBSMS%"),
                "date DESC"
            )

            cursor?.use { c ->
                val idIndex = c.getColumnIndex("_id")
                val addressIndex = c.getColumnIndex("address")
                val bodyIndex = c.getColumnIndex("body")
                val dateIndex = c.getColumnIndex("date")
                val typeIndex = c.getColumnIndex("type")

                while (c.moveToNext()) {
                    val address = if (addressIndex >= 0) c.getString(addressIndex) else ""

                    // Double-check the address contains "SIBSMS" (case-insensitive)
                    if (address.uppercase().contains("SIBSMS")) {
                        val smsMap = mapOf<String, Any>(
                            "id" to (if (idIndex >= 0) c.getString(idIndex) else ""),
                            "address" to address,
                            "body" to (if (bodyIndex >= 0) c.getString(bodyIndex) else ""),
                            "date" to (if (dateIndex >= 0) c.getLong(dateIndex) else 0L),
                            "type" to (if (typeIndex >= 0) c.getInt(typeIndex) else 0)
                        )
                        smsList.add(smsMap)
                    }
                }
            }
        } catch (e: Exception) {
            e.printStackTrace()
        }

        return smsList
    }

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray
    ) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)

        if (requestCode == SMS_PERMISSION_REQUEST_CODE) {
            if (grantResults.isNotEmpty() && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                Toast.makeText(this, "SMS Permission Granted", Toast.LENGTH_SHORT).show()
            } else {
                Toast.makeText(this, "SMS Permission Denied", Toast.LENGTH_SHORT).show()
            }
        }
    }
}