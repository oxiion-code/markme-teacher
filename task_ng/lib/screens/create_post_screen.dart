import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/local_post.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();

  void _savePost() async {
    final title = _titleController.text.trim();
    final body = _bodyController.text.trim();

    if (title.isNotEmpty && body.isNotEmpty) {
      final post = LocalPost(title: title, body: body);
      final box = Hive.box<LocalPost>('localPosts');
      await box.add(post);

      Navigator.pop(context); // go back to LocalPostScreen
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Both fields are required')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create Post")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _bodyController,
              maxLines: 5,
              decoration: const InputDecoration(labelText: 'Body'),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _savePost,
              child: const Text("Create"),
            )
          ],
        ),
      ),
    );
  }
}
