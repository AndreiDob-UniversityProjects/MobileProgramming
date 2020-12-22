package com.example.textnote

import android.app.Activity
import android.content.Context
import android.content.Intent
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.view.View
import android.widget.TextView
import android.widget.Toast
import com.example.textnote.Helpers.DbHelper

class NoteDetailActivity : AppCompatActivity() {

    var noteId=0
    var noteTitle=""
    var noteContent=""

    companion object {
        const val EXTRA_TITLE = "title"
        const val EXTRA_TEXT = "content"
        const val EXTRA_ID = "-1"


        fun newIntent(context: Context, note: Note): Intent {
            val detailIntent = Intent(context, NoteDetailActivity::class.java)

            detailIntent.putExtra(EXTRA_TITLE, note.title)
            detailIntent.putExtra(EXTRA_TEXT, note.content)
            detailIntent.putExtra(EXTRA_ID, note.id.toString())

            return detailIntent
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_note_detail)

        this.noteId=intent.extras.getString(EXTRA_ID).toInt()
        this.noteTitle = intent.extras.getString(EXTRA_TITLE)
        this.noteContent = intent.extras.getString(EXTRA_TEXT)

        setTitle("Edit note")

        val titleEditText = findViewById<TextView>(R.id.title_editText)
        val contentEditText = findViewById<TextView>(R.id.content_editText)

        titleEditText.text=this.noteTitle
        contentEditText.text=this.noteContent

    }

    fun deleteNote(view: View) {
        //noteRepo.delete(this.noteId)
        val dbHandler = DbHelper(this, null)
        dbHandler.deleteNote(noteId)

        val bundle=Bundle()
        bundle.putString("action","delete")
        bundle.putString("id",noteId.toString())

        val returnIntent = Intent()
        returnIntent.putExtras(bundle)

        setResult(Activity.RESULT_OK, returnIntent)
        finish()
    }

    fun saveNote(view: View) {

        val dbHandler = DbHelper(this, null)
        val titleEditText = findViewById<TextView>(R.id.title_editText)
        val contentEditText = findViewById<TextView>(R.id.content_editText)

        dbHandler.updateNote(Note(noteId,titleEditText.text.toString(),contentEditText.text.toString()))

        Toast.makeText(this, titleEditText.text.toString() + " was updated in the database", Toast.LENGTH_LONG).show()

        val bundle=Bundle()
        bundle.putString("action","update")
        bundle.putString("id",dbHandler.getIdByTitle(titleEditText.text.toString()).toString())
        bundle.putString("title",titleEditText.text.toString())
        bundle.putString("content",contentEditText.text.toString())

        val returnIntent = Intent()
        returnIntent.putExtras(bundle)

        setResult(Activity.RESULT_OK, returnIntent)
        finish()
    }
}
