import 'package:flutter/material.dart';
import 'package:wedding_planner/screens/venue_screen.dart';
import 'pages/budget_cal_page.dart';
import 'pages/check_list_page.dart';
import 'pages/guest_list_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = <Widget>[
    ChecklistScreen(),
    VenueScreen(),
    BudgetCalculatorScreen(),
    GuestListScreen(),
  ];

  final List<BottomNavigationBarItem> _bottomNavItems = [
    BottomNavigationBarItem(
      icon: Icon(Icons.checklist_outlined),
      activeIcon: Icon(Icons.checklist),
      label: 'Checklist',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.location_city_outlined),
      activeIcon: Icon(Icons.location_city),
      label: 'Venues',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.calculate_outlined),
      activeIcon: Icon(Icons.calculate),
      label: 'Budget',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.people_outline),
      activeIcon: Icon(Icons.people),
      label: 'Guests',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor:   Color(0xffffd2df),
          selectedItemColor: Theme.of(context).primaryColor,
          unselectedItemColor: Colors.grey[600],
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          items: _bottomNavItems,
        ),
      ),
    );
  }
}
