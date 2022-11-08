import 'package:flutter/material.dart';
import 'package:nosso_primeiro_projeto/data/task_dao.dart';
import 'package:nosso_primeiro_projeto/data/task_inherited.dart';
import 'package:nosso_primeiro_projeto/screens/form_screen.dart';

import '../components/task.dart';

class InitialScreen extends StatefulWidget {
  const InitialScreen({Key? key}) : super(key: key);

  @override
  State<InitialScreen> createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {
  int level = 0;

  void callbackSetState() {
    setState(() {});
  }

  void updateLevel() {
    level = TaskInherited.of(context)
        .taskList
        .map((task) => task.dificuldade * task.maestria)
        .reduce((a, b) => a + b);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          toolbarHeight: 80,
          title: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Text('Tarefas'),
                  IconButton(
                      onPressed: () {
                        setState(() {
                          updateLevel();
                        });
                      },
                      icon: const Icon(Icons.refresh))
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const SizedBox(
                      width: 200,
                      child: LinearProgressIndicator(
                          color: Colors.white, value: 1)),
                  Text('Level: $level')
                ],
              )
            ],
          )),
      body: Padding(
        padding: EdgeInsets.only(top: 8, bottom: 70),
        child: FutureBuilder<List<Task>>(
          future: TaskDao().findAll(),
          builder: (context, snapshot) {
            List<Task>? items = snapshot.data;
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return Center(
                  child: Column(
                    children: [CircularProgressIndicator(), Text('Carregando')],
                  ),
                );
                break;
              case ConnectionState.waiting:
                return Center(
                  child: Column(
                    children: [CircularProgressIndicator(), Text('Carregando')],
                  ),
                );
                break;
              case ConnectionState.active:
                return Center(
                  child: Column(
                    children: [CircularProgressIndicator(), Text('Carregando')],
                  ),
                );
                break;
              case ConnectionState.done:
                if (snapshot.hasData && items != null) {
                  if (items.isNotEmpty) {
                    return ListView.builder(
                        itemCount: items.length,
                        itemBuilder: (BuildContext context, int index) {
                          final Task tarefa = items[index];
                          tarefa.callbackSetState = callbackSetState;
                          return tarefa;
                        });
                  }
                  return Center(
                    child: Column(
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 128,
                        ),
                        Text(
                          'Não há nenhuma tarefa',
                          style: TextStyle(fontSize: 32),
                        )
                      ],
                    ),
                  );
                }
                return Text('Erro ao carregar tarefas');
                break;
            }
            return Text('Erro desconhecido');
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (contextNew) => FormScreen(taskContext: context)),
          ).then((value) => setState(() {
                print('Recarregando a tela inicial');
              }));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
