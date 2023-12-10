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
  final confirmarNovaSenhaController = TextEditingController();
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
                    controller: confirmarNovaSenhaController,
                    obscureText: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Confirmar Nova Senha',
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (confirmarNovaSenhaController.text ==
                        passwordController.text) {
                      if (_formKey.currentState!.validate()) {
                        int resposta = await atualizarSenha(
                          nomeController.text,
                          emailController.text,
                          passwordController.text,
                          confirmarNovaSenhaController.text,
                        );

                        if (resposta == 200) {
                          appState.setPage(LoginPage());
                          appState.sucesso('Senha Atualiazda com sucesso!');
                        } else if (resposta == 400) {
                          appState
                              .erro('Erro no cadastro - Senhas Diferentes!');
                        } else if (resposta == 600) {
                          appState.erro('Dados Incorretos!');
                        } else {
                          appState.erro('Erro na atualização de senha');
                        }
                      }
                    } else {
                      appState.erro('Erro no cadastro - Senhas Diferentes!');
                    }
                  },
                  child: Text('Atualizar Senha'),
                ),
                TextButton(
                  onPressed: () {
                    appState.setPage(LoginPage());
                  },
                  child: Text(
                    'voltar para o Login',
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
