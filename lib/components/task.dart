import 'package:flutter/material.dart';
import 'package:nosso_primeiro_projeto/data/task_dao.dart';

import 'difficulty.dart';

class Task extends StatefulWidget {
  final String nome;
  final String foto;
  final int dificuldade;
  int maestria = 0;
  Function? callbackSetState;
  int nivel = 0;

  Task(this.nome, this.foto, this.dificuldade, {this.nivel = 0, this.maestria = 0, this.callbackSetState, Key? key}) : super(key: key);

  @override
  State<Task> createState() => _TaskState();
}

class _TaskState extends State<Task> {
  var maestriaCores = {0: Colors.blue, 1: Colors.green, 2: Colors.purple};

  bool assertOrNetwork() {
    if (widget.foto.contains('http')) {
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: maestriaCores[widget.maestria]),
            height: 140,
          ),
          Column(
            children: [
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: Colors.white),
                height: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: Colors.black26),
                      width: 72,
                      height: 100,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: assertOrNetwork()
                            ? Image.asset(
                                widget.foto,
                                fit: BoxFit.cover,
                              )
                            : Image.network(
                                widget.foto,
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                            width: 200,
                            child: Text(
                              widget.nome,
                              style: const TextStyle(fontSize: 24),
                              overflow: TextOverflow.ellipsis,
                            )),
                        Difficulty(difficultyLevel: widget.dificuldade),
                      ],
                    ),
                    SizedBox(
                      height: 52,
                      width: 52,
                      child: ElevatedButton(
                          onLongPress: () => showDialog(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                    title: Row(children: [
                                      Text('Deletar'),
                                      Icon(Icons.delete)
                                    ]),
                                    content: Text(
                                        'Certeza que deseja deletar essa tarefa?'),
                                    actions: [
                                      TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context, 'Cancel'),
                                          child: const Text('Cancel')),
                                      TextButton(
                                          onPressed: () => {
                                                TaskDao().delete(widget.nome),
                                                if (widget.callbackSetState != null && widget.callbackSetState is Function) {
                                                  widget.callbackSetState!()
                                                },
                                                Navigator.pop(context, 'OK')
                                              },
                                          child: const Text('OK')),
                                    ],
                                  )),
                          onPressed: () {
                            setState(() {
                              if (widget.maestria < 2 &&
                                  (widget.nivel / widget.dificuldade) / 10 ==
                                      1) {
                                widget.nivel = 0;
                                widget.maestria++;
                              } else {
                                widget.nivel++;
                              }
                              TaskDao().saveAsync(widget);
                            });
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: const [
                              Icon(Icons.arrow_drop_up),
                              Text(
                                'UP',
                                style: TextStyle(fontSize: 12),
                              )
                            ],
                          )),
                    )
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: SizedBox(
                      width: 200,
                      child: LinearProgressIndicator(
                          color: Colors.white,
                          value: (widget.dificuldade > 0)
                              ? (widget.nivel / widget.dificuldade) / 10
                              : 1),
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        'Nivel: ${widget.nivel}',
                        style:
                            const TextStyle(color: Colors.white, fontSize: 16),
                      ))
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
