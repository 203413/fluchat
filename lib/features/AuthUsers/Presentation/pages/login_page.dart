import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proyecto_c2/features/AuthUsers/Presentation/cubit/auth/auth_cubit.dart';
import 'package:proyecto_c2/features/AuthUsers/Presentation/cubit/credential/credential_cubit.dart';
import 'package:proyecto_c2/features/AuthUsers/Presentation/widgets/common.dart';
import 'package:proyecto_c2/features/AuthUsers/Presentation/widgets/theme/style.dart';
import 'package:proyecto_c2/page_const.dart';
import 'package:line_icons/line_icons.dart';

import 'home_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool _isShowPassword = true;
  GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldState,
      body: BlocConsumer<CredentialCubit, CredentialState>(
        listener: (context, credentialState) {
          if (credentialState is CredentialSuccess) {
            BlocProvider.of<AuthCubit>(context).loggedIn();
          }
          if (credentialState is CredentialFailure) {
            snackBarNetwork(
                msg: "Correo incorrecto, intente de nuevo.",
                scaffoldState: _scaffoldState);
          }
        },
        builder: (context, credentialState) {
          if (credentialState is CredentialLoading) {
            return Scaffold(
              body: loadingIndicatorProgressBar(),
            );
          }
          if (credentialState is CredentialSuccess) {
            return BlocBuilder<AuthCubit, AuthState>(
              builder: (context, authState) {
                if (authState is Authenticated) {
                  return HomePage(
                    uid: authState.uid,
                  );
                } else {
                  print("No autentificado");
                  return _bodyWidget();
                }
              },
            );
          }

          return _bodyWidget();
        },
      ),
    );
  }

  _bodyWidget() {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 22, vertical: 32),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            Container(
                alignment: Alignment.topLeft,
                child: Text(
                  'Iniciar sesión',
                  style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.w700,
                      color: darkPrimaryColor),
                )),
            SizedBox(
              height: 10,
            ),
            Divider(
              thickness: 1,
              endIndent: 15,
              indent: 15,
            ),
            // Container(
            //   child: SvgPicture.asset('assets/login_image.svg'),
            // ),
            SizedBox(
              height: 17,
            ),
            Container(
              height: 50,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: color747480.withOpacity(.2),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.email,
                    color: Colors.grey,
                  ),
                  hintText: 'Correo electrónico',
                  hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 17,
                      fontWeight: FontWeight.w400),
                  border: InputBorder.none,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              height: 50,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: color747480.withOpacity(.2),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: TextField(
                obscureText: _isShowPassword,
                controller: _passwordController,
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.lock,
                    color: Colors.grey,
                  ),
                  hintText: 'Contraseña',
                  hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 17,
                      fontWeight: FontWeight.w400),
                  border: InputBorder.none,
                  suffixIcon: InkWell(
                      onTap: () {
                        setState(() {
                          _isShowPassword =
                              _isShowPassword == false ? true : false;
                        });
                      },
                      child: Icon(_isShowPassword == false
                          ? Icons.remove_red_eye
                          : Icons.panorama_fish_eye)),
                ),
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Align(
              alignment: Alignment.topRight,
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context, PageConst.forgotPage);
                },
                child: Text(
                  '¿No recuerdas tu contraseña?',
                  style: TextStyle(
                      color: darkPrimaryColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w700),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: () {
                _submitLogin();
              },
              child: Container(
                alignment: Alignment.center,
                height: 44,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(18, 169, 221, 1),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: Text(
                  'Iniciar sesión',
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: Colors.white),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              alignment: Alignment.topRight,
              child: Row(
                children: <Widget>[
                  Text(
                    "¿Aún no tienes cuenta?",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  InkWell(
                    onTap: () {
                      //Navigator.pushNamedAndRemoveUntil(context, "/registration", (route) => false);
                      Navigator.pushNamed(context, PageConst.registrationPage);
                    },
                    child: Text(
                      ' Crea una',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: darkPrimaryColor),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "O intenta con:",
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                  ),
                  SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      BlocProvider.of<CredentialCubit>(context)
                          .googleAuthSubmit();
                    },
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                          color: Color.fromRGBO(66, 133, 244, 1),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(.2),
                              offset: Offset(1.0, 1.0),
                              spreadRadius: 1,
                              blurRadius: 1,
                            )
                          ]),
                      child: Icon(
                        LineIcons.googlePlusG,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void _submitLogin() {
    if (_emailController.text.isEmpty) {
      toast('enter your email');
      return;
    }
    if (_passwordController.text.isEmpty) {
      toast('enter your password');
      return;
    }
    BlocProvider.of<CredentialCubit>(context).signInSubmit(
      email: _emailController.text,
      password: _passwordController.text,
    );
  }
}
