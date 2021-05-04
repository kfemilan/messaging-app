class Account {
  Account({this.id, this.name, this.email, this.profilePic});
  String id;
  String name;
  String email;
  String profilePic;
}

List<String> getFirstNames(List<Account> accounts) {
  List<String> firstNames = [];
  accounts.forEach((element) => firstNames.add(element.name.contains(" ") ? element.name.split(" ")[0] : element.name));
  return firstNames;
}

String defaultGCName(List<Account> accounts) {
  List<String> firstNames = getFirstNames(accounts);

  String gcName = "";
  for (var i = 0; i < firstNames.length; i++) {
    if (i == firstNames.length - 1) {
      gcName = gcName + firstNames[i];
    } else {
      gcName = gcName + firstNames[i] + ", ";
    }
  }

  return gcName;
}
