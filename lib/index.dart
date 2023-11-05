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
  int tipo;
  String nome;
  String email;
  String senha;

  RegisterUser(this.tipo, this.nome, this.email, this.senha);

  Map<String, dynamic> toJson() {
    return {
      'usuario': "user",
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

//Vagas/Inscritos:
class Receita {
  String tituloReceitas;
  String descricao;
  String id;
  String requisitos;
  String preparo;

  Receita(
      {required this.tituloReceitas,
      required this.descricao,
      required this.id,
      required this.requisitos,
      required this.preparo});

  factory Receita.fromJson(Map<String, dynamic> json) {
    print(json);
    return Receita(
      tituloReceitas: json['titulo_receitas'],
      descricao: json['descricao'],
      id: json['id'],
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

  Map<String, dynamic> toJson() {
    return {
      "titulo_vaga": tituloReceitas,
      "descricao": descricao,
      "requisitos": requisitos,
      "preparo": preparo
    };
  }
}

void criaReceita(
    tituloReceitas, descricao, id, idEmpresa, requisitos, preparo) async {
  Receita novaVaga = Receita(
      tituloReceitas: tituloReceitas,
      descricao: descricao,
      id: 'id',
      requisitos: requisitos,
      preparo: preparo);
  String jsonVaga = jsonEncode(novaVaga.toJson());
  http.Response response = await http.post(
    Uri.parse("http://localhost:8000/vagas/cadastro"),
    headers: {'Content-Type': 'application/json'},
    body: jsonVaga,
  );
  print(jsonVaga);
  if (response.statusCode == 200) {
    print('Vaga registrada com sucesso');
  } else {
    print(response.statusCode);
  }
}

Future<List<Receita>> listaReceitas() async {
  List<Receita> receitas = [];

  http.Response response = await http.get(
    Uri.parse('http://localhost:8000/vagas'),
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
