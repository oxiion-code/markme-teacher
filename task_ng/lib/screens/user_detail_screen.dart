import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_ng/blocs/user_detail/user_detail_event.dart';
import 'package:task_ng/blocs/user_detail/user_detail_state.dart';
import 'package:task_ng/widgets/post_tile.dart';
import 'package:task_ng/widgets/todo_tile.dart';

import '../blocs/user_detail/user_detail_bloc.dart';
import '../models/user_model.dart';

class UserDetailScreen extends StatefulWidget{
  final User user;

  const UserDetailScreen({super.key, required this.user});

  @override
  State<UserDetailScreen> createState() {
   return   _UserDetailScreenState();
}
  }
class _UserDetailScreenState extends State<UserDetailScreen>{
  String selectedSection ="info";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(
      title: Text("${widget.user.firstName} ${widget.user.lastName}"),
    ),
    body: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _sectionButton("User Info", "info", () {
                  setState(() {
                    selectedSection = "info";
                  });
                }),
                SizedBox(width: 12,),
                _sectionButton("Posts", "posts", () {
                  context.read<UserDetailBloc>().add(LoadUserPosts(widget.user.id));
                  setState(() {
                    selectedSection = "posts";
                  });
                }),
                SizedBox(width: 12,),
                _sectionButton("Todos", "todos", () {
                  context.read<UserDetailBloc>().add(LoadUserTodos(widget.user.id));
                  setState(() {
                    selectedSection = "todos";
                  });
                }),
              ],
            ),
          ],
        ),
        Expanded(child: Builder(builder: (_){
          if(selectedSection=='info'){
            return _buildUserInfo();
          }else if(selectedSection=='posts'){
            return BlocBuilder<UserDetailBloc,UserDetailState>(builder: (context,state){
              if(state is UserPostsLoading){
                return const Center(child: CircularProgressIndicator(),);
              }else if(state is UserPostsLoaded){
                if(state.posts.isEmpty){
                  return Center(child: Text("No Posts"),);
                }
                return ListView.builder(
                  itemCount: state.posts.length,
                   itemBuilder: (_,i){
                     final post=state.posts[i];
                     return PostTile(post: post);
                   });
              }else if(state is UserDetailError){
                return Center(child: Text(state.message),);
              }
              return SizedBox.shrink();
            }
            );
        } else if (selectedSection == 'todos') {
            return BlocBuilder<UserDetailBloc, UserDetailState>(
              builder: (context, state) {
                if (state is UserTodosLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is UserTodosLoaded) {
                  if(state.todos.isEmpty){
                    return Center(child: Text("No Todos"),);
                  }
                  return ListView.builder(
                    itemCount: state.todos.length,
                    itemBuilder: (_, i) {
                      final todo = state.todos[i];
                      return TodoTile(todo: todo,);
                    },
                  );
                } else if (state is UserDetailError) {
                  return Center(child: Text(state.message));
                }
                return const SizedBox.shrink();
              },
            );
          }
          return const SizedBox.shrink();
        },
        ),
        )
      ],
    ),
    );
  }
  Widget _sectionButton(String text, String sectionKey, VoidCallback onPressed) {
    final isSelected = selectedSection == sectionKey;

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        elevation: isSelected ? 2 : 0,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      ),
      child: Text(text),
    );
  }

  Widget _buildUserInfo() {
    final user = widget.user;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Image
              CircleAvatar(
                radius: 40,
                backgroundImage: NetworkImage(user.image),
                backgroundColor: Colors.grey[200],
              ),
              const SizedBox(width: 16),

              // User Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${user.firstName} ${user.lastName}",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildInfoRow("Email", user.email),
                    _buildInfoRow("Phone", user.phone),
                    _buildInfoRow("Age", user.age.toString()),
                    _buildInfoRow("Gender", user.gender),
                    _buildInfoRow("University", user.university),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

// Helper widget to display a label and value row
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$label: ",
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          Expanded(
            child: Text(
              value,
            ),
          ),
        ],
      ),
    );
  }

}

