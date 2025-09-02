import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../models/task.dart';
import '../../services/db_helper.dart';

class ChecklistScreen extends StatefulWidget {
  @override
  _ChecklistScreenState createState() => _ChecklistScreenState();
}

class _ChecklistScreenState extends State<ChecklistScreen> {
  List<Task> tasks = [];
  final TextEditingController _taskController = TextEditingController();
  String selectedCategory = 'All';

  final List<String> categories = [
    'All', 'Venue', 'Photography', 'Catering', 'Events', 'Travel', 'Shopping', 'Decoration'
  ];

  // Category icons mapping
  final Map<String, IconData> categoryIcons = {
    'Venue': Icons.location_on,
    'Photography': Icons.camera_alt,
    'Catering': Icons.restaurant,
    'Events': Icons.event,
    'Travel': Icons.flight,
    'Shopping': Icons.shopping_bag,
    'Decoration': Icons.palette,
    'General': Icons.task_alt,
  };

  // Category colors mapping
  final Map<String, Color> categoryColors = {
    'Venue': Colors.blue,
    'Photography': Colors.purple,
    'Catering': Colors.orange,
    'Events': Colors.green,
    'Travel': Colors.indigo,
    'Shopping': Colors.teal,
    'Decoration': Colors.deepPurple,
    'General': Colors.grey,
  };

  // Wedding category real images mapping (high-quality wedding photos)
  // final Map<String, String> categoryImages = {
  //   'Venue': 'https://images.unsplash.com/photo-1519225421980-715cb0215aed?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80', // Beautiful wedding venue
  //   'Photography': 'https://images.unsplash.com/photo-1511285560929-80b456fea0bc?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80', // Wedding photography scene
  //   'Catering': 'https://images.unsplash.com/photo-1414235077428-338989a2e8c0?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80', // Wedding catering/food service
  //   'Events': 'https://images.unsplash.com/photo-1465495976277-4387d4b0e4a6?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80', // Wedding ceremony/event
  //   'Travel': 'https://images.unsplash.com/photo-1488646953014-85cb44e25828?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80', // Travel/honeymoon destination
  //   'Shopping': 'https://images.unsplash.com/photo-1445205170230-053b83016050?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80', // Wedding dress shopping
  //   'Decoration': 'https://images.unsplash.com/photo-1511795409834-ef04bbd61622?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80', // Wedding decoration/flowers
  //   'General': 'https://images.unsplash.com/photo-1606216794074-735e91aa2c92?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80', // General wedding planning
  // };
  final Map<String,String> categoryImage={
    'Venue':'assets/images/wedding_ceremony.jpg',
    'Photography':'assets/images/photography.jpg',
    'Catering':'assets/images/catering.jpg',
    'Events':'assets/images/mehendi.jpg',
    'Travel':'assets/images/travel.jpg',
    'Shopping':'assets/images/shopping.jpg',
    'Decoration':'assets/images/decoration.jpg',
    'General':'assets/images/general.jpg',
  };
  final Map<String, String> categoryImages = {
    'Venue': 'https://images.unsplash.com/photo-1519225421980-715cb0215aed?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80', // Beautiful wedding venue (your current image)
    'Photography': 'https://images.unsplash.com/photo-1606800052052-a08af7148866?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80', // Wedding photographer with camera
    'Catering': 'https://images.unsplash.com/photo-1555939594-58d7cb561ad1?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80', // Elegant food presentation
    'Events': 'https://www.freepik.com/free-photo/indian-wedding-bangles-mehandi-henna-coloured-hands-with-reflective-ornament_6448398.htm#fromView=search&page=1&position=0&uuid=ec8facba-ee8b-4ef1-81be-efa3ed26035c&query=wedding+mehandi', // Wedding ceremony setup
    'Travel': 'https://images.unsplash.com/photo-1436491865332-7a61a109cc05?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80', // Tropical honeymoon destination
    'Shopping': 'https://images.unsplash.com/photo-1594736797933-d0501ba2fe65?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80', // Wedding dress shopping
    'Decoration': 'https://images.unsplash.com/photo-1469371670807-013ccf25f16a?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80', // Wedding flowers and decoration
    'General': 'https://images.unsplash.com/photo-1511795409834-ef04bbd61622?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80', // Wedding planning essentials
  };

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }

  void _loadTasks() async {
    final loaded = await DatabaseHelper.instance.getTasks();
    setState(() {
      tasks = loaded;
    });
  }

  List<Task> get filteredTasks {
    if (selectedCategory == 'All') return tasks;
    return tasks.where((task) => task.category == selectedCategory).toList();
  }

  double get completionPercentage {
    if (tasks.isEmpty) return 0.0;
    int completed = tasks.where((task) => task.completed).length;
    return completed / tasks.length;
  }

  void _addTask(String title) async {
    if (title.trim().isEmpty) return;
    await DatabaseHelper.instance.insertTask(
        Task(title: title, category: selectedCategory == 'All' ? 'General' : selectedCategory)
    );
    _taskController.clear();
    _loadTasks();
  }

  void _toggleComplete(Task task) async {
    final updatedTask = task.copyWith(completed: !task.completed);
    await DatabaseHelper.instance.updateTask(updatedTask);
    _loadTasks();
  }

  void _editTask(Task task, String newTitle) async {
    if (newTitle.trim().isEmpty) return;
    final updatedTask = task.copyWith(title: newTitle);
    await DatabaseHelper.instance.updateTask(updatedTask);
    _loadTasks();
  }

  void _deleteTask(Task task) async {
    await DatabaseHelper.instance.deleteTask(task.id!);
    _loadTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wedding Checklist',style: TextStyle(color: Color(0xFFE91E63),),),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: _showCategoryFilter,
          ),
        ],
      ),
      body: Column(
        children: [
          // Progress Card
          Container(
            margin: EdgeInsets.all(16),
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.pink.shade100, Colors.pink.shade50],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Wedding Progress',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.pink.shade800,
                  ),
                ),
                SizedBox(height: 12),
                LinearProgressIndicator(
                  value: completionPercentage,
                  backgroundColor: Colors.pink.shade100,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.pink.shade600),
                  minHeight: 8,
                ),
                SizedBox(height: 8),
                Text(
                  '${(completionPercentage * 100).toInt()}% Complete (${tasks.where((t) => t.completed).length}/${tasks.length})',
                  style: TextStyle(
                    color: Colors.pink.shade700,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          // Category Filter
          Container(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                final isSelected = category == selectedCategory;
                return Container(
                  margin: EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        selectedCategory = category;
                      });
                    },
                    selectedColor: Colors.pink.shade100,
                    checkmarkColor: Colors.pink.shade800,
                  ),
                );
              },
            ),
          ),

          // Tasks List
          Expanded(
            child: filteredTasks.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.checklist_outlined,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  SizedBox(height: 16),
                  Text(
                    selectedCategory == 'All' ? 'No tasks yet' : 'No ${selectedCategory.toLowerCase()} tasks yet',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    selectedCategory == 'All'
                        ? 'Select a category to add your first wedding task'
                        : 'Add your first ${selectedCategory.toLowerCase()} task below',
                    style: TextStyle(
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            )
                : AnimationLimiter(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 16),
                itemCount: filteredTasks.length,
                itemBuilder: (context, index) {
                  final task = filteredTasks[index];
                  return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: Duration(milliseconds: 375),
                    child: SlideAnimation(
                      verticalOffset: 50.0,
                      child: FadeInAnimation(
                        child: _buildTaskCard(task),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // Add Task Input - Only show when not "All" category
          if (selectedCategory != 'All')
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Color(0xffffd2df),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 8,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _taskController,
                      decoration: InputDecoration(
                        hintText: 'Add a new ${selectedCategory.toLowerCase()} task...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.pink.shade200),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.pink.shade400),
                        ),
                        prefixIcon: Icon(
                            categoryIcons[selectedCategory] ?? Icons.add_task,
                            color: categoryColors[selectedCategory] ?? Colors.pink.shade400
                        ),
                      ),
                      onSubmitted: _addTask,
                    ),
                  ),
                  SizedBox(width: 12),
                  IconButton(
                    onPressed: () => _addTask(_taskController.text),
                    icon: Icon(Icons.done),
                    color: categoryColors[selectedCategory] ?? Colors.pink.shade400,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
  Widget _buildTaskCard(Task task) {
    final categoryIcon = categoryIcons[task.category] ?? Icons.task_alt;
    final categoryColor = categoryColors[task.category] ?? Colors.grey;
    final categoryImageUrl = categoryImage[task.category] ?? categoryImage['General'];

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      child: Dismissible(
        key: Key(task.id.toString()),
        background: Container(
          decoration: BoxDecoration(
            color: Colors.red.shade400,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: EdgeInsets.only(right: 20),
              child: Icon(Icons.delete, color: Colors.white),
            ),
          ),
        ),
        direction: DismissDirection.endToStart,
        onDismissed: (_) => _deleteTask(task),
        child: Card(
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: task.completed
                  ? Border.all(color: Colors.green.withOpacity(0.4), width: 2)
                  : null,
              gradient: LinearGradient(
                colors: !task.completed
                    ? [
                  Colors.green.withOpacity(0.03),
                  Colors.green.withOpacity(0.08),
                ]
                    : [
                  Colors.white,
                  categoryColor.withOpacity(0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Stack(
              children: [
                ListTile(
                  leading: Container(
                    width: 60,
                    height: 60, // Fixed: Made height match width
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: categoryColor.withOpacity(0.3),
                          spreadRadius: 1,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: _buildCategoryImage(categoryImageUrl, categoryIcon, categoryColor),
                    ),
                  ),
                  // ... rest of your ListTile content
                  title: GestureDetector(
                    onTap: () => _showEditDialog(task),
                    child: Text(
                      task.title,
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  subtitle: task.category != 'General'
                      ? Container(
                    margin: EdgeInsets.only(top: 8),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: categoryColor.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: categoryColor.withOpacity(0.3), width: 1),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(categoryIcon, size: 14, color: categoryColor),
                              SizedBox(width: 4),
                              Text(
                                task.category,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: categoryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                      : null,
                  trailing: PopupMenuButton(
                    icon: Icon(Icons.more_vert, color: categoryColor, size: 20),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit, size: 18, color: categoryColor),
                            SizedBox(width: 8),
                            Text('Edit', style: TextStyle(fontWeight: FontWeight.w500)),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete, size: 18, color: Colors.red),
                            SizedBox(width: 8),
                            Text('Delete', style: TextStyle(fontWeight: FontWeight.w500)),
                          ],
                        ),
                      ),
                    ],
                    onSelected: (value) {
                      if (value == 'edit') {
                        _showEditDialog(task);
                      } else if (value == 'delete') {
                        _deleteTask(task);
                      }
                    },
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: () => _toggleComplete(task),
                    child: Container(
                      padding: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: task.completed
                            ? Colors.green.withOpacity(0.9)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                        border: task.completed
                            ? null
                            : Border.all(color: Colors.grey.withOpacity(0.6), width: 2),
                      ),
                      child: Icon(
                        task.completed ? Icons.check : null,
                        color: task.completed ? Colors.white : Colors.grey.withOpacity(0.7),
                        size: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  Widget _buildCategoryImage(String? imageUrl, IconData fallbackIcon, Color categoryColor) {
    // Check if imageUrl is null or empty
    if (imageUrl == null || imageUrl.isEmpty) {
      return _buildFallbackIcon(fallbackIcon, categoryColor);
    }

    return Image.asset(
      imageUrl,
      width: 60,
      height: 60,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        print('Image loading error: $error'); // Debug print
        return _buildFallbackIcon(fallbackIcon, categoryColor);
      },
      // loadingBuilder: (context, child, loadingProgress) {
      //   if (loadingProgress == null) return child;
      //   return Container(
      //     width: 60,
      //     height: 60,
      //     decoration: BoxDecoration(
      //       color: categoryColor.withOpacity(0.1),
      //       borderRadius: BorderRadius.circular(10),
      //     ),
      //     child: Center(
      //       child: SizedBox(
      //         width: 20,
      //         height: 20,
      //         child: CircularProgressIndicator(
      //           strokeWidth: 2,
      //           valueColor: AlwaysStoppedAnimation<Color>(categoryColor),
      //           value: loadingProgress.expectedTotalBytes != null
      //               ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
      //               : null,
      //         ),
      //       ),
      //     ),
      //   );
      // },
    );
  }

  Widget _buildFallbackIcon(IconData icon, Color color) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(
        icon,
        color: color,
        size: 28,
      ),
    );
  }



  void _showEditDialog(Task task) {
    final TextEditingController editController = TextEditingController(text: task.title);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: Text('Edit Task', style: TextStyle(fontWeight: FontWeight.bold)),
          content: TextField(
            controller: editController,
            autofocus: true,
            decoration: InputDecoration(
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              labelText: 'Task Title',
            ),
            onSubmitted: (val) {
              Navigator.pop(context);
              _editTask(task, val);
            },
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink.shade400,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: Text('Save', style: TextStyle(color: Colors.white)),
              onPressed: () {
                Navigator.pop(context);
                _editTask(task, editController.text);
              },
            ),
          ],
        );
      },
    );
  }
  void _showCategoryFilter() {
    showModalBottomSheet(
      showDragHandle: true,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.filter_list, color: Colors.pink.shade600),
                  SizedBox(width: 8),
                  Text(
                    'Filter by Category',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: categories.map((category) {
                  return FilterChip(
                    label: Text(category),
                    selected: category == selectedCategory,
                    selectedColor: Colors.pink.shade100,
                    checkmarkColor: Colors.pink.shade800,
                    onSelected: (selected) {
                      setState(() {
                        selectedCategory = category;
                      });
                      Navigator.pop(context);
                    },
                  );
                }).toList(),
              ),
            ],
          ),
        );
      },
    );
  }
}
