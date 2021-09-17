package com.clubfostr.fostr

<<<<<<< HEAD
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import okhttp3.*
import java.io.IOException


class MainActivity: FlutterActivity() {
    private var creatorId=""
    private var roomId=""
    private var role=""
    private var userId=""

    private val client = OkHttpClient()
    fun run(url: String) {
//       val data:RequestBody = FormBody.Builder().add("creatorId",creatorId).add("roomId",roomId).add("role",role).add("userId",userId).build()
        val request = Request.Builder()
            .url(url)
            .build()
        Log.d("run","inner")
        client.newCall(request).enqueue(object : Callback {
            override fun onFailure(call: Call, e: IOException) {}
            override fun onResponse(call: Call, response: Response) = println(response.body()?.string())
        })
        Log.d("run","inner-lower")
    }


    private val CHANNEL = "com.clubfostr.fostr"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call: MethodCall?, result: MethodChannel.Result? ->
                if(call!!.method.equals("setID")){
                   this.creatorId = call.argument<String>("creatorId").toString()
                    this.roomId = call.argument<String>("roomId").toString()
                    this.role = call.argument<String>("role").toString()
                    this.userId =call.argument<String>("role").toString()
                    result!!.success(1)
                }else{
                    result!!.error("0","dasd","adas")
                }
            }
    }




    override fun onDestroy() {
        Log.d("onDestory","hello")
       run("https://us-central1-fostr2021.cloudfunctions.net/updateParticipants")
        super.onDestroy()
    }
}

=======
import io.flutter.embedding.android.FlutterActivity

class MainActivity: FlutterActivity() {
}
>>>>>>> b68f405ecb16ce6bbdbe7696d2f5e90cb734de28
