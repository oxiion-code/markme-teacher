import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/local_post.dart';
import 'create_post_screen.dart';

class LocalPostScreen extends StatelessWidget {
  const LocalPostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final postBox = Hive.box<LocalPost>('localPosts');

    return Scaffold(
      appBar: AppBar(
        title: const Text("Local Posts"),
        actions: [
          IconButton(
            icon: const Icon(Icons.post_add_sharp),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CreatePostScreen()),
              );
            },
          ),
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: postBox.listenable(),
        builder: (context, Box<LocalPost> box, _) {
          if (box.isEmpty) {
            return const Center(child: Text("No local posts yet."));
          }

          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) {
              final post = box.getAt(index);
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: ListTile(
                  title: Text(post?.title ?? ""),
                  subtitle: Text(post?.body ?? ""),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      _showDeleteConfirmation(context, box, index);
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showDeleteConfirmation(
      BuildContext context, Box<LocalPost> box, int index) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Delete Post"),
        content: const Text("Are you sure you want to delete this post?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              box.deleteAt(index);
              Navigator.pop(context);
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
