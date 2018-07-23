import 'dart:async';

import 'package:mvvm_demo/validator.dart';
import 'package:rxdart/rxdart.dart';

class LoginViewModel {
  final _emailController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();

  // input
  Function(String) get updateEmail => _emailController.sink.add;
  Function(String) get updatePassword => _passwordController.sink.add;
  void login() {
    String email = _emailController.value;
    String password = _passwordController.value;
    //延迟执行
    Future.delayed(const Duration(seconds: 3), () {});
  }

  // Transformer
  final emailTransformer =
      StreamTransformer<String, String>.fromHandlers(handleData: (email, sink) {
    Validator.isEmailValid(email) ? sink.add(email) : sink.addError('请输入有效的邮箱');
  });
  final passwordTransformer = StreamTransformer<String, String>.fromHandlers(
      handleData: (password, sink) {
    Validator.isPasswordValid(password)
        ? sink.add(password)
        : sink.addError('密码必须至少包含一个数字，大写和小写字母');
  });

  // output
  Stream<String> get emailStream =>
      _emailController.stream.transform(emailTransformer);
  Stream<String> get passwordStream =>
      _passwordController.stream.transform(passwordTransformer);
  Stream<bool> get submitValid =>
      Observable.combineLatest2(emailStream, passwordStream, (e, p) => true);

  dispose() {
    _emailController.close();
    _passwordController.close();
  }
}
