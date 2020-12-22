package com.example.textnote

import android.content.Context
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.BaseAdapter
import android.widget.TextView

class NoteAdapter (private val context: Context,
                   private val dataSource: ArrayList<Note>) : BaseAdapter() {

    private val inflater: LayoutInflater
            = context.getSystemService(Context.LAYOUT_INFLATER_SERVICE) as LayoutInflater

    //1
    override fun getCount(): Int {
        return dataSource.size
    }

    //2
    override fun getItem(position: Int): Any {
        return dataSource[position]
    }

    //3
    override fun getItemId(position: Int): Long {
        return position.toLong()
    }

    //4
    override fun getView(position: Int, convertView: View?, parent: ViewGroup): View {
        // Get view for row item
        val rowView = inflater.inflate(R.layout.list_item_note, parent, false)


        val titleTextView = rowView.findViewById(R.id.note_list_title) as TextView
        val contentTextView = rowView.findViewById(R.id.note_list_text) as TextView

        val currentNote = getItem(position) as Note

        titleTextView.text = currentNote.id.toString() + "--"+ currentNote.title
        contentTextView.text = currentNote.content

        return rowView
    }
}