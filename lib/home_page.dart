import 'package:flutter/material.dart';
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
          appBar: AppBar(title: Text("Notes App"), backgroundColor: Colors.blue,),
          body: ValueListenableBuilder<Box<NotesModel>>(
            valueListenable: Boxes.getData().listenable(),
            builder: (context, box, _){
              // convert the values of the box to list
              // so that you can find them index wise
              var data = box.values.toList().cast<NotesModel>();
              return ListView.builder(
                itemCount: box.length,
                  itemBuilder: (context, index){
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(data[index].title.toString()),
                                Spacer(),
                                IconButton(onPressed: (){
                                  update(data[index], data[index].title.toString(), data[index].description.toString());
                                }, icon: Icon(Icons.edit)),
                                IconButton(onPressed: (){
                                  delete(data[index]);
                                }, icon: Icon(Icons.delete)),
                              ],
                            ),
                            Text(data[index].description.toString()),
                          ],
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
            child: Icon(Icons.add),
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
}
