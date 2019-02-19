import 'user.dart';
import 'challenge.dart';
import 'post.dart';

class Profile {
  String _description;
  String _quote;
  String _avatarImage; // changed from UML Image -> String
  double _progress;
  User _forUser;
  List<Challenge> _challenges;
  Map _weightLog = {DateTime: 0};

  Profile(this._forUser, [
    this._description,
    this._quote,
    this._avatarImage,
    this._progress,
    this._challenges,
    this._weightLog
  ]);

  void addPost(Post post) {}
  void addFriend() {}
  String getDescription() => _description;
  double getProgress() => _progress;
  User getUser() => _forUser;
  String getQuote() => _quote;
  String getAvatarImage() => _avatarImage;
  void RemovePost(Post post) {}
  void setAvatarImage(String newImage) {_avatarImage = newImage;}
  void setDescription(String newDescription) {_description = newDescription;}
  set progress(double newProgress) => this.progress = newProgress;  // unsure if this works
}