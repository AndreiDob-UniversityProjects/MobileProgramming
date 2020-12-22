package com.example.textnote

import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.widget.ListView
import android.view.View
import android.content.Intent
import android.app.Activity
import android.widget.BaseAdapter
import com.example.textnote.Helpers.DbHelper
import com.example.textnote.Helpers.RestHelper


class MainActivity : AppCompatActivity() {

    private lateinit var listView: ListView
    private var noteList=ArrayList<Note>()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        //loadOnlyBasicNotes()

        listView = this.findViewById(R.id.note_list_view)

        val dbHandler = DbHelper(this, null)
        this.noteList = dbHandler.getAllNotes()

        //TEST AREA
        simpleTests()
        //TEST AREA

        val adapter = NoteAdapter(this, noteList)
        listView.adapter = adapter

        val context = this

        listView.setOnItemClickListener { _, _, position, _ ->

            val selectedNote = dbHandler.getAllNotes()[position]

            val detailIntent = NoteDetailActivity.newIntent(context, selectedNote)
            startActivityForResult(detailIntent, 2)
            //refreshList()
        }

    }

    fun simpleTests(){
        val rest=RestHelper(this)
        var result=rest.getAllNotes()
        var abc=""
    }

    fun loadOnlyBasicNotes() {
        val dbHandler = DbHelper(this, null)

        dbHandler.eraseAllData()

        for (i in 1..5) {
            dbHandler.addNote("note title" + i.toString(), "note content" + i.toString())
        }
    }

//    override fun onResume() {
//        super.onResume()
//        refreshList()
//    }
//
//    //TODO fa cu startActivityForResult si onResult(). Adauga la lista folosita pentru
//    // adapter si da-i notify changed
//    fun refreshList() {
//        listView = findViewById(R.id.note_list_view)
//        val dbHandler = DbHelper(this, null)
//
//        val adapter = NoteAdapter(this, dbHandler.getAllNotes())
//        listView.adapter = adapter
//    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)

        if (requestCode == 1) {
            if (resultCode == Activity.RESULT_OK) {
                val id = data!!.getStringExtra("id").toInt()
                val title = data!!.getStringExtra("title")
                val content = data!!.getStringExtra("content")
                this.noteList.add(Note(id, title, content))
                (this.listView.getAdapter() as BaseAdapter).notifyDataSetChanged()
            }
        }
        if (requestCode == 2) {
            if (resultCode == Activity.RESULT_OK) {
                val action=data!!.getStringExtra("action")
                if(action=="update"){
                    val id = data!!.getStringExtra("id").toInt()
                    val title = data!!.getStringExtra("title")
                    val content = data!!.getStringExtra("content")

                    for (i in 0..noteList.size-1) {
                        if(noteList.get(i).id==id){
                            noteList.set(i,Note(id, title,content))
                        }
                    }

                    (this.listView.getAdapter() as BaseAdapter).notifyDataSetChanged()
                }
                if(action=="delete"){
                    val id = data!!.getStringExtra("id").toInt()

                    for (i in 0..noteList.size-1) {
                        if(noteList.get(i).id==id){
                            noteList.removeAt(i)
                            (this.listView.getAdapter() as BaseAdapter).notifyDataSetChanged()
                            return
                        }
                    }


                }


            }
        }

    }

    fun navigateToAddActivity(view: View) {
        val intent = Intent(this, AddActivity::class.java)
        startActivityForResult(intent, 1)
        //refreshList()
    }


}
