import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: WelcomeScreen(),
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Welcome to Local Event Finder',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
              child: Text('Get Started'),
            ),
          ],
        ),
      ),
    );
  }
}
class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Map<String, String> registeredUsers = {
    'user': 'password123',  // Predefined user for demonstration
  };

  Map<String, List<Map<String, String>>> userSavedEvents = {
    'user': [
      {
        'title': 'Atlanta Music Festival',
        'location': 'Piedmont Park',
        'date': 'July 15, 2024',
        'time': '2:00 PM - 10:00 PM',
        'description': 'Join us for a day of great music, food, and fun at the annual Atlanta Music Festival in Piedmont Park.'
      },
    ]
  };

  bool isRegistering = false;

  void _login() {
    String username = usernameController.text;
    String password = passwordController.text;
    if (registeredUsers.containsKey(username) && registeredUsers[username] == password) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen(username: username, savedEvents: userSavedEvents[username]!)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Incorrect username or password')));
    }
  }

  void _register() {
    String username = usernameController.text;
    String password = passwordController.text;
    if (!registeredUsers.containsKey(username)) {
      registeredUsers[username] = password;
      userSavedEvents[username] = [];
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Registration successful')));
      setState(() {
        isRegistering = false;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Username already exists')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isRegistering ? 'Register' : 'Login/Registration'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: usernameController,
                decoration: InputDecoration(labelText: 'Username/Email'),
              ),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (isRegistering) {
                    _register();
                  } else {
                    _login();
                  }
                },
                child: Text(isRegistering ? 'Register' : 'Login'),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    isRegistering = !isRegistering;
                  });
                },
                child: Text(isRegistering ? 'Back to Login' : 'Register'),
              ),
              if (!isRegistering)
                TextButton(
                  onPressed: () {},
                  child: Text('Forgot Password?'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
class HomeScreen extends StatefulWidget {
  final String username;
  final List<Map<String, String>> savedEvents;

  HomeScreen({required this.username, required this.savedEvents});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<Map<String, String>> savedEvents;

  @override
  void initState() {
    super.initState();
    savedEvents = widget.savedEvents;
  }

  void updateSavedEvents(List<Map<String, String>> newSavedEvents) {
    setState(() {
      savedEvents = newSavedEvents;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FilterScreen()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileScreen(username: widget.username, savedEvents: savedEvents),
                ),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Search',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EventListScreen(onSaveEvent: updateSavedEvents, savedEvents: savedEvents)),
                );
              },
              child: Text('Search'),
            ),
            SizedBox(height: 20),
            Text('Saved Events:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Expanded(
              child: ListView.builder(
                itemCount: savedEvents.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(savedEvents[index]['title']!),
                    subtitle: Text('${savedEvents[index]['location']} • ${savedEvents[index]['date']} • ${savedEvents[index]['time']}'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EventDetailsScreen(event: savedEvents[index], onSaveEvent: updateSavedEvents, savedEvents: savedEvents),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class EventListScreen extends StatelessWidget {
  final List<Map<String, String>> events = [
    {
      'title': 'Atlanta Music Festival',
      'location': 'Piedmont Park',
      'date': 'July 15, 2024',
      'time': '2:00 PM - 10:00 PM',
      'description': 'Join us for a day of great music, food, and fun at the annual Atlanta Music Festival in Piedmont Park.'
    },
    {
      'title': 'Tech Conference 2024',
      'location': 'Georgia World Congress Center',
      'date': 'August 1-3, 2024',
      'time': '9:00 AM - 5:00 PM',
      'description': 'Explore the latest in technology and innovation at the Tech Conference 2024, featuring keynotes, workshops, and exhibitions.'
    },
    {
      'title': 'Atlanta Food & Wine Festival',
      'location': 'Midtown Atlanta',
      'date': 'September 5-8, 2024',
      'time': '12:00 PM - 8:00 PM',
      'description': 'Experience the best of Southern cuisine with tastings, cooking demonstrations, and more at the Atlanta Food & Wine Festival.'
    },
  ];

  final Function(List<Map<String, String>>) onSaveEvent;
  final List<Map<String, String>> savedEvents;

  EventListScreen({required this.onSaveEvent, required this.savedEvents});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Event List'),
      ),
      body: ListView.builder(
        itemCount: events.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(events[index]['title']!),
            subtitle: Text('${events[index]['location']} • ${events[index]['date']} • ${events[index]['time']}'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EventDetailsScreen(event: events[index], onSaveEvent: onSaveEvent, savedEvents: savedEvents),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
class EventDetailsScreen extends StatefulWidget {
  final Map<String, String> event;
  final Function(List<Map<String, String>>) onSaveEvent;
  final List<Map<String, String>> savedEvents;

  EventDetailsScreen({required this.event, required this.onSaveEvent, required this.savedEvents});

  @override
  _EventDetailsScreenState createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  bool isSaved = false;

  @override
  void initState() {
    super.initState();
    isSaved = widget.savedEvents.contains(widget.event);
  }

  void _toggleSaveEvent() {
    setState(() {
      isSaved = !isSaved;
      List<Map<String, String>> updatedSavedEvents = List.from(widget.savedEvents);
      if (isSaved) {
        updatedSavedEvents.add(widget.event);
      } else {
        updatedSavedEvents.remove(widget.event);
      }
      widget.onSaveEvent(updatedSavedEvents);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.event['title']!),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(widget.event['title']!, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            Text('Location: ${widget.event['location']}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Date: ${widget.event['date']}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Time: ${widget.event['time']}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            Text(widget.event['description']!, style: TextStyle(fontSize: 16)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _toggleSaveEvent,
              child: Text(isSaved ? 'Unsave Event' : 'Save Event'),
            ),
          ],
        ),
      ),
    );
  }
}
class FilterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Filter Events'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              decoration: InputDecoration(labelText: 'Event Type'),
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Date Range'),
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Venue'),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    // Apply filter logic
                  },
                  child: Text('Apply'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Reset filter logic
                  },
                  child: Text('Reset'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
class ProfileScreen extends StatelessWidget {
  final String username;
  final List<Map<String, String>> savedEvents;

  ProfileScreen({required this.username, required this.savedEvents});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Username: $username', style: TextStyle(fontSize: 20)),
            SizedBox(height: 20),
            Text('Saved Events:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Expanded(
              child: ListView.builder(
                itemCount: savedEvents.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(savedEvents[index]['title']!),
                    subtitle: Text('${savedEvents[index]['location']} • ${savedEvents[index]['date']} • ${savedEvents[index]['time']}'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EventDetailsScreen(event: savedEvents[index], onSaveEvent: (newSavedEvents) {}, savedEvents: savedEvents),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
