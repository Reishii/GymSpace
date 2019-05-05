class Post {
  final String documentID;
  final String fromUser;
  final String fromGroup;
  final String mediaURL;
  final String body;

  Map<String, String> comments = Map();
  List<String> likes = List();

  Post({
    this.documentID = '', 
    this.fromUser = '', 
    this.fromGroup = '', 
    this.mediaURL = '', 
    this.body = '',
    this.comments,
    this.likes,
  });

  Map<String, dynamic> toJSON() {
    return  <String, dynamic> {
      'fromUser': fromUser,
      'fromGroup': fromGroup,
      'mediaURL': mediaURL,
      'body': body,
      'comments': comments ?? {},
      'likes': likes ?? {},
    };
  }

  static Post jsonToPost(Map<String, dynamic> data) {
    return Post(
      fromUser: data['fromUser'],
      fromGroup: data['fromGroup'],
      mediaURL: data['mediaURL'],
      body: data['body'],
      comments: data['comments'].cast<Map<String,String>>(),
      likes: data['likes'].cast<String>().toList(),
    );
  }
}