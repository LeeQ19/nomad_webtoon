import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.grey[900],
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    CircleAvatar(
                      backgroundImage: NetworkImage('https://avatars.githubusercontent.com/u/37331313'),
                      radius: 30,
                    ),
                    Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 40,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Calendar(),
              const SizedBox(height: 20),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: const [
                      Card(
                        title: "Design meeting",
                        startHour: 11,
                        startMinute: 30,
                        endHour: 12,
                        endMinute: 20,
                        people: ["Alex", "Helena", "Nana"],
                        color: Colors.lime,
                      ),
                      Card(
                        title: "Daily project",
                        startHour: 12,
                        startMinute: 35,
                        endHour: 14,
                        endMinute: 00,
                        people: ["Me", "Richard", "Ciry", "+4"],
                        color: Colors.pink,
                      ),
                      Card(
                        title: "Weekly planning",
                        startHour: 15,
                        startMinute: 00,
                        endHour: 16,
                        endMinute: 30,
                        people: ["Den", "Nana", "Mark"],
                        color: Colors.purple,
                      ),
                      Card(
                        title: "Market strategy",
                        startHour: 16,
                        startMinute: 45,
                        endHour: 17,
                        endMinute: 20,
                        people: ["Me", "Helena", "Ciry"],
                        color: Colors.cyan,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Calendar extends StatelessWidget {
  const Calendar({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final lastDate = DateTime(now.year, now.month + 1, 0).day;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            DateFormat('EEEE dd').format(now).toUpperCase(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
        const SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    "TODAY",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 42,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Icon(
                  Icons.circle,
                  color: Colors.grey[700],
                  size: 10,
                ),
                for (int i = now.day + 1; i <= lastDate; i++)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      i.toString(),
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 42,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class Card extends StatelessWidget {
  final String title;
  final int startHour, startMinute, endHour, endMinute;
  final List<String> people;
  final Color? color;

  const Card({
    super.key,
    required this.title,
    required this.startHour,
    required this.startMinute,
    required this.endHour,
    required this.endMinute,
    required this.people,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final timeFormatter = NumberFormat('00');

    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(40),
      ),
      padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Text(
                timeFormatter.format(startHour),
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                timeFormatter.format(startMinute),
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
              const SizedBox(
                height: 30,
                child: VerticalDivider(
                  color: Colors.black,
                  thickness: 2,
                ),
              ),
              Text(
                timeFormatter.format(endHour),
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                timeFormatter.format(endMinute),
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title.replaceAll(" ", "\n").toUpperCase(),
                style: const TextStyle(
                  fontSize: 64,
                  fontWeight: FontWeight.w500,
                  height: .9,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  for (final person in people)
                    Container(
                      margin: const EdgeInsets.only(right: 20),
                      child: Text(
                        person.toUpperCase(),
                        style: TextStyle(
                          fontSize: 16,
                          color: person == "Me" ? Colors.black : Colors.black.withOpacity(0.3),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
