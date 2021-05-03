class Account {
  Account({this.id, this.name, this.email});
  String id;
  String name;
  String email;
}

List<String> getFirstNames(List<Account> accounts) {
  List<String> firstNames = [];
  accounts.forEach((element) => firstNames.add(element.name.contains(" ") ? element.name.split(" ")[0] : element.name));
  return firstNames;
}
