import 'package:flutter/material.dart';
import 'auth.dart';

class LoginPage extends StatefulWidget {
  LoginPage({this.auth, this.onLoggedIn});
  final BaseAuth auth;
  final VoidCallback onLoggedIn;
  @override
  LoginPageState createState () => new LoginPageState();
}

enum FormType {
  login,
  register
}
class LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin{
  
  final formKey = new GlobalKey<FormState>();
  // User info
  String _email;
  String _password;
  FormType _formType = FormType.login;


  bool validateAndSave() {
    final form = formKey.currentState;
    if(form.validate()){
      form.save();
      return true;
    }
    return false;
  }

  // Checks if User is valid from Firebase authentication 
  void validateAndSubmit() async {
    if(validateAndSave()) {
      try {
        if(_formType == FormType.login) {
          String userID = await widget.auth.signInWithEmailAndPassword(_email, _password);   
          print('Signed in: $userID');
        }
        else {
          String userID = await widget.auth.createUserWithEmailAndPassword(_email, _password);
          print('Registered User: $userID');
        }
        widget.onLoggedIn();
      }
      catch (e) {
        print('Error: $e');
      }
    }
  }

  // Move buttons to show 'create an account'
  void moveToRegister() {
    formKey.currentState.reset();
    setState(() {
      _formType = FormType.register;
    });
  }

  // Move buttons to show 'Login'
  void moveToLogin() {
    formKey.currentState.reset();
    setState(() {
      _formType = FormType.login;
    });
  }

  // Animates the GymSpace Icon
  AnimationController _iconAnimationController;
  Animation<double> _iconAnimation;

  @override
  void initState(){
    super.initState();
    _iconAnimationController = new AnimationController(
      vsync: this, 
      duration: new Duration(milliseconds: 500)
    );
    _iconAnimation = new CurvedAnimation(
      parent: _iconAnimationController,
      curve: Curves.easeOut
    );
    _iconAnimation.addListener(()=> this.setState((){}));
    _iconAnimationController.forward();
  }

  @override
  Widget build(BuildContext context){
    return new Scaffold(
      backgroundColor: Colors.amberAccent,
      body: new Stack(
        fit: StackFit.expand,
        children: <Widget>[
          new Image(
            image: new AssetImage("lib/assets/armshake.jpg"),
            fit:BoxFit.cover,
            color: Colors.black38,
            colorBlendMode: BlendMode.darken,
          ),
          new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              /*new FlutterLogo( // just using Flutter Logo as a base. Will change to Gym Space Logo whenever
                size: _iconAnimation.value * 100,
              ),*/
              new Form(
                key: formKey,
                child: new Theme(
                  data: new ThemeData(
                    brightness: Brightness.dark,
                    primarySwatch: Colors.teal,
                    inputDecorationTheme: new InputDecorationTheme(
                      labelStyle: new TextStyle(
                        color: Colors.teal,
                        fontSize: 20.0
                      )
                    )
                  ),
                  child: new Container(
                    padding :const EdgeInsets.all(40.0),
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: buildInputs() + buildSubmitButtons() + <Widget>[
                        new Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  // Gets Email and Passwords
  List<Widget> buildInputs() {
    return [
      new TextFormField(
        decoration: new InputDecoration(
          labelText: "Enter Email",
        ),
        keyboardType: TextInputType.emailAddress,
        validator: (value) => value.isEmpty ? 'Error: Email is empty' : null,
        onSaved: (value) => _email = value,
      ),
      new TextFormField(
        decoration: new InputDecoration(
          labelText: "Enter Password",
        ),
        keyboardType: TextInputType.text,
        obscureText: true,
        validator: (value) => value.isEmpty ? 'Error: Password is empty' : null,
        onSaved: (value) => _password = value,
      ),
    ];
  }

  // The Recieve
  List<Widget> buildSubmitButtons() {
    if(_formType == FormType.login){
      return [
        new MaterialButton(
          height: 40.0,
          minWidth: 100.0,
          color: Colors.indigo[900],
          textColor: Colors.white,
          child: new Text("Login"),
          onPressed: () {
            validateAndSubmit();
          } 
        ),
        new MaterialButton(
          height: 40.0,
          minWidth: 200.0,
          color: Colors.indigo[900],
          textColor: Colors.white,
          child: new Text("Register an account"),
          onPressed: () {
            moveToRegister();
          }
        )
      ];
    }
    else {
      return [
        new MaterialButton(
          height: 40.0,
          minWidth: 100.0,
          color: Colors.indigo[900],
          textColor: Colors.white,
          child: new Text("Create an account"),
          onPressed: () {
            validateAndSubmit();
          } 
        ),
        new MaterialButton(
          height: 40.0,
          minWidth: 300.0,
          color: Colors.indigo[900],
          textColor: Colors.white,
          child: new Text("Have an account? Login"),
          onPressed: () {
            moveToLogin();
          }
        )
      ];
    }
  }
}
