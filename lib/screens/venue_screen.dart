import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:wedding_planner/screens/pages/venue_detail_page.dart';
import '../models/venue.dart';

class VenueScreen extends StatefulWidget {
  @override
  _VenueScreenState createState() => _VenueScreenState();
}

class _VenueScreenState extends State<VenueScreen> {
  List<Venue> venues = [
    Venue(
      name: '🏛️ Royal Garden Palace',
      location: 'Mumbai, Maharashtra',
      priceRange: '₹200,000 - ₹500,000',
      capacity: 500,
      rating: 4.8,
      amenities: ['AC Halls', 'Parking', 'Catering', 'Decoration', 'Photography'],
      description: 'Luxury wedding venue with beautiful gardens and royal architecture.',
      imageUrls: [
        'https://images.unsplash.com/photo-1519167758481-83f550bb49b3?w=800',
        'https://images.unsplash.com/photo-1464366400600-7168b8af9bc3?w=800',
        'https://images.unsplash.com/photo-1470229722913-7c0e2dbbafd3?w=800',
        'https://images.unsplash.com/photo-1505373877841-8d25f7d46678?w=800',
      ],
    ),
    Venue(
      name: '🌺 Sunnybrook Banquets',
      location: 'Delhi, NCR',
      priceRange: '₹150,000 - ₹300,000',
      capacity: 300,
      rating: 4.5,
      amenities: ['AC Halls', 'Valet Parking', 'Sound System', 'Lighting'],
      description: 'Modern banquet hall perfect for intimate wedding celebrations.',
      imageUrls: [
        'https://images.unsplash.com/photo-1511795409834-ef04bbd61622?w=800',
        'https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=800',
      ],
    ),
    Venue(
      name: '🏖️ Lakeside Resort',
      location: 'Goa',
      priceRange: '₹180,000 - ₹400,000',
      capacity: 400,
      rating: 4.7,
      amenities: ['Beach View', 'Outdoor Setup', 'Accommodation', 'Catering'],
      description: 'Stunning lakeside venue with picturesque views and beachfront access.',
      imageUrls: [
        'https://images.unsplash.com/photo-1544984243-ec57ea16fe25?w=800',
        'https://images.unsplash.com/photo-1540479859555-17af45c78602?w=800',
        'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=800',
      ],
    ),
    Venue(
      name: '🏰 Heritage Hall',
      location: 'Jaipur, Rajasthan',
      priceRange: '₹100,000 - ₹250,000',
      capacity: 250,
      rating: 4.3,
      amenities: ['Heritage Architecture', 'Traditional Decor', 'Parking'],
      description: 'Historic venue showcasing traditional Rajasthani architecture.',
      imageUrls: [
        'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?w=800',
        'https://images.unsplash.com/photo-1571896349842-33c89424de2d?w=800',
        'https://images.unsplash.com/photo-1504215680853-026ed2a45def?w=800',
      ],
    ),
    Venue(
      name: '🌸 Grand Orchid',
      location: 'Bangalore, Karnataka',
      priceRange: '₹220,000 - ₹480,000',
      capacity: 450,
      rating: 4.6,
      amenities: ['Garden Setting', 'Modern Facilities', 'Catering', 'Decoration'],
      description: 'Elegant garden venue with modern amenities and beautiful landscaping.',
      imageUrls: [
        'https://images.unsplash.com/photo-1527529482837-4698179dc6ce?w=800',
        'https://images.unsplash.com/photo-1464366400600-7168b8af9bc3?w=800',
      ],
    ),
    Venue(
      name: '🎭 Crystal Ballroom',
      location: 'Hyderabad, Telangana',
      priceRange: '₹300,000 - ₹600,000',
      capacity: 600,
      rating: 4.9,
      amenities: ['Luxury Interior', 'Crystal Chandeliers', 'Premium Catering'],
      description: 'Ultra-luxury ballroom with crystal chandeliers and premium services.',
      imageUrls: [
        'https://images.unsplash.com/photo-1445019980597-93fa8acb246c?w=800',
        'https://images.unsplash.com/photo-1561414927-6d86591d0c4f?w=800',
        'https://images.unsplash.com/photo-1519167758481-83f550bb49b3?w=800',
        'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=800',
      ],
    ),
  ];

  // Filter states
  int selectedCapacity = 0;
  double maxBudget = 600000;
  String selectedLocation = 'All';

  // Search functionality
  String searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  List<String> get locations {
    List<String> locs = ['All'];
    locs.addAll(venues.map((v) => v.location.split(',')[0]).toSet().toList());
    return locs;
  }

  // Enhanced filtering with search
  List<Venue> get filteredVenues {
    return venues.where((venue) {
      // Search filter - matches name, location, or amenities
      bool matchesSearch = searchQuery.isEmpty ||
          venue.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
          venue.location.toLowerCase().contains(searchQuery.toLowerCase()) ||
          venue.description.toLowerCase().contains(searchQuery.toLowerCase()) ||
          venue.amenities.any((amenity) =>
              amenity.toLowerCase().contains(searchQuery.toLowerCase()));

      // Capacity filter
      bool matchesCapacity = selectedCapacity == 0 || venue.capacity <= selectedCapacity;

      // Budget filter
      RegExp reg = RegExp(r'₹([\d,]+) - ₹([\d,]+)');
      var match = reg.firstMatch(venue.priceRange);
      int priceMax = 0;
      if (match != null) {
        priceMax = int.parse(match.group(2)!.replaceAll(',', ''));
      }
      bool matchesPrice = priceMax <= maxBudget;

      // Location filter
      bool matchesLocation = selectedLocation == 'All' ||
          venue.location.toLowerCase().contains(selectedLocation.toLowerCase());

      return matchesSearch && matchesCapacity && matchesPrice && matchesLocation;
    }).toList();
  }

  // Active filters count for UI
  int get activeFiltersCount {
    int count = 0;
    if (selectedCapacity > 0) count++;
    if (maxBudget < 600000) count++;
    if (selectedLocation != 'All') count++;
    if (searchQuery.isNotEmpty) count++;
    return count;
  }

  @override
  void initState() {
    super.initState();
    // Real-time search listener
    _searchController.addListener(() {
      setState(() {
        searchQuery = _searchController.text;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wedding Venues',style: TextStyle(color: Color(0xFFE91E63),)),
        elevation: 0,
        actions: [
          // Search results count badge
          if (searchQuery.isNotEmpty)
            Center(
              child: Container(
                margin: EdgeInsets.only(right: 8),
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${filteredVenues.length}',
                  style: TextStyle(
                    color: Colors.pink.shade700,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          IconButton(
            icon: Stack(
              children: [
                Icon(Icons.tune),
                if (activeFiltersCount > 0)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      constraints: BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        '$activeFiltersCount',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            onPressed: _showFilterSheet,
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(70),
          child: Container(
            padding: EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    focusNode: _searchFocusNode,
                    decoration: InputDecoration(
                      hintText: 'Search venues by name, location, or amenities...',
                      hintStyle: TextStyle(color: Colors.grey[500]),
                      prefixIcon: Icon(Icons.search, color: Colors.pink.shade400),
                      suffixIcon: searchQuery.isNotEmpty
                          ? IconButton(
                        icon: Icon(Icons.clear, color: Colors.grey[600]),
                        onPressed: () {
                          _searchController.clear();
                          _searchFocusNode.unfocus();
                        },
                      )
                          : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide(color: Colors.pink.shade200),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide(color: Colors.pink.shade400, width: 2),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.symmetric(vertical: 12),
                    ),
                    textInputAction: TextInputAction.search,
                    onSubmitted: (value) {
                      _searchFocusNode.unfocus();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Enhanced Filter Summary Card
          // Container(
          //   margin: EdgeInsets.all(16),
          //   padding: EdgeInsets.all(16),
          //   decoration: BoxDecoration(
          //     color: Colors.pink.shade50,
          //     borderRadius: BorderRadius.circular(12),
          //     border: Border.all(color: Colors.pink.shade200),
          //   ),
          //   child: Column(
          //     children: [
          //       Row(
          //         children: [
          //           Icon(Icons.filter_list, color: Colors.pink.shade600),
          //           SizedBox(width: 8),
          //           Expanded(
          //             child: Text(
          //               '${filteredVenues.length} venues found',
          //               style: TextStyle(
          //                 fontWeight: FontWeight.w500,
          //                 color: Colors.pink.shade800,
          //               ),
          //             ),
          //           ),
          //           if (activeFiltersCount > 0)
          //             Container(
          //               padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          //               decoration: BoxDecoration(
          //                 color: Colors.pink.shade200,
          //                 borderRadius: BorderRadius.circular(12),
          //               ),
          //               child: Text(
          //                 '$activeFiltersCount filter${activeFiltersCount == 1 ? '' : 's'}',
          //                 style: TextStyle(
          //                   fontSize: 12,
          //                   color: Colors.pink.shade800,
          //                   fontWeight: FontWeight.w500,
          //                 ),
          //               ),
          //             ),
          //           SizedBox(width: 8),
          //           TextButton(
          //             onPressed: _showFilterSheet,
          //             child: Text('Filter'),
          //           ),
          //         ],
          //       ),
          //
          //       // Active search query chip
          //       if (searchQuery.isNotEmpty) ...[
          //         SizedBox(height: 8),
          //         Row(
          //           children: [
          //             Icon(Icons.search, size: 16, color: Colors.pink.shade600),
          //             SizedBox(width: 4),
          //             Text(
          //               'Searching: ',
          //               style: TextStyle(
          //                 fontSize: 12,
          //                 color: Colors.pink.shade600,
          //               ),
          //             ),
          //             Expanded(
          //               child: Container(
          //                 padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          //                 decoration: BoxDecoration(
          //                   color: Colors.pink.shade100,
          //                   borderRadius: BorderRadius.circular(8),
          //                 ),
          //                 child: Text(
          //                   '"$searchQuery"',
          //                   style: TextStyle(
          //                     fontSize: 12,
          //                     color: Colors.pink.shade800,
          //                     fontWeight: FontWeight.w500,
          //                     fontStyle: FontStyle.italic,
          //                   ),
          //                   overflow: TextOverflow.ellipsis,
          //                 ),
          //               ),
          //             ),
          //             SizedBox(width: 8),
          //             GestureDetector(
          //               onTap: () => _clearAllFilters(),
          //               child: Text(
          //                 'Clear All',
          //                 style: TextStyle(
          //                   fontSize: 12,
          //                   color: Colors.pink.shade700,
          //                   decoration: TextDecoration.underline,
          //                 ),
          //               ),
          //             ),
          //           ],
          //         ),
          //       ],
          //     ],
          //   ),
          // ),

          // Venues List
          Expanded(
            child: filteredVenues.isEmpty
                ? _buildEmptyState()
                : AnimationLimiter(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 16),
                itemCount: filteredVenues.length,
                itemBuilder: (context, index) {
                  final venue = filteredVenues[index];
                  return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: Duration(milliseconds: 375),
                    child: SlideAnimation(
                      verticalOffset: 50.0,
                      child: FadeInAnimation(
                        child: _buildVenueCard(venue),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            searchQuery.isNotEmpty ? Icons.search_off : Icons.location_city_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16),
          Text(
            searchQuery.isNotEmpty
                ? 'No venues found for "$searchQuery"'
                : 'No venues found',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8),
          Text(
            searchQuery.isNotEmpty
                ? 'Try a different search term or adjust your filters'
                : 'Try adjusting your filters',
            style: TextStyle(
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
          if (activeFiltersCount > 0) ...[
            SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _clearAllFilters,
              icon: Icon(Icons.clear_all),
              label: Text('Clear All Filters'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink.shade400,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildVenueCard(Venue venue) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (_)=>VenueDetailsPage(venue: venue)));
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Carousel with indicators
              if (venue.imageUrls.isNotEmpty)
                _buildImageCarousel(venue.imageUrls, isCompact: true),

              // Header with rating
              Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Highlight search matches in venue name
                          _buildHighlightedText(
                            venue.name,
                            searchQuery,
                            TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[800],
                            ),
                          ),
                          SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                              SizedBox(width: 4),
                              Expanded(
                                child: _buildHighlightedText(
                                  venue.location,
                                  searchQuery,
                                  TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.star, size: 16, color: Colors.orange.shade700),
                          SizedBox(width: 2),
                          Text(
                            venue.rating.toString(),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.orange.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Details
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _buildDetailItem(
                            Icons.currency_rupee,
                            'Price Range',
                            venue.priceRange,
                            Colors.green,
                          ),
                        ),
                        Expanded(
                          child: _buildDetailItem(
                            Icons.people,
                            'Capacity',
                            '${venue.capacity} guests',
                            Colors.blue,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),

                    // Amenities Preview with search highlighting
                    if (venue.amenities.isNotEmpty) ...[
                      Text(
                        'Amenities',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[700],
                        ),
                      ),
                      SizedBox(height: 8),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: venue.amenities.take(3).map((amenity) {
                          bool isHighlighted = searchQuery.isNotEmpty &&
                              amenity.toLowerCase().contains(searchQuery.toLowerCase());
                          return Container(
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: isHighlighted
                                  ? Colors.yellow.shade100
                                  : Colors.pink.shade50,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isHighlighted
                                    ? Colors.yellow.shade400
                                    : Colors.pink.shade200,
                              ),
                            ),
                            child: Text(
                              amenity,
                              style: TextStyle(
                                fontSize: 12,
                                color: isHighlighted
                                    ? Colors.yellow.shade800
                                    : Colors.pink.shade700,
                                fontWeight: isHighlighted
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      if (venue.amenities.length > 3)
                        Padding(
                          padding: EdgeInsets.only(top: 6),
                          child: Text(
                            '+${venue.amenities.length - 3} more amenities',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                    ],
                  ],
                ),
              ),

              // View Details button
              Container(
                width: double.infinity,
                margin: EdgeInsets.all(16),
                child: ElevatedButton.icon(
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (_)=>VenueDetailsPage(venue: venue)));
                  },
                  icon: Icon(Icons.visibility),
                  label: Text('View Details & Photos'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink.shade400,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to highlight search terms
  Widget _buildHighlightedText(String text, String query, TextStyle style) {
    if (query.isEmpty) {
      return Text(text, style: style);
    }

    List<TextSpan> spans = [];
    String lowerText = text.toLowerCase();
    String lowerQuery = query.toLowerCase();

    int lastIndex = 0;
    int index = lowerText.indexOf(lowerQuery);

    while (index != -1) {
      // Add text before match
      if (index > lastIndex) {
        spans.add(TextSpan(
          text: text.substring(lastIndex, index),
          style: style,
        ));
      }

      // Add highlighted match
      spans.add(TextSpan(
        text: text.substring(index, index + query.length),
        style: style.copyWith(
          backgroundColor: Colors.yellow.shade200,
          fontWeight: FontWeight.bold,
        ),
      ));

      lastIndex = index + query.length;
      index = lowerText.indexOf(lowerQuery, lastIndex);
    }

    // Add remaining text
    if (lastIndex < text.length) {
      spans.add(TextSpan(
        text: text.substring(lastIndex),
        style: style,
      ));
    }

    return RichText(
      text: TextSpan(children: spans),
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildImageCarousel(List<String> imageUrls, {bool isCompact = false}) {
    if (imageUrls.isEmpty) {
      return Container(
        height: isCompact ? 180 : 250,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Center(
          child: Icon(
            Icons.image_not_supported,
            size: 48,
            color: Colors.grey.shade400,
          ),
        ),
      );
    }

    return Container(
      height: isCompact ? 180 : 250,
      child: Stack(
        children: [
          PageView.builder(
            itemCount: imageUrls.length,
            itemBuilder: (context, index) {
              return ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                child: Image.network(
                  imageUrls[index],
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      color: Colors.grey.shade200,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: Colors.pink.shade400,
                        ),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey.shade200,
                      child: Center(
                        child: Icon(
                          Icons.broken_image,
                          size: 48,
                          color: Colors.grey.shade400,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),

          // Image counter overlay
          Positioned(
            top: 12,
            right: 12,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${imageUrls.length} photos',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: color),
            SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
      ],
    );
  }

  void _clearAllFilters() {
    setState(() {
      _searchController.clear();
      searchQuery = '';
      selectedCapacity = 0;
      maxBudget = 600000;
      selectedLocation = 'All';
    });
    _searchFocusNode.unfocus();
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      showDragHandle: true,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: EdgeInsets.only(left: 20,right: 20,bottom: 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Filter Venues',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      if (activeFiltersCount > 0)
                        TextButton(
                          onPressed: () {
                            _clearAllFilters();
                            setModalState(() {});
                            setState(() {});
                          },
                          child: Text('Clear All'),
                        ),
                    ],
                  ),
                  SizedBox(height: 15),
                  // Capacity Filter
                  Text('Minimum Capacity'),
                  SizedBox(height: 8),
                  DropdownButtonFormField<int>(
                    value: selectedCapacity == 0 ? null : selectedCapacity,
                    hint: Text('Select Minimum Capacity'),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    items: [0, 100, 200, 300, 400, 500, 600].map((int value) {
                      return DropdownMenuItem<int>(
                        value: value,
                        child: Text(value == 0 ? 'Any Capacity' : 'Less than $value guests'),
                      );
                    }).toList(),
                    onChanged: (val) {
                      setModalState(() {
                        selectedCapacity = val ?? 0;
                      });
                    },
                  ),

                  SizedBox(height: 20),
                  // Budget Filter
                  Text('Maximum Budget: ₹${maxBudget.toInt()}'),
                  Slider(
                    min: 100000,
                    max: 600000,
                    divisions: 10,
                    value: maxBudget,
                    label: '₹${maxBudget.toInt()}',
                    onChanged: (val) {
                      setModalState(() {
                        maxBudget = val;
                      });
                    },
                  ),
                  SizedBox(height: 20),

                  // Location Filter
                  Text('Location'),
                  SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: selectedLocation,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    items: locations.map((String location) {
                      return DropdownMenuItem<String>(
                        value: location,
                        child: Text(location),
                      );
                    }).toList(),
                    onChanged: (val) {
                      setModalState(() {
                        selectedLocation = val ?? 'All';
                      });
                    },
                  ),
                  SizedBox(height: 20),

                  // Apply Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {}); // Update main screen
                        Navigator.pop(context);
                      },
                      child: Text('Apply Filters'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pink.shade400,
                        padding: EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // void _showVenueDetails(Venue venue) {
  //   showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     showDragHandle: false, // Removed to eliminate top space
  //     useSafeArea: false, // Prevents extra padding
  //     backgroundColor: Colors.transparent, // Makes background transparent
  //     shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
  //     ),
  //     builder: (context) {
  //       return Container(
  //         decoration: BoxDecoration(
  //           color: Colors.white,
  //           borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
  //         ),
  //         child: DraggableScrollableSheet(
  //           initialChildSize: 0.8,
  //           maxChildSize: 0.95,
  //           minChildSize: 0.5,
  //           builder: (context, scrollController) {
  //             return Column(
  //               children: [
  //                 // Custom minimal drag indicator
  //                 Container(
  //                   width: 40,
  //                   height: 4,
  //                   margin: EdgeInsets.only(top: 8, bottom: 4),
  //                   decoration: BoxDecoration(
  //                     color: Colors.grey[300],
  //                     borderRadius: BorderRadius.circular(2),
  //                   ),
  //                 ),
  //                 Expanded(
  //                   child: SingleChildScrollView(
  //                     controller: scrollController,
  //                     padding: EdgeInsets.fromLTRB(20, 8, 20, 20), // Minimal top padding
  //                     child: Column(
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: [
  //                         // Full Image Gallery
  //                         if (venue.imageUrls.isNotEmpty) ...[
  //                           _buildImageCarousel(venue.imageUrls),
  //                           SizedBox(height: 16),
  //                           // Image thumbnails row
  //                           Container(
  //                             height: MediaQuery.of(context).size.height * 0.1,
  //                             child: ListView.builder(
  //                               scrollDirection: Axis.horizontal,
  //                               itemCount: venue.imageUrls.length,
  //                               itemBuilder: (context, index) {
  //                                 return Container(
  //                                   margin: EdgeInsets.only(right: 8),
  //                                   width: 60,
  //                                   height: 60,
  //                                   child: ClipRRect(
  //                                     borderRadius: BorderRadius.circular(8),
  //                                     child: Image.network(
  //                                       venue.imageUrls[index],
  //                                       fit: BoxFit.cover,
  //                                     ),
  //                                   ),
  //                                 );
  //                               },
  //                             ),
  //                           ),
  //                           SizedBox(height: 20),
  //                         ],
  //
  //                         // Header
  //                         Row(
  //                           children: [
  //                             Expanded(
  //                               child: Text(
  //                                 venue.name,
  //                                 style: TextStyle(
  //                                   fontSize: 24,
  //                                   fontWeight: FontWeight.bold,
  //                                 ),
  //                               ),
  //                             ),
  //                             Container(
  //                               padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
  //                               decoration: BoxDecoration(
  //                                 color: Colors.orange.shade100,
  //                                 borderRadius: BorderRadius.circular(12),
  //                               ),
  //                               child: Row(
  //                                 mainAxisSize: MainAxisSize.min,
  //                                 children: [
  //                                   Icon(Icons.star, size: 18, color: Colors.orange.shade700),
  //                                   SizedBox(width: 4),
  //                                   Text(
  //                                     venue.rating.toString(),
  //                                     style: TextStyle(
  //                                       fontWeight: FontWeight.bold,
  //                                       color: Colors.orange.shade700,
  //                                     ),
  //                                   ),
  //                                 ],
  //                               ),
  //                             ),
  //                           ],
  //                         ),
  //                         SizedBox(height: 8),
  //                         Row(
  //                           children: [
  //                             Icon(Icons.location_on, color: Colors.grey[600]),
  //                             SizedBox(width: 4),
  //                             Text(venue.location, style: TextStyle(color: Colors.grey[700])),
  //                           ],
  //                         ),
  //                         SizedBox(height: 20),
  //
  //                         // Description
  //                         Text(
  //                           'About This Venue',
  //                           style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
  //                         ),
  //                         SizedBox(height: 8),
  //                         Text(
  //                           venue.description,
  //                           style: TextStyle(color: Colors.grey[700], height: 1.5),
  //                         ),
  //                         SizedBox(height: 20),
  //
  //                         // Details Grid
  //                         Row(
  //                           children: [
  //                             Expanded(
  //                               child: _buildDetailCard(
  //                                 Icons.currency_rupee,
  //                                 'Price Range',
  //                                 venue.priceRange,
  //                                 Colors.green,
  //                               ),
  //                             ),
  //                             SizedBox(width: 12),
  //                             Expanded(
  //                               child: _buildDetailCard(
  //                                 Icons.people,
  //                                 'Capacity',
  //                                 '${venue.capacity} guests',
  //                                 Colors.blue,
  //                               ),
  //                             ),
  //                           ],
  //                         ),
  //                         SizedBox(height: 20),
  //
  //                         // Amenities
  //                         Text(
  //                           'Amenities & Services',
  //                           style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
  //                         ),
  //                         SizedBox(height: 12),
  //                         Wrap(
  //                           spacing: 8,
  //                           runSpacing: 8,
  //                           children: venue.amenities.map((amenity) {
  //                             return Container(
  //                               padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
  //                               decoration: BoxDecoration(
  //                                 color: Colors.pink.shade50,
  //                                 borderRadius: BorderRadius.circular(20),
  //                                 border: Border.all(color: Colors.pink.shade200),
  //                               ),
  //                               child: Text(
  //                                 amenity,
  //                                 style: TextStyle(
  //                                   color: Colors.pink.shade700,
  //                                   fontWeight: FontWeight.w500,
  //                                 ),
  //                               ),
  //                             );
  //                           }).toList(),
  //                         ),
  //                         SizedBox(height: 30),
  //
  //                         // Action Buttons
  //                         Row(
  //                           children: [
  //                             Expanded(
  //                               child: OutlinedButton.icon(
  //                                 onPressed: () {
  //                                   ScaffoldMessenger.of(context).showSnackBar(
  //                                     SnackBar(content: Text('Contact feature coming soon!')),
  //                                   );
  //                                 },
  //                                 icon: Icon(Icons.phone),
  //                                 label: Text('Contact Venue'),
  //                                 style: OutlinedButton.styleFrom(
  //                                   padding: EdgeInsets.symmetric(vertical: 12),
  //                                 ),
  //                               ),
  //                             ),
  //                             SizedBox(width: 12),
  //                             Expanded(
  //                               child: ElevatedButton.icon(
  //                                 onPressed: () {
  //                                   print('Button tapped!');
  //                                   ScaffoldMessenger.of(context).showSnackBar(
  //                                     SnackBar(
  //                                       content: Text('Booking feature coming soon!'),
  //                                       duration: Duration(seconds: 2),
  //                                     ),
  //                                   );
  //                                 },
  //                                 icon: Icon(Icons.book_online, color: Colors.white),
  //                                 label: Text(
  //                                   'Book Now',
  //                                   style: TextStyle(color: Colors.white),
  //                                 ),
  //                                 style: ElevatedButton.styleFrom(
  //                                   backgroundColor: Colors.pink.shade400,
  //                                   foregroundColor: Colors.white,
  //                                   padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
  //                                   elevation: 2,
  //                                   shape: RoundedRectangleBorder(
  //                                     borderRadius: BorderRadius.circular(8),
  //                                   ),
  //                                 ),
  //                               ),
  //                             ),
  //                           ],
  //                         ),
  //                         SizedBox(height: 20),
  //                       ],
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             );
  //           },
  //         ),
  //       );
  //     },
  //   );
  // }


  /*void _showVenueDetails(Venue venue) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.8,
          maxChildSize: 0.95,
          minChildSize: 0.5,
          builder: (context, scrollController) {
            return Container(
              padding: EdgeInsets.all(20),
              child: SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Full Image Gallery
                    if (venue.imageUrls.isNotEmpty) ...[
                      _buildImageCarousel(venue.imageUrls),
                      SizedBox(height: 16),
                      // Image thumbnails row
                      Container(
                        height: MediaQuery.of(context).size.height*0.1,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: venue.imageUrls.length,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: EdgeInsets.only(right: 8),
                              width: 60,
                              height: 60,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  venue.imageUrls[index],
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 20),
                    ],

                    // Header
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            venue.name,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.orange.shade100,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.star, size: 18, color: Colors.orange.shade700),
                              SizedBox(width: 4),
                              Text(
                                venue.rating.toString(),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange.shade700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.location_on, color: Colors.grey[600]),
                        SizedBox(width: 4),
                        Text(venue.location, style: TextStyle(color: Colors.grey[700])),
                      ],
                    ),
                    SizedBox(height: 20),

                    // Description
                    Text(
                      'About This Venue',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      venue.description,
                      style: TextStyle(color: Colors.grey[700], height: 1.5),
                    ),
                    SizedBox(height: 20),

                    // Details Grid
                    Row(
                      children: [
                        Expanded(
                          child: _buildDetailCard(
                            Icons.currency_rupee,
                            'Price Range',
                            venue.priceRange,
                            Colors.green,
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: _buildDetailCard(
                            Icons.people,
                            'Capacity',
                            '${venue.capacity} guests',
                            Colors.blue,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),

                    // Amenities
                    Text(
                      'Amenities & Services',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: venue.amenities.map((amenity) {
                        return Container(
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.pink.shade50,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.pink.shade200),
                          ),
                          child: Text(
                            amenity,
                            style: TextStyle(
                              color: Colors.pink.shade700,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 30),

                    // Action Buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Contact feature coming soon!')),
                              );
                            },
                            icon: Icon(Icons.phone),
                            label: Text('Contact Venue'),
                            style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () async {
                              try {
                                print('Button tapped!'); // Use print instead of log for debugging

                                // Show the snackbar
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Booking feature coming soon!'),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              } catch (e) {
                                print('Error in button press: $e');
                              }
                            },
                            icon: Icon(Icons.book_online, color: Colors.white),
                            label: Text(
                              'Book Now',
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.pink.shade400,
                              foregroundColor: Colors.white, // Ensures text/icon are white
                              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),

                      ],
                    ),

                    SizedBox(height: 20),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }*/

  Widget _buildDetailCard(IconData icon, String label, String value, Color color) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color),
          SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
        ],
      ),
    );
  }
}
