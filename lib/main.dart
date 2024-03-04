import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:notes_app/home_page.dart';
import 'package:notes_app/model/notes_model.dart';
import 'package:path_provider/path_provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  var directory = await getApplicationDocumentsDirectory();
  Hive.init(directory.path);
  
  Hive.registerAdapter(NotesModelAdapter());
  await Hive.openBox<NotesModel>('notes');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // what is happening in this app?
      // valueListenable property that listens to the Boxes class
      // where there is a function called getData(),
      // where Hive has a box(file) called 'notes', that contains only NotesModel type data
      // after getting the data, we convert it to List and cast it to the NotesModel generic type
      // so that we can access the data index wise
      home: HomePage(),
    );
  }
}
