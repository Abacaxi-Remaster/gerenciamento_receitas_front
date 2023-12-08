// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import "../all.dart";
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:comment_box/comment/comment.dart';
import 'package:comment_box/comment/test.dart';
import 'package:comment_box/main.dart';

class DetalheReceita extends StatefulWidget {
  @override
  State<DetalheReceita> createState() => _DetalheReceitaState();
}

class _DetalheReceitaState extends State<DetalheReceita> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final userController = TextEditingController();

  late Future<List<Map<String, String>>> dataFuture;
  late int likes;
  late Future<bool> likeOrNot;
  late Icon LikeIcon; // = Icon(Icons.favorite_outline)
  late double initRating;

  @override
  void initState() {
    super.initState();
    var appState = context.read<MyAppState>();
    //get user info:
    likes = 187;
    likeOrNot = likedOrNot(appState.logged.id, appState.receitaAtual.id);
    LikeIcon = Icon(Icons.favorite_outline);
    initRating = 3;

    //get existing comments:
    dataFuture = fetchComments();
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    Receita receita = appState.receitaAtual;
//---------------------------------------------------------------------------------------------Pegar do Back! ^^^-----------------------------------------------------------
    likeAndDislike() {
      if (appState.liked) {
        setState(() {
          appState.liked = false;
          LikeIcon = Icon(Icons.favorite_outline);
        });
      } else {
        setState(() {
          appState.liked = true;
          LikeIcon = Icon(Icons.favorite);
        });
      }
      toggleLike(appState.logged.id, appState.receitaAtual.id);
    }

    int rating = 0;

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
                    style: TextStyle(fontSize: 25)),
                Text('Ingredientes: ${receita.requisitos}',
                    style: TextStyle(fontSize: 20)),
                Text('Modo de Preparo: ${receita.preparo}',
                    style: TextStyle(fontSize: 20)),
                Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    children: [
                      //Text('Teste: Comentários'),
                      const Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                        child: TextFormField(
                          controller: userController,
                          maxLines: null,
                          decoration: InputDecoration(
                              labelText: 'Insira seu Comentário'),
                          onChanged: (value) {
                            setState(() {});
                          },
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          RatingBar(
                            initialRating: initRating,
                            direction: Axis.horizontal,
                            allowHalfRating: false,
                            itemCount: 5,
                            itemSize: 25,
                            ratingWidget: RatingWidget(
                              full: Icon(Icons.star),
                              half: Icon(Icons.star_half_outlined),
                              empty: Icon(Icons.star_border),
                            ),
                            itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                            onRatingUpdate: (rating) {
                              //print(rating);
                              avaliar(rating, appState.logged.id,
                                  appState.receitaAtual.id);
                            },
                          ),
                          Row(
                            children: [
                              IconButton(
                                  onPressed: () {
                                    setState(() {
                                      likeAndDislike();
                                    });
                                  },
                                  icon: LikeIcon),
                              Text(appState.numerolike.toString())
                            ],
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              comentar(userController, appState.logged.id,
                                  appState.receitaAtual.id);
                            },
                            child: Text('Comentar'),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                FutureBuilder<List<Map<String, String>>>(
                  future: dataFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      // Display a loading indicator while waiting for data
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      // Display an error message if an error occurs
                      return Text('Error: ${snapshot.error}');
                    } else {
                      // Display your list of comments once the data is available
                      return Column(
                        children: [
                          for (var i = 0; i < snapshot.data!.length; i++)
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(2.0, 8.0, 2.0, 0.0),
                              child: ListTile(
                                title: Text(
                                  snapshot.data![i]['name']!,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(snapshot.data![i]['message']!),
                              ),
                            ),
                        ],
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
