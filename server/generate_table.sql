use text_note;
CREATE TABLE IF NOT EXISTS notes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) ,
    content VARCHAR(255) 
);

insert into notes(title,content) values 
	("note1_server","content1_server"),
    ("note2_server","content2_server"),
    ("note3_server","content3_server"),
    ("note4_server","content4_server"),
    ("note5_server","content5_server");

delete from notes where id>0;
    
select * from notes;

ALTER USER 'user'@'localhost' IDENTIFIED WITH mysql_native_password BY 'password';

CREATE USER 'user'@'%' IDENTIFIED WITH mysql_native_password BY 'password';
-- then
FLUSH PRIVILEGES;
GRANT ALL PRIVILEGES ON *.* TO 'user'@'%';
-- then
FLUSH PRIVILEGES;