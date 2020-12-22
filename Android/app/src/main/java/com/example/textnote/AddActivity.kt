package com.example.textnote

import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.view.View
import android.widget.TextView
import android.widget.Toast
import android.app.Activity
import android.content.Intent
import com.example.textnote.Helpers.DbHelper


class AddActivity : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_add)
    }


    fun saveNote(view: View) {
        val dbHandler = DbHelper(this, null)
        val titleEditText = findViewById<TextView>(R.id.title_editText)
        val contentEditText = findViewById<TextView>(R.id.content_editText)
        dbHandler.addNote(titleEditText.text.toString(),contentEditText.text.toString())

        val list=dbHandler.getAllNotes()
        Toast.makeText(this, titleEditText.text.toString() + "Added to database", Toast.LENGTH_LONG).show()

        val bundle=Bundle()
        bundle.putString("id",dbHandler.getIdByTitle(titleEditText.text.toString()).toString())
        bundle.putString("title",titleEditText.text.toString())
        bundle.putString("content",contentEditText.text.toString())

        val returnIntent = Intent()
        returnIntent.putExtras(bundle)

        setResult(Activity.RESULT_OK, returnIntent)
        finish()
    }
}
