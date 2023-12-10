import 'dart:html';

import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

validaNull(value) {
  if (value == null || value.isEmpty) {
    return '*Campo Obrigatório!';
  }
  return null;
}

validaNullClean(value) {
  if (value == null || value.isEmpty) {
    return '';
  }
  return null;
}

//Cadastro/Login:
class RegisterUser {
  int id;
  String nome;
  String email;
  String senha;

  RegisterUser(this.id, this.nome, this.email, this.senha);

  Map<String, dynamic> toJson() {
    return {
      'usuario': "user",
      'nome': nome,
      'email': email,
      'senha': senha,
    };
  }

  Map<String, dynamic> updateToJson() {
    return {
      'id': id,
      'nome': nome,
      'email': email,
      'senha': senha,
    };
  }
}

Future<int> cadastro(tipo, nome, email, senha, ultimo) async {
  RegisterUser newUser = RegisterUser(tipo, nome, email, senha);

  String jsonUser = jsonEncode(newUser.toJson());

  http.Response response = await http.post(
    Uri.parse("http://localhost:8000/cadastro"),
    headers: {'Content-Type': 'application/json'},
    body: jsonUser,
  );

  if (response.statusCode == 200) {
    print('Cadastro feito com sucesso');
  } else {
    if (response.statusCode == 400) {
      print('erro no cadastro');
    }
  }
  return response.statusCode;
}

Future<int> update(id, nome, email, senha) async {
  RegisterUser newUser = RegisterUser(id, nome, email, senha);

  String jsonUser = jsonEncode(newUser.updateToJson());

  http.Response response = await http.post(
    Uri.parse("http://localhost:8000/update"),
    headers: {'Content-Type': 'application/json'},
    body: jsonUser,
  );

  if (response.statusCode == 200) {
    print('Cadastro feito com sucesso');
  } else {
    if (response.statusCode == 400) {
      print('erro no cadastro');
    }
  }
  return response.statusCode;
}

Future<String> getNome(email) async {
  http.Response response = await http.get(
    Uri.parse("http://localhost:8000/recuperarNome/$email"),
    headers: {'Content-Type': 'application/json'},
  );

  if (response.statusCode == 200) {
    print(response.body);
    Map<String, dynamic> decodedData = jsonDecode(response.body);
    return decodedData['nome'];
  } else {
    if (response.statusCode == 400) {
      print('Email nao existe');
    }
  }
  return response.statusCode.toString();
}

Future<int> atualizarSenha(String testeNome, String email, String novaSenha,
    String confirmarSenha) async {
  if (novaSenha != confirmarSenha) {
    // Senhas não coincidem
    return 400;
  }

  String nome = await (getNome(email));
  print('nome: $nome');
  print('teste: $testeNome');
  if (nome != testeNome) {
    print('nomes diferentes');
    return 600;
  }

  Map<String, dynamic> newUser = {'email': email, 'senha': novaSenha};
  String jsonUser = jsonEncode(newUser);

  try {
    http.Response response = await http.post(
      Uri.parse("http://localhost:8000/updateSenha"),
      headers: {'Content-Type': 'application/json'},
      body: jsonUser,
    );

    if (response.statusCode == 200) {
      print('Senha atualizada com sucesso');
    } else {
      print('Erro na atualização da senha');
    }

    return response.statusCode;
  } catch (e) {
    print('Erro durante a chamada da API: $e');
    return 500; // Código de erro genérico
  }
}

//Receitas/Inscritos:
class Receita {
  String tituloReceitas;
  String descricao;
  String id = '0';
  String requisitos;
  String preparo;

  Receita(
      {required this.tituloReceitas,
      required this.descricao,
      required this.id,
      required this.requisitos,
      required this.preparo});

  factory Receita.fromJson(Map<String, dynamic> json) {
    return Receita(
      tituloReceitas: json['titulo'],
      descricao: json['descricao'],
      id: json['id_receitas'].toString(),
      requisitos: json['requisitos'],
      preparo: json['preparo'],
    );
  }

  @override
  String toString() {
    return 'Receita: '
        'tituloReceitas=$tituloReceitas, '
        'descricao=$descricao, '
        'id=$id, '
        'requisitos=$requisitos, '
        'preparo=$preparo';
  }

  Map<String, dynamic> toJson(idUser) {
    return {
      "id_usuario": idUser,
      "id_receitas": id,
      "titulo_receitas": tituloReceitas,
      "descricao": descricao,
      "requisitos": requisitos,
      "preparo": preparo
    };
  }
}

void criaReceita(
    tituloReceitas, descricao, id, idUsuario, requisitos, preparo) async {
  Receita novaReceita = Receita(
      tituloReceitas: tituloReceitas,
      descricao: descricao,
      id: 'id',
      requisitos: requisitos,
      preparo: preparo);
  String jsonReceita = jsonEncode(novaReceita.toJson(idUsuario));
  http.Response response = await http.post(
    Uri.parse("http://localhost:8000/receita/cadastro"),
    headers: {'Content-Type': 'application/json'},
    body: jsonReceita,
  );
  print(jsonReceita);
  if (response.statusCode == 200) {
    print('Receita registrada com sucesso');
  } else {
    print('erro ao cadastrar receita!');
    print(response.statusCode);
  }
}

//uri: /receita/update

Future<List<Receita>> listaReceitas() async {
  List<Receita> receitas = [];

  http.Response response = await http.post(
    Uri.parse('http://localhost:8000/receita/read/all'),
    headers: {'Content-Type': 'application/json'},
  );

  if (response.statusCode == 200) {
    List<dynamic> decodedData = jsonDecode(response.body);
    receitas = decodedData.map((data) => Receita.fromJson(data)).toList();
  } else {
    print(response.statusCode);
  }

  return receitas;
}

Future<List<Receita>> listaCriadas(id) async {
  List<Receita> criadas = [];

  String url = "http://localhost:8000/receita/usuario/read/$id";

  http.Response response = await http.get(
    Uri.parse(url),
    headers: {'Content-Type': 'application/json'},
  );

  if (response.statusCode == 200) {
    List<dynamic> decodedData = jsonDecode(response.body);
    criadas =
        List<Receita>.from(decodedData.map((data) => Receita.fromJson(data)));
  } else {
    print(response.statusCode);
  }

  return criadas;
}

void deletaReceita(idReceita) async {
  Receita receita = Receita(
      tituloReceitas: '',
      descricao: '',
      id: idReceita,
      requisitos: '',
      preparo: '');
  //Map<String, dynamic> receita = {"id_receita": idReceita};
  String json = jsonEncode(receita.toJson(0));

  http.Response response = await http.post(
    Uri.parse("http://localhost:8000/receita/delete"),
    headers: {'Content-Type': 'application/json'},
    body: json,
  );
  if (response.statusCode == 200) {
    print('Receita Deletada com sucesso!');
  } else {
    print(response.statusCode);
    print(response.body);
  }
}

void updateReceita(
    tituloReceitas, descricao, id, idUsuario, requisitos, preparo) async {
  Receita novaReceita = Receita(
      tituloReceitas: tituloReceitas,
      descricao: descricao,
      id: id,
      requisitos: requisitos,
      preparo: preparo);
  String jsonReceita = jsonEncode(novaReceita.toJson(idUsuario));
  http.Response response = await http.post(
    Uri.parse("http://localhost:8000/receita/update"),
    headers: {'Content-Type': 'application/json'},
    body: jsonReceita,
  );
  print(jsonReceita);
  if (response.statusCode == 200) {
    print('Receita atualizada com sucesso');
  } else {
    print('erro ao cadastrar receita!');
    print(response.statusCode);
  }
}

class LoggedUser {
  int tipo;
  String email;
  String senha;
  String nome;
  int id;

  LoggedUser(this.tipo, this.email, this.senha, this.nome, this.id);

  Map<String, dynamic> toJson() {
    switch (tipo) {
      case 1:
        return {
          'usuario': "user",
          'email': email,
          'senha': senha,
        };
      case 3:
        return {
          'usuario': "adm",
          'email': email,
          'senha': senha,
        };
      default:
        return {'default': ''};
    }
  }

  static LoggedUser fromJson(Map<String, dynamic> json, int tipo) {
    return LoggedUser(
      tipo,
      json['email'],
      json['senha'],
      json['nome'],
      json['id'],
    );
  }
}

Future<LoggedUser> login(tipo, email, senha) async {
  LoggedUser user = LoggedUser(tipo, email, senha, '', 0);
  String jsonUser = jsonEncode(user.toJson());
  http.Response response = await http.post(
    Uri.parse("http://localhost:8000/login"),
    headers: {'Content-Type': 'application/json'},
    body: jsonUser,
  );
  if (response.statusCode == 200) {
    final jsonBody = json.decode(response.body);
    print("logou!");
    print(jsonBody);
    LoggedUser logged = LoggedUser.fromJson(jsonBody, tipo);
    return logged;
  } else {
    if (response.statusCode == 204) {
      print("204");
    } else {
      print("outro");
    }
    return LoggedUser(204, 'email', 'senha', 'nome', 0);
  }
}

class Curtida {
  String Nome;
  String id;

  Curtida(this.Nome, this.id);

  Map<String, dynamic> toJson() {
    return {
      'Nome': Nome,
      'id': id,
    };
  }

  static Curtida fromJson(Map<String, dynamic> json) {
    return Curtida(
      json['Nome'],
      json['id'],
    );
  }
}

Future<List<Receita>> getLiked(id) async {
  List<Receita> curtidas = [];

  String url = "http://localhost:8000/curtida/all/read/$id";

  http.Response response = await http.get(
    Uri.parse(url),
    headers: {'Content-Type': 'application/json'},
  );

  if (response.statusCode == 200) {
    List<dynamic> decodedData = jsonDecode(response.body);
    curtidas =
        List<Receita>.from(decodedData.map((data) => Receita.fromJson(data)));
  } else {
    print(response.statusCode);
  }

  return curtidas;
}

Future<bool> likedOrNot(idUser, idReceita) async {
  bool liked = false;

  String url = "http://localhost:8000/curtida/read/$idUser/$idReceita";

  http.Response response = await http.get(
    Uri.parse(url),
    headers: {'Content-Type': 'application/json'},
  );

  if (response.statusCode == 200) {
    liked = true;
  } else if (response.statusCode == 204) {
    liked = false;
  } else {
    print(response.statusCode);
  }
  return liked;
}

void toggleLike(idUsuario, idReceita) async {
  Map<String, dynamic> receita = {
    "id_receitas": idReceita,
    "id_usuario": idUsuario
  };
  String json = jsonEncode(receita);

  http.Response response = await http.post(
    Uri.parse("http://localhost:8000/curtida/cadastro"),
    headers: {'Content-Type': 'application/json'},
    body: json,
  );
  if (response.statusCode == 200) {
  } else {
    print(response.statusCode);
    print(response.body);
  }
}

Future<int> countLikes(idReceita) async {
  int count = 0;

  String url = "http://localhost:8000/curtida/count/$idReceita";
  http.Response response = await http.get(
    Uri.parse(url),
    headers: {'Content-Type': 'application/json'},
  );

  if (response.statusCode == 200) {
    Map<String, dynamic> decodedData = jsonDecode(response.body);
    print(decodedData);
    count = decodedData['COUNT(*)'];
  } else {
    print(response.statusCode);
  }

  return count;
}

class Comentario {
  String user_id;
  String id;
  String texto;
  String idReceita;

  Comentario(this.user_id, this.id, this.texto, this.idReceita);

  Map<String, dynamic> toJson() {
    return {
      'id_usuario': user_id,
      'texto': texto,
      'id_receitas': idReceita,
    };
  }

  static Comentario fromJson(Map<String, dynamic> json) {
    return Comentario(
      json['id_usuario'],
      json['id'],
      json['texto'],
      json['idReceita'],
    );
  }
}

void avaliar(rating, userId, recipeId) async {
  //alterar a avaliação do usuário
  Map<String, dynamic> like = {
    'id_usuario': userId,
    'id_receitas': recipeId,
    'nota': rating
  };
  String json = jsonEncode(like);
  String url = "http://localhost:8000/avaliacao/cadastro";

  http.Response response = await http.post(
    Uri.parse(url),
    headers: {'Content-Type': 'application/json'},
    body: json,
  );
  if (response.statusCode == 200) {
  } else if (response.statusCode == 204) {
    print('Erro ao alterar a avaliação');
    print(response.statusCode);
    print(response.body);
  }
}

void comentar(texto, userId, recipeId) async {
  Comentario newComment = Comentario(userId, '0', texto, recipeId.toString());
  String json = jsonEncode(newComment.toJson());
  String url = "http://localhost:8000/comentario/cadastro";

  http.Response response = await http.post(
    Uri.parse(url),
    headers: {'Content-Type': 'application/json'},
    body: json,
  );
  if (response.statusCode == 200) {
    print('Sucesso ao adicionar comentário');
  } else {
    print(response.statusCode);
    print(response.body);
  }
}

class Pesquisa {
  String string;
  String nota;

  Pesquisa(this.string, this.nota);

  Map<String, dynamic> toJson() {
    return {
      'string': string,
      'nota': nota,
    };
  }

  static Pesquisa fromJson(Map<String, dynamic> json) {
    return Pesquisa(
      json['string'],
      json['nota'],
    );
  }
}

Future<List<Receita>> pesquisaComFiltro(texto, filtro) async {
  //print('entrou em pesquisaComFiltro');
  String pesquisaString;
  if (texto != null) {
    pesquisaString = texto;
  } else {
    pesquisaString = ' ';
  }

  Pesquisa pesquisa = Pesquisa(pesquisaString, filtro);
  List<Receita> sugestoes = [];
  String url = "http://localhost:8000/filtro/read";
  String jsonSearch = jsonEncode(pesquisa.toJson());

  http.Response response = await http.post(Uri.parse(url),
      headers: {'Content-Type': 'application/json'}, body: jsonSearch);

  if (response.statusCode == 200) {
    List<dynamic> decodedData = jsonDecode(response.body);
    sugestoes = decodedData.map((data) => Receita.fromJson(data)).toList();
  } else {
    print(response.statusCode);
  }
  //print(sugestoes);
  return sugestoes;
}

Future<double> AvaliacaoRead(id_receitas, id_usuario) async {
  double avaliacao = 0;
  Map<String, dynamic> data = {
    'id_usuario': id_usuario,
    'id_receitas': id_receitas,
  };
  String url = "http://localhost:8000/avaliacao/usuario/read";
  String jsonid = jsonEncode(data);

  http.Response response = await http.post(Uri.parse(url),
      headers: {'Content-Type': 'application/json'}, body: jsonid);

  if (response.statusCode == 200) {
    Map<String, dynamic> decodedData = jsonDecode(response.body);
    avaliacao = decodedData['nota'];
  } else if (response.statusCode == 204) {
    avaliacao = 0;
  } else {
    print('AvalicaoRead: ${response.statusCode}');
  }

  return avaliacao;
}

Future<List<Map<String, String>>> fetchComments(id) async {
  List<Map<String, String>> comentarios = [];

  String url = "http://localhost:8000/comentario/read/$id";

  http.Response response = await http.get(
    Uri.parse(url),
    headers: {'Content-Type': 'application/json'},
  );

  if (response.statusCode == 200) {
    List<dynamic> decodedData = jsonDecode(response.body);
    print(decodedData);
    comentarios = decodedData.map((map) {
      return {
        'name': map['nome'].toString(),
        'message': map['texto'].toString(),
      };
    }).toList();
    //print(comentarios[0]['name']);
  } else {
    print(response.statusCode);
  }

  return comentarios;

  /*[
    {'name': 'User1', 'message': 'Comment 1'},
    {'name': 'User2', 'message': 'Comment 2'},
    // Add more data as needed
  ]*/
}
