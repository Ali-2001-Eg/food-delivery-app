class SignUpModel {
  String name;
  String password;
  String phone;
  String email;

  SignUpModel(
      {required this.name,
      required this.password,
      required this.phone,
      required this.email});

  Map<String,dynamic> toJson (){
    final Map<String,dynamic> data = {};
    //data is retrieved here from constructor

    data['f_name']=this.name;
    data['phone']=this.phone;
    data['password']=this.password;
    data['email']=this.email;

    return data;

  }
}
