import 'package:flutter/material.dart';
import '../models/models.dart';
import '../models/todo_item.dart';

class TripDetailPage extends StatefulWidget {
  final Trip trip;
  TripDetailPage({required this.trip});

  @override
  _TripDetailPageState createState() => _TripDetailPageState();
}

class _TripDetailPageState extends State<TripDetailPage> {
  final TextEditingController todoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F0),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.trip.tripName ?? 'Trip Detail',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 32, 86, 137),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              widget.trip.imageUrl != null && widget.trip.imageUrl!.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(
                        widget.trip.imageUrl!,
                        height: 300,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        height: 270,
                        width: double.infinity,
                        color: Colors.grey[300],
                        child: const Center(
                          child: Text('No Image Available'),
                        ),
                      ),
                    ),
              const SizedBox(height: 20),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 6,
                margin: const EdgeInsets.symmetric(vertical: 15),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.description, color: Colors.blueGrey),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Description: ${widget.trip.description ?? 'No Description'}',
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Icon(Icons.calendar_today,
                              color: Colors.blueGrey),
                          const SizedBox(width: 10),
                          Text(
                            'Start Date: ${widget.trip.starttime?.toIso8601String().split('T').first ?? 'No Start Time'}',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          const Icon(Icons.event, color: Colors.blueGrey),
                          const SizedBox(width: 10),
                          Text(
                            'End Date: ${widget.trip.endtime?.toIso8601String().split('T').first ?? 'No End Time'}',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Icon(Icons.person, color: Colors.blueGrey),
                          const SizedBox(width: 10),
                          Text(
                            'Role: ${widget.trip.role == true ? "Leader" : "Participant"}',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Icon(Icons.access_time, color: Colors.blueGrey),
                          const SizedBox(width: 10),
                          Text(
                            widget.trip.isLate
                                ? 'This trip is late!'
                                : 'This trip is on time!',
                            style: TextStyle(
                              fontSize: 16,
                              color: widget.trip.isLate
                                  ? Colors.red
                                  : Colors.green,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Things to Do',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 32, 86, 137)),
              ),
              const SizedBox(height: 10),
              _buildTodoList(),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: todoController,
                      decoration: InputDecoration(
                        hintText: 'Add a new task...',
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: _addTodoItem,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 32, 86, 137),
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 20),
                    ),
                    child: const Text('Add',
                        style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTodoList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.trip.todoList.length,
      itemBuilder: (context, index) {
        final todoItem = widget.trip.todoList[index];
        return ListTile(
          leading: Checkbox(
            value: todoItem.isCompleted,
            onChanged: (bool? value) {
              setState(() {
                todoItem.isCompleted = value ?? false;
              });
            },
          ),
          title: Text(
            todoItem.task,
            style: TextStyle(
              decoration: todoItem.isCompleted
                  ? TextDecoration.lineThrough
                  : TextDecoration.none,
              color: todoItem.isCompleted ? Colors.grey : Colors.black,
            ),
          ),
        );
      },
    );
  }

  void _addTodoItem() {
    if (todoController.text.isNotEmpty) {
      setState(() {
        widget.trip.todoList
            .add(TodoItem(task: todoController.text, isCompleted: false));
        todoController.clear();
      });
    }
  }
}
