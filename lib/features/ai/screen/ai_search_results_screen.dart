import 'package:diaz1234567890/core/utils/constants/image_path.dart';
import 'package:diaz1234567890/core/utils/constants/icon_path.dart';
import 'package:diaz1234567890/core/common/style/global_text_style.dart';
import 'package:diaz1234567890/core/endpoints/endpoints.dart';
import 'package:diaz1234567890/features/home/model/home_model.dart';
import 'package:diaz1234567890/features/details/screen/details_screen.dart';
import 'package:diaz1234567890/core/services/api_service.dart';
import 'package:diaz1234567890/core/services/firebase/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AiSearchResultsScreen extends StatefulWidget {
  final String query;
  final List<Yacht> results;

  const AiSearchResultsScreen({
    super.key,
    required this.query,
    required this.results,
  });

  @override
  State<AiSearchResultsScreen> createState() => _AiSearchResultsScreenState();
}

class _AiSearchResultsScreenState extends State<AiSearchResultsScreen> {
  late TextEditingController _searchController;
  final _isLoading = false.obs;
  late List<Yacht> _results;
  double _limit = 10;
  bool _showLimitSlider = false;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.query);
    _results = List.from(widget.results);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _handleAiSearch(String query) async {
    if (query.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter a search query',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      _isLoading.value = true;

      await StorageService.init();
      final userId = StorageService.userId;

      if (userId == null || userId.isEmpty) {
        EasyLoading.showError('User not logged in');
        return;
      }

      final response = await ApiService.aiSearch(
        userId: userId,
        query: query,
        limit: _limit.toInt(),
      );

      if (response['error'] != null) {
        EasyLoading.showError(response['error'] ?? 'Search failed');
        return;
      }

      final data = response['data'] as List<dynamic>? ?? [];
      final yachts = <Yacht>[];

      for (final item in data) {
        try {
          final map = item as Map<String, dynamic>;
          String coverImageUrl = Imagepath.singleBoat;
          final images = map['images'];
          if (images is Map<String, dynamic> && images['Uri'] != null) {
            coverImageUrl = images['Uri'] as String;
          }
          final location = map['location'] as Map<String, dynamic>? ?? {};
          yachts.add(
            Yacht(
              id: map['document_id']?.toString() ?? '',
              title: '${map['make'] ?? ''} ${map['model'] ?? ''}'.trim(),
              location:
                  '${location['BoatCityName'] ?? ''}, ${location['BoatStateCode'] ?? ''}',
              make: map['make']?.toString() ?? 'N/A',
              model: map['model']?.toString() ?? 'N/A',
              year: map['model_year']?.toString() ?? 'N/A',
              price: map['price'] != null
                  ? '\$${(map['price'] as num).toStringAsFixed(0)}'
                  : 'Call for Price',
              image: coverImageUrl,
            ),
          );
        } catch (e) {
          print('Error parsing result: $e');
        }
      }

      setState(() {
        _results = yachts;
      });
    } catch (e) {
      Get.snackbar(
        'Error',
        'Error: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      print('AI Search Error: $e');
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> _navigateToDetails(String id) async {
    try {
      EasyLoading.show(status: 'Loading...');
      final response = await http.get(
        Uri.parse(Endpoints.getBoatById(id)),
        headers: {'Content-Type': 'application/json'},
      );
      final jsonBody = jsonDecode(response.body) as Map<String, dynamic>;
      EasyLoading.dismiss();

      if (response.statusCode == 200 && jsonBody['success'] == true) {
        Get.to(() => const DetailsScreen(), arguments: id);
      } else {
        final message =
            jsonBody['message']?.toString() ?? 'Failed to load boat details';
        Get.snackbar(
          'Error',
          message,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      EasyLoading.dismiss();
      Get.snackbar(
        'Error',
        'Could not load boat details: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Widget _buildDetail(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          value.substring(0, value.length > 10 ? 10 : value.length),
          style: TextStyle(fontSize: 12, color: Colors.grey[700]),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5FEFF),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top Stack Section (Search Bar)
            Stack(
              children: [
                Image.asset(
                  Imagepath.homeBoat,
                  height: 244,
                  width: double.infinity,
                  fit: BoxFit.fill,
                ),
                Positioned(
                  bottom: 15,
                  left: 20,
                  right: 20,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () => setState(
                            () => _showLimitSlider = !_showLimitSlider,
                          ),
                          child: Image.asset(
                            Iconpath.customTune,
                            width: 25,
                            height: 25,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            onSubmitted: (value) => _handleAiSearch(value),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText:
                                  "Find me a Viking for sale from 2005 to 2008",
                              hintStyle: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                        Obx(
                          () => TextButton(
                            onPressed: _isLoading.value
                                ? null
                                : () => _handleAiSearch(_searchController.text),
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 8,
                              ),
                              backgroundColor: Colors.grey[200],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                              foregroundColor: Colors.black,
                              elevation: 0,
                            ),
                            child: _isLoading.value
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Row(
                                    children: [
                                      Image.asset(
                                        Iconpath.askAi,
                                        width: 18,
                                        height: 18,
                                      ),
                                      const SizedBox(width: 6),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 2,
                                        ),
                                        child: Text(
                                          "Ask AI",
                                          style: getTextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Limit Slider
            if (_showLimitSlider)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 4,
                ),
                child: Row(
                  children: [
                    const Text(
                      'Limit:',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                      ),
                    ),
                    Expanded(
                      child: Slider(
                        value: _limit,
                        min: 0,
                        max: 100,
                        divisions: 100,
                        activeColor: const Color(0xFF00A3AC),
                        label: _limit.toInt().toString(),
                        onChanged: (value) => setState(() => _limit = value),
                      ),
                    ),
                    SizedBox(
                      width: 36,
                      child: Text(
                        _limit.toInt().toString(),
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 20),

            // Results Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Search Results',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    '${_results.length} found',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            // Results List
            if (_results.isEmpty)
              Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.search, size: 64, color: Colors.grey[300]),
                    const SizedBox(height: 16),
                    Text(
                      'No results found',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              )
            else
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _results.length,
                  itemBuilder: (context, index) {
                    final yacht = _results[index];
                    return GestureDetector(
                      onTap: () => _navigateToDetails(yacht.id),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.horizontal(
                                left: Radius.circular(12),
                              ),
                              child: Image.network(
                                yacht.image,
                                width: 120,
                                height: 120,
                                fit: BoxFit.cover,
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Container(
                                        width: 120,
                                        height: 120,
                                        color: Colors.grey[200],
                                        child: const Center(
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                        ),
                                      );
                                    },
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.asset(
                                    Imagepath.singleBoat,
                                    width: 120,
                                    height: 120,
                                    fit: BoxFit.cover,
                                  );
                                },
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      yacht.title,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.location_on,
                                          size: 12,
                                          color: Colors.grey,
                                        ),
                                        const SizedBox(width: 2),
                                        Expanded(
                                          child: Text(
                                            yacht.location,
                                            style: TextStyle(
                                              fontSize: 11,
                                              color: Colors.grey[600],
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        _buildDetail("Make", yacht.make),
                                        _buildDetail("Year", yacht.year),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      "Price: ${yacht.price}",
                                      style: const TextStyle(
                                        color: Color(0xFF00A3AC),
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
