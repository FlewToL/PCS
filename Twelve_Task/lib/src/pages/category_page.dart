import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/src/objects/food_class.dart';
import 'package:shop_app/src/items/food_item.dart';
import 'package:shop_app/src/objects/categories_class.dart';
import 'package:shop_app/src/objects/favorites_provider_class.dart';
import 'package:shop_app/src/objects/shopping_cart_class.dart';

import 'add_food_page.dart';
import 'package:shop_app/src/service/food_service.dart';

class CategoryPage extends StatefulWidget {
  final Category category;

  const CategoryPage({super.key, required this.category});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  final FoodService _foodService = FoodService();
  late Future<List<Food>> _foodsFuture;
  List<Food> _allFoods = [];
  List<Food> _filteredFoods = [];
  double _minPrice = 0;
  double _maxPrice = 1000;
  String _searchQuery = '';
  bool _isFilterVisible = false;
  bool _isSaleFilterEnabled = false;
  String _selectedSortMethod = 'default';

  @override
  void initState() {
    super.initState();
    _foodsFuture = _foodService.getAllFoods();
  }

  List<Food> getFoodsByCategory(List<Food> allFoods, Category category) {
    switch (category.article) {
      case 'food_1':
        return allFoods.where((food) => food.art == 'veg_food').toList();
      case 'food_2':
        return allFoods.where((food) => food.art == 'bak_food').toList();
      case 'food_3':
        return allFoods.where((food) => food.art == 'mea_food').toList();
      case 'food_4':
        return allFoods.where((food) => food.art == 'fis_food').toList();
      default:
        return [];
    }
  }

  Future<void> deleteFood(Food food) async {
    try {
      await _foodService.deleteFood(food.id!);
      setState(() {
        _foodsFuture = _foodService.getAllFoods();
      });

      final favoritesProvider =
          Provider.of<FavoritesProvider>(context, listen: false);
      favoritesProvider.removeFavorite(food.id!);
      final shoppingCart = Provider.of<ShoppingCart>(context, listen: false);
      shoppingCart.removeItem(food);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка при удалении продукта: $e')));
    }
  }

  void sortFoods() {
    switch (_selectedSortMethod) {
      case 'price_asc':
        _filteredFoods.sort((a, b) => a.salePrice.compareTo(b.salePrice));
        break;
      case 'price_desc':
        _filteredFoods.sort((a, b) => b.salePrice.compareTo(a.salePrice));
        break;
      case 'default':
      default:
        _filteredFoods.sort((a, b) => a.id!.compareTo(b.id!));
        break;
    }
    setState(() {});
  }

  void filterFoods() {
    setState(() {
      _filteredFoods = _allFoods.where((food) {
        bool isPriceValid = food.salePrice >= _minPrice && food.salePrice <= _maxPrice;
        bool isSaleValid =
            !_isSaleFilterEnabled || (food.salePrice < food.price);
        return isPriceValid && isSaleValid;
      }).toList();

      sortFoods();
    });
  }

  void searchFoods(String query) {
    setState(() {
      _searchQuery = query;
      _filteredFoods = _allFoods.where((food) {
        return food.title.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  Future<void> addFood(Food food) async {
    try {
      await _foodService.addFood(food);
      setState(() {
        _foodsFuture = _foodService.getAllFoods();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка при добавлении продукта: $e')));
    }
  }

  void _showSortDialog() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter modalSetState) {
            return Container(
              padding: const EdgeInsets.all(16.0),
              height: MediaQuery.of(context).size.height / 3,
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Сортировка',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        iconSize: 28,
                        color: Colors.black,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildSortOption(
                    context,
                    modalSetState,
                    title: 'По умолчанию',
                    value: 'default',
                  ),
                  Divider(color: Colors.grey[300], thickness: 1),
                  _buildSortOption(
                    context,
                    modalSetState,
                    title: 'По возрастанию цены',
                    value: 'price_asc',
                  ),
                  Divider(color: Colors.grey[300], thickness: 1),
                  _buildSortOption(
                    context,
                    modalSetState,
                    title: 'По убыванию цены',
                    value: 'price_desc',
                  ),
                  const Spacer(),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSortOption(
    BuildContext context,
    StateSetter modalSetState, {
    required String title,
    required String value,
  }) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(fontSize: 20),
      ),
      trailing: Transform.scale(
        scale: 1.2,
        child: Radio<String>(
          value: value,
          groupValue: _selectedSortMethod,
          activeColor: Colors.green,
          onChanged: (selectedValue) {
            modalSetState(() {
              _selectedSortMethod = selectedValue!;
            });
            setState(() {
              sortFoods();
            });
          },
        ),
      ),
      onTap: () {
        modalSetState(() {
          _selectedSortMethod = value;
        });
        setState(() {
          sortFoods();
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final shoppingCart = Provider.of<ShoppingCart>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Text(
              widget.category.title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
            ),
            centerTitle: true,
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.transparent,
            shadowColor: Colors.black,
            pinned: true,
            floating: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.swap_vert_outlined),
                color: Colors.black,
                iconSize: 28,
                tooltip: 'Сортировка',
                onPressed: _showSortDialog,
              ),
              IconButton(
                icon: const Icon(Icons.filter_alt_outlined),
                color: Colors.black,
                iconSize: 28,
                tooltip: 'Фильтровать по цене',
                onPressed: () {
                  setState(() {
                    _isFilterVisible = !_isFilterVisible;
                  });
                },
              ),
              IconButton(
                icon: const Icon(Icons.add),
                color: Colors.black,
                iconSize: 28,
                tooltip: 'Добавить товар',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddFoodPage(
                        onAddFood: (food) {
                          addFood(food);
                        },
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(width: 12),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                onChanged: searchFoods,
                cursorColor: const Color(0xFF60CA00),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFFEAEAEA),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide.none,
                  ),
                  hintText: 'Найти товар',
                  hintStyle: const TextStyle(
                      color: Color(0xFF757575),
                      fontSize: 18,
                      fontWeight: FontWeight.w400),
                  prefixIcon: const Icon(Icons.search),
                ),
                style: const TextStyle(
                  color: Color(0xFF676767),
                  fontSize: 18,
                ),
              ),
            ),
          ),
          if (_isFilterVisible)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Row(
                          children: [
                            Icon(
                              Icons.call_to_action,
                              color: Color(0xFF555555),
                              size: 18,
                            ),
                            SizedBox(width: 4),
                            Text(
                              'Товары со скидкой',
                              style: TextStyle(
                                fontSize: 18,
                                color: Color(0xFF555555),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 2),
                        Transform.scale(
                          scale: 0.9,
                          child: SwitchTheme(
                            data: SwitchThemeData(
                              thumbColor: WidgetStateProperty.resolveWith<Color?>(
                                    (states) {
                                  if (states.contains(WidgetState.selected)) {
                                    return const Color(0xFF60CA00);
                                  }
                                  return const Color(0xFFFFFFFF);
                                },
                              ),
                              trackColor: WidgetStateProperty.resolveWith<Color?>(
                                    (states) {
                                  if (states.contains(WidgetState.selected)) {
                                    return const Color(0xFFB2F2A5);
                                  }
                                  return const Color(0xFFDADADA);
                                },
                              ),
                            ),
                            child: Switch(
                              trackOutlineWidth: WidgetStateProperty. resolveWith<double?>((Set<WidgetState> states) {
                                if (states. contains(WidgetState.disabled)) {
                                  return 0.0;
                                }
                              }),
                              value: _isSaleFilterEnabled,
                              onChanged: (bool value) {
                                setState(() {
                                  _isSaleFilterEnabled = value;
                                });
                                filterFoods();
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Row(
                          children: [
                            Icon(
                              Icons.currency_ruble_outlined,
                              color: Color(0xFF555555),
                              size: 18,
                            ),
                            SizedBox(width: 4),
                            Text(
                              'Цена',
                              style: TextStyle(
                                fontSize: 18,
                                color: Color(0xFF555555),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          '${_minPrice.round()} ₽  -  ${_maxPrice.round()} ₽',
                          style: const TextStyle(
                            fontSize: 18,
                            color: Color(0xFF555555),
                          ),
                        ),
                      ],
                    ),
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        trackHeight: 2,
                        activeTrackColor: const Color(0xFF60CA00),
                        inactiveTrackColor: const Color(0xFFDADADA),
                        thumbColor: const Color(0xFFFFFFFF),
                        thumbShape: const RoundSliderThumbShape(
                          enabledThumbRadius: 24,
                        ),
                        overlayShape: const RoundSliderOverlayShape(
                          overlayRadius: 24,
                        ),
                        overlayColor: const Color(0x2960CA00),
                        valueIndicatorColor: const Color(0xFF60CA00),
                      ),
                      child: RangeSlider(
                        values: RangeValues(_minPrice, _maxPrice),
                        min: 0,
                        max: 1000,
                        divisions: 1000,
                        labels: RangeLabels(
                          _minPrice.toStringAsFixed(0),
                          _maxPrice.toStringAsFixed(0),
                        ),
                        onChanged: (values) {
                          setState(() {
                            _minPrice = values.start;
                            _maxPrice = values.end;
                          });
                          filterFoods();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          FutureBuilder<List<Food>>(
            future: _foodsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SliverToBoxAdapter(
                    child: Center(child: CircularProgressIndicator()));
              } else if (snapshot.hasError) {
                return SliverToBoxAdapter(
                  child: Center(
                    child: Text(
                      'Ошибка: ${snapshot.error}',
                      style: const TextStyle(fontSize: 18, color: Colors.red),
                    ),
                  ),
                );
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const SliverToBoxAdapter(
                  child: Center(
                    child: Text(
                      'Здесь пока ничего нет =\'(',
                      style: TextStyle(fontSize: 20, color: Colors.grey),
                    ),
                  ),
                );
              } else {
                _allFoods = snapshot.data!;
                _filteredFoods = getFoodsByCategory(_allFoods, widget.category);

                _filteredFoods = _filteredFoods
                    .where((food) => food.title
                        .toLowerCase()
                        .contains(_searchQuery.toLowerCase()))
                    .toList();

                _filteredFoods = _filteredFoods
                    .where((food) =>
                        food.salePrice >= _minPrice && food.salePrice <= _maxPrice)
                    .toList();

                if (_isSaleFilterEnabled) {
                  _filteredFoods = _filteredFoods
                      .where((food) => food.salePrice < food.price)
                      .toList();
                }

                if (_selectedSortMethod == 'price_asc') {
                  _filteredFoods.sort((a, b) => a.salePrice.compareTo(b.salePrice));
                } else if (_selectedSortMethod == 'price_desc') {
                  _filteredFoods.sort((a, b) => b.salePrice.compareTo(a.salePrice));
                }

                return SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return GestureDetector(
                        child: FoodItem(
                          item: _filteredFoods[index],
                          onDelete: () => deleteFood(_filteredFoods[index]),
                          onUpdate: () => setState(() {}),
                          onAdd: () {
                            shoppingCart.addItem(_filteredFoods[index]);
                          },
                          onRemove: () {
                            shoppingCart.removeItem(_filteredFoods[index]);
                          },
                          onIncrement: () {
                            shoppingCart.incrementItem(_filteredFoods[index]);
                          },
                          onDecrement: () {
                            shoppingCart.decrementItem(_filteredFoods[index]);
                          },
                        ),
                      );
                    },
                    childCount: _filteredFoods.length,
                  ),
                );
              }
            },
          )
        ],
      ),
    );
  }
}
