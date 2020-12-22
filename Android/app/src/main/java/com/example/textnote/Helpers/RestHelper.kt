package com.example.textnote.Helpers

import android.content.Context
import android.net.ConnectivityManager
import android.net.NetworkInfo
import java.io.IOException
import com.example.textnote.MainActivity
import android.R.string
import okhttp3.*
import org.json.JSONException
import org.json.JSONObject
import org.junit.experimental.results.ResultMatchers.isSuccessful


class RestHelper(private val context: Context) {


//    fun addNote(title: String, text: String) {
//
//    }
//
//    fun deleteNote(id: Int): Int {
//
//    }
//
//    fun updateNote(note: Note): {
//
//    }

    fun getAllNotes():String {//ArrayList<Note> {
        var body=""
//
//        if(!appHasInternet()){
//            return "No internet"
//        }
//        val queue = Volley.newRequestQueue(context)
//        val request = JsonArrayRequest(
//            Request.Method.GET, base_url+"/notes", null,
//            Response.Listener { response ->
//                body= response.toString()
//            },
//            Response.ErrorListener { error ->
//                // TODO: Handle error
//            }
//        )
//        queue.add(request)

        //return URL( base_url+"/notes").readText()
        return run(base_url+"/notes")
    }



    @Throws(IOException::class)
    fun run(url: String): String {
        val client = OkHttpClient()

        val url = "https://reqres.in/api/users?page=2"

        val request = Request.Builder()
            .url(url)
            .build()

        client.newCall(request).enqueue(object : Callback {
            override fun onFailure(call: Call, e: IOException) {
                e.printStackTrace()
            }

            @Throws(IOException::class)
            override fun onResponse(call: Call, response: Response) {
                if (response.isSuccessful) {
                    val responseData = response.body?.string()

                    runOnUiThread{
                        try {
                            var json = JSONObject(responseData)
                            println("Request Successful!!")
                            println(json)
                            val responseObject = json.getJSONObject("response")
                            val docs = json.getJSONArray("docs")
                            this@MainActivity.fetchComplete()
                        } catch (e: JSONException) {
                            e.printStackTrace()
                        }
                    }
                }
            }
        })
    }

    fun appHasInternet():Boolean{
        val connectivityManager = context.getSystemService(Context.CONNECTIVITY_SERVICE) as ConnectivityManager
        val activeNetwork: NetworkInfo? = connectivityManager.activeNetworkInfo
        val isConnected: Boolean = activeNetwork?.isConnectedOrConnecting == true
        return isConnected
    }

    companion object {
        val base_url = "http://10.0.2.2:3000"

    }
}