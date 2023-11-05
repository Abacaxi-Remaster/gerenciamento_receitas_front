import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import "../all.dart";

class DetalheReceita extends StatefulWidget {
  @override
  State<DetalheReceita> createState() => _DetalheReceitaState();
}

class _DetalheReceitaState extends State<DetalheReceita> {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    Receita receita = appState.receitaAtual;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text(receita.tituloReceitas),
        titleTextStyle: Theme.of(context).textTheme.headlineMedium,
      ),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 25,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Descrição: ${receita.descricao}',
                    style: TextStyle(fontSize: 20)),
                Text('Requisitos: ${receita.requisitos}',
                    style: TextStyle(fontSize: 15)),
                Text('Salário: ${receita.preparo}',
                    style: TextStyle(fontSize: 15)),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: Text('Inscritos:', style: TextStyle(fontSize: 30)),
          ),
        ],
      ),
    );
  }
}