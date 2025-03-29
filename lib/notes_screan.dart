import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
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
                const snackBar = SnackBar(
                  elevation: 0,
                  behavior: SnackBarBehavior.fixed,
                  backgroundColor: Colors.transparent,
                  content: AwesomeSnackbarContent(
                    title: 'All notes deleted',
                    contentType: ContentType.failure,
                    message: '',
                  ),
                );
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(snackBar);
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
                    setState(() {
                    });
                    const snackBar = SnackBar(
                      elevation: 0,
                      behavior: SnackBarBehavior.fixed,
                      backgroundColor: Colors.transparent,
                      content: AwesomeSnackbarContent(
                        title: 'Note deleted',
                        contentType: ContentType.failure,
                        message: '',
                      ),
                    );
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(snackBar);
                  },
                  child: Container(
                      margin: EdgeInsets.all(7),
                      height: 150,
                      width: double.infinity,
                      child: GradientGlowBorder.normalGradient(
                        borderRadius: BorderRadius.circular(20),
                        blurRadius: 0,
                        spreadRadius: 0,
                        colors: [Colors.black, Colors.orange,Colors.brown],
                        glowOpacity: 0,
                        duration: Duration(milliseconds: 1000),
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
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 5),
                                child: Container(
                                  child: CircleAvatar(child: Text('${index+1}',style: TextStyle(fontSize: 24),)),
                                  height: 150,
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(snapshot.data![index]['title'],style: TextStyle(fontSize: 24),),
                                      Container(child: SingleChildScrollView(child: Text(snapshot.data![index]['desc']))),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                height: 150,
                                decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(15)
                                ),
                                child: IconButton(
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
                                              child: Text('Edit'),
                                              onPressed: () {
                                                sqlHelper.updateNote(
                                                    Note(
                                                        titleController.text,
                                                        descController.text,
                                                      snapshot.data![index]['id'],
                                                    )
                                                ).whenComplete((){
                                                  setState(() {});
                                                });
                                                Navigator.pop(context);
                                                const snackBar = SnackBar(
                                                  elevation: 0,
                                                  behavior: SnackBarBehavior.fixed,
                                                  backgroundColor: Colors.transparent,
                                                  content: AwesomeSnackbarContent(
                                                    title: 'Edited',
                                                    contentType: ContentType.success,
                                                    message: '',
                                                  ),
                                                );
                                                ScaffoldMessenger.of(context)
                                                  ..hideCurrentSnackBar()
                                                  ..showSnackBar(snackBar);
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  icon: Icon(Icons.edit),
                                ),
                              )
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
                      const snackBar = SnackBar(
                        elevation: 0,
                        behavior: SnackBarBehavior.fixed,
                        backgroundColor: Colors.transparent,
                        content: AwesomeSnackbarContent(
                          title: 'Added',
                          contentType: ContentType.success,
                          message: '',
                        ),
                      );
                      ScaffoldMessenger.of(context)
                        ..hideCurrentSnackBar()
                        ..showSnackBar(snackBar);
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
