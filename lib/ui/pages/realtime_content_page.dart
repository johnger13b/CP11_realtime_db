import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mintic_un_todo_core/domain/models/to_do.dart';
import 'package:misiontic_todo/ui/controllers/database.dart';

class RealTimeContentPage extends StatefulWidget {
  const RealTimeContentPage({Key? key}) : super(key: key);

  @override
  createState() => _State();
}

class _State extends State<RealTimeContentPage> {
  late TextEditingController _textController;
  late DatabaseController controller;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
    controller = Get.find();
    controller.toDoStream.listen((data) {
      setState(() {
        controller.toDos = data;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lista de ToDos"),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      decoration: const InputDecoration(
                        hintText: "Nuevo To-Do",
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 16.0,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        final toDo = ToDo(content: _textController.text);
                        controller.saveToDo(data: toDo).then((_) {
                          _textController.clear();
                        });
                      },
                      child: const Text("Aceptar"))
                ],
              ),
            ),
            Expanded(
                child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    itemCount: controller.toDos.length,
                    itemBuilder: (ontext, index) {
                      final toDo = controller.toDos[index];
                      return ListTile(
                        leading: AbsorbPointer(
                          absorbing: toDo.completed,
                          child: IconButton(
                            icon: Icon(
                              toDo.completed
                                  ? Icons.check_circle
                                  : Icons.circle_outlined,
                              color:
                                  toDo.completed ? Colors.green : Colors.grey,
                            ),
                            onPressed: () {
                              toDo.completed = true;
                              controller.updateToDo(data: toDo);
                            },
                          ),
                        ),
                        title: Text(toDo.content),
                        trailing: IconButton(
                          onPressed: () {
                            controller.deleteToDo(uuid: toDo.uuid);
                          },
                          icon: const Icon(
                            Icons.delete_forever_rounded,
                            color: Colors.red,
                          ),
                        ),
                      );
                    }))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.delete_sweep_rounded),
        onPressed: () {
          controller.clear();
        },
      ),
    );
  }
}
