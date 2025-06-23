import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:by_faith/features/go/providers/go_settings_font_provider.dart';

class GoSearchScreen extends StatefulWidget {
  const GoSearchScreen({super.key});

  @override
  State<GoSearchScreen> createState() => _GoSearchScreenState();
}

class _GoSearchScreenState extends State<GoSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchResult = '';
  LatLng? _foundLocation;

  Future<void> _searchAddress(String address) async {
    if (address.trim().isEmpty) {
      setState(() {
        _searchResult = 'Please enter an address.';
        _foundLocation = null;
      });
      return;
    }

    final url = Uri.parse('https://nominatim.openstreetmap.org/search?format=json&q=${Uri.encodeComponent(address)}');
    try {
      final response = await http.get(url, headers: {'User-Agent': 'by_faith_app'});
      if (response.statusCode == 200) {
        final List results = json.decode(response.body);
        if (results.isNotEmpty) {
          final lat = double.tryParse(results[0]['lat'] ?? '');
          final lon = double.tryParse(results[0]['lon'] ?? '');
          if (lat != null && lon != null) {
            final displayName = results[0]['display_name'];
            setState(() {
              _searchResult = 'Found: $displayName';
              _foundLocation = LatLng(lat, lon);
            });
            // The navigation will be handled by the clickable text
            return;
          }
        }
      }
      setState(() {
        _searchResult = 'Address not found.';
        _foundLocation = null;
      });
    } catch (e) {
      setState(() {
        _searchResult = 'Error searching address: $e';
        _foundLocation = null;
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Search Address',
          style: TextStyle(
            fontFamily: context.watch<FontProvider>().fontFamily,
            fontSize: context.watch<FontProvider>().fontSize,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Enter address',
                hintStyle: TextStyle(
                  fontFamily: context.watch<FontProvider>().fontFamily,
                  fontSize: context.watch<FontProvider>().fontSize,
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    Icons.search,
                    size: context.watch<FontProvider>().fontSize * 1.2,
                  ),
                  onPressed: () => _searchAddress(_searchController.text),
                ),
              ),
              onSubmitted: (_) => _searchAddress(_searchController.text),
              style: TextStyle(
                fontFamily: context.watch<FontProvider>().fontFamily,
                fontSize: context.watch<FontProvider>().fontSize,
              ),
            ),
            const SizedBox(height: 16),
            if (_searchResult.isNotEmpty)
              SelectableText(
                _searchResult,
                onTap: () {
                  if (_foundLocation != null) {
                    Navigator.pop(context, _foundLocation);
                  }
                },
                style: TextStyle(
                  fontFamily: context.watch<FontProvider>().fontFamily,
                  fontSize: context.watch<FontProvider>().fontSize,
                ),
              ),
            if (_foundLocation != null)
              Text(
                'Latitude: ${_foundLocation!.latitude}, Longitude: ${_foundLocation!.longitude}',
                style: TextStyle(
                  fontFamily: context.watch<FontProvider>().fontFamily,
                  fontSize: context.watch<FontProvider>().fontSize,
                ),
              ),
          ],
        ),
      ),
    );
  }
}