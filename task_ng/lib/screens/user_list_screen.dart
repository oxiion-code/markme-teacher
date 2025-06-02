import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_ng/blocs/theme/theme_bloc.dart';
import 'package:task_ng/blocs/user_list/user_list_event.dart';
import 'package:task_ng/blocs/user_list/user_list_state.dart';
import 'package:task_ng/screens/local_post_screen.dart';
import 'package:task_ng/screens/user_detail_screen.dart';
import 'package:task_ng/theme/app_colors.dart';
import 'package:task_ng/widgets/loading_animation.dart';
import 'package:task_ng/widgets/user_tile.dart';

import '../blocs/theme/theme_event.dart';
import '../blocs/user_list/user_list_bloc.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});
  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  void _setUpScrollController(BuildContext context) {
    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent > 0 &&
          _scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200) {
        context.read<UserListBloc>().add(LoadMoreUsers());
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _setUpScrollController(context);

    _searchController.addListener(() {
      final query = _searchController.text.trim();
      context.read<UserListBloc>().add(SearchUsers(query));
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeBloc = context.watch<ThemeBloc>();
    final isDarkMode = themeBloc.state.isDarkMode;
    final switchActiveColor = isDarkMode
        ? AppColors.darkBackground
        : AppColors.lightBackground;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const LocalPostScreen()),
          );
        },
        child: const Icon(Icons.post_add),
      ),
      appBar: AppBar(
        title: const Text("User List"),
        actions: [
          Row(
            children: [
              Icon(isDarkMode ? Icons.dark_mode : Icons.light_mode),
              Padding(
                padding: EdgeInsets.all(8),
                child: Switch(
                  value: isDarkMode,
                  onChanged: (value) {
                    context.read<ThemeBloc>().add(ToggleTheme());
                  },
                  activeColor: switchActiveColor,
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search users...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder<UserListBloc, UserListState>(
              builder: (context, state) {
                if (state is UserListLoading) {
                  return const LoadingScreen();
                } else if (state is UserListLoadSuccess) {
                  return RefreshIndicator(
                    onRefresh: () async{
                      context.read<UserListBloc>().add(RefreshUsers());
                    },
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount: state.hasMore
                          ? state.users.length + 1
                          : state.users.length,
                      itemBuilder: (context, index) {
                        if (index < state.users.length) {
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      UserDetailScreen(user: state.users[index]),
                                ),
                              );
                            },
                            child: UserTile(user: state.users[index]),
                          );
                        } else {
                          return const Padding(
                            padding: EdgeInsets.all(16),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }
                      },
                    ),
                  );
                } else if (state is UserListError) {
                  return Center(child: Text(state.message));
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}
