class SignupModel {
  bool? success;
  String? message;
  Token? token;

  SignupModel({this.success, this.message, this.token});

  SignupModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    token = json['token'] != null ? new Token.fromJson(json['token']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.token != null) {
      data['token'] = this.token!.toJson();
    }
    return data;
  }
}

class Token {
  Headers? headers;
  Original? original;
  Null? exception;

  Token({this.headers, this.original, this.exception});

  Token.fromJson(Map<String, dynamic> json) {
    headers = json['headers'] != null ? new Headers.fromJson(json['headers']) : null;
    original = json['original'] != null ? new Original.fromJson(json['original']) : null;
    exception = json['exception'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.headers != null) {
      data['headers'] = this.headers!.toJson();
    }
    if (this.original != null) {
      data['original'] = this.original!.toJson();
    }
    data['exception'] = this.exception;
    return data;
  }
}

class Headers {


  // Headers({});

Headers.fromJson(Map<String, dynamic> json) {
}

Map<String, dynamic> toJson() {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  return data;
}
}

class Original {
  String? accessToken;
  String? tokenType;
  int? expiresIn;
  User? user;

  Original({this.accessToken, this.tokenType, this.expiresIn, this.user});

  Original.fromJson(Map<String, dynamic> json) {
    accessToken = json['access_token'];
    tokenType = json['token_type'];
    expiresIn = json['expires_in'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['access_token'] = this.accessToken;
    data['token_type'] = this.tokenType;
    data['expires_in'] = this.expiresIn;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}

class User {
  int? id;
  String? name;
  String? email;
  String? phone;
  Null? deviceToken;
  Null? emailVerifiedAt;
  int? active;
  Null? lattitude;
  Null? longitude;
  String? createdAt;
  String? updatedAt;

  User({this.id, this.name, this.email, this.phone, this.deviceToken, this.emailVerifiedAt, this.active, this.lattitude, this.longitude, this.createdAt, this.updatedAt});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    deviceToken = json['device_token'];
    emailVerifiedAt = json['email_verified_at'];
    active = json['active'];
    lattitude = json['lattitude'];
    longitude = json['longitude'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['device_token'] = this.deviceToken;
    data['email_verified_at'] = this.emailVerifiedAt;
    data['active'] = this.active;
    data['lattitude'] = this.lattitude;
    data['longitude'] = this.longitude;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

