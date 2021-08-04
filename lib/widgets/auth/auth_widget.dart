import 'package:flutter/material.dart';
import 'package:the_movie_db/Theme/app_button_style.dart';
import 'package:the_movie_db/const/routes_screen.dart';

class AuthWidget extends StatefulWidget {
  const AuthWidget({Key? key}) : super(key: key);

  @override
  _AuthWidgetState createState() => _AuthWidgetState();
}

class _AuthWidgetState extends State<AuthWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Войти в свою учётную запись'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ListView(
          children: [
            _HeaderWidget(),
            _FormWidget(),
          ],
        ),
      ),
    );
  }
}

class _HeaderWidget extends StatelessWidget {
  const _HeaderWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textStyle = const TextStyle(fontSize: 16, color: Colors.black);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 25,
        ),
        Text(
            'Чтобы пользоваться правкой и возможностями рейтинга TMDb, а также получить персональные рекомендации, необходимо войти в свою учётную запись. Если у вас нет учётной записи, её регистрация является бесплатной и простой. Нажмите здесь, чтобы начать',
            style: textStyle),
        TextButton(
          onPressed: () {},
          child: Text('Register'),
          style: AppButtonStyle.linkButton,
        ),
        SizedBox(
          height: 25,
        ),
        Text(
          'Если Вы зарегистрировались, но не получили письмо для подтверждения, нажмите здесь, чтобы отправить письмо повторно.',
          style: textStyle,
        ),
        TextButton(
          onPressed: () {},
          child: Text('verify email'),
          style: AppButtonStyle.linkButton,
        ),
      ],
    );
  }
}

class _FormWidget extends StatefulWidget {
  const _FormWidget({Key? key}) : super(key: key);

  @override
  __FormWidgetState createState() => __FormWidgetState();
}

class __FormWidgetState extends State<_FormWidget> {
  final _loginTextController = TextEditingController(text: 'admin');
  final _passwordTextController = TextEditingController(text: 'admin');
  String? errorText = null;
  void _auth() {
    final login = _loginTextController.text;
    final password = _passwordTextController.text;
    print(login);
    print(password);
    if (login == 'admin' && password == 'admin') {
      errorText = null;
      Navigator.of(context).pushReplacementNamed(RouteScreen.main_screen);
    } else {
      errorText = 'Не верный Логин или пароль';
    }
    setState(() {});
  }

  void _resetPassword() {
    print('password');
  }

  @override
  Widget build(BuildContext context) {
    final color = const Color(0xFF01b4e4);
    final textStyle = const TextStyle(
      fontSize: 16,
      color: Color(0xff212529),
    );
    final textFielfDecorator = const InputDecoration(
        border: OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue, width: 1)),
        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        isCollapsed: true);
    final errorText = this.errorText; //Объявляем переменную почему так не понял
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (errorText != null) ...[
          Text(errorText, style: TextStyle(color: Colors.red, fontSize: 17)),
          SizedBox(
            height: 10,
          ),
        ],
        Text(
          'Username',
          style: textStyle,
        ),
        SizedBox(
          height: 5,
        ),
        TextField(
          decoration: textFielfDecorator,
          controller: _loginTextController,
        ),
        SizedBox(
          height: 5,
        ),
        Text(
          'Password',
          style: textStyle,
        ),
        SizedBox(
          height: 5,
        ),
        TextField(
          controller: _passwordTextController,
          obscureText: true,
          decoration: textFielfDecorator,
        ),
        SizedBox(
          height: 25,
        ),
        Row(
          children: [
            ElevatedButton(
              onPressed: _auth,
              child: Text(
                'login',
              ),
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(color),
                  foregroundColor: MaterialStateProperty.all(Colors.white),
                  textStyle: MaterialStateProperty.all(
                    TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  padding: MaterialStateProperty.all(
                      EdgeInsets.symmetric(horizontal: 15, vertical: 8))),
            ),
            SizedBox(
              width: 30,
            ),
            TextButton(
              onPressed: _resetPassword,
              child: Text('Reset password'),
              style: AppButtonStyle.linkButton,
            ),
          ],
        )
      ],
    );
  }
}
