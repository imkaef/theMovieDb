import 'package:flutter/material.dart';
import 'package:the_movie_db/domain/inherited/provider.dart';
import 'package:the_movie_db/ui/widgets/auth/auth_model.dart';

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
        padding: const EdgeInsets.symmetric(horizontal: 20),
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
          height: 10,
        ),
        Text(
            'Чтобы пользоваться правкой и возможностями рейтинга TMDb, а также получить персональные рекомендации, необходимо войти в свою учётную запись. Если у вас нет учётной записи, её регистрация является бесплатной и простой. Нажмите здесь, чтобы начать',
            style: textStyle),
        TextButton(
          onPressed: () {},
          child: Text('Регистрация'),
          style: TextButton.styleFrom(
            primary: const Color(0xFF01b4e4),
            padding: EdgeInsets.zero,
            textStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        Text(
          'Если Вы зарегистрировались, но не получили письмо для подтверждения, нажмите здесь, чтобы отправить письмо повторно.',
          style: textStyle,
        ),
        TextButton(
          onPressed: () {},
          child: Text('Повторное письмо'),
          style: TextButton.styleFrom(
            primary: const Color(0xFF01b4e4),
            padding: EdgeInsets.zero,
            textStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
}

class _FormWidget extends StatelessWidget {
  const _FormWidget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.read<AuthModel>(context);

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
    //Объявляем переменную почему так не понял
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _ErrorMessageWidget(),
        Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Text(
            'Имя пользователя',
            style: textStyle,
          ),
        ),
        SizedBox(
          height: 5,
        ),
        TextField(
          decoration: textFielfDecorator,
          controller: model?.loginTextController,
        ),
        SizedBox(
          height: 5,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Text(
            'Пароль',
            style: textStyle,
          ),
        ),
        SizedBox(
          height: 5,
        ),
        TextField(
          controller: model?.passwordTextController,
          obscureText: true,
          decoration: textFielfDecorator,
        ),
        SizedBox(
          height: 25,
        ),
        Row(
          children: [
            const _AuthButtonWidget(),
            SizedBox(
              width: 30,
            ),
            TextButton(
              onPressed: () {},
              child: Text('Сбросить пароль'),
              style: TextButton.styleFrom(
                primary: const Color(0xFF01b4e4),
                padding: EdgeInsets.zero,
                textStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}

class _AuthButtonWidget extends StatelessWidget {
  const _AuthButtonWidget({
    Key? key,
  }) : super(key: key);

  void pressff(BuildContext context) {
    final model = NotifierProvider.read<AuthModel>(context);
    if (model?.canStartAuth == true) {
      model?.auth(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = const Color(0xFF01b4e4);
    final model = NotifierProvider.watch<AuthModel>(context);
    final child = model?.isAuthinProgress == true
        ? Center(
            child: const SizedBox(
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
              height: 20,
              width: 20,
            ),
          )
        : const Text('Войти');

    return ElevatedButton(
      onPressed: () => pressff(context),
      child: child,
      style: ButtonStyle(
        minimumSize: MaterialStateProperty.all(Size(78, 0)),
        backgroundColor: MaterialStateProperty.all(color),
        foregroundColor: MaterialStateProperty.all(Colors.white),
        textStyle: MaterialStateProperty.all(
          TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
        padding: MaterialStateProperty.all(
          EdgeInsets.symmetric(vertical: 10),
        ),
      ),
    );
  }
}

class _ErrorMessageWidget extends StatelessWidget {
  const _ErrorMessageWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final errorMessage =
        NotifierProvider.watch<AuthModel>(context)?.errorMessage;
    if (errorMessage == null) return const SizedBox.shrink();
    return Text(errorMessage,
        style: TextStyle(color: Colors.red, fontSize: 17));
  }
}
