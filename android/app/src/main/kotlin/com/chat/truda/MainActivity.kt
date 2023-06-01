package com.chat.truda

import android.content.*
import android.content.pm.PackageManager
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.provider.Settings
import android.util.Base64
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import net.aihelp.init.AIHelpSupport
import java.io.*
import java.security.MessageDigest
import java.security.NoSuchAlgorithmException

class MainActivity : FlutterActivity() {
    private val CHANNEL = "newhita_aihelp_channel"
    private val CHANNEL_method = "newhita_method_channel"
    private val METHOD_GOTO_GOOGLE_PLAY = "method_goto_google_play"
    private val KEY_CLEAR_EXCEPT = "key_clear_except"
    private val KEY_PACKAGE_NAME = "key_package_name"


    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            window.statusBarColor = 0
        }

        MethodChannel(
            flutterEngine!!.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler { call, result ->
            if (call.method == "initAIHelp") {
                val para = call.arguments as Map<*, *>
                val apiKey = para["apiKey"] as String?
                val domainName = para["domainName"] as String?
                val appId = para["appId"] as String?
                initAIHelp(apiKey, domainName, appId)
            } else if (call.method == "enterMinAIHelp") {
                val para = call.arguments as Map<*, *>
                TrudaAihelpTools.showConversation(para)
            } else if (call.method == "enterOrderAIHelp") {
                val para = call.arguments as Map<*, *>
                TrudaAihelpTools.showOrderConversation(para)
            } else {
                result.notImplemented()
            }
        }


        MethodChannel(
            flutterEngine!!.dartExecutor.binaryMessenger,
            CHANNEL_method
        ).setMethodCallHandler { call, result ->
            if (call.method == "getFacebookKey") {
                try {
                    val info = packageManager.getPackageInfo(
                        "com.hitawula.newhita",  //此处换成自己app的包名
                        PackageManager.GET_SIGNATURES
                    )
                    var str: String? = ""
                    for (signature in info.signatures) {
                        val md = MessageDigest.getInstance("SHA")
                        md.update(signature.toByteArray())
                        val encode = Base64.encodeToString(
                            md.digest(),
                            Base64.DEFAULT
                        )
                        Log.d("KeyHash", encode)
                        str += encode
                    }
                    result.success(str)
                    //获取剪贴板管理器：
                    val cm =
                        getSystemService(Context.CLIPBOARD_SERVICE) as ClipboardManager
                    // 创建普通字符型ClipData
                    val mClipData = ClipData.newPlainText("Label", str)
                    // 将ClipData内容放到系统剪贴板里。
                    cm.setPrimaryClip(mClipData)
                } catch (ignored: PackageManager.NameNotFoundException) {
                    result.notImplemented()
                } catch (ignored: NoSuchAlgorithmException) {
                    result.notImplemented()
                }
            } else if (call.method == "askNotification") {
                askNotificationPremission();
            } else if (call.method == METHOD_GOTO_GOOGLE_PLAY) {
                val packageName = call.argument<String>(KEY_PACKAGE_NAME)
                packageName?.let { openApplicationStore(it) }
            } else if (call.method == KEY_CLEAR_EXCEPT) {
                TrudaActivityManager.INSTANCE.popAllActivityExceptOne(this::class.java)
            } else {
                result.notImplemented()
            }
        }
    }


    fun initAIHelp(apiKey: String?, domainName: String?, appId: String?) {
        AIHelpSupport.init(this, apiKey, domainName, appId)
    }

    fun askNotificationPremission() {
        val intent: Intent = Intent()
        try {
            intent.action = Settings.ACTION_APP_NOTIFICATION_SETTINGS

            //8.0及以后版本使用这两个extra.  >=API 26
            intent.putExtra(Settings.EXTRA_APP_PACKAGE, packageName)
            intent.putExtra(Settings.EXTRA_CHANNEL_ID, applicationInfo.uid)

            //5.0-7.1 使用这两个extra.  <= API 25, >=API 21
            intent.putExtra("app_package", packageName)
            intent.putExtra("app_uid", applicationInfo.uid)

            startActivity(intent)
        } catch (e: Exception) {
            e.printStackTrace()

            //其他低版本或者异常情况，走该节点。进入APP设置界面
            intent.action = Settings.ACTION_APPLICATION_DETAILS_SETTINGS
            intent.putExtra("package", packageName)

            //val uri = Uri.fromParts("package", packageName, null)
            //intent.data = uri
            startActivity(intent)
        }
    }

    /**
     * 打开google play 对应的应用页面
     */
    fun openApplicationStore(packageName: String) {

        //这里对应的是谷歌商店，跳转别的商店改成对应的即可
        val GOOGLE_PLAY = "com.android.vending"
        try {
            val intent = Intent(Intent.ACTION_VIEW)
            intent.data = Uri.parse("market://details?id=$packageName")
            intent.setPackage(GOOGLE_PLAY) //这里对应的是谷歌商店，跳转别的商店改成对应的即可
            if (intent.resolveActivity(this.packageManager) != null) {
                this.startActivity(intent)
            } else { //没有应用市场，通过浏览器跳转到Google Play
                val intent2 = Intent(Intent.ACTION_VIEW)
                intent2.data =
                    Uri.parse("https://play.google.com/store/apps/details?id=$packageName")
                if (intent2.resolveActivity(this.packageManager) != null) {
                    this.startActivity(intent2)
                } else {
                    //没有Google Play 也没有浏览器
                    Log.e("GoogleStore", "not google play and not web browser")
                }
            }
        } catch (activityNotFoundException1: ActivityNotFoundException) {
            Log.e("GoogleStore", "GoogleStore Intent not found")
        }
    }

}
