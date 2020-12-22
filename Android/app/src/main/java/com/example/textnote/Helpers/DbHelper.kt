package com.example.textnote.Helpers

import android.content.ContentValues
import android.content.Context
import android.database.sqlite.SQLiteDatabase
import android.database.sqlite.SQLiteOpenHelper
import com.example.textnote.Note


class DbHelper(
    context: Context,
    factory: SQLiteDatabase.CursorFactory?
) :
    SQLiteOpenHelper(
        context, DATABASE_NAME,
        factory, DATABASE_VERSION
    ) {

    override fun onCreate(db: SQLiteDatabase) {
        val CREATE_TABLE = ("CREATE TABLE " + TABLE_NAME + " ( " +
                "id INTEGER PRIMARY KEY," +
                "title TEXT," +
                "content TEXT);")
        db.execSQL(CREATE_TABLE)
    }

    override fun onUpgrade(db: SQLiteDatabase, oldVersion: Int, newVersion: Int) {
        db.execSQL("DROP TABLE IF EXISTS " + TABLE_NAME)
        onCreate(db)
    }

    fun clearAllFromDatabase(){

    }

    fun addNote(title:String,text:String) {
        val values = ContentValues()
        //values.put("id", currentId)
        values.put("title", title)
        values.put("content", text)
        val db = this.writableDatabase
        db.insert(TABLE_NAME, null, values)
        db.close()
        //currentId+=1
    }

    fun deleteNote(id : Int) : Int {
        val db = this.writableDatabase
        return db.delete(TABLE_NAME,"id = ?", arrayOf(id.toString()))
    }

    fun eraseAllData(){
        val db = this.writableDatabase
        db.execSQL("delete from "+ TABLE_NAME);
    }

    fun updateNote(note: Note):
            Boolean {
        val db = this.writableDatabase
        val values = ContentValues()
        values.put("id", note.id)
        values.put("title", note.title)
        values.put("content", note.content)
        db.update(TABLE_NAME, values, "id = ?", arrayOf(note.id.toString()))
        return true
    }


    fun getIdByTitle(title:String): Int {
        for(note in getAllNotes()){
            if(note.title==title){
                return note.id
            }
        }
        return -1
    }

    fun getAllNotes(): ArrayList<Note> {
        val db = this.readableDatabase
        val cursor = db.rawQuery("SELECT * FROM $TABLE_NAME", null)
        cursor!!.moveToFirst()
        val noteList= ArrayList<Note>()

        noteList.add(
            Note(
                cursor.getString(cursor.getColumnIndex("id")).toInt(),
                cursor.getString(cursor.getColumnIndex("title")),
                cursor.getString(cursor.getColumnIndex("content"))
            )
        )

        while (cursor.moveToNext()) {
            noteList.add(
                Note(
                    cursor.getString(cursor.getColumnIndex("id")).toInt(),
                    cursor.getString(cursor.getColumnIndex("title")),
                    cursor.getString(cursor.getColumnIndex("content"))
                )
            )
        }
        cursor.close()
        return noteList
    }



    companion object {
        private val DATABASE_VERSION = 1
        private val DATABASE_NAME = "textNote.db"
        val TABLE_NAME = "text_note"
        private var currentId = 0;
    }
}