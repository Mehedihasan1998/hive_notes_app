import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:notes_app/boxes/boxes.dart';
import 'package:notes_app/model/notes_model.dart';
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text("Quick Notes🖋"),
            backgroundColor: Colors.amber,
            titleTextStyle: myStyle(25, Colors.white, FontWeight.bold),
            centerTitle: true,
          ),
          body: ValueListenableBuilder<Box<NotesModel>>(
            valueListenable: Boxes.getData().listenable(),
            builder: (context, box, _){
              // convert the values of the box to list
              // so that you can find them index wise
              var data = box.values.toList().cast<NotesModel>();
              return ListView.builder(
                reverse: true,
                shrinkWrap: true,
                itemCount: box.length,
                  itemBuilder: (context, index){
                    return InkWell(
                      onTap: (){
                        update(data[index], data[index].title.toString(), data[index].description.toString());

                      },
                      onLongPress: (){
                        _deleteDialogue(data[index]);
                      },
                      child: Card(
                        color: Colors.amber.shade100,
                        elevation: 2,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(data[index].title.toString(), style: myStyle(35, Colors.green),),
                                  Spacer(),
                                  IconButton(onPressed: (){
                                    update(data[index], data[index].title.toString(), data[index].description.toString());
                                  }, icon: Icon(Icons.edit, color: Colors.blue,)),
                                  IconButton(onPressed: (){
                                    // delete(data[index]);
                                    _deleteDialogue(data[index]);
                                  }, icon: Icon(Icons.delete, color: Colors.red,)),
                                ],
                              ),
                              Text(data[index].description.toString(), style: myStyle2(15)),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
              );
            },
          ),
          floatingActionButton: FloatingActionButton(
              onPressed: () async {
                _showMyDialogue();
              },
            backgroundColor: Colors.amber,
            child: Icon(Icons.add, color: Colors.white, size: 30,),
          ),
        ));
  }
  void delete(NotesModel notesModel) async{
    await notesModel.delete();
  }
  Future<void> update(NotesModel notesModel, String title, String description) async{
    titleController.text = title;
    descriptionController.text = description;
    return showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: Text("Edit notes"),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller: titleController,
                    decoration: InputDecoration(
                      hintText: "title",
                    ),
                  ),
                  TextFormField(
                    controller: descriptionController,
                    maxLines: 10,
                    decoration: InputDecoration(
                      hintText: "description",
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: (){
                    titleController.clear();
                    descriptionController.clear();
                    Navigator.pop(context);
                  }, child: Text("Cancel")),
              TextButton(
                  onPressed: (){
                    notesModel.title = titleController.text.toString();
                    notesModel.description = descriptionController.text.toString();

                    notesModel.save();

                    titleController.clear();
                    descriptionController.clear();
                    Navigator.pop(context);

                  }, child: Text("Add")),
            ],
          );
        }
    );
  }
  Future<void> _deleteDialogue(NotesModel notesModel) async{
    return showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: Text("Delete!!!"),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  Text("Do you want to delete this note?")
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: (){
                    delete(notesModel);
                    titleController.clear();
                    descriptionController.clear();
                    Navigator.pop(context);

                  }, child: Text("Yes")
              ),
              TextButton(
                  onPressed: (){
                    Navigator.pop(context);
                  }, child: Text("No")
              ),

            ],
          );
        }
    );
  }
  Future<void> _showMyDialogue() async{
    return showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: Text("Add notes"),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller: titleController,
                    decoration: InputDecoration(
                      hintText: "title",
                    ),
                  ),
                  TextFormField(
                    controller: descriptionController,
                    maxLines: 10,
                    decoration: InputDecoration(
                      hintText: "description",
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: (){
                    titleController.clear();
                    descriptionController.clear();
                    Navigator.pop(context);
                  }, child: Text("Cancel")),
              TextButton(
                  onPressed: (){
                    // make the data of the type of model class
                    final data = NotesModel(title: titleController.text, description: descriptionController.text);
                    // make a box which is like a file
                    final box = Boxes.getData();
                    // Add the data in the box
                    box.add(data);
                    // If you extend the HiveObject class in the Model class
                    // then you can use this save() function to save the data
                    // you don't need to use setState any more for this
                    // the screen will be automatically updated
                    data.save();

                    titleController.clear();
                    descriptionController.clear();
                    Navigator.pop(context);

                  }, child: Text("Add")),
            ],
          );
        }
    );
  }
  myStyle(double fs, [Color ?clr, FontWeight ?fw,]){
    return GoogleFonts.dancingScript(
        fontSize: fs,
        color: clr,
        fontWeight: fw
    );
  }
  myStyle2(double fs, [Color ?clr, FontWeight ?fw,]){
    return GoogleFonts.poppins(
        fontSize: fs,
        color: clr,
        fontWeight: fw
    );
  }
}
