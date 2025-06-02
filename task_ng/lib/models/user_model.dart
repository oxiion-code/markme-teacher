class User {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String image;
  final String phone;
  final String university;
  final String gender;
  final int age;
  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.image,
    required this.phone,
    required this.university,
    required this.gender,
    required this.age
  });
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      image: json['image'],
      phone: json['phone'],
      university: json['university'],
      gender: json['gender'],
      age: json['age']
    );
  }
}
