import 'package:GymSpace/logic/user.dart';
import 'package:GymSpace/widgets/app_drawer.dart';
import 'package:GymSpace/widgets/page_header.dart';
import 'package:flutter/material.dart';
import 'package:GymSpace/global.dart';
import 'package:GymSpace/misc/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:intl/intl.dart';

class NutritionPage extends StatefulWidget {
  NutritionPage(
    {Key key}) : super(key: key);

  _NutritionPage createState() => _NutritionPage();
}


class _NutritionPage extends State<NutritionPage> {
  Future<DocumentSnapshot> _futureUser = DatabaseHelper.getUserSnapshot(DatabaseHelper.currentUserID);
  String _dietKey = DateTime.now().toString().substring(0,10);
  var day = DateTime.now();
  int _currentDay;
  external int get weekday;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(startPage: 3,),
      backgroundColor: GSColors.darkBlue,
       floatingActionButton: FloatingActionButton(
        child: Icon(
          FontAwesomeIcons.plus,
          size: 14,
          color: Colors.white
        ),
        backgroundColor: GSColors.purple,
        onPressed: () => _updateNutritionInfo(context)
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      appBar: _buildAppBar(),
      body: _buildBody(context),
    );
  }

  Widget _buildAppBar() {
    return PreferredSize(
      preferredSize: Size.fromHeight(100),
      child: PageHeader(
        title: 'Nutrition', 
        backgroundColor: Colors.white, 
        showDrawer: true,
        titleColor: GSColors.darkBlue,
      )
    );  
  }

  Widget _buildBody(BuildContext context) {
    return Container(
      child: ListView(
        children: <Widget>[
          _buildWeeklyLabel(),
          _buildWeeklyNavigator(),
          _buildNutritionLabel(),
          _buildNutritionInfo(context),
        ],
      ),
    );
  }

  Widget _buildWeeklyLabel() {
    return Container(
      margin: EdgeInsets.only(top: 25),
      height: 40,
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Container(),
          ),
          Expanded(
            flex: 2,
            child: Container(
              alignment: Alignment.center,
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    topLeft: Radius.circular(20),
                  )
                )
              ),
              child: Text(
                "Weekly Nutrition",
                style: TextStyle(
                  color: GSColors.darkBlue,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyNavigator() {
    return Container(
      height: 100, 
      margin: EdgeInsets.symmetric(vertical: 5),
      child: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.only(left: 12),
              itemCount: 7,
              itemBuilder: (BuildContext context, int i) {

              return StreamBuilder(
                stream: DatabaseHelper.getUserStreamSnapshot(DatabaseHelper.currentUserID),
                builder: (context, snapshot) {
                  if(!snapshot.hasData)
                    return Container();

                    User user = User.jsonToUser(snapshot.data.data);
                    return _buildWeeklyCircularProgress(user, snapshot);
                  }
                );
              }
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyCircularProgress(User user, AsyncSnapshot<dynamic> snapshot) {

    // ******* MONDAY ********
    if(user.diet[_dietKey] != null && snapshot.data['caloricGoal'] > 0 && user.diet[_dietKey][3] <= snapshot.data['caloricGoal']) {
      return Container(
        margin: EdgeInsets.only(right: 12),
        child: InkWell(
          child: CircularPercentIndicator(
            animation: true,
            radius: 45.0,
            lineWidth: 5.0,
            percent: snapshot.data['diet'][_dietKey][3] / snapshot.data['caloricGoal'],
            progressColor: GSColors.lightBlue,
            backgroundColor: GSColors.darkCloud,
            circularStrokeCap: CircularStrokeCap.round,
            header:   
              Text(
                "M",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16.0),
            ),
            center: 
              Text(
                (100.0 * snapshot.data['diet'][_dietKey][3] / snapshot.data['caloricGoal']).toStringAsFixed(0) + "%",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12.0),
            )
          ),
          onTap: () {
            // Set state to MONDAY
            if(_currentDay != 1) 
              setState(() => _currentDay = 1);
          },
        ),
      );
    }

    else if(user.diet[_dietKey] != null && snapshot.data['caloricGoal'] > 0 && user.diet[_dietKey][3] > snapshot.data['caloricGoal']) {
      return InkWell(
        child: CircularPercentIndicator(
          radius: 45.0,
          lineWidth: 4.0,  
          percent: 1.0,
          progressColor: Colors.green,
          backgroundColor: GSColors.darkCloud,
          center: Text ( 
            "100%",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12.0),
          ),
          header:   
            Text(
              "M",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16.0),
            ),
        ),
        onTap: () {
          // Set state to MONDAY
          if(_currentDay != 1) 
            setState(() => _currentDay = 1);
          },
      );
    }

    else if(user.diet[_dietKey] != null && snapshot.data['caloricGoal'] == 0) {
      return InkWell(
        child: CircularPercentIndicator(
          radius: 45.0,
          lineWidth: 4.0,  
          percent: 0.0,
          progressColor: GSColors.darkCloud,
          backgroundColor: GSColors.darkCloud,
          center: Text ( 
            "0%",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12.0),
          ),
          header:   
            Text(
              "M",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16.0),
            ),
        ),
        onTap: () {
          // Set state to MONDAY
          if(_currentDay != 1) 
            setState(() => _currentDay = 1);
          },
      );
    }

    else {
      return InkWell(
        child: CircularPercentIndicator(
          radius: 45.0,
          lineWidth: 4.0,  
          percent: 0,
          progressColor: GSColors.darkCloud,
          backgroundColor: GSColors.darkCloud,
          header:   
            Text(
              "M",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16.0),
            ),
        ),
        onTap: () {
          // Set state to MONDAY
          if(_currentDay != 1) 
            setState(() => _currentDay = 1);
        },
      );
    }
  }

  Widget _buildNutritionLabel() {
    return Container(
      child: Row(
        children: <Widget>[ 
          Expanded(
            flex: 2,
            child: Container(
              height: 40,
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  //day.weekday.toString(),
                  // Get day of current nutrition thing
                  DateFormat('EEEE, MMMM dd, y').format(day),
                  style: TextStyle(
                    color: GSColors.darkBlue,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2
                  ),
                ),
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(20),
                      topRight: Radius.circular(20)
                    )
                  )
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(),
          ),
        ],
      ),
    );
  }

  Future<void> _checkDailyMacrosExist() async{
  List<int> newMacros = new List(5);

  DocumentSnapshot macroDoc = await Firestore.instance.collection('users').document(DatabaseHelper.currentUserID).get();//await Firestore.instance.collection('user').document(DatabaseHelper.currentUserID);
  var macroFromDB = macroDoc.data['diet'];
 
  if(macroFromDB[_dietKey] == null)
  {
    newMacros[0] = 0;   //protein
    newMacros[1] = 0;   //carbs
    newMacros[2] = 0;   //fats
    newMacros[3] = 0;   //current calories
    newMacros[4] = 0;   //caloric goal

    macroFromDB[_dietKey] = newMacros;

    Firestore.instance.collection('users').document(DatabaseHelper.currentUserID).updateData(
              {'diet': macroFromDB});
  }
}

  Widget _buildNutritionInfo(BuildContext context) {
  _checkDailyMacrosExist();
    return Container(
      //onTap: () => print("Open nutrition info"),
      child: Container(
        margin: EdgeInsets.only(top: 20),
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Container(
                height: 180,
                child: Container(
                //  child:  CircularPercentIndicator(
                //           radius: 120.0,
                //           lineWidth: 10,
                //           percent: 0.8,
                //           progressColor: Colors.green,
                //           backgroundColor: GSColors.darkCloud,
                //           animateFromLastPercent: true,
                //           animation: true
                //         ),
                  child: StreamBuilder(
                    stream: DatabaseHelper.getUserStreamSnapshot(DatabaseHelper.currentUserID),
                    builder: (context, snapshot){ 
                      if(!snapshot.hasData)
                      {
                        return Container();
                      }
                      User user = User.jsonToUser(snapshot.data.data);
                      
                      //if(user.diet[_dietKey] != null && snapshot.data['diet'][_dietKey][4] > 0)
                      if(user.diet[_dietKey] != null && snapshot.data['caloricGoal'] > 0 && user.diet[_dietKey][3] <= snapshot.data['caloricGoal'])
                      {
                        return CircularPercentIndicator(
                          animation: true,
                          radius: 130.0,
                          lineWidth: 17,
                          percent: snapshot.data['diet'][_dietKey][3] / snapshot.data['caloricGoal'],
                          progressColor: GSColors.lightBlue,
                          backgroundColor: GSColors.darkCloud,
                          circularStrokeCap: CircularStrokeCap.round,
                          footer:   
                            Text(
                              "Daily Caloric Goal",
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18.0),
                            ),
                          center: 
                            Text(
                              (100.0 * snapshot.data['diet'][_dietKey][3] / snapshot.data['caloricGoal']).toStringAsFixed(0) + "%",
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20.0),

                          ),
                        );
                      }
                      
                      else if(user.diet[_dietKey] != null && snapshot.data['caloricGoal'] > 0 && user.diet[_dietKey][3] > snapshot.data['caloricGoal'])
                      {
                        return CircularPercentIndicator(
                          radius: 130.0,
                          lineWidth: 17,  
                          percent: 1.0,
                          progressColor: Colors.green,
                          backgroundColor: GSColors.darkCloud,
                          center: Text ( 
                            "100%",
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20.0),
                          ),
                          footer:   
                            Text(
                              "Daily Caloric Goal",
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18.0),
                            ),
                          
                        );
                      }
                      else if(user.diet[_dietKey] != null && snapshot.data['caloricGoal'] == 0)
                      {
                        return CircularPercentIndicator(
                          radius: 130.0,
                          lineWidth: 17,  
                          percent: 0.0,
                          progressColor: GSColors.darkCloud,
                          backgroundColor: GSColors.darkCloud,
                          center: Text ( 
                            "No Caloric Goal",
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10.0),
                          ),
                          footer:   
                            Text(
                              "Daily Caloric Goal",
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18.0),
                            ),
                        );
                      }

                      else
                      {
                        return CircularPercentIndicator(
                          radius: 130.0,
                          lineWidth: 17,  
                          percent: 0,
                          progressColor: GSColors.darkCloud,
                          backgroundColor: GSColors.darkCloud,
                          footer:   
                            Text(
                              "Daily Caloric Goal",
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18.0),
                            ),
                        );
                      }
    
                    }
                  )

                  // decoration: ShapeDecoration(
                  //   shape: CircleBorder(
                  //     side: BorderSide(
                  //       width: 16,
                  //       color: GSColors.darkBlue
                  //     )
                  //   )
                  // ),
                )
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                // margin: EdgeInsets.only(right: 100),
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin:EdgeInsets.only(top: 10, bottom: 10, right: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("Protein: ",
                                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
                            StreamBuilder(
                              stream: DatabaseHelper.getUserStreamSnapshot(DatabaseHelper.currentUserID),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return Container();
                                }
                                User user = User.jsonToUser(snapshot.data.data);

                                if(user.diet[_dietKey] == null)
                                {
                                  return Text(
                                    '0 g ',
                                      style: TextStyle(color: Colors.lightGreen, fontWeight: FontWeight.w500)
                                  );                        
                                }
                                else
                                {
                                  return Text(
                                    '${user.diet[_dietKey][0].toString()} g ',
                                      style: TextStyle(color: Colors.lightGreen, fontWeight: FontWeight.w500)
                                  );
                                }
                              
                              }
                            )
                          ],
                        )
                      ),
                      Container(
                        margin:EdgeInsets.only(bottom: 10, right: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("Carbs: ",
                                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
                            StreamBuilder(
                              stream: DatabaseHelper.getUserStreamSnapshot(DatabaseHelper.currentUserID),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return Container();
                                }
                                User user = User.jsonToUser(snapshot.data.data);
                               
                               if(user.diet[_dietKey] == null)
                                {
                                  return Text(  
                                    '0 g ',
                                      style: TextStyle(color: Colors.lightGreen, fontWeight: FontWeight.w500)
                                  );                        
                                }
                                else
                                {
                                  return Text(
                                    '${user.diet[_dietKey][1].toString()} g ',
                                      style: TextStyle(color: Colors.lightGreen, fontWeight: FontWeight.w500)
                                  );
                                } 
                              }
                            )
                          ],
                        )
                      ),
                      Container(
                        margin:EdgeInsets.only(bottom: 10, right: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("Fats: ",
                                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
                            StreamBuilder(
                              stream: DatabaseHelper.getUserStreamSnapshot(DatabaseHelper.currentUserID),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return Container();
                                }
                                User user = User.jsonToUser(snapshot.data.data);
                                
                                if(user.diet[_dietKey] == null)
                                {
                                  return Text(
                                    '0 g ',
                                      style: TextStyle(color: Colors.lightGreen, fontWeight: FontWeight.w500)
                                  );                        
                                }
                                else
                                {
                                  return Text(
                                    '${user.diet[_dietKey][2].toString()} g ',
                                      style: TextStyle(color: Colors.lightGreen, fontWeight: FontWeight.w500)
                                  );
                                }
                              
                              }
                            )
                          ],
                        )
                      ),
                      Container(
                        margin:EdgeInsets.only(bottom: 10, right: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("Daily Calories: ",
                                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
                            StreamBuilder(
                              stream: DatabaseHelper.getUserStreamSnapshot(DatabaseHelper.currentUserID),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return Container();
                                }
                                User user = User.jsonToUser(snapshot.data.data);

                                if(user.diet[_dietKey] == null)
                                {
                                  return Text(
                                    '0 ',
                                      style: TextStyle(color: Colors.lightGreen, fontWeight: FontWeight.w500)
                                  );                        
                                }
                                else
                                {
                                  return Text(
                                    '${user.diet[_dietKey][3].toString()} ',
                                      style: TextStyle(color: Colors.lightGreen, fontWeight: FontWeight.w500)
                                  );
                                }
                              
                              }
                            )
                          ],
                        )
                      ),
                      Container(
                        margin:EdgeInsets.only(right: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("Caloric Goal: ",
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
                            StreamBuilder(
                              stream: DatabaseHelper.getUserStreamSnapshot(DatabaseHelper.currentUserID),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return Container();
                                }
                                User user = User.jsonToUser(snapshot.data.data);

                                  if(user.caloricGoal == null)
                                  {
                                    return Text('0 ',
                                      style: TextStyle(color: Colors.lightGreen, fontWeight: FontWeight.w500));
                                  }
                                  else
                                  {
                                    return Text('${user.caloricGoal.toString()}',
                                      style: TextStyle(color: Colors.yellow, fontWeight: FontWeight.w500));
                                  }
                                // if(user.diet[_dietKey] == null)
                                // {
                                //   return Text(
                                //     '0 '
                                //   );                        
                                // }
                                // else
                                // {
                                //   return Text(
                                //     '${user.diet[_dietKey][4].toString()} '
                                //   );
                                //}
                              }
                            )
                          ],
                        )
                      ),
                      // Container(
                      //   margin: EdgeInsets.only(top: 5, left: 55),
                      //   child: MaterialButton(
                      //     child: Icon(
                      //       Icons.add_circle,
                      //       color: Colors.green.withAlpha(220),
                      //       size: 40,
                      //     ),
                      //     onPressed: () {_updateNutritionInfo(context);},
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        )
      ),
    ); 
  }

  void  _updateNutritionInfo(BuildContext context) async{
      int protein, carbs, fats, currentCalories = 0, caloricGoal;
      DocumentSnapshot macroDoc = await Firestore.instance.collection('users').document(DatabaseHelper.currentUserID).get();//await Firestore.instance.collection('user').document(DatabaseHelper.currentUserID);
      var macroFromDB = macroDoc.data['diet'];
      
    showDialog<String>(
      context: context,
      //child: SingleChildScrollView(
        //padding: EdgeInsets.all(5.0),
        child: AlertDialog(
        title: Text("Update your daily macros"),
        contentPadding: const EdgeInsets.all(16.0),
        content:  
          Container(
          //Row(
          height: 200,
          child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
             Flexible(
              child:  TextField(
                keyboardType: TextInputType.number,
                maxLines: 1,
                autofocus: true,
                decoration: InputDecoration(
                  labelText: 'Protein',
                  labelStyle: TextStyle(
                    fontSize: 18.0,
                    color: GSColors.darkBlue,
                  ),
                  contentPadding: EdgeInsets.all(10.0)
                ),
                onChanged: (text) {
                  (text != null) ? protein = int.parse(text): protein = 0;
                  (text != null) ? currentCalories += protein * 4: currentCalories += 0;
                }
              ),
            ),
            
            Flexible(
              child:  TextField(
                keyboardType: TextInputType.number,
                maxLines: 1,
                autofocus: true,
                decoration: InputDecoration(
                  labelText: 'Carbs',
                  labelStyle: TextStyle(
                    fontSize: 18.0,
                    color: GSColors.darkBlue,
                  ),
                  hintStyle: TextStyle(
                    fontSize: 16.0,
                    color: GSColors.darkBlue,
                  ),
                    contentPadding: EdgeInsets.all(10.0)
                ),
                onChanged: (text) { 
                  text != null ? carbs = int.parse(text) : carbs = 0;
                  text != null ? currentCalories += carbs * 4 : currentCalories += 0;
                }
              ),
            ),
    
            Flexible(
              child:  TextField(
                keyboardType: TextInputType.number,
                maxLines: 1,
                autofocus: true,
                decoration: InputDecoration(
                  labelText: 'Fats',
                  labelStyle: TextStyle(
                    fontSize: 18.0,
                    color: GSColors.darkBlue,
                  ),
                  hintStyle: TextStyle(
                    fontSize: 16.0,
                    color: GSColors.darkBlue,
                  ),
                    contentPadding: EdgeInsets.all(10.0)
                ),
                onChanged: (text) {
                    text != null ? fats = int.parse(text) : fats = 0;
                    text != null ? currentCalories += fats * 9 : currentCalories += 0;
                }
              ),
            ),


             Flexible(
              child:  TextField(
                keyboardType: TextInputType.number,
                maxLines: 1,
                autofocus: true,
                decoration: InputDecoration(
                  labelText: 'Caloric Goal',
                  labelStyle: TextStyle(
                    fontSize: 18.0,
                    color: GSColors.darkBlue,
                  ),
                  hintStyle: TextStyle(
                    fontSize: 16.0,
                    color: GSColors.darkBlue,
                  ),
                    contentPadding: EdgeInsets.all(10.0)
                ),
                onChanged: (text) {
                    text != null ? caloricGoal = int.parse(text) : caloricGoal = -1;
                }
              )
             )

          ],
        )),
        actions: <Widget>[
          FlatButton(
            child: const Text('Cancel'),
            onPressed: (){
              currentCalories = 0;
              Navigator.pop(context);
            }
          ),
          FlatButton(
            child: const Text('Save'),
            onPressed: (){

            if(protein == null)
              protein = 0;
            if(carbs == null)
              carbs = 0;
            if(fats == null)
              fats = 0;
            if(currentCalories == null)
              currentCalories = 0;
            if(caloricGoal == null)
              caloricGoal = -1;

            macroFromDB[_dietKey][0] += protein;
            macroFromDB[_dietKey][1] += carbs;
            macroFromDB[_dietKey][2] += fats;
            macroFromDB[_dietKey][3] += currentCalories;
            if(caloricGoal != -1)
              macroFromDB[_dietKey][4] = caloricGoal;

            print("*******************************************************************************");
            print(caloricGoal);
            
            currentCalories = 0;

            Firestore.instance.collection('users').document(DatabaseHelper.currentUserID).updateData(
              {'diet': macroFromDB});
            _buildNutritionInfo(context);

            Navigator.pop(context);
            }
          )
        ],
      )
    );
  }

  Widget _buildWeeklyInfo(BuildContext context) {
    return Container(
      
    );
  }
}