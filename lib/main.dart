import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Registro App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'CustomFont', // fonte
      ),
      home: const RegisterScreen(), // Tela de registro como inicial
    );
  }
}

// armazenamento de dados
String? registeredUsername;
String? registeredPassword;

class LoginForms extends StatefulWidget {
  final String? username; // Recebe o nome de usuário do registro

  const LoginForms({super.key, this.username});

  @override
  State<LoginForms> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginForms> {
  final _loginController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.username != null) {
      _loginController.text = widget.username!; // Preenche o campo de login com o nome de usuário
    }
  }

  void _login() {
    final login = _loginController.text;
    final password = _passwordController.text;

    // Validação do login e senha
    if (login.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, insira seu login.')),
      );
      return;
    }

    if (password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, insira sua senha.')),
      );
      return;
    }

    if (password.length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('A senha deve conter pelo menos 8 caracteres.')),
      );
      return;
    }

    // Verifica se o login e a senha correspondem aos registrados
    if (login != registeredUsername || password != registeredPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login ou senha incorretos.')),
      );
      return;
    }

    // Login realizado com sucesso
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Login realizado com sucesso!')),
    );

    // Ir para a tela principal
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => HomeScreen(username: registeredUsername!),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: _loginController,
                decoration: const InputDecoration(labelText: 'Digite seu login'),
              ),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Digite sua senha'),
                obscureText: true,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _login,
                child: const Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController(); // Nome de usuário
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  void _register() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Simula um processo de registro
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          _isLoading = false;
        });

        // Armazena os dados registrados
        registeredUsername = _usernameController.text;
        registeredPassword = _passwordController.text;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Registro realizado com sucesso, ${_nameController.text}!'),
          ),
        );

        // Ir para a tela de login
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => LoginForms(
              username: _usernameController.text, // Passa o nome de usuário para o login
            ),
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextFormField(
                    controller: _usernameController,
                    decoration: const InputDecoration(labelText: 'Nome de Usuário'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira um nome de usuário.';
                      }
                      if (value.length < 5) {
                        return 'O nome de usuário deve ter pelo menos 5 caracteres.';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Nome completo'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira seu nome completo.';
                      }
                      if (value.length < 3) {
                        return 'O nome deve ter pelo menos 3 caracteres.';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: 'E-mail'),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira seu e-mail.';
                      }
                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                        return 'Por favor, insira um e-mail válido.';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Senha',
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                    ),
                    obscureText: !_isPasswordVisible,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira sua senha.';
                      }
                      if (value.length < 8) {
                        return 'A senha deve conter pelo menos 8 caracteres.';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _confirmPasswordController,
                    decoration: const InputDecoration(labelText: 'Confirme sua senha'),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, confirme sua senha.';
                      }
                      if (value != _passwordController.text) {
                        return 'As senhas não coincidem.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  _isLoading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: _register,
                          child: const Text('Registrar'),
                        ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: () {
                      // Ir para a tela de login
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginForms()),
                      );
                    },
                    child: const Text('Já possui uma conta? Faça login'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final String username; // Nome do usuário

  const HomeScreen({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tela Principal'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Seja Bem Vindo, $username!',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
