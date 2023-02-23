class Profile {
  String uid;
  String email;
  String password;
  String comfirmpassword;
  String roleUser;
  String fname;
  String lname;
  String skill;
  String gender;
  String call;

  Profile(this.email, this.password, this.roleUser, this.comfirmpassword,
      this.uid, this.call, this.fname, this.lname, this.gender, this.skill);
}
