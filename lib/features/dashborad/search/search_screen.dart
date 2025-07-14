import 'package:afronika/common/product_card.dart';
import 'package:afronika/utils/constant/app_test_style.dart';
import 'package:afronika/utils/constant/image_strings.dart';
import 'package:afronika/utils/device/device_utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../utils/constant/colors.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  // Sample search data
  List<Map<String, dynamic>> allProducts = [
    {
      'title': 'Casual Dress',
      'price': '394',
      'image': GImagePath.image1,
      'category': 'Dresses',
      'isPopular': true,
    },
    {
      'title': 'T-Shirt',
      'price': '210',
      'image': 'GImagePath.image2',
      'category': 'Shirts',
      'isPopular': false,
    },
    {
      'title': 'Summer Dress',
      'price': '450',
      'image': 'GImagePath.image1',
      'category': 'Dresses',
      'isPopular': true,
    },
    {
      'title': 'Polo Shirt',
      'price': '320',
      'image': 'GImagePath.image2',
      'category': 'Shirts',
      'isPopular': false,
    },
    {
      'title': 'Evening Dress',
      'price': '680',
      'image': 'GImagePath.image1',
      'category': 'Dresses',
      'isPopular': true,
    },
    {
      'title': 'Casual Shirt',
      'price': '280',
      'image': 'GImagePath.image2',
      'category': 'Shirts',
      'isPopular': false,
    },
  ];

  List<Map<String, dynamic>> filteredProducts = [];
  List<String> recentSearches = ['Summer Dress', 'Casual Wear', 'T-Shirt'];
  List<String> popularSearches = ['Dresses', 'Shirts', 'Casual', 'Evening Wear'];

  String selectedCategory = 'All';
  String selectedSortBy = 'Popular';

  @override
  void initState() {
    super.initState();
    filteredProducts = allProducts;
    _focusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _filterProducts(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredProducts = allProducts;
      } else {
        filteredProducts = allProducts
            .where((product) =>
        product['title'].toLowerCase().contains(query.toLowerCase()) ||
            product['category'].toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
      _applySortAndFilter();
    });
  }

  void _applySortAndFilter() {
    // Apply category filter
    if (selectedCategory != 'All') {
      filteredProducts = filteredProducts
          .where((product) => product['category'] == selectedCategory)
          .toList();
    }

    // Apply sorting
    switch (selectedSortBy) {
      case 'Popular':
        filteredProducts.sort((a, b) => b['isPopular'] ? 1 : -1);
        break;
      case 'Price: Low to High':
        filteredProducts.sort((a, b) =>
            int.parse(a['price']).compareTo(int.parse(b['price'])));
        break;
      case 'Price: High to Low':
        filteredProducts.sort((a, b) =>
            int.parse(b['price']).compareTo(int.parse(a['price'])));
        break;
      case 'A-Z':
        filteredProducts.sort((a, b) =>
            a['title'].compareTo(b['title']));
        break;
    }
  }

  void _addToRecentSearches(String search) {
    if (search.isNotEmpty && !recentSearches.contains(search)) {
      setState(() {
        recentSearches.insert(0, search);
        if (recentSearches.length > 5) {
          recentSearches.removeLast();
        }
      });
    }
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildFilterBottomSheet(),
    );
  }

  Widget _buildFilterBottomSheet() {
    final bool isDark = ADeviceUtils.isDarkMode(context);

    return StatefulBuilder(
      builder: (context, setModalState) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.6,
          decoration: BoxDecoration(
            color: isDark ? Colors.grey[900] : Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Filter & Sort',
                      style: AappTextStyle.roboto(
                        color: isDark ? Colors.white : Colors.black,
                        fontSize: 18,
                        weight: FontWeight.w600,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setModalState(() {
                          selectedCategory = 'All';
                          selectedSortBy = 'Popular';
                        });
                        setState(() {
                          selectedCategory = 'All';
                          selectedSortBy = 'Popular';
                        });
                        _filterProducts(_searchController.text);
                      },
                      child: Text(
                        'Reset',
                        style: AappTextStyle.roboto(
                          color: AColors.primary,
                          fontSize: 14,
                          weight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Category',
                        style: AappTextStyle.roboto(
                          color: isDark ? Colors.white : Colors.black,
                          fontSize: 16,
                          weight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: ['All', 'Dresses', 'Shirts', 'Pants', 'Accessories']
                            .map((category) => FilterChip(
                          label: Text(
                            category,
                            style: AappTextStyle.roboto(
                              color: selectedCategory == category
                                  ? AColors.primary
                                  : (isDark ? Colors.white : Colors.black),
                              fontSize: 12,
                              weight: FontWeight.w400,
                            ),
                          ),
                          selected: selectedCategory == category,
                          onSelected: (selected) {
                            setModalState(() {
                              selectedCategory = category;
                            });
                            setState(() {
                              selectedCategory = category;
                            });
                          },
                          selectedColor: AColors.primary.withOpacity(0.2),
                          checkmarkColor: AColors.primary,
                          backgroundColor: isDark ? Colors.grey[800] : Colors.grey[100],
                        ))
                            .toList(),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Sort By',
                        style: AappTextStyle.roboto(
                          color: isDark ? Colors.white : Colors.black,
                          fontSize: 16,
                          weight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...['Popular', 'Price: Low to High', 'Price: High to Low', 'A-Z']
                          .map((sortOption) => RadioListTile<String>(
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          sortOption,
                          style: AappTextStyle.roboto(
                            color: isDark ? Colors.white : Colors.black,
                            fontSize: 14,
                            weight: FontWeight.w400,
                          ),
                        ),
                        value: sortOption,
                        groupValue: selectedSortBy,
                        activeColor: AColors.primary,
                        onChanged: (value) {
                          setModalState(() {
                            selectedSortBy = value!;
                          });
                          setState(() {
                            selectedSortBy = value!;
                          });
                        },
                      ))
                          .toList(),
                    ],
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      _filterProducts(_searchController.text);
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Apply Filters',
                      style: AappTextStyle.roboto(
                        color: Colors.white,
                        fontSize: 16,
                        weight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = ADeviceUtils.isDarkMode(context);
    final bool isSearching = _searchController.text.isNotEmpty;
    final bool isSearchFocused = _focusNode.hasFocus;

    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.white,
      appBar: AppBar(
        backgroundColor: isDark ? Colors.black : Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Search',
          style: AappTextStyle.roboto(
            color: isDark ? Colors.white : Colors.black,
            fontSize: 18,
            weight: FontWeight.w600,
          ),
        ),
      ),
      body: Column(
        children: [
          // Search bar in body
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: TextField(
                      controller: _searchController,
                      focusNode: _focusNode,

                      onChanged: _filterProducts,
                      onSubmitted: (value) {
                        _addToRecentSearches(value);
                        _focusNode.unfocus();
                      },
                      decoration: InputDecoration(
                        hintText: 'Search for products...',
                        hintStyle: AappTextStyle.roboto(
                          color: Colors.grey[500]!,
                          fontSize: 14,
                          weight: FontWeight.w400,
                        ),
                        prefixIcon: const Icon(Icons.search, size: 20),
                        suffixIcon: isSearching
                            ? IconButton(
                          icon: const Icon(Icons.clear, size: 20),
                          onPressed: () {
                            _searchController.clear();
                            _filterProducts('');
                          },
                        )
                            : null,
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                      style: AappTextStyle.roboto(
                        color: isDark ? Colors.white : Colors.black,
                        fontSize: 14,
                        weight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  height: 48,
                  width: 48,
                  decoration: BoxDecoration(
                    color: AColors.primary,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.tune, color: Colors.white),
                    onPressed: _showFilterBottomSheet,
                  ),
                ),
              ],
            ),
          ),
          // Search suggestions when focused and not searching
          if (isSearchFocused && !isSearching)
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (recentSearches.isNotEmpty) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Recent Searches',
                            style: AappTextStyle.roboto(
                              color: isDark ? Colors.white : Colors.black,
                              fontSize: 16,
                              weight: FontWeight.w500,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                recentSearches.clear();
                              });
                            },
                            child: Text(
                              'Clear All',
                              style: AappTextStyle.roboto(
                                color: AColors.primary,
                                fontSize: 12,
                                weight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ...recentSearches.map((search) => ListTile(
                        leading: const Icon(Icons.history, size: 20),
                        title: Text(
                          search,
                          style: AappTextStyle.roboto(
                            color: isDark ? Colors.white : Colors.black,
                            fontSize: 14,
                            weight: FontWeight.w400,
                          ),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.close, size: 18),
                          onPressed: () {
                            setState(() {
                              recentSearches.remove(search);
                            });
                          },
                        ),
                        onTap: () {
                          _searchController.text = search;
                          _filterProducts(search);
                          _focusNode.unfocus();
                        },
                      )),
                      const SizedBox(height: 16),
                    ],
                    Text(
                      'Popular Searches',
                      style: AappTextStyle.roboto(
                        color: isDark ? Colors.white : Colors.black,
                        fontSize: 16,
                        weight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: popularSearches.map((search) => GestureDetector(
                        onTap: () {
                          _searchController.text = search;
                          _filterProducts(search);
                          _focusNode.unfocus();
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[300]!),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            search,
                            style: AappTextStyle.roboto(
                              color: isDark ? Colors.white : Colors.black,
                              fontSize: 12,
                              weight: FontWeight.w400,
                            ),
                          ),
                        ),
                      )).toList(),
                    ),
                  ],
                ),
              ),
            )
          else
          // Search results
            Expanded(
              child: Column(
                children: [
                  if (isSearching) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${filteredProducts.length} results found',
                            style: AappTextStyle.roboto(
                              color: isDark ? Colors.white : Colors.black,
                              fontSize: 14,
                              weight: FontWeight.w400,
                            ),
                          ),
                          if (selectedCategory != 'All' || selectedSortBy != 'Popular')
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: AColors.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'Filtered',
                                style: AappTextStyle.roboto(
                                  color: AColors.primary,
                                  fontSize: 10,
                                  weight: FontWeight.w500,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const Divider(height: 1),
                  ],
                  Expanded(
                    child: filteredProducts.isEmpty
                        ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No results found',
                            style: AappTextStyle.roboto(
                              color: Colors.grey[600]!,
                              fontSize: 16,
                              weight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Try adjusting your search or filters',
                            style: AappTextStyle.roboto(
                              color: Colors.grey[500]!,
                              fontSize: 14,
                              weight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    )
                        : GridView.builder(
                      padding: const EdgeInsets.all(16),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.7,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      itemCount: filteredProducts.length,
                      itemBuilder: (context, index) {
                        final product = filteredProducts[index];
                        return SizedBox(
                          height: 250,
                          child: ProductCard(
                            imagePath: GImagePath.image1, // Use actual image path
                            title: product['title'],
                            price: product['price'],
                            isDark: isDark,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}