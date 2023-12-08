import 'package:flutter/material.dart';
import 'package:receita_front/all.dart';
import 'package:provider/provider.dart';
import '/main.dart';

class RecuperarSenhaPage extends StatefulWidget {
  @override
  State<RecuperarSenhaPage> createState() => _RecuperarSenhaPageState();
}

class _RecuperarSenhaPageState extends State<RecuperarSenhaPage> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final oldpasswordController = TextEditingController();
  final nomeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 75, horizontal: 250),
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
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.always,
            child: Column(
              children: [
                Text('Recuperação de Senha'),
                Padding(
                  padding: EdgeInsets.all(12),
                  child: TextFormField(
                    controller: nomeController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Nome Completo',
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(12),
                  child: TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Email',
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(12),
                  child: TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Nova Senha',
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(12),
                  child: TextFormField(
                    controller: oldpasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Confirmar Nova Senha',
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (oldpasswordController.text == passwordController.text) {
                      if (_formKey.currentState!.validate()) {
                        if (emailController.text == 'ADM') {
                          appState.erro('Erro no cadastro - Email inválido!');
                        } else {
                          int resposta = await emailUsuario(
                            emailController.text,
                          );
                          if (resposta == 200) {
                            appState.setPage(LoginPage());
                          } else {
                            print(resposta);
                            appState
                                .erro('Erro - Email não existe');
                          }
                        }
                        ;
                      }
                    } else {
                      appState
                          .erro('Erro no cadastro - Senhas Diferentes!');
                    }
                  },
                  child: Text('Atualizar Senha'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
