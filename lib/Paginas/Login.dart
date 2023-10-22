import 'package:flutter/material.dart';
import 'package:receita_front/all.dart';
import 'package:receita_front/HomePage.dart';
import 'package:provider/provider.dart';
import '/main.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var tipoSelecionado = 0;

  final userController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return Center(
      child: Container(
        padding: EdgeInsets.all(16.0),
        alignment: Alignment.center,
        width: 400,
        height: 350,
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
              Text('LOGIN'),
              Padding(
                padding: EdgeInsets.all(10),
                child: TextFormField(
                  controller: userController,
                  validator: (value) {
                    return validaNull(value);
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: TextFormField(
                  controller: passwordController,
                  validator: (value) {
                    return validaNull(value);
                  },
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  //async
                  /*appState.TESTE_toggle_logado();
                    appState.setPage(
                      MyHomePageState().updatePage(0, appState.tipoLogado));
                */
                  if (_formKey.currentState!.validate()) {
                    LoggedUser loggedUser;
                    print(appState.logado);
                    if (userController.text == 'ADM') {
                      loggedUser = await login(
                          3, userController.text, passwordController.text);
                    } else {
                      loggedUser = await login(tipoSelecionado,
                          userController.text, passwordController.text);
                    }
                    appState.logar(loggedUser);
                    if (loggedUser.tipo != 204) {
                      appState.setPage(MyHomePageState().updatePage(0));
                    }
                  }
                },
                child: Text('Próximo'),
              ),
              TextButton(
                onPressed: () {
                  appState.setPage(CadastroPage());
                },
                child: Text(
                  'Cadastro',
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
