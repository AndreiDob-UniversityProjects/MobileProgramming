var express = require("express");
var app = express();
var bodyParser = require('body-parser')
app.use( bodyParser.json() );

const mysql = require('mysql');
const connection = mysql.createConnection({
    host: 'localhost',
    user: 'user',
    password: 'password',
    database: 'text_note'
});

connection.connect((err) => {
    if (err) throw err;
    console.log('Connected!');
});



app.listen(3000, () => {
    console.log("Server running on port 3000");
    console.log("\n")
});

app.get("/notes", (req, res, next) => {
    console.log('GET /')
    connection.query('SELECT * FROM notes', (err,rows) => {
        if(err) throw err;

        //console.log('Data received from Db:\n');
        //console.log(rows);
        res.json(rows);
    });
    console.log("\n")
});

app.post('/add', function(request, response) {
    console.log('POST add /')
    console.log(request.body)

    var title = request.body.title;
    var content = request.body.content;

    connection.query('insert into notes(title,content) values ("'+title+'","'+content+'")', (err, res) => {
        if(err) throw err;
        console.log('Last insert ID:', res.insertId,": ",title," | ",content);
        response.json("Inserted with id: "+ res.insertId);
    });
    console.log("\n")
});

app.post('/update', function(request, response) {
    console.log('POST update/')
    console.log(request.body)

    var id = request.body.id;
    var title = request.body.title;
    var content = request.body.content;

    connection.query(
        'UPDATE notes SET title ="'+title+'", content="'+content+'" Where id ='+id,
        (err, result) => {
            if (err) throw err;

            //console.log(`Changed ${result.changedRows} row(s)`);
            response.json("updated to: "+ request);
        }
    );
    console.log("\n")
});

app.post('/delete', function(request, response) {
    console.log('POST delete/')
    console.log(request.body)

    var id = request.body.id;

    connection.query(
        'DELETE FROM notes WHERE id = '+id, (err, result) => {
            if (err) throw err;

            //console.log(`Deleted ${result.affectedRows} row(s)`);
            response.json("Deleted with id: "+ id);
        }
    );
    console.log("\n")
});