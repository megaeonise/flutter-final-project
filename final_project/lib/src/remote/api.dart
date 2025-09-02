import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:final_project/src/models/task.dart';
import 'package:final_project/src/models/user.dart';

final options = BaseOptions(
  baseUrl: 'https://flutter-final-project-server.fly.dev',
  connectTimeout: Duration(seconds: 10),
  receiveTimeout: Duration(seconds: 10),
);
final dio = Dio(options);
final cookieJar = CookieJar();

void initDio() {
  dio.interceptors.add(CookieManager(cookieJar));
}

Future<bool> postLogin(username, password) async {
  print("im in the file");
  try {
    await dio.post(
      '/auth/login',
      data: {'username': username, 'password': password},
    );
    print(
      await cookieJar.loadForRequest(
        Uri.parse('https://flutter-final-project-server.fly.dev/auth/login'),
      ),
    );
    return true;
  } catch (e) {
    print(e);
    return false;
  }
}

Future<bool> postRegister(email, username, password) async {
  print("im in the file");
  try {
    await dio.post(
      '/auth/register',
      data: {'email': email, 'username': username, 'password': password},
    );
    print(
      await cookieJar.loadForRequest(
        Uri.parse('https://flutter-final-project-server.fly.dev/auth/register'),
      ),
    );
    return true;
  } catch (e) {
    print(e);
    return false;
  }
}

Future<bool> postLogout() async {
  print("logging out");
  try {
    await dio.post('/auth/logout');
    return true;
  } catch (e) {
    print(e);
    return false;
  }
}

Future<List<dynamic>> getFriends() async {
  print("im in the file friends");
  Response response;
  try {
    response = await dio.get('/friend/friends');
    print(response.data);
    final friendList = response.data;
    // print(friendList[0]);
    final friendMap = friendList
        .map((element) => User.fromJson(element))
        .toList();
    if (friendMap.isEmpty) {
      return ["empty"];
    }
    return friendMap;
  } catch (e) {
    print(e);
    return ["empty"];
  }
}

Future<List<dynamic>> getUsers() async {
  print("im in the file friends");
  Response response;
  try {
    response = await dio.get('/friend/users');
    // print(response.data);
    final userList = response.data;
    // print(friendList[0]);
    final userMap = userList.map((element) => User.fromJson(element)).toList();
    if (userMap.isEmpty) {
      return ["empty"];
    }
    return userMap;
  } catch (e) {
    print(e);
    return ["empty"];
  }
}

Future<bool> postAddFriend(id) async {
  print("im in the file");
  try {
    await dio.post('/friend/add', data: {'friendId': id});
    // print(
    //   await cookieJar.loadForRequest(
    //     Uri.parse('https://flutter-final-project-server.fly.dev/auth/register'),
    //   ),
    // );
    return true;
  } catch (e) {
    print(e);
    return false;
  }
}

Future<List<dynamic>> getTasks() async {
  print("im in the file friends");
  Response response;
  try {
    response = await dio.get('/task/tasks');
    // print(response.data);
    final taskList = response.data;
    print(taskList);
    // print(friendList[0]);
    final taskMap = taskList.map((element) => Task.fromJson(element)).toList();
    print(taskMap);
    if (taskMap.isEmpty) {
      return ["empty"];
    }
    return taskMap;
  } catch (e) {
    print(e);
    return ["empty"];
  }
}

Future<bool> postAddTask(title, body, urgent, color, completionTime) async {
  print("im in the file tasks");
  final intTime = int.parse(completionTime);
  print({
    'title': title,
    'body': body,
    'urgent': urgent,
    'color': color,
    'completionTime': intTime,
  });
  try {
    await dio.post(
      '/task/add',
      data: {
        'title': title,
        'body': body,
        'urgent': urgent,
        'color': color,
        'completionTime': intTime,
      },
    );
    print(
      await cookieJar.loadForRequest(
        Uri.parse('https://flutter-final-project-server.fly.dev/auth/register'),
      ),
    );
    return true;
  } catch (e) {
    print(e);
    return false;
  }
}

Future<bool> putPoints(points, id) async {
  try {
    await dio.put('/task/reward', data: {'points': points, 'id': id});
    return true;
  } catch (e) {
    print(e);
    return false;
  }
}
