import 'user.dart';
import 'challenge.dart';
import 'post.dart';

class Profile {
  String _description;
  String _quote;
  String _avatarImage; // changed from UML Image -> String
  double _progress;
  final User _forUser;
  List<Challenge> _challenges;
  List<Post> _posts; // new from UML
  Map _weightLog = {DateTime: 0};

  Profile(this._forUser, 
    [
      this._description,
      this._quote,
      this._avatarImage,
      this._progress,
      this._challenges,
      this._weightLog
    ]
  );

  void addPost(Post post) => _posts.add(post);
  void addFriend() {}
  void block() {}
  void calculateDietInfo() {}
  void displayGraph() {}
  String getDescription() => _description;
  double getProgress() => _progress;
  List<Challenge> getChallenges() => _challenges;
  User getUser() => _forUser;
  String getQuote() => _quote;
  String getAvatarImage() => _avatarImage;
  Map getWeightLog() => _weightLog;
  void removePost(Post post) => _posts.remove(post); // might need to have this actually return a bool to check
  void setAvatarImage(String image) => _avatarImage = image;
  void setDescription(String description) => _description = description;
  void setQuote(String quote) => _quote = quote;
  void updateProgress(double progress) => _progress = progress;  // unsure if this works
}