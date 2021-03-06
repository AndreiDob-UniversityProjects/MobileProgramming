# projectIdea
Describe your project idea from the point of view of a client.
The client is not having any technical skills but has a very good idea of why he needs a mobile application for his users.
The details should cover the following requirements:
- The application should offer CRUD operations on the business objects. The main screen should be a list of the business objects and it should allow at least the following operations:
   - Create - create new elements that will be added to the list.
   - Read - present the elements in a list.
   - Update - allow the user to update an element found in the list.
   - Delete - delete existing elements from the list.
- The application should persist the content locally, to be able to allow offline access. And while online it should synchronize the content with a remote server (implemented also by you, in the language of your choice, no serverless solutions are allowed yet).
- The communication with the server should be managed using REST services, and it should have counterpart operations for each of the operations mentioned above.
- While offline the application will perform the following actions:
   - On update and delete - a message will be displayed, that the application is offline and the operation is not available.
   - On read - the content from the local database will be displayed.
   - On create - the input will be persisted in the local database and when the application will detect that the device is able to connect to the server will push all the created entries, while the device was offline.
   
   Project idea:
   
   The app will be called TextNote and will be an app that allows the user to memorise short text notes. Also, it can have a section for quickly making a shopping list. 
   The user can predefine things that he usually buys. Those things will appear as buttons which, when clicked, will add an object tot the list without the need to write it down manually. 
   If you ever used Evernote, this app should look similar, but run faster.
   So, the user can:
      - Create - create a text note that will be added to the list.
      - Read - present the text notes in a list.
      - Update - update a text note found in the list.
      - Delete - delete existing text notes from the list.
   
   - The application should persist the content locally, to be able to allow offline access. And while online it should synchronize the content with a remote server (no serverless solutions are allowed).
   - The communication with the server should be managed using REST services, and it should have counterpart operations for each of the operations mentioned above.
   - While offline the application will perform the following actions:
    - On update and delete - a message will be displayed, that the application is offline and the operation is not available.
    - On read - the content from the local database will be displayed.
    - On create - the input will be persisted in the local database and when the application will detect that the device is able to connect to the server will push all the created entries, while the device was offline.
