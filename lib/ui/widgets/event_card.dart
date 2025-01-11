import 'package:flutter/material.dart';

class EventCard extends StatelessWidget {
  final String title;
  final String department;
  final String date;
  final String start_time;
  final String status;
  final String imageUrl;

  const EventCard({
    Key? key,
    required this.title,
    required this.department,
    required this.date,
    required this.start_time,
    required this.status,
    required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (imageUrl.isNotEmpty)
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10.0),
                topRight: Radius.circular(10.0),
              ),
              child: Image.network(
                imageUrl,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Chip(
                      label: Text(
                        status,
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      backgroundColor: status == 'Open'
                          ? Colors.green
                          : status == 'Closing Soon'
                          ? Colors.orange
                          : Colors.red,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  department,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 14,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      date,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Icon(
                      Icons.access_time,
                      size: 14,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      start_time,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10,),
                Center(
                    child:
                    TextButton(
                      onPressed: () {},
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.blueAccent,
                            boxShadow: [
                              new BoxShadow(color: Colors.black12, offset: new Offset(3.0, 3.0),),
                            ],
                            borderRadius: BorderRadius.all(Radius.circular(10))
                        ),

                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 70),
                        child: const Text(
                          'Register',
                          style: TextStyle(color: Colors.white, fontSize: 13.0),
                        ),
                      ),
                    ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
