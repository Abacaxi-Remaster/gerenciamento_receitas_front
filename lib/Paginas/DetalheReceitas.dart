import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import "../all.dart";
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class DetalheReceita extends StatefulWidget {
  @override
  State<DetalheReceita> createState() => _DetalheReceitaState();
}

class _DetalheReceitaState extends State<DetalheReceita> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final userController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    Receita receita = appState.receitaAtual;

    int likes = 187;
    var likeOrNot = false;
    var LikeIcon = Icon(Icons.favorite_outline);
    double initRating = 3;
//---------------------------------------------------------------------------------------------Pegar do Back! ^^^-----------------------------------------------------------
    likeAndDislike() {
      if (appState.liked) {
        LikeIcon = Icon(Icons.favorite_outline);
      } else {
        LikeIcon = Icon(Icons.favorite);
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
                //------------------------------------------------------------------------Criar Lista de Comentários----------------------------------------------------------------
              ],
            ),
          ),
        ],
      ),
    );
  }
}
