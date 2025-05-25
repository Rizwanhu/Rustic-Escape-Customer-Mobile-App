//home_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'cabin_detail_screen.dart';
import 'cabin_model.dart';
import 'supabase_service.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Cabin> _allCabins = [];
  String _currentFilter = 'All Cabins';
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadCabins();
  }

  Future<void> _loadCabins() async {
    try {
      final supabaseService = SupabaseService();
      final data = await supabaseService.getAllCabins();
      print('[HOME] Raw cabins data: $data');
      final cabins = data.map((json) => Cabin.fromJson(json)).toList();

      setState(() {
        _allCabins = cabins;
        _isLoading = false;
      });
    } catch (e) {
      print('[HOME] Error loading cabins: $e');
      setState(() {
        _error = 'Failed to load cabins: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Cabin> filteredCabins = _getFilteredCabins();

    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: Text(
          'Our Luxury Cabins',
          style: GoogleFonts.josefinSans(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.black,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(child: Text(_error!, style: TextStyle(color: Colors.white)))
          : SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Cozy yet luxurious cabins...Welcome to paradise.',
              style: GoogleFonts.josefinSans(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 16),
            Wrap(
              spacing: 8,
              children: [
                _buildFilterChip('All Cabins'),
                _buildFilterChip('1–3 guests'),
                _buildFilterChip('4–7 guests'),
                _buildFilterChip('8+ guests'),
              ],
            ),
            SizedBox(height: 16),
            if (filteredCabins.isEmpty)
              Center(
                child: Text(
                  'No cabins found',
                  style: GoogleFonts.josefinSans(
                    color: Colors.white,
                  ),
                ),
              )
            else
              Column(
                children: filteredCabins
                    .map((cabin) => _buildCabinCard(context, cabin))
                    .toList(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    return FilterChip(
      label: Text(
        label,
        style: GoogleFonts.josefinSans(
          color: _currentFilter == label ? Colors.white : Colors.grey[400],
        ),
      ),
      selected: _currentFilter == label,
      onSelected: (selected) {
        setState(() {
          _currentFilter = selected ? label : 'All Cabins';
        });
      },
      backgroundColor: Colors.grey[800],
      selectedColor: Colors.brown[700],
      checkmarkColor: Colors.white,
    );
  }

  List<Cabin> _getFilteredCabins() {
    switch (_currentFilter) {
      case '1–3 guests':
        return _allCabins.where((cabin) => cabin.maxCapacity <= 3).toList();
      case '4–7 guests':
        return _allCabins.where((cabin) => cabin.maxCapacity >= 4 && cabin.maxCapacity <= 7).toList();
      case '8+ guests':
        return _allCabins.where((cabin) => cabin.maxCapacity >= 8).toList();
      default:
        return _allCabins;
    }
  }

  Widget _buildCabinCard(BuildContext context, Cabin cabin) {
    return Card(
      color: Colors.grey[800],
      margin: EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CabinDetailScreen(cabinId: cabin.id.toString()),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              cabin.image.isNotEmpty
                  ? cabin.image
                  : 'https://your-default-fallback-image-url.jpg',
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Image.asset(
                'assets/default_cabin.jpg',
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cabin.name,
                    style: GoogleFonts.josefinSans(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.person, size: 16, color: Colors.white),
                      SizedBox(width: 4),
                      Text(
                        'For up to ${cabin.maxCapacity} guests',
                        style: GoogleFonts.josefinSans(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    '\$${cabin.regularPrice.toStringAsFixed(2)} / night',
                    style: GoogleFonts.josefinSans(
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'View details →',
                      style: GoogleFonts.josefinSans(
                        color: Colors.brown[200],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}