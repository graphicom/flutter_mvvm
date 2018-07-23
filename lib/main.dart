import 'package:flutter/material.dart';
import 'package:mvvm_demo/login_view_model.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(),
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final loginViewModel = new LoginViewModel();

  // 输入框
  Widget textField(LoginViewModel vm, bool isPassword) {
    return StreamBuilder(
      stream: isPassword ? vm.passwordStream : vm.emailStream,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        return TextField(
          onChanged: isPassword ? vm.updatePassword : vm.updateEmail,
          obscureText: isPassword,
          keyboardType:
              isPassword ? TextInputType.text : TextInputType.emailAddress,
          decoration: InputDecoration(
            hintText: isPassword ? '请输入密码' : '请输入邮箱地址',
            errorText: snapshot.error,
          ),
        );
      },
    );
  }

  // 登录按钮
  Widget loginButton(LoginViewModel vm) {
    return StreamBuilder(
      stream: vm.submitValid,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        return RaisedButton(
          child: Text('登录'),
          color: Theme.of(context).primaryColor,
          textColor: Colors.white,
          onPressed: snapshot.hasData
              ? () => vm.login()
              : null, //Disable the button if there is an error
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MVVM Demo'),
      ),
      body: Container(
        margin: EdgeInsets.all(30.0),
        child: Column(
          children: <Widget>[
            textField(loginViewModel, false),
            SizedBox(height: 10.0),
            textField(loginViewModel, true),
            SizedBox(height: 40.0),
            loginButton(loginViewModel),
          ],
        ),
      ),
    );
  }
}
