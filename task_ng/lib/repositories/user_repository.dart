import 'package:task_ng/models/todo_model.dart';

import '../models/post_model.dart';
import '../models/user_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserRepository {
  Future<List<User>> fetchUsers({int limit = 10, int skip = 0}) async {
    final response = await http.get(
      Uri.parse('https://dummyjson.com/users?limit=$limit&skip=$skip'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final users = (data['users'] as List)
          .map((userJson) => User.fromJson(userJson))
          .toList();
      return users;
    } else {
      throw Exception('Failed to load users');
    }
  }

  Future<List<User>> searchUsersByUsername(String username) async{
    final response= await http.get(Uri.parse("https://dummyjson.com/users/search?q=$username"));
    if(response.statusCode==200){
      final data=jsonDecode(response.body);
      return(data['users'] as List).map((e)=>User.fromJson(e)).toList();
    }else{
      throw Exception('No username found');
    }
  }

  Future<List<Post>> fetchPostsByUser(int userId) async{
    final response =await http.get(Uri.parse("https://dummyjson.com/posts/user/$userId"));
    if(response.statusCode==200){
      final jsonData=jsonDecode(response.body);
      return(jsonData['posts'] as List).map((e)=>Post.fromJson(e)).toList();
    }else{
      throw(Exception("No post found"));
    }
  }
  Future<List<Todo>> fetchTodosByUser(int userId) async{
    final response =await http.get(Uri.parse("https://duusermmyjson.com/todos/user/$userId"));
    if(response.statusCode==200){
      final jsonData=jsonDecode(response.body);
      return(jsonData['todos'] as List).map((e)=>Todo.fromJson(e)).toList();
    }else{
      throw(Exception("No post found"));
    }
  }
}
