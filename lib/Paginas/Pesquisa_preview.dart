import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:receita_front/all.dart';
import 'package:receita_front/main.dart';

class SearchPreview extends StatefulWidget {
  @override
  State<SearchPreview> createState() => _SearchPreviewState();
}

class _SearchPreviewState extends State<SearchPreview> {
  bool isDark = false;

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    double getNota(idReceita, lista) {
      double nota = 0;

      for (var item in lista) {
        if (item["id"] == idReceita) {
          //print(item["nota"]);
          String text = item['nota'];
          nota = double.parse(text);
          break;
        }
      }

      return nota;
    }

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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text('Avaliação Mínima:  '),
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
                        appState.setMinimumRating(rating);
                      },
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SearchAnchor(builder:
                      (BuildContext context, SearchController controller) {
                    return SearchBar(
                      controller: controller,
                      padding: const MaterialStatePropertyAll<EdgeInsets>(
                          EdgeInsets.symmetric(horizontal: 16.0)),
                      onTap: () {
                        controller.openView();
                      },
                      onChanged: (_) {
                        controller.openView();
                      },
                      leading: const Icon(Icons.search),
                    );
                  }, suggestionsBuilder:
                      (BuildContext context, SearchController controller) {
/*------------------------------------------------------------------------------------------------------- 
  ver se a sugestão do cara já funciona (ja foi modificado para aceitar async, ent talvez dê) 
-> link: https://github.com/flutter/flutter/issues/126531 */

//provavelmente funciona, mas é deselegante:
                    return [
                      FutureBuilder(
                        future: Future.wait([
                          pesquisaComFiltro(controller.text,
                              appState.filtroAvaliacao.toString()),
                          allAval(),
                        ]),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            final List<dynamic> data = snapshot.data!;
                            List<Receita>? list = data[0];
                            List<Map<String, dynamic>> notas = data[1];

                            print(list);
                            print('');
                            print(notas);
                            print('fim');

                            if (list != null) {
                              return ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: list.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return ListTile(
                                    title: Text(list[index].tituloReceitas),
                                    subtitle: RatingBar(
                                      ignoreGestures: true,
                                      initialRating: getNota(
                                          list[index].id, notas), //initRating,
                                      direction: Axis.horizontal,
                                      allowHalfRating: false,
                                      itemCount: 5,
                                      itemSize: 25,
                                      ratingWidget: RatingWidget(
                                        full: Icon(Icons.star),
                                        half: Icon(Icons.star_half_outlined),
                                        empty: Icon(Icons.star_border),
                                      ),
                                      itemPadding:
                                          EdgeInsets.symmetric(horizontal: 4.0),
                                      onRatingUpdate: (rating) {
                                        //print(rating);
                                        avaliar(rating, appState.logged.id,
                                            appState.receitaAtual.id);
                                      },
                                    ),
                                    trailing: IconButton(
                                      icon: Icon(Icons.menu),
                                      onPressed: () {
                                        appState.receitaAtual = list[
                                            index]; // Agora atribui uma instância de Receita
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                DetalheReceita(),
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                },
                              );
                            }
                          }
                          return const LinearProgressIndicator();
                        },
                      )
                    ];

//teste:-------------------------------------------------------------------------------------------------
/*                    return List<ListTile>.generate(5, (int index) {
                      final String item = 'item $index';
                      return ListTile(
                        title: Text(item),
                        onTap: () {
                          setState(() {
                            controller.closeView(item);
                          });
                        },
                      );
                    });
*/
//teste ^^-----------------------------------------------------------------------------------------------
                  }),
                ),
              ],
            )),
      ),
    );
  }
}
