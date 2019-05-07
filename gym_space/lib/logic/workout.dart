class Workout {
  String name;
  String author;
  String muscleGroup;
  String description;
  String documentID;
  Map exercises = Map();
  
  Workout({
    this.name = "",
    this.author = "",
    this.muscleGroup = "",
    this.description = "",
    this.documentID = "",
    this.exercises,
  });

  Map<String, dynamic> toJSON() {
    return <String, dynamic> {
      'name': name,
      'author': author,
      'muscleGroup': muscleGroup,
      'description': description,
      'exercises' : exercises == null ? Map() : exercises
    };
  }

  static Workout jsonToWorkout(Map<String, dynamic> data) {    
    return Workout(
      name: data['name'],
      author: data['author'],
      muscleGroup: data['muscleGroup'],
      description: data['description'],
      documentID: data['documentID'],
      exercises: data['exercises'],
    );
  }
} 