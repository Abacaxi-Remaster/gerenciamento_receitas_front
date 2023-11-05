import 'package:flutter/material.dart';
import 'package:receita_front/all.dart';
import 'package:receita_front/HomePage.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:receita_front/index.dart';
import 'dart:math';
import '/main.dart';

class CrudReceitas extends StatefulWidget {
  @override
  CrudReceitasCrudState createState() => CrudReceitasCrudState();
}

class CrudReceitasCrudState extends State<CrudReceitas> {
  final tituloController = TextEditingController();
  final descricaoController = TextEditingController();
  final requisitosController = TextEditingController();
  final preparoController = TextEditingController();
  String tituloReceitas = '';
  String descricao = '';
  int id = Random().nextInt(1000);

  String requisitos = '';
  String preparo = '';

  TextInputFormatter _inputFormatter1 = FilteringTextInputFormatter.digitsOnly;

  void submitForm() {
    tituloController.clear();
    descricaoController.clear();
    requisitosController.clear();
    preparoController.clear();
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return ListView(
      children: [
        Text('Receitas', style: TextStyle(fontSize: 25)),
        TextFormField(
          controller: tituloController,
          decoration: InputDecoration(labelText: 'Titulo da receita'),
          onChanged: (value) {
            setState(() {
              tituloReceitas = value;
            });
          },
        ),
        TextFormField(
          controller: descricaoController,
          decoration: InputDecoration(labelText: 'Descrição'),
          onChanged: (value) {
            setState(() {
              descricao = value;
            });
          },
        ),
        TextFormField(
          controller: requisitosController,
          decoration: InputDecoration(labelText: 'Ingredientes'),
          onChanged: (value) {
            setState(() {
              requisitos = value;
            });
          },
        ),
        TextFormField(
          controller: preparoController,
          inputFormatters: [_inputFormatter1],
          decoration: InputDecoration(labelText: 'Modo de Preparo'),
          onChanged: (value) {
            setState(() {
              preparo = value;
            });
          },
        ),
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Criar Receita'),
                  content: TextField(
                    controller: tituloController,
                  ),
                  actions: [
                    TextButton(
                      child: Text('Cancelar'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      child: Text('Salvar'),
                      onPressed: () {
                        Navigator.of(context).pop();
                        criaReceita(tituloReceitas, descricao, 0, appState.logged.id,
                            requisitos, preparo);
                        appState.adicionarReceita(Receita(
                            tituloReceitas: tituloReceitas,
                            descricao: descricao,
                            id: '',
                            requisitos: requisitos,
                            preparo: preparo));
                        submitForm();
                      },
                    ),
                  ],
                );
              },
            );
          },
        ),
        Receitas(),
      ],
    );
  }
}

class Receitas extends StatefulWidget {
  @override
  State<Receitas> createState() => _ReceitasState();
}

class _ReceitasState extends State<Receitas> {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return Consumer<MyAppState>(builder: (context, appState, _) {
      return FutureBuilder<List<Receita>>(
        future: listaReceitas(appState.logged.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            List<Receita>? receitas = snapshot.data;

            return Column(
              children: [
                for (var receita in receitas!)
                  ListTile(
                    leading: IconButton(
                      icon: Icon(Icons.menu),
                      onPressed: () {
                        appState.receita = receita;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetalheReceita(),
                          ),
                        );
                      },
                    ),
                    title: Text(receita.tituloReceitas),
                    subtitle: Text(receita.descricao),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        setState(() {
                          deletaReceita(receita.id);
                        });
                      },
                    ),
                  ),
              ],
            );
          }
        },
      );
    });
  }
}