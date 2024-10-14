import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/export_bloc.dart';
import '../repositories/join_request_repository.dart';

class JoinRequestsPage extends StatelessWidget {
  final JoinRequestRepository joinRequestRepository;

  const JoinRequestsPage({Key? key, required this.joinRequestRepository})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          JoinRequestBloc(joinRequestRepository)..add(FetchJoinRequests()),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Join Requests'),
        ),
        body: BlocBuilder<JoinRequestBloc, JoinRequestState>(
          builder: (context, state) {
            if (state is JoinRequestLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is JoinRequestLoaded) {
              if (state.joinRequests.isEmpty) {
                return Center(child: Text('No join requests found.'));
              }
              return ListView.builder(
                itemCount: state.joinRequests.length,
                itemBuilder: (context, index) {
                  final joinRequest = state.joinRequests[index];
                  return ListTile(
                    title: Text('Request ID: ${joinRequest.id}'),
                    subtitle: Text('Status: ${joinRequest.status}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.check, color: Colors.green),
                          onPressed: () {
                            context.read<JoinRequestBloc>().add(
                                  ApproveJoinRequest(
                                      joinRequest.itemId, joinRequest.id),
                                );
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.clear, color: Colors.red),
                          onPressed: () {
                            context.read<JoinRequestBloc>().add(
                                  RejectJoinRequest(
                                      joinRequest.itemId, joinRequest.id),
                                );
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            } else if (state is JoinRequestError) {
              return Center(child: Text('Error: ${state.error}'));
            } else {
              return Center(child: Text('Something went wrong!'));
            }
          },
        ),
      ),
    );
  }
}
