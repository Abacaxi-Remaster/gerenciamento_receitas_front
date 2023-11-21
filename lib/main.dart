import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'HomePage.dart';

import 'index.dart';
import 'all.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Projeto',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Color.fromRGBO(254, 215, 51, 100),
          ),
        ),
        home: Builder(
          builder: (context) {
            var appState = context.watch<MyAppState>();
            appState.scaffoldMessenger = ScaffoldMessenger.of(context);
            return MyHomePage();
          },
        ),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  late ScaffoldMessengerState scaffoldMessenger;

//inicio:
  var selectedIndex = 0;
  Widget page = LoginPage();
  var logado = false;

//login:
  LoggedUser logged = LoggedUser(-1, 'email', 'senha', 'nome', 0);
  var tipoLogado = 0;

  void logar(LoggedUser user) {
    if (user.tipo == 204) {
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text('Crendenciais Inválidas!'),
        ),
      );
    } else {
      logged = user;
      logado = true;
      tipoLogado = user.tipo;
      notifyListeners();
    }
  }

  void deslogar() {
    //WidgetsBinding.instance.addPostFrameCallback((_) {
    tipoLogado = 0;
    logado = false;
    page = LoginPage();
    selectedIndex = 0;
    print('delogou');
    notifyListeners();
    //deletar dados temporarios do usuário
    //});
  }

// Parte  CRUD de receitas
  Receita receitaAtual = Receita(
      tituloReceitas: 'tituloReceitas',
      descricao: 'descricao',
      id: '-1',
      requisitos: 'requisitos',
      preparo: '');

  List<Receita> _receitas = [];
  List<Receita> get receitas => _receitas;

  void adicionarReceita(Receita receita) {
    _receitas.add(receita);
    notifyListeners();
    print(receita);
  }

  void removerReceita(Receita receita) {
    receitas.remove(receita);
    notifyListeners();
  }

  var receita = <String>[];
  void addReceitas(String receitasUser) {
    receita.add(receitasUser);
  }

//mensagem de erro
  void erro(String mensagem) {
    scaffoldMessenger.showSnackBar(
      SnackBar(
        content: Text(mensagem),
      ),
    );
  }

//Navegação:
  void setPage(Widget newPage) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      page = newPage;
      //print('page: ');
      //print(page);
      notifyListeners();
    });
  }

  void setIndex(int newIndex) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      selectedIndex = newIndex;
      notifyListeners();
    });
  }

//exemplo de add/remove:
  /*
  void adicionarVaga(Vaga vaga) {
    _vagas.add(vaga);
    notifyListeners();
    print(vaga);
  }

  void removerVaga(Vaga vaga) {
    vagas.remove(vaga);
    notifyListeners();
  }
  */

//Pesquisa:
  var filtroAvaliacao = 0;
  setMinimumRating(value) {
    filtroAvaliacao = value;
  }

//Testes------------------------------------------------------------------------------------------------------

  var like = Icon(Icons.favorite_outline);
  var liked = false;
  var numerolike = 187;

  testeToggleLogado() {
    logado = true;
    notifyListeners();
  }

  placeholder() {}
}
