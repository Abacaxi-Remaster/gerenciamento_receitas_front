import 'package:flutter/material.dart';
import 'package:receita_front/all.dart';
import 'package:provider/provider.dart';
import '/main.dart';

class CadastroPage extends StatefulWidget {
  @override
  State<CadastroPage> createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nomeController = TextEditingController();
  final ultimoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 100, horizontal: 250),
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
                Text('Cadastro'),
                Padding(
                  padding: EdgeInsets.all(12),
                  child: TextFormField(
                    controller: nomeController,
                    validator: (value) {
                      return validaNull(value);
                    },
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
                  padding: EdgeInsets.all(12),
                  child: TextFormField(
                    controller: passwordController,
                    validator: (value) {
                      return validaNull(value);
                    },
                    obscureText: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Senha',
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    //adicionar confirmação de inputs
                    if (_formKey.currentState!.validate()) {
                      if (emailController.text == 'ADM') {
                        appState.erro('Erro no cadastro - Email inválido!');
                      } else {
                        int resposta = await cadastro(
                            0,
                            nomeController.text,
                            emailController.text,
                            passwordController.text,
                            ultimoController.text);
                        if (resposta == 200) {
                          appState.setPage(LoginPage());
                        } else {
                          print(resposta);
                          appState.erro('Erro no cadastro - Email já em uso!');
                        }
                      }
                      ;
                    }
                  },
                  child: Text('Cadastrar'),
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

class AttCadastroPage extends StatefulWidget {
  @override
  State<AttCadastroPage> createState() => _AttCadastroPageState();
}

class _AttCadastroPageState extends State<AttCadastroPage> {
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
                Text('Atualização de Cadastro'),
                Padding(
                  padding: EdgeInsets.all(12),
                  child: TextFormField(
                    controller: nomeController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Novo Nome Completo',
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(12),
                  child: TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Novo Email',
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
                      labelText: 'Senha Atual',
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
                ElevatedButton(
                  onPressed: () async {
                    if (oldpasswordController.text == appState.logged.senha) {
                      if (_formKey.currentState!.validate()) {
                        if (emailController.text == 'ADM') {
                          appState.erro('Erro no cadastro - Email inválido!');
                        } else {
                          int resposta = await update(
                            appState.logged.id,
                            nomeController.text,
                            emailController.text,
                            passwordController.text,
                          );
                          if (resposta == 200) {
                            appState.sucesso('Cadastro Atualizado com Sucesso!');
                          } else {
                            print(resposta);
                            appState
                                .erro('Erro no cadastro - Email já em uso!');
                          }
                        }
                        ;
                      }
                    } else {
                      appState
                          .erro('Erro no cadastro - Senha Atual Incorreta!');
                      print('atual:' +
                          appState.logged.senha +
                          '\n lida: ' +
                          oldpasswordController.text);
                    }
                  },
                  child: Text('Atualizar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
