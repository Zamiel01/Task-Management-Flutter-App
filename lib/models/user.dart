class User {
  final String email;
  final String password;

  User({
    required this.email,
    required this.password,
  });
//used to read the data from the db by converting the map to an object
  User.fromMap(Map<dynamic, dynamic> res)
  : email = res['email'],
  password = res['password'];

  //used to save back into the db by converting back the objet created into a map before saving

  Map<String, Object?> toMap(){
    return {
      'email' : email,
      'password' : password,
    };
  }
}