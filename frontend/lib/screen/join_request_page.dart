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
          automaticallyImplyLeading: false,
          title: const Text(
            'Join Requests',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          backgroundColor: const Color.fromARGB(255, 32, 86, 137),
          centerTitle: true,
          elevation: 0,
        ),
        backgroundColor: const Color(0xFFF6F7F0),
        body: BlocBuilder<JoinRequestBloc, JoinRequestState>(
          builder: (context, state) {
            if (state is JoinRequestLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is JoinRequestLoaded) {
              if (state.joinRequests.isEmpty) {
                return const Center(child: Text('No join requests found.'));
              }
              return ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: state.joinRequests.length,
                itemBuilder: (context, index) {
                  final joinRequest = state.joinRequests[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 4,
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16.0),
                      title: Text(
                        'Request ID: ${joinRequest.id}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 32, 86, 137),
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          'Status: ${joinRequest.status}',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.check, color: Colors.green),
                            onPressed: () {
                              context.read<JoinRequestBloc>().add(
                                    ApproveJoinRequest(
                                        joinRequest.itemId, joinRequest.id),
                                  );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.clear, color: Colors.red),
                            onPressed: () {
                              context.read<JoinRequestBloc>().add(
                                    RejectJoinRequest(
                                        joinRequest.itemId, joinRequest.id),
                                  );
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            } else if (state is JoinRequestError) {
              return Center(child: Text('Error: ${state.error}'));
            } else {
              return const Center(child: Text('Something went wrong!'));
            }
          },
        ),
      ),
    );
  }
}
