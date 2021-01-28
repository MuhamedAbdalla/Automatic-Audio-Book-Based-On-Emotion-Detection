import 'dart:convert';

class User {
  String email;
  // ignore: non_constant_identifier_names
  String first_name;
  // ignore: non_constant_identifier_names
  String last_name;
  String gender;
  String phone;
  String birthday;
  String password;
  // ignore: non_constant_identifier_names
  String profile_image_url;
  User({
    this.email,
    this.first_name, // ignore: non_constant_identifier_names
    this.last_name, // ignore: non_constant_identifier_names
    this.gender,
    this.phone,
    this.birthday,
    this.password,
    this.profile_image_url, // ignore: non_constant_identifier_names
  });

  User copyWith({
    String email,
    String first_name, // ignore: non_constant_identifier_names
    String last_name, // ignore: non_constant_identifier_names
    String gender,
    String phone,
    String birthday,
    String password,
    String profile_image_url, // ignore: non_constant_identifier_names
  }) {
    return User(
      email: email ?? this.email,
      first_name: first_name ?? this.first_name,
      last_name: last_name ?? this.last_name,
      gender: gender ?? this.gender,
      phone: phone ?? this.phone,
      birthday: birthday ?? this.birthday,
      password: password ?? this.password,
      profile_image_url: profile_image_url ?? this.profile_image_url,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'first_name': first_name,
      'last_name': last_name,
      'gender': gender,
      'phone': phone,
      'birthday': birthday,
      'password': password,
      'profile_image_url': profile_image_url,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return User(
      email: map['email'],
      first_name: map['first_name'],
      last_name: map['last_name'],
      //gender: map['gender'],
      //phone: map['phone'],
      //birthday: map['birthday'],
      //password: map['password'],
      profile_image_url: map['profile_image_url'],
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));

  @override
  String toString() {
    return 'User(email: $email, first_name: $first_name, last_name: $last_name, gender: $gender, phone: $phone, birthday: $birthday, password: $password, profile_image_url: $profile_image_url)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is User &&
        o.email == email &&
        o.first_name == first_name &&
        o.last_name == last_name &&
        o.gender == gender &&
        o.phone == phone &&
        o.birthday == birthday &&
        o.password == password &&
        o.profile_image_url == profile_image_url;
  }

  @override
  int get hashCode {
    return email.hashCode ^
        first_name.hashCode ^
        last_name.hashCode ^
        gender.hashCode ^
        phone.hashCode ^
        birthday.hashCode ^
        password.hashCode ^
        profile_image_url.hashCode;
  }
}