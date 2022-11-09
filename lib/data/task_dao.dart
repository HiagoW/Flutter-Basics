import 'package:nosso_primeiro_projeto/components/task.dart';
import 'package:nosso_primeiro_projeto/data/database.dart';
import 'package:sqflite/sqflite.dart';

class TaskDao {
  static const String tableSql = 'CREATE TABLE $_tableName('
      '$_name TEXT, '
      '$_difficulty INTEGER, '
      '$_image TEXT,'
      '$_nivel INTEGER,'
      '$_maestry INTEGER)';

  static const String _tableName = 'taskTable';
  static const String _name = 'name';
  static const String _difficulty = 'difficulty';
  static const String _image = 'image';
  static const String _nivel = 'nivel';
  static const String _maestry = 'maestry';

  save(Task tarefa) async {
    print('Iniciando o save: ');
    final Database database = await getDatabase();
    var itemExists = await find(tarefa.nome);
    Map<String, dynamic> taskMap = toMap(tarefa);
    if (itemExists.isEmpty) {
      print('A tarefa não exitia');
      return await database.insert(_tableName, taskMap);
    } else {
      print('A tarefa já existia!');
      await database.update(
        _tableName,
        taskMap,
        where: '$_name = ?',
        whereArgs: [tarefa.nome],
      );
    }
  }

  saveAsync(Task tarefa) async {
    print('Iniciando o save async: ');
    final Database database = await getDatabase();
    var itemExists = await find(tarefa.nome);
    Map<String, dynamic> taskMap = toMap(tarefa);
    if (itemExists.isEmpty) {
      print('A tarefa não exitia');
      return database.insert(_tableName, taskMap);
    } else {
      print('A tarefa já existia!');
      database.update(
        _tableName,
        taskMap,
        where: '$_name = ?',
        whereArgs: [tarefa.nome],
      );
    }
  }

  Map<String, dynamic> toMap(Task task) {
    print('Convertendo tarefa em Map: ');
    final Map<String, dynamic> taskMap = Map();
    taskMap[_name] = task.nome;
    taskMap[_difficulty] = task.dificuldade;
    taskMap[_image] = task.foto;
    taskMap[_nivel] = task.nivel;
    taskMap[_maestry] = task.maestria;
    print('Mapa de Tarefas: $taskMap');
    return taskMap;
  }

  Future<List<Task>> findAll() async {
    print('Acessando o findAll: ');
    final Database database = await getDatabase();
    final List<Map<String, dynamic>> result = await database.query(_tableName);
    print('Procurando dados no banco de dados... encontrado: $result');
    return toList(result);
  }

  List<Task> toList(List<Map<String, dynamic>> taskMap) {
    print('Convertendo to List:');
    final List<Task> tasks = [];
    for (Map<String, dynamic> row in taskMap) {
      tasks.add(Task(row[_name], row[_image], row[_difficulty], nivel: row[_nivel], maestria: row[_maestry]));
    }
    print('Lista de tarefas $tasks');
    return tasks;
  }

  Future<List<Task>> find(String nomeDaTarefa) async {
    print('Acessando o find: ');
    final Database database = await getDatabase();
    final List<Map<String, dynamic>> result = await database.query(
      _tableName,
      where: '$_name = ?',
      whereArgs: [nomeDaTarefa],
    );
    print('Tarefa encontrada: ${toList(result)}');
    return toList(result);
  }

  delete(String nomeDaTarefa) async {
    print('Deletando tarefa: $nomeDaTarefa');
    final Database database = await getDatabase();
    return database.delete(
      _tableName,
      where: '$_name = ?',
      whereArgs: [nomeDaTarefa],
    );
  }
}
