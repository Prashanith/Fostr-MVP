package com.clubfostr.fostr

import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import okhttp3.*
import java.io.IOException
import java.net.URL
import javax.net.ssl.HttpsURLConnection
import kotlin.math.log

class MainActivity: FlutterActivity() {
//    private val client = OkHttpClient()
//    private fun clean(){
////    URL("https://us-central1-fostr2021.cloudfunctions.net/updateParticipants").openConnection() as HttpsURLConnection
//    }
//
//    fun run(url: String) {
//        val request = Request.Builder()
//            .url(url)
//            .build()
//        Log.d("run","inner")
//        client.newCall(request).enqueue(object : Callback {
//            override fun onFailure(call: Call, e: IOException) {}
//            override fun onResponse(call: Call, response: Response) = println(response.body()?.string())
//        })
//        Log.d("run","inner-lower")
//    }
//
////    override fun onStart() {
////        super.onStart()
////        Log.d("onStart","calling")
////        run("https://us-central1-fostr2021.cloudfunctions.net/updateParticipants")
//////        clean()
////    }
////
////    override fun onDestroy() {
////        Log.d("onDestroy","upper")
////        run("https://us-central1-fostr2021.cloudfunctions.net/updateParticipants")
////        super.onDestroy()
////        Log.d("onDestroy","lower")
////
////    }
}
