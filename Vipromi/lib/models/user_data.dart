class UserData {
  UserData({required this.email, required this.phoneNumber, required this.name, required this.age});

  final String email;
  final String name;
  final String phoneNumber;
  final int age;

  Map<String,dynamic> toMap(){
     return{
        'email':email,
        'name':name,
        'phoneNumber':phoneNumber,
        'age':age
     };
  }
  factory UserData.fromMap(Map <String,dynamic> map){
     return UserData(
        name: map['name']??'',
        email: map['email']??'',
        age: map['age']??0,
        phoneNumber: map['phoneNumber']??''
     );
  }
}
