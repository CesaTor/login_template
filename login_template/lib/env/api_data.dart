class LoginJsonData {
  String identifier;
  String password;

  Map<String, dynamic> toJson() =>
      {
        'identifier': identifier,
        'password' : password
      };
}

class SignUpJsonData {
  String username;
  String email;
  String password;

  Map<String, dynamic> toJson() =>
      {
        'username': username,
        'email': email,
        'password' : password
      };
}

class JwtData {
  String jwt;
  JwtUser user;

  JwtData.fromMap(Map data) {
    if(data.containsKey("jwt") && data.containsKey("user")) {
      jwt = data["jwt"] as String;

      var uData = data["user"];
      var rData = uData["role"];

      user = new JwtUser(
        uData["id"] as int,
        uData["username"] as String,
        uData["email"] as String,
        uData["provider"] as String,
        uData["confirmed"] as bool,
        uData["blocked"] as String,
        new JwtUserRole(
          rData["id"] as int,
          rData["name"] as String,
          rData["description"] as String,
          rData["type"] as String,
        ),
        uData["created_at"] as String,
        uData["updated_at"] as String,
        uData["groups"] as List<dynamic>, // TODO CHECK
      );
    }
  }

}

class JwtUser {
  int id;
  String username;
  String email;
  String provider;
  bool confirmed;
  var blocked;
  JwtUserRole role;
  String created_at;
  String updated_at;
  List<dynamic> groups;

  JwtUser(this.id, this.username, this.email, this.provider,
      this.confirmed, this.blocked, this.role, this.created_at, this.updated_at,
      this.groups);

}

class JwtUserRole {
  int id;
  String name;
  String description;
  String type;

  JwtUserRole(this.id, this.name, this.description, this.type);

}

class StrapiError {
  int statusCode;
  String error;
  List<StrapiErrorMessage> message;
  List<StrapiErrorMessage> data;

  StrapiError.fromMap(Map dt) {
    if(dt.containsKey("message") && dt.containsKey("data")) {

      statusCode = dt["statusCode"] as int;
      error = dt["error"] as String;

      // TODO - convert to class
//      message = new List<StrapiErrorMessage>();
//      for(message in dt["message"]){
//
//      }
//      data = dt["data"];

    }
  }

}

class StrapiErrorMessage {
  List<StrapiMessage> messages;
}

class StrapiMessage {
  String id;
  String message;
}
