import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:receita_front/all.dart';
import '/main.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class LikePreview extends StatefulWidget {
  @override
  State<LikePreview> createState() => _LikePreviewState();
}

class _LikePreviewState extends State<LikePreview> {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

//teste
    //falta backend: (requisição getLiked(id))

    return FutureBuilder<List<Curtida>>(
      future: getLiked(appState.logged.id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          List<Curtida>? curtidas = snapshot.data;

          return ListView(
            children: [
              for (var curtida in curtidas!)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: ListTile(
                    leading: Icon(Icons.favorite),
                    title: Text('${curtida.Nome}'),
                    trailing: IconButton(
                        onPressed: () {
                          setState(() {/*placeholder*/});
                        },
                        icon: Icon(Icons.arrow_right)),
                  ),
                )
            ],
          );
        }
      },
    );

//teste (apresentação)
    /*  Curtida temp = Curtida('Teste 1', '1');
    Curtida temp2 = Curtida('Teste 2', '2');

    var curtidas = [temp, temp2];
    return ListView(
      children: [
        /*Padding(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Text('Lista de curtidas:', style: TextStyle(fontSize: 25)),
        ),*/
        for (var curtida in curtidas!)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: ListTile(
              leading: Icon(Icons.favorite),
              title: Text('${curtida.Nome}'),
              trailing: IconButton(
                  onPressed: () {
                    setState(() {/*placeholder*/});
                  },
                  icon: Icon(Icons.arrow_right)),
            ),
          )
      ],
    );
  }*/
  }
}
/*return FutureBuilder<List<Curtida>>(
      future: getLiked(appState.logged.id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          List<Curtida>? curtidas = snapshot.data;

          return Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 50, horizontal: 250),
              child: Container(
                padding: EdgeInsets.all(12.0),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.white,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: ListView(
                  children: [
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      child: Text('Lista de curtidas:',
                          style: TextStyle(fontSize: 25)),
                    ),
                    for (var curtida in curtidas!)
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: ListTile(
                          leading: Icon(Icons.favorite),
                          title: Text('${curtida.Nome}'),
                          trailing: IconButton(
                              onPressed: () {
                                setState(() {/*placeholder*/});
                              },
                              icon: Icon(Icons.arrow_right)),
                        ),
                      )
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
*/