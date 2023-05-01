class Globals {
  late String email;
  late String role;
  bool isloggedin;
  late DateTime logintime;

  Globals({
    required this.email,
    required this.role,
    this.isloggedin = false,
    required this.logintime,
  });
}

String apiUrl = "http://127.0.0.1:8000/";
Globals? global;
