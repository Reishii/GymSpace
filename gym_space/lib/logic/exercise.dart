class Exercise {
  String name;
  String bodyPart;
  String description;
  int sets;
  int reps;
  double weight;
  
  Exercise({String name = "", String bodyPart = "", String description = "", int sets = 0, int reps = 0, double weight = 0}) {
    this.name = name;
    this.bodyPart = bodyPart;
    this.description = description;
    this.sets = sets;
    this.reps = reps;
    this.weight = weight;
  }

  
}