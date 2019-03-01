class Exercise {
  String _name;
  String _bodyPart;
  String _description;
  int sets;
  int reps;
  double weight;
  
  Exercise([this._name, this._bodyPart, this._description]);

  String getName() => _name;
  String getBodyPart() => _bodyPart;
  String getDescription() => _description;
  void setName(String name) => _name = name;
  void setBodyPart(String bodyPart) => _bodyPart = bodyPart;
  void setDescription(String description) => _description = description;
}