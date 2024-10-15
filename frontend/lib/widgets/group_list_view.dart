import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/repositories/people_repository.dart';
import 'package:frontend/screen/people_to_group.dart';
import 'package:frontend/widgets/add_new_people_to_group.dart';
import 'package:frontend/screen/message_page.dart';

import '../bloc/export_bloc.dart';
import '../models/groups.dart';

class GroupListView extends StatefulWidget {
  final String searchQuery;
  final String token;

  GroupListView({required this.searchQuery, required this.token});

  @override
  _GroupListViewState createState() => _GroupListViewState();
}

class _GroupListViewState extends State<GroupListView> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    context.read<GroupBloc>().add(FetchGroupEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GroupBloc, GroupState>(
      builder: (context, state) {
        print("Current State: $state");
        if (state is GroupStateLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is GroupStateLoaded) {
          return _buildGroupList(state.groups.cast<Group>());
        } else if (state is GroupError) {
          return Center(child: Text('Error: ${state.message}'));
        } else {
          return const Center(child: Text('No groups available'));
        }
      },
    );
  }

  Widget _buildGroupList(List<Group> groups) {
    final filteredGroups = groups
        .where((group) =>
            group.name != null &&
            group.name!
                .toLowerCase()
                .contains(widget.searchQuery.toLowerCase()))
        .toList();

    if (filteredGroups.isEmpty) {
      return const Center(child: Text('No results found for your search'));
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '${filteredGroups.length} Results matched your search',
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: filteredGroups.length,
            itemBuilder: (context, index) {
              return _buildGroupCard(filteredGroups[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildGroupCard(Group group) {
    final String imageUrl = convertGiphyUrl(group.imageUrl);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        elevation: 4,
        child: ListTile(
          contentPadding: const EdgeInsets.all(16.0),
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: imageUrl.isNotEmpty
                ? Image.network(
                    imageUrl,
                    width: 50,
                    height: 100,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.broken_image, size: 60);
                    },
                  )
                : const Icon(Icons.broken_image, size: 60),
          ),
          title: Text(group.name ?? 'Unnamed Group'),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text('Start date: ${group.startDate ?? 'N/A'}'),
              Text('End date: ${group.endDate ?? 'N/A'}'),
            ],
          ),
          onTap: () {
            _onGroupTap(group.id);
          },
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  _showAddPeopleDialog(group.id);
                },
              ),
              IconButton(
                icon: const Icon(Icons.message),
                onPressed: () {
                  _onMessageButtonTap(group.id);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onGroupTap(int groupId) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GroupPeoplePage(),
        settings: RouteSettings(
          arguments: groupId,
        ),
      ),
    );

    if (mounted) {
      context.read<GroupBloc>().add(FetchGroupEvent());
    }
  }

  void _showAddPeopleDialog(int groupId) {
    showDialog(
      context: context,
      builder: (context) => AddPeopleDialog(
        groupId: groupId,
        peopleRepository: PeopleRepository(),
      ),
    );
  }

  void _onMessageButtonTap(int groupId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            MessagePage(groupId: groupId, token: widget.token),
      ),
    );
  }
}

String convertGiphyUrl(String? url) {
  if (url == null ||
      !(url.contains('giphy.com/stickers/') ||
          url.contains('giphy.com/media/'))) {
    return '';
  }

  final uri = Uri.parse(url);
  final segments = uri.pathSegments;

  if (segments.length < 2) {
    return '';
  }

  final gifId = segments.last.split('-').last;
  return 'https://media.giphy.com/media/$gifId/giphy.gif';
}
