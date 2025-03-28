import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gradient_glow_border/gradient_glow_border.dart';
import 'package:notes_app/model.dart';
import 'package:notes_app/sql_helpers.dart';

class NotesScrean extends StatefulWidget {
  const NotesScrean({super.key});

  @override
  State<NotesScrean> createState() => _NotesScreanState();
}

SqlHelper sqlHelper = SqlHelper();
class _NotesScreanState extends State<NotesScrean> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes'),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              onPressed: () {
                sqlHelper.deleteAllNotes().whenComplete(() {
                  setState(() {});
                });
              },
              icon: Icon(Icons.delete),
            ),
          ),
        ],
      ),
      body: Center(
        child: FutureBuilder(
          future: sqlHelper.loadNotes(),
          builder: (context, snapshot) {
            if(snapshot.connectionState== ConnectionState.waiting){
              return CircularProgressIndicator();
            }
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return Dismissible(
                  key: UniqueKey(),
                  onDismissed: (direction) {
                    sqlHelper.deleteNote(snapshot.data![index]['id']);
                  },
                  child: Container(
                      margin: EdgeInsets.all(7),
                      height: 150,
                      width: double.infinity,
                      child: GradientGlowBorder.normalGradient(
                        borderRadius: BorderRadius.circular(20),
                        blurRadius: 0,
                        spreadRadius: 0,
                        colors: [Colors.blue, Colors.red],
                        glowOpacity: 0,
                        duration: Duration(milliseconds: 800),
                        thickness: 3,
                        child: Container(
                          height: 150,
                          width: double.infinity,
                          margin: EdgeInsets.all(7),
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Row(
                            children: [
                              Column(
                                children: [
                                  Text(snapshot.data![index]['title']),
                                  Text(snapshot.data![index]['desc']),
                                ],
                              ),
                              IconButton(
                                onPressed: () {
                                  showCupertinoDialog(
                                    context: context,
                                    builder: (_) {
                                      TextEditingController titleController = TextEditingController(
                                        text: snapshot.data![index]['title']
                                      ) ;
                                      TextEditingController descController = TextEditingController(
                                        text: snapshot.data![index]['desc']
                                      );
                                      return CupertinoAlertDialog(
                                        title: Text('Edit Note'),
                                        content: Material(
                                          color: Colors.transparent,
                                          child: Column(
                                            spacing: 5,
                                            children: [
                                              SizedBox(
                                                height: 60,
                                                child: TextFormField(
                                                  controller: titleController,
                                                  decoration: InputDecoration(
                                                    hintText: 'title',
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 60,
                                                child: TextFormField(
                                                  controller: descController,
                                                  decoration: InputDecoration(
                                                    hintText: 'description',
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        actions: [
                                          CupertinoDialogAction(
                                            child: Text('Cancel'),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                          CupertinoDialogAction(
                                            child: Text('Add'),
                                            onPressed: () {
                                              sqlHelper.addNote(
                                                  Note(
                                                      titleController.text,
                                                      descController.text
                                                  )
                                              ).whenComplete((){
                                                setState(() {});
                                              });
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                icon: Icon(Icons.edit),
                              ),
                              Text(index.toString())
                            ],
                          ),
                        ),
                      )),
                );
              },
            );
          }
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showCupertinoDialog(
            context: context,
            builder: (_) {
              TextEditingController titleController = TextEditingController() ;
              TextEditingController descController = TextEditingController();
              return CupertinoAlertDialog(
                title: Text('Add Note'),
                content: Material(
                  color: Colors.transparent,
                  child: Column(
                    spacing: 5,
                    children: [
                      SizedBox(
                        height: 60,
                        child: TextFormField(
                          controller: titleController,
                          decoration: InputDecoration(
                            hintText: 'title',
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 60,
                        child: TextFormField(
                          controller: descController,
                          decoration: InputDecoration(
                            hintText: 'description',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                actions: [
                  CupertinoDialogAction(
                    child: Text('Cancel'),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  CupertinoDialogAction(
                    child: Text('Add'),
                    onPressed: () {
                      sqlHelper.addNote(
                          Note(
                              titleController.text,
                              descController.text
                          )
                      ).whenComplete((){
                        setState(() {});
                      });
                      Navigator.pop(context);
                    },
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
