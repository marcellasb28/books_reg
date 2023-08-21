import 'package:flutter/material.dart';

void main() {
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

class _MyBooksScreenState extends State<MyBooksScreen> {
  final TextEditingController _nomeLivroController = TextEditingController();
  final TextEditingController _autorController = TextEditingController();
  final TextEditingController _classificacaoController = TextEditingController();
  List<String> _historicoLivros = [];

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
              controller: _classificacaoController,
              decoration: InputDecoration(labelText: "Classificação:"),
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
                  return ListTile(
                    title: Text(_historicoLivros[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _registrarLivro() {
    final nomeLivro = _nomeLivroController.text;
    final autor = _autorController.text;
    final classificacao = _classificacaoController.text;

    // Valide se todos os campos estão preenchidos antes de adicionar ao histórico
    if (nomeLivro.isNotEmpty && autor.isNotEmpty && classificacao.isNotEmpty) {
      setState(() {
        final livroRegistrado = "$nomeLivro - $autor - $classificacao";
        _historicoLivros.add(livroRegistrado);
        _limparCampos();
      });
    }
  }

  void _limparCampos() {
    _nomeLivroController.clear();
    _autorController.clear();
    _classificacaoController.clear();
  }
}
