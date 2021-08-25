class AppConstants {
  static const String Splash = '/splash';
  static const String Index = '/';
  static const String Home = '/home';
  static const String AddTask = '/addTask';
}

class AppSizeConstants {
  static const int BaseScreenWidth = 375;
}

class TodoTaskType {
  static const NEED_TOS = 'Need Tos';
  static const WANT_TOS = 'Want Tos';
  static const MIGHT_TOS = 'Might Tos';
}

Map<String, String> ptTodoType = {
  "all": "Tudo",
  "Need Tos": "Preciso Fazer",
  "Want Tos": "Quero Fazer",
  "Might Tos": "Posso Fazer",
};
