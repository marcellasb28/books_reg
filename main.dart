import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Certifique-se de que o Flutter está inicializado.
  await copyDatabase(); // Copie o banco de dados existente para o diretório de documentos.
  runApp(MyBooksApp());
}


class MyBooksApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyBooksScreen(),
    );
  }
}

class MyBooksScreen extends StatefulWidget {
  @override
  _MyBooksScreenState createState() => _MyBooksScreenState();
}

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  late Database _database;

  Future<void> initializeDatabase() async {
  if (_database == null || !_database.isOpen) {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'books.db'),
      version: 1,
    );
  }
}


  Future<void> insertBook(String nome, String autor, String genero) async {
    await _database.insert(
      'registros',
      {
        'nome': nome,
        'autor': autor,
        'genero': genero,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getAllBooks() async {
    return await _database.query('registros');
  }
}



class _MyBooksScreenState extends State<MyBooksScreen> {
  final TextEditingController _nomeLivroController = TextEditingController();
  final TextEditingController _autorController = TextEditingController();
  final TextEditingController _generoController = TextEditingController();
  List<String> _historicoLivros = [];
_MyBooksScreenState() {
  DatabaseHelper().initializeDatabase();
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Books"),
        backgroundColor: Color.fromARGB(255, 179, 54, 23), // Tom marrom-avermelhado
      ),
      backgroundColor: Color.fromARGB(255, 226, 146, 117), // Tela de fundo marrom claro
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              "Registre sua leitura nos campos abaixo:",
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _nomeLivroController,
              decoration: InputDecoration(labelText: "Nome do livro:"),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _autorController,
              decoration: InputDecoration(labelText: "Autor(a):"),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _generoController,
              decoration: InputDecoration(labelText: "Gênero:"),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _registrarLivro();
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.black, // Botão branco
                textStyle: TextStyle(fontSize: 18),
              ),
              child: Text("REGISTRAR"),
            ),
            SizedBox(height: 16),
            SizedBox(height: 16), // Espaço adicionado aqui
            Text(
              "Histórico de registros:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white, // Cor de fundo mais clara
                borderRadius: BorderRadius.circular(12.0), // Borda arredondada
              ),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _historicoLivros.length,
                itemBuilder: (context, index) {
                  final livro = _historicoLivros[index];
                  final parts = livro.split(' - ');
                  return ListTile(
                    title: Text(parts[0]), // Nome do livro
                    subtitle: Text('Autor: ${parts[1]}, Gênero: ${parts[2]}'), // Autor e Gênero
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

void _registrarLivro() async {
  final nomeLivro = _nomeLivroController.text;
  final autor = _autorController.text;
  final genero = _generoController.text;

  if (nomeLivro.isNotEmpty && autor.isNotEmpty && genero.isNotEmpty) {

    await DatabaseHelper().insertBook(nomeLivro, autor, genero); // Insira o livro
    setState(() {
      _limparCampos();
    });
  }
}


  void _limparCampos() {
    _nomeLivroController.clear();
    _autorController.clear();
    _generoController.clear();
  }

Future<void> copyDatabase() async {
  try {
    // Obtenha o diretório de documentos do aplicativo.
    final documentsDirectory = await getApplicationDocumentsDirectory();

    // Caminho para o banco de dados no diretório de documentos.
    final databasePath = join(documentsDirectory.path, 'books.db');

    // Caminho para o seu banco de dados SQLite existente.
    final sourceDatabasePath = 'file:///C:/sqlite3/books.bd;';

    // Verifique se o arquivo de origem existe antes de copiar.
    if (await File(sourceDatabasePath).exists()) {
      await File(sourceDatabasePath).copy(databasePath);
    }
  } catch (e) {
    print('Erro ao copiar o banco de dados: $e');
   
  }

}
