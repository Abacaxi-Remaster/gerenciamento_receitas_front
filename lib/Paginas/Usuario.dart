import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:receita_front/Paginas/Curtidas.dart';
import 'package:receita_front/all.dart';
import '/main.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class Usuario extends StatefulWidget {
  @override
  State<Usuario> createState() => _UsuarioState();
}

class _UsuarioState extends State<Usuario> {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var User = appState.logged;
    var Nome = User.nome;
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 50, horizontal: 150),
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
          child: DefaultTabController(
            length: 2,
            child: Scaffold(
              appBar: AppBar(
                bottom: const TabBar(
                  tabs: [
                    Tab(
                      text: "Curtidas",
                    ),
                    Tab(
                      text: "Minhas Receitas",
                    ),
                  ],
                ),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Olá, $Nome',
                      style: TextStyle(fontSize: 25),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: Icon(Icons.add),
                          tooltip: "Criar Receita",
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CrudReceitas(),
                              ),
                            );
                          },
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            appState.setPage(AttCadastroPage());
                          },
                          child: Text('Atualizar\nCadastro'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              body: TabBarView(
                children: [
                  LikePreview(),
                  Receitas(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/*Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Olá, $Nome',
                          style: TextStyle(fontSize: 25),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon: Icon(Icons.add),
                              tooltip: "Criar Receita",
                              onPressed: (
                                  //-------------------------------------------------------------------Func p criar receita------------------------------------------------------
                                  ) {},
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                //---------------------------------------------------------------------Direcionar p cadastro update---------------------------------------------
                              },
                              child: Text('Atualizar\nCadastro'),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    /*Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.all(12.0),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(255, 238, 169, 1),
                                border: Border.all(
                                  color: Color.fromRGBO(255, 238, 169, 1),
                                ),
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20)),
                              ),
                              child:
                            ),
                          ],
                        ),
                      )
                    */
                    //bar(),
                    DefaultTabController(
                      length: 2,
                      child: Column(
                        children: [
                          AppBar(
                            bottom: const TabBar(
                              tabs: [
                                Tab(icon: Icon(Icons.directions_car)),
                                Tab(icon: Icon(Icons.directions_transit)),
                              ],
                            ),
                            title: const Text('Tabs Demo'),
                          ),
                          TabBarView(
                            children: [
                              Icon(Icons.directions_car),
                              Icon(Icons.directions_transit),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        */
/*Container(
                            padding: EdgeInsets.all(12.0),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(255, 238, 169, 1),
                              border: Border.all(
                                color: Color.fromRGBO(255, 238, 169, 1),
                              ),
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(20),
                                  bottomRight: Radius.circular(20)),
                            ),
                          ),*/

