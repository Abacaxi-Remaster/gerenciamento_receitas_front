import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
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
                    /*    final searchFuture = search(controller.text);
                      return [FutureBuilder(
                        future: searchFuture,
                        builder: (context, snapshot){
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return CircularProgressIndicator(); 
                          } else if (snapshot.hasError) {
                            return Text(
                                'Error: ${snapshot.error}'); 
                          } else {
                            List<Receita>? list = snapshot.data;
                            if (list != null){
                              return ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: list.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return ListTile(
                                    title: Text(list[index]),
                                  );
                                },
                              );
                            }
                          }
                          return const LinearProgressIndicator();
                        },
                      )];
                */
//teste:-------------------------------------------------------------------------------------------------
                    return List<ListTile>.generate(5, (int index) {
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
//teste ^^-----------------------------------------------------------------------------------------------
                  }),
                ),
              ],
            )),
      ),
    );
  }
}
