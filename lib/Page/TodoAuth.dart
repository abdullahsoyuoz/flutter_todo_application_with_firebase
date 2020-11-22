import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/Page/TodoHome.dart';
import 'package:todo_app/Services/firestoreAuthService.dart';
import 'package:todo_app/Services/sharedPreferences.dart';
import 'package:todo_app/Util/TodoLogoWidget.dart';
import 'package:todo_app/Util/TodoWaiting.dart';
import 'package:todo_app/Util/utility.dart';

class AuthPage extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    _usernameController.text;
    _passwordController.text;
    final Future<FirebaseApp> _initialize = Firebase.initializeApp();
    return Scaffold(
        resizeToAvoidBottomInset: false,
        resizeToAvoidBottomPadding: false,
        backgroundColor: Theme.of(context).backgroundColor,
        body: FutureBuilder(
          future: _initialize,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              Scaffold.of(context)
                  .showSnackBar(SnackBar(content: Text(snapshot.error)));
            }
            if (snapshot.connectionState == ConnectionState.none) {
              Scaffold.of(context).showSnackBar(
                  SnackBar(content: Text("Bağlantı Bulunamadı...")));
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return todoWaiting("Bağlantı kuruluyor...", context);
            } else {
              getPrefsEmailPassword().then((value) {
                if (value["email"].isNotEmpty || value["password"].isNotEmpty) {
                  FirebaseAuthService.signIn(value["email"], value["password"])
                      .then((value) => Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomePage(),
                          ),
                          (route) => false))
                      .catchError((onError) {
                    Scaffold.of(context).showSnackBar(SnackBar(
                        content: Text("Hata : ${onError.toString()}")));
                  }).catchError((onError) => print("onError:" + onError));
                  return todoWaiting("Bekleyiniz...", context);
                } else {
                  return authController(context);
                }
              });
            }
            return authController(context);
          },
        ));
  }

  authController(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        height: getSize(context).size.height,
        width: getSize(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: getSize(context).size.height * 0.1,
            ),
            authLogo(context),
            Divider(
              indent: getSize(context).size.height * 0.1,
              endIndent: getSize(context).size.height * 0.1,
              height: getSize(context).size.height * 0.1,
              color: Theme.of(context).primaryColor,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                emailInput(context),
                SizedBox(
                  height: getSize(context).size.height * 0.05,
                ),
                passwordInput(context),
              ],
            ),
            Divider(
              indent: getSize(context).size.height * 0.1,
              endIndent: getSize(context).size.height * 0.1,
              height: getSize(context).size.height * 0.1,
              color: Theme.of(context).primaryColor,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.max,
              children: [
                signInButton(context),
                signUpButton(context),
              ],
            )
          ],
        ),
      ),
    );
  }

  emailInput(BuildContext context) {
    return Container(
        height: getSize(context).size.height * 0.07,
        width: getSize(context).size.width,
        margin: EdgeInsets.only(
            left: getSize(context).size.height * 0.1,
            right: getSize(context).size.height * 0.1),
        padding: EdgeInsets.symmetric(
            horizontal: getSize(context).size.height * 0.03),
        color: Theme.of(context).accentColor,
        child: TextFormField(
          controller: _usernameController,
          autocorrect: false,
          showCursor: false,
          maxLines: 1,
          keyboardType: TextInputType.emailAddress,
          strutStyle: StrutStyle.disabled,
          decoration: InputDecoration(
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            focusedErrorBorder: InputBorder.none,
            hintText: "email adresiniz...",
            hintStyle: TextStyle(
                color: Theme.of(context).primaryColor.withOpacity(0.2)),
          ),
          style: TextStyle(
            decoration: TextDecoration.none,
          ),
          validator: (value) => _validateEmail(value),
        ));
  }

  _validateEmail(String value) {
    if (value.isEmpty) {
      return "Lütfen bir email adresi giriniz...";
    }
    if (!value.contains("@")) {
      return "Geçerli bir email adresi giriniz...";
    }
  }

  passwordInput(BuildContext context) {
    return Container(
        height: getSize(context).size.height * 0.07,
        width: getSize(context).size.width,
        margin: EdgeInsets.only(
            left: getSize(context).size.height * 0.1,
            right: getSize(context).size.height * 0.1),
        padding: EdgeInsets.symmetric(
            horizontal: getSize(context).size.height * 0.03),
        color: Theme.of(context).accentColor,
        child: TextFormField(
          controller: _passwordController,
          obscureText: true,
          validator: (value) => _validatePassword(value),
          autocorrect: false,
          showCursor: false,
          maxLines: 1,
          keyboardType: TextInputType.text,
          strutStyle: StrutStyle.disabled,
          decoration: InputDecoration(
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            focusedErrorBorder: InputBorder.none,
            hintText: "şifreniz...",
            hintStyle: TextStyle(
                color: Theme.of(context).primaryColor.withOpacity(0.2)),
          ),
          style: TextStyle(
            decoration: TextDecoration.none,
          ),
        ));
  }

  _validatePassword(String value) {
    if (value.isEmpty) {
      return "Lütfen şifrenizi giriniz...";
    }
    if (value.length < 6) {
      return "Şifreniz en az 6 karakterden oluşmalıdır...";
    }
  }

  authLogo(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Hero(tag: "textLogo", child: TodoTextLogoWidget()),
        Hero(tag: "logo", child: TodoLogoWidget()),
      ],
    );
  }

  signInButton(BuildContext context) {
    return CupertinoButton(
        child: Text(
          "Giriş Yap",
          style: TextStyle(color: Theme.of(context).colorScheme.green),
        ),
        pressedOpacity: 0.3,
        onPressed: () {
          if (_formKey.currentState.validate()) {
            FirebaseAuthService.signIn(
                    _usernameController.text, _passwordController.text)
                .then((value) => Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomePage(),
                    ),
                    (route) => false))
                .catchError((onError) {
              Scaffold.of(context).showSnackBar(
                  SnackBar(content: Text("Hata : ${onError.toString()}")));
            });
          }
        });
  }

  signUpButton(BuildContext context) {
    return CupertinoButton(
        child: Text(
          "Kaydol",
          style: TextStyle(color: Theme.of(context).colorScheme.orange),
        ),
        pressedOpacity: 0.3,
        onPressed: () {
          if (_formKey.currentState.validate()) {
            FirebaseAuthService.signUp(
                    _usernameController.text, _passwordController.text)
                .then((value) {
              _usernameController.text = null;
              _passwordController.text = null;
            }).catchError((onError) {
              Scaffold.of(context).showSnackBar(
                  SnackBar(content: Text("Hata : ${onError.toString()}")));
            });
          }
        });
  }
}
