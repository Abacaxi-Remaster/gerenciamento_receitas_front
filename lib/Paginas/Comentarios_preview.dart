/*import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/main.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class CommentPreview extends StatefulWidget {
  @override
  State<CommentPreview> createState() => _CommentPreviewState();
}

class _CommentPreviewState extends State<CommentPreview> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final userController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    void ToggleIcon() {
      if (appState.liked) {
        appState.like = Icon(Icons.favorite_outline);
        appState.numerolike--;
        appState.liked = false;
      } else {
        appState.like = Icon(Icons.favorite);
        appState.numerolike++;
        appState.liked = true;
      }
    }

    return Center(
      child: Container(
        padding: EdgeInsets.all(16.0),
        alignment: Alignment.center,
        width: 800,
        height: 400,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Colors.white,
          ),
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: [
              Text('Teste: Comentários'),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                child: TextFormField(
                  controller: userController,
                  maxLines: null,
                  decoration:
                      InputDecoration(labelText: 'Insira seu Comentário'),
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RatingBar(
                    initialRating: 3,
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
                      print(rating);
                    },
                  ),
                  Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            setState(() {
                              ToggleIcon();
                            });
                          },
                          icon: appState.like),
                      Text(appState.numerolike.toString())
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      //async
                      /*appState.TESTE_toggle_logado();
                    appState.setPage(
                      MyHomePageState().updatePage(0, appState.tipoLogado));
                */
                    },
                    child: Text('Comentar'),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
*/