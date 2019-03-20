// import 'package:flutter/material.dart';
// import 'package:GymSpace/logic/auth.dart';
// import 'package:GymSpace/misc/colors.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:GymSpace/misc/bubblecontroller.dart';
// // import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:flutter/services.dart';

// class LoginPage extends StatefulWidget {
//   LoginPage({this.auth, this.onLoggedIn});
//   final BaseAuth auth;
//   final VoidCallback onLoggedIn;
//   @override
//   LoginPageState createState () => new LoginPageState();
// }

// enum FormType {
//   login,
//   register
// }
// class LoginPageState extends State<LoginPage>{
//   final FocusNode myFocusNodeEmail = FocusNode();
//   final formKey = new GlobalKey<FormState>();
//   final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
//   // User info
//   String _email;
//   String _password;
//   String _firstName;
//   String _lastName;
//   FormType _formType = FormType.login;

//   PageController _pageController;

//   Color left = Colors.black;
//   Color right = Colors.white;

//   bool validateAndSave() {
//     final form = formKey.currentState;
//     if(form.validate()){
//       form.save();
//       return true;
//     }
//     return false;
//   }

//   // Checks if User is valid from Firebase authentication 
//   void validateAndSubmit() async {
//     if(validateAndSave()) {
//       try {
//         if(_formType == FormType.login) {
//           String userID = await widget.auth.signInWithEmailAndPassword(_email, _password);   
//           print('Signed in: $userID');
//         }
//         else {
//           String userID = await widget.auth.createUserWithEmailAndPassword(_email, _password);
//           Firestore.instance.collection('users').document(userID).setData(
//               {'first name': '$_firstName',
//               'last name': '$_lastName',
//               'email': '$_email',
//               'password' : '$_password'
//               }

//             );
//           print('Registered User: $userID');
//         }
//         widget.onLoggedIn();
//       }
//       catch (e) {
//         print('Error: $e');
//       }
//     }
//   }

// void moveToRegister() {
//     formKey.currentState.reset();
//     setState(() {
//       _formType = FormType.register;
//     });
//   }

//   // Move buttons to show 'Login'
//   void moveToLogin() {
//     formKey.currentState.reset();
//     setState(() {
//       _formType = FormType.login;
//     });
//   }
  
//   // Existing Button
//   void _existing() {
//     moveToLogin();
//     _pageController.animateToPage(0,
//       duration: Duration(milliseconds: 500), curve: Curves.decelerate);
//   }

//   // New User Button
//   void _newUser() {
//     moveToRegister();
//     _pageController?.animateToPage(1,
//       duration: Duration(milliseconds: 500), curve: Curves.decelerate);
//   }

//   @override
//   void initState(){
//     super.initState();
//     SystemChrome.setPreferredOrientations([
//       DeviceOrientation.portraitUp,
//       DeviceOrientation.portraitDown,
//     ]);
//     _pageController = PageController();
//   }

//   @override
//   Widget build(BuildContext context){
//     return new Scaffold(
//       key: _scaffoldKey,
//       body: NotificationListener<OverscrollIndicatorNotification>(
//         onNotification: (overscroll){
//           overscroll.disallowGlow();
//         },
//         child:SingleChildScrollView(
//           child: Container(
//             width:MediaQuery.of(context).size.width,
//             height:MediaQuery.of(context).size.height >= 775.0 
//               ? MediaQuery.of(context).size.height : 775.0,
//             decoration: new BoxDecoration(
//               gradient: new LinearGradient(
//                 colors: [
//                   GSColors.darkBlue,
//                   GSColors.darkCloud
//                 ],
//                 begin: const FractionalOffset(0.0, 0.0),
//                 end: const FractionalOffset(5.0, 5.0),
//                 stops: [0.0,1.0],
//                 tileMode: TileMode.clamp
//               ),
//             ),
//             child: Column (
//               mainAxisSize: MainAxisSize.max,
//               children: <Widget>[
//                 Padding(
//                   padding:EdgeInsets.only(top: 75.0),
//                   child: new Image (
//                     width: 250.0,
//                     height: 191.0,
//                     fit:BoxFit.fill, 
//                     image: new AssetImage("lib/assets/armshake.jpg")
//                   ),
//                 ),
//                 Padding (
//                   padding:  EdgeInsets.only(top: 20.0),
//                   child: _buildSlidingMenuBar(context),
//                 ),
//                 Expanded(
//                   flex: 2,
//                   child: new Form(
//                     key: formKey,
//                     child: PageView(
//                       controller:_pageController,
//                       onPageChanged: (i) {
//                         if (i == 0){
//                           setState((){
//                             right = Colors.white;
//                             left = Colors.black;
//                           });
//                         }
//                         else if (i == 1){
//                           setState((){
//                             right = Colors.black;
//                             left = Colors.white;
//                           });
//                         }
//                       },
//                       children: <Widget>[
//                         new ConstrainedBox(
//                           constraints: const BoxConstraints.expand(),
//                           child: _buildLogin(context),
//                         ),
//                           new ConstrainedBox(
//                           constraints: const BoxConstraints.expand(),
//                           child: _buildNewUser(context),
//                         ),
//                       ],
//                     ),
//                   )
//                 )
//               ],
//             )
//           )
//         )
//       ),
//     );
//   }

//   // Builds Sliding Bar
//   Widget _buildSlidingMenuBar (BuildContext context){
//     return Container (
//       width: 300.0,
//       height: 50.0,
//       decoration:BoxDecoration(
//         color: GSColors.blue,
//         borderRadius: BorderRadius.all(Radius.circular(25.0)),
//       ),
//       child:CustomPaint(
//         painter: TabIndicationPainter(pageController: _pageController),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: <Widget>[
//             Expanded(
//               child: FlatButton(
//                 splashColor: Colors.transparent,
//                 highlightColor: Colors.transparent,
//                 onPressed: _existing,
//                 child: Text (
//                   "Existing",
//                   style:TextStyle(
//                     color: left,
//                     fontSize: 16.0,
//                   ),
//                 ),
//               ),
//             ),
//             Expanded(
//               child: FlatButton(
//                 splashColor: Colors.transparent,
//                 highlightColor: Colors.transparent,
//                 onPressed: _newUser,
//                 child: Text(
//                   "New User",
//                   style: TextStyle(
//                     color: right,
//                     fontSize: 16.0
//                   ),
//                 )
//               )
//             )
//           ],
//         ),
//       )
//     );
//   }

//  @override
//  void dispose() {
//    _pageController?.dispose();
//    super.dispose();
//  }

// // Builds log
// Widget _buildLogin(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.only(top: 23.0),
//       child: Column(
//         children: <Widget>[
//           Stack(
//             alignment: Alignment.topCenter,
//             overflow: Overflow.visible,
//             children: <Widget>[
//               Card(
//                 elevation: 2.0,
//                 color: Colors.white,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8.0),
//                 ),
//                 child: Container(
//                   width: 300.0,
//                   height: 190.0,
//                   child: Column(
//                     children: <Widget>[
//                       Padding(
//                         padding: EdgeInsets.only(
//                             top: 5.0, bottom: 5.0, left: 25.0, right: 25.0),
//                         child: TextFormField(
//                           keyboardType: TextInputType.emailAddress,
//                           validator: (value) => value.isEmpty ? 'Error: Email is empty' : null,
//                           onSaved: (value) => _email = value,
//                           style: TextStyle(
//                               fontSize: 16.0,
//                               color: Colors.black),
//                           decoration: InputDecoration(
//                             border: InputBorder.none,
//                             icon: Icon(
//                               FontAwesomeIcons.envelope,
//                               color: Colors.black,
//                               size: 22.0,
//                             ),
//                             hintText: "Email Address",
//                             hintStyle: TextStyle(fontSize: 17.0),
//                           ),
//                         ),
//                       ),
//                       Container(
//                         width: 250.0,
//                         height: 1.0,
//                         color: Colors.grey[400],
//                       ),
//                       Padding(
//                         padding: EdgeInsets.only(
//                             top: 5.0, bottom: 5.0, left: 25.0, right: 25.0),
//                         child: TextFormField(
//                           keyboardType: TextInputType.text,
//                           obscureText: true,
//                           validator: (value) => value.isEmpty ? 'Error: Password is empty' : null,
//                           onSaved: (value) => _password = value,
//                           style: TextStyle(
//                               fontSize: 16.0,
//                               color: Colors.black),
//                           decoration: InputDecoration(
//                             border: InputBorder.none,
//                             icon: Icon(
//                               FontAwesomeIcons.lock,
//                               size: 22.0,
//                               color: Colors.black,
//                             ),
//                             hintText: "Password",
//                             hintStyle: TextStyle( fontSize: 17.0),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               Container(
//                 margin: EdgeInsets.only(top: 170.0),
//                 decoration: new BoxDecoration(
//                   borderRadius: BorderRadius.all(Radius.circular(5.0)),
//                   boxShadow: <BoxShadow>[
//                     BoxShadow(
//                       color: GSColors.darkBlue,
//                       offset: Offset(1.0, 6.0),
//                       blurRadius: 20.0,
//                     ),
//                     BoxShadow(
//                       color: GSColors.darkCloud,
//                       offset: Offset(1.0, 6.0),
//                       blurRadius: 20.0,
//                     ),
//                   ],
//                   gradient: new LinearGradient(
//                     colors: [
//                       GSColors.blue,
//                       GSColors.darkBlue
//                     ],
//                     begin: const FractionalOffset(0.2, 0.2),
//                     end: const FractionalOffset(1.0, 1.0),
//                     stops: [0.0, 1.0],
//                     tileMode: TileMode.clamp
//                   ),
//                 ),
//                 child: MaterialButton(
//                   highlightColor: Colors.transparent,
//                   splashColor: GSColors.darkCloud,
//                   //shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(
//                         vertical: 10.0, horizontal: 42.0),
//                     child: Text(
//                       "LOGIN",
//                       style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 25.0),
//                     ),
//                   ),
//                   onPressed: () {
//                     validateAndSubmit();
//                   }
//                 )
//               ),
//             ],
//           ),
//           Padding(
//             padding: EdgeInsets.only(top: 10.0),
//             child: FlatButton(
//                 onPressed: () {},
//                 child: Text(
//                   "Forgot Password?",
//                   style: TextStyle(
//                       decoration: TextDecoration.underline,
//                       color: Colors.white,
//                       fontSize: 16.0,
//                       fontFamily: "WorkSansMedium"),
//                 )),
//           ),
//           Padding(
//             padding: EdgeInsets.only(top: 10.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: <Widget>[
//                 Container(
//                   decoration: BoxDecoration(
//                     gradient: new LinearGradient(
//                         colors: [
//                           Colors.white10,
//                           Colors.white,
//                         ],
//                         begin: const FractionalOffset(0.0, 0.0),
//                         end: const FractionalOffset(1.0, 1.0),
//                         stops: [0.0, 1.0],
//                         tileMode: TileMode.clamp),
//                   ),
//                   width: 100.0,
//                   height: 1.0,
//                 ),
//                 Padding(
//                   padding: EdgeInsets.only(left: 15.0, right: 15.0),
//                   child: Text(
//                     "Or",
//                     style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 16.0,
//                         fontFamily: "WorkSansMedium"),
//                   ),
//                 ),
//                 Container(
//                   decoration: BoxDecoration(
//                     gradient: new LinearGradient(
//                         colors: [
//                           Colors.white,
//                           Colors.white10,
//                         ],
//                         begin: const FractionalOffset(0.0, 0.0),
//                         end: const FractionalOffset(1.0, 1.0),
//                         stops: [0.0, 1.0],
//                         tileMode: TileMode.clamp),
//                   ),
//                   width: 100.0,
//                   height: 1.0,
//                 ),
//               ],
//             ),
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               Padding(
//                 padding: EdgeInsets.only(top: 10.0, right: 40.0),
//                 child: GestureDetector(
//                   onTap: () {}, // Will link Facebook Login Eventually
//                   child: Container(
//                     padding: const EdgeInsets.all(15.0),
//                     decoration: new BoxDecoration(
//                       shape: BoxShape.circle,
//                       color: Colors.white,
//                     ),
//                     child: new Icon(
//                       FontAwesomeIcons.facebookF,
//                       color: Color(0xFF0084ff),
//                     ),
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: EdgeInsets.only(top: 10.0),
//                 child: GestureDetector(
//                   onTap: () {}, // Will Link in Google Login Eventually
//                   child: Container(
//                     padding: const EdgeInsets.all(15.0),
//                     decoration: new BoxDecoration(
//                       shape: BoxShape.circle,
//                       color: Colors.white,
//                     ),
//                     child: new Icon(
//                       FontAwesomeIcons.google,
//                       color: Color(0xFF0084ff),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   // Builds Sign Up Page <==>  Page View #2
//   Widget _buildNewUser(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.only(top: 23.0),
//       child: Column(
//         children: <Widget>[
//           Stack(
//             alignment: Alignment.topCenter,
//             overflow: Overflow.visible,
//             children: <Widget>[
//               Card(
//                 elevation: 2.0,
//                 color: Colors.white,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8.0),
//                 ),
//                 child: Container(
//                   width: 300.0,
//                   height: 360.0,
//                   child: Column(
//                     children: <Widget>[
//                       Padding(
//                         padding: EdgeInsets.only(
//                             top: 2.0, bottom: 2.0, left: 25.0, right: 25.0),
//                         child: TextFormField(
//                           keyboardType: TextInputType.text,
//                           textCapitalization: TextCapitalization.words,
//                           validator: (value) => value.isEmpty ? 'Error: First Name is empty' : null,
//                           onSaved: (value) => _firstName = value,
//                           style: TextStyle(
//                               fontSize: 16.0,
//                               color: Colors.black),
//                           decoration: InputDecoration(
//                             border: InputBorder.none,
//                             icon: Icon(
//                               FontAwesomeIcons.user,
//                               color: Colors.black,
//                             ),
//                             hintText: "First Name",
//                             hintStyle: TextStyle(fontSize: 16.0),
//                           ),
//                         ),
//                       ),
//                       Container(
//                         width: 250.0,
//                         height: 1.0,
//                         color: Colors.grey[400],
//                       ),
//                        Padding(
//                         padding: EdgeInsets.only(
//                             top: 2.0, bottom: 2.0, left: 65.0, right: 25.0),
//                         child: TextFormField(
//                           keyboardType: TextInputType.text,
//                           textCapitalization: TextCapitalization.words,
//                           validator: (value) => value.isEmpty ? 'Error: Last Name is empty' : null,
//                           onSaved: (value) => _lastName = value,
//                           style: TextStyle(
//                               fontSize: 16.0,
//                               color: Colors.black),
//                           decoration: InputDecoration(
//                             border: InputBorder.none,
//                             hintText: "Last Name",
//                             hintStyle: TextStyle(fontSize: 16.0),
//                           ),
//                         ),
//                       ),
//                       Container(
//                         width: 250.0,
//                         height: 1.0,
//                         color: Colors.grey[400],
//                       ),
//                       Padding(
//                         padding: EdgeInsets.only(
//                             top: 2.0, bottom: 2.0, left: 25.0, right: 25.0),
//                         child: TextFormField(
//                           keyboardType: TextInputType.emailAddress,
//                           validator: (value) => value.isEmpty ? 'Error: Email is empty' : null,
//                           onSaved: (value) => _email = value,
//                           style: TextStyle(
//                               fontSize: 16.0,
//                               color: Colors.black),
//                           decoration: InputDecoration(
//                             border: InputBorder.none,
//                             icon: Icon(
//                               FontAwesomeIcons.envelope,
//                               color: Colors.black,
//                             ),
//                             hintText: "Email Address",
//                             hintStyle: TextStyle( fontSize: 16.0),
//                           ),
//                         ),
//                       ),
//                       Container(
//                         width: 250.0,
//                         height: 1.0,
//                         color: Colors.grey[400],
//                       ),
//                       Padding(
//                         padding: EdgeInsets.only(
//                             top: 2.0, bottom: 2.0, left: 25.0, right: 25.0),
//                         child: TextFormField(
//                           keyboardType: TextInputType.text,
//                           obscureText: true,
//                           validator: (value) => value.isEmpty ? 'Error: Password is empty' : null,
//                           onSaved: (value) => _password = value,
//                           style: TextStyle(
//                               fontSize: 16.0,
//                               color: Colors.black
//                               ),
//                           decoration: InputDecoration(
//                             border: InputBorder.none,
//                             icon: Icon(
//                               FontAwesomeIcons.lock,
//                               color: Colors.black,
//                             ),
//                             hintText: "Password",
//                             hintStyle: TextStyle( fontSize: 16.0),
//                           ),
//                         ),
//                       ),
//                       Container(
//                         width: 250.0,
//                         height: 1.0,
//                         color: Colors.grey[400],
//                       ),
//                       Padding(
//                         padding: EdgeInsets.only(
//                           top: 2.0, bottom: 2.0, left: 25.0, right: 25.0),
//                           child: TextFormField(
//                           keyboardType: TextInputType.text,
//                           obscureText: true,
//                           validator: (value) {if (value != _password) {return 'Error: Password is not matching';}},
//                           onSaved: (value) => _password = value,
//                           style: TextStyle(
//                               fontSize: 16.0,
//                               color: Colors.black),
//                           decoration: InputDecoration(
//                             border: InputBorder.none,
//                             icon: Icon(
//                               FontAwesomeIcons.lock,
//                               color: Colors.black,
//                             ),
//                             hintText: "Confirm Password",
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               Container(
//                 margin: EdgeInsets.only(top: 340.0),
//                 decoration: new BoxDecoration(
//                   borderRadius: BorderRadius.all(Radius.circular(5.0)),
//                   boxShadow: <BoxShadow>[
//                     BoxShadow(
//                       color: GSColors.darkBlue,
//                       offset: Offset(1.0, 6.0),
//                       blurRadius: 20.0,
//                     ),
//                     BoxShadow(
//                       color: GSColors.darkCloud,
//                       offset: Offset(1.0, 6.0),
//                       blurRadius: 20.0,
//                     ),
//                   ],
//                   gradient: new LinearGradient(
//                       colors: [
//                         GSColors.darkBlue,
//                         GSColors.blue
//                       ],
//                       begin: const FractionalOffset(0.2, 0.2),
//                       end: const FractionalOffset(1.0, 1.0),
//                       stops: [0.0, 1.0],
//                       tileMode: TileMode.clamp
//                       ),
//                 ),
//                 child: MaterialButton(
//                   highlightColor: Colors.transparent,
//                   //shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(
//                         vertical: 10.0, horizontal: 42.0),
//                     child: Text(
//                       "SIGN UP",
//                       style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 25.0),
//                     ),
//                   ),
//                   onPressed: (){
//                     validateAndSubmit();
//                   }
//                 )
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }