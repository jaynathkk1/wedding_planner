import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../models/guest.dart';
import '../../services/db_helper.dart';

class GuestListScreen extends StatefulWidget {
  @override
  _GuestListScreenState createState() => _GuestListScreenState();
}

class _GuestListScreenState extends State<GuestListScreen> with TickerProviderStateMixin {
  List<Guest> guests = [];
  String selectedCategory = 'All';
  String selectedRSVPStatus = 'All';

  final List<String> categories = ['All', 'Family', 'Friends', 'Colleagues', 'Others'];
  final List<String> rsvpStatuses = ['All', 'Pending', 'Accepted', 'Declined'];

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  String _selectedCategory = 'friends';

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadGuests();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _loadGuests() async {
    final loaded = await DatabaseHelper.instance.getGuests();
    setState(() {
      guests = loaded;
    });
  }

  List<Guest> get filteredGuests {
    return guests.where((guest) {
      bool categoryMatch = selectedCategory == 'All' ||
          guest.category.toLowerCase() == selectedCategory.toLowerCase();
      bool statusMatch = selectedRSVPStatus == 'All' ||
          guest.rsvpStatus.toLowerCase() == selectedRSVPStatus.toLowerCase();
      return categoryMatch && statusMatch;
    }).toList();
  }

  Map<String, int> get rsvpCounts {
    return {
      'total': guests.length,
      'accepted': guests.where((g) => g.rsvpStatus == 'accepted').length,
      'declined': guests.where((g) => g.rsvpStatus == 'declined').length,
      'pending': guests.where((g) => g.rsvpStatus == 'pending').length,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Guest List',style: TextStyle(color: Color(0xFFE91E63)),),
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'All Guests'),
            Tab(text: 'RSVP Status'),
            Tab(text: 'Analytics'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildGuestList(),
          _buildRSVPStatus(),
          _buildAnalytics(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddGuestDialog,
        icon: Icon(Icons.person_add),
        label: Text('Add Guest'),
        backgroundColor: Colors.pink.shade400,
      ),
    );
  }

  Widget _buildGuestList() {
    return Column(
      children: [
        // Filter Row
        Container(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: selectedCategory,
                  decoration: InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  items: categories.map((String category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (val) {
                    setState(() {
                      selectedCategory = val ?? 'All';
                    });
                  },
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: selectedRSVPStatus,
                  decoration: InputDecoration(
                    labelText: 'RSVP Status',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  items: rsvpStatuses.map((String status) {
                    return DropdownMenuItem<String>(
                      value: status,
                      child: Text(status),
                    );
                  }).toList(),
                  onChanged: (val) {
                    setState(() {
                      selectedRSVPStatus = val ?? 'All';
                    });
                  },
                ),
              ),
            ],
          ),
        ),

        // Guest Count Summary
        Container(
          margin: EdgeInsets.symmetric(horizontal: 16),
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.pink.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.pink.shade200),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildCountItem('Total', filteredGuests.length, Colors.grey.shade700),
              _buildCountItem('Accepted', filteredGuests.where((g) => g.rsvpStatus == 'accepted').length, Colors.green),
              _buildCountItem('Pending', filteredGuests.where((g) => g.rsvpStatus == 'pending').length, Colors.orange),
              _buildCountItem('Declined', filteredGuests.where((g) => g.rsvpStatus == 'declined').length, Colors.red),
            ],
          ),
        ),

        // Guests List
        Expanded(
          child: filteredGuests.isEmpty
              ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.people_outline,
                  size: 64,
                  color: Colors.grey[400],
                ),
                SizedBox(height: 16),
                Text(
                  'No guests found',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Add your first guest to get started',
                  style: TextStyle(
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          )
              : AnimationLimiter(
            child: ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: filteredGuests.length,
              itemBuilder: (context, index) {
                final guest = filteredGuests[index];
                return AnimationConfiguration.staggeredList(
                  position: index,
                  duration: Duration(milliseconds: 375),
                  child: SlideAnimation(
                    verticalOffset: 50.0,
                    child: FadeInAnimation(
                      child: _buildGuestCard(guest),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRSVPStatus() {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        _buildRSVPSection('✅ Accepted', guests.where((g) => g.rsvpStatus == 'accepted').toList(), Colors.green),
        SizedBox(height: 16),
        _buildRSVPSection('⏳ Pending', guests.where((g) => g.rsvpStatus == 'pending').toList(), Colors.orange),
        SizedBox(height: 16),
        _buildRSVPSection('❌ Declined', guests.where((g) => g.rsvpStatus == 'declined').toList(), Colors.red),
      ],
    );
  }

  Widget _buildAnalytics() {
    Map<String, int> categoryCount = {};
    for (var guest in guests) {
      categoryCount[guest.category] = (categoryCount[guest.category] ?? 0) + 1;
    }

    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        // Overall Stats Card
        Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                colors: [Colors.pink.shade50, Colors.pink.shade100],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '📊 Guest Analytics',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.pink.shade800,
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: _buildAnalyticsCard(
                        'Total Guests',
                        rsvpCounts['total'].toString(),
                        Icons.people,
                        Colors.blue,
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: _buildAnalyticsCard(
                        'Confirmed',
                        rsvpCounts['accepted'].toString(),
                        Icons.check_circle,
                        Colors.green,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildAnalyticsCard(
                        'Pending',
                        rsvpCounts['pending'].toString(),
                        Icons.schedule,
                        Colors.orange,
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: _buildAnalyticsCard(
                        'Declined',
                        rsvpCounts['declined'].toString(),
                        Icons.cancel,
                        Colors.red,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        SizedBox(height: 20),

        // Response Rate
        Card(
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Response Rate',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                LinearProgressIndicator(
                  value: guests.isEmpty ? 0 : (rsvpCounts['accepted']! + rsvpCounts['declined']!) / rsvpCounts['total']!,
                  backgroundColor: Colors.grey.shade300,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.pink.shade400),
                  minHeight: 8,
                ),
                SizedBox(height: 8),
                Text(
                  guests.isEmpty
                      ? '0% responded'
                      : '${(((rsvpCounts['accepted']! + rsvpCounts['declined']!) / rsvpCounts['total']!) * 100).toInt()}% responded',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ),

        SizedBox(height: 20),

        // Category Breakdown
        if (categoryCount.isNotEmpty) ...[
          Text(
            'Guests by Category',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12),
          ...categoryCount.entries.map((entry) {
            double percentage = entry.value / guests.length;
            return Container(
              margin: EdgeInsets.only(bottom: 8),
              child: Card(
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          entry.key.toUpperCase(),
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ),
                      Text('${entry.value} guests'),
                      SizedBox(width: 12),
                      Text('${(percentage * 100).toInt()}%'),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ],
      ],
    );
  }

  Widget _buildGuestCard(Guest guest) {
    Color statusColor;
    IconData statusIcon;
    switch (guest.rsvpStatus) {
      case 'accepted':
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        break;
      case 'declined':
        statusColor = Colors.red;
        statusIcon = Icons.cancel;
        break;
      default:
        statusColor = Colors.orange;
        statusIcon = Icons.schedule;
    }

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          leading: CircleAvatar(
            backgroundColor: Colors.pink.shade100,
            child: Text(
              guest.name.isNotEmpty ? guest.name[0].toUpperCase() : 'G',
              style: TextStyle(
                color: Colors.pink.shade800,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          title: Text(
            guest.name,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (guest.email != null) Text('📧 ${guest.email}'),
              if (guest.phone != null) Text('📱 ${guest.phone}'),
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      guest.category.toUpperCase(),
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.blue.shade700,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(statusIcon, color: statusColor),
              Text(
                guest.rsvpStatus.toUpperCase(),
                style: TextStyle(
                  fontSize: 10,
                  color: statusColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          onTap: () => _showGuestActions(guest),
        ),
      ),
    );
  }

  Widget _buildRSVPSection(String title, List<Guest> sectionGuests, Color color) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Row(
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                Spacer(),
                Text(
                  '${sectionGuests.length} guests',
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          if (sectionGuests.isEmpty)
            Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'No guests in this category',
                style: TextStyle(color: Colors.grey[600]),
              ),
            )
          else
            ...sectionGuests.map((guest) => ListTile(
              title: Text(guest.name),
              subtitle: Text(guest.category.toUpperCase()),
              trailing: PopupMenuButton<String>(
                onSelected: (status) => _updateRSVP(guest, status),
                itemBuilder: (context) => [
                  PopupMenuItem(value: 'pending', child: Text('⏳ Pending')),
                  PopupMenuItem(value: 'accepted', child: Text('✅ Accepted')),
                  PopupMenuItem(value: 'declined', child: Text('❌ Declined')),
                ],
              ),
            )).toList(),
        ],
      ),
    );
  }

  Widget _buildCountItem(String label, int count, Color color) {
    return Column(
      children: [
        Text(
          count.toString(),
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildAnalyticsCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _showAddGuestDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text('Add New Guest'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Name *',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                    SizedBox(height: 12),
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email (optional)',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                    SizedBox(height: 12),
                    TextField(
                      controller: _phoneController,
                      decoration: InputDecoration(
                        labelText: 'Phone (optional)',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                    SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: _selectedCategory,
                      decoration: InputDecoration(
                        labelText: 'Category',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      items: ['family', 'friends', 'colleagues', 'others'].map((String category) {
                        return DropdownMenuItem<String>(
                          value: category,
                          child: Text(category.toUpperCase()),
                        );
                      }).toList(),
                      onChanged: (val) {
                        setDialogState(() {
                          _selectedCategory = val ?? 'friends';
                        });
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  child: Text('Cancel'),
                  onPressed: () {
                    _clearControllers();
                    Navigator.pop(context);
                  },
                ),
                ElevatedButton(
                  child: Text('Add Guest'),
                  onPressed: _addGuest,
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _addGuest() async {
    String name = _nameController.text.trim();
    if (name.isEmpty) return;

    String? email = _emailController.text.trim().isEmpty ? null : _emailController.text.trim();
    String? phone = _phoneController.text.trim().isEmpty ? null : _phoneController.text.trim();

    Guest newGuest = Guest(
      name: name,
      email: email,
      phone: phone,
      category: _selectedCategory,
    );

    await DatabaseHelper.instance.insertGuest(newGuest);
    _clearControllers();
    _loadGuests();
    Navigator.pop(context);
  }

  void _clearControllers() {
    _nameController.clear();
    _emailController.clear();
    _phoneController.clear();
    _selectedCategory = 'friends';
  }

  void _updateRSVP(Guest guest, String status) async {
    Guest updated = guest.copyWith(rsvpStatus: status);
    await DatabaseHelper.instance.updateGuest(updated);
    _loadGuests();
  }

  void _showGuestActions(Guest guest) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                guest.name,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              ListTile(
                leading: Icon(Icons.schedule, color: Colors.orange),
                title: Text('Mark as Pending'),
                onTap: () {
                  _updateRSVP(guest, 'pending');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.check_circle, color: Colors.green),
                title: Text('Mark as Accepted'),
                onTap: () {
                  _updateRSVP(guest, 'accepted');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.cancel, color: Colors.red),
                title: Text('Mark as Declined'),
                onTap: () {
                  _updateRSVP(guest, 'declined');
                  Navigator.pop(context);
                },
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.delete, color: Colors.red),
                title: Text('Delete Guest'),
                onTap: () async {
                  await DatabaseHelper.instance.deleteGuest(guest.id!);
                  _loadGuests();
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
