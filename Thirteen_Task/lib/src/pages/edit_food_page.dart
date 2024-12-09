import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shop_app/src/objects/food_class.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shop_app/src/service/food_service.dart';

class EditFoodPage extends StatefulWidget {
  final Food food;
  final VoidCallback onUpdate;

  const EditFoodPage({
    Key? key,
    required this.food,
    required this.onUpdate,
  }) : super(key: key);

  @override
  State<EditFoodPage> createState() => _EditFoodPageState();
}

class _EditFoodPageState extends State<EditFoodPage> {
  final _formKey = GlobalKey<FormState>();
  final FoodService _foodService = FoodService();
  late Future<List<Food>> _foodsFuture;

  late TextEditingController _artController;
  late TextEditingController _titleController;
  late TextEditingController _descController;
  late TextEditingController _weightController;
  late TextEditingController _expDateController;
  late TextEditingController _priceController;
  late TextEditingController _salePriceController;
  late TextEditingController _countController;
  late TextEditingController _brandController;
  late TextEditingController _caloriesController;
  late TextEditingController _fatController;
  late TextEditingController _proteinController;
  late TextEditingController _carbohydrateController;

  String? _imagePath;

  @override
  void initState() {
    super.initState();
    _artController = TextEditingController(text: widget.food.art.toString());
    _titleController = TextEditingController(text: widget.food.title);
    _descController = TextEditingController(text: widget.food.desc.toString());
    _weightController =
        TextEditingController(text: widget.food.weight.toString());
    _expDateController =
        TextEditingController(text: widget.food.expDate.toString());
    _priceController =
        TextEditingController(text: widget.food.price.toString());
    _salePriceController =
        TextEditingController(text: widget.food.salePrice.toString());
    _countController =
        TextEditingController(text: widget.food.count.toString());
    _brandController =
        TextEditingController(text: widget.food.brand.toString());
    _caloriesController =
        TextEditingController(text: widget.food.calories.toString());
    _fatController = TextEditingController(text: widget.food.fat.toString());
    _proteinController =
        TextEditingController(text: widget.food.protein.toString());
    _carbohydrateController =
        TextEditingController(text: widget.food.carbohydrate.toString());

    _imagePath = widget.food.img != 'assets/images/default_image.png'
        ? widget.food.img
        : null;
  }

  @override
  void dispose() {
    _artController.dispose();
    _titleController.dispose();
    _descController.dispose();
    _weightController.dispose();
    _expDateController.dispose();
    _priceController.dispose();
    _salePriceController.dispose();
    _countController.dispose();
    _brandController.dispose();
    _caloriesController.dispose();
    _fatController.dispose();
    _proteinController.dispose();
    _carbohydrateController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _imagePath = image.path;
      });
    }
  }

  void updateCallback() {
    setState(() {
      _foodsFuture = _foodService.getAllFoods();
    });
  }

  void _saveEdits() async {
    if (_formKey.currentState!.validate()) {
      Food updatedFood = Food(
        id: widget.food.id,
        art: _artController.text,
        title: _titleController.text,
        desc: _descController.text,
        weight: int.parse(_weightController.text),
        expDate: _expDateController.text,
        price: double.parse(_priceController.text),
        salePrice: double.parse(_salePriceController.text),
        count: int.parse(_countController.text),
        brand: _brandController.text,
        calories: double.parse(_caloriesController.text),
        fat: double.parse(_fatController.text),
        protein: double.parse(_proteinController.text),
        carbohydrate: double.parse(_carbohydrateController.text),
        img: _imagePath ?? 'assets/images/default_image.png',
      );

      await _foodService.updateFood(updatedFood);
      widget.onUpdate();
      Navigator.pop(context);
    }
  }

  Widget _buildImage(String imgPath) {
    if (imgPath.startsWith('assets/')) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(16.0),
        child: Image.asset(
          imgPath,
          height: 300,
          width: 300,
          fit: BoxFit.contain,
          errorBuilder:
              (BuildContext context, Object exception, StackTrace? stackTrace) {
            return const Icon(
              Icons.image_not_supported,
              size: 300,
              color: Colors.grey,
            );
          },
        ),
      );
    } else {
      File imageFile = File(imgPath);
      if (imageFile.existsSync()) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(16.0),
          child: Image.file(
            imageFile,
            height: 300,
            width: 300,
            fit: BoxFit.contain,
            errorBuilder: (BuildContext context, Object exception,
                StackTrace? stackTrace) {
              return const Icon(
                Icons.image_not_supported,
                size: 300,
                color: Colors.grey,
              );
            },
          ),
        );
      } else {
        return const Icon(
          Icons.image_not_supported,
          size: 300,
          color: Colors.grey,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Редактировать товар',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.check, size: 26),
            onPressed: _saveEdits,
          ),
          const SizedBox(width: 12),
        ],
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _artController,
                decoration: const InputDecoration(labelText: 'Артикул'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Пожалуйста, введите артикул товара';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Название'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Пожалуйста, введите название товара';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _descController,
                decoration: const InputDecoration(labelText: 'Описание'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Пожалуйста, введите описание товара';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _weightController,
                decoration: const InputDecoration(labelText: 'Вес (г)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Пожалуйста, введите вес товара';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Вес должен быть числом';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _expDateController,
                decoration: const InputDecoration(labelText: 'Срок годности'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Пожалуйста, введите срок годности';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Цена'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Пожалуйста, введите цену';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Цена должна быть числом';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _salePriceController,
                decoration: const InputDecoration(labelText: 'Цена со скидкой'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Пожалуйста, введите цену со скидкой';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Цена со скидкой должна быть числом';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _countController,
                decoration: const InputDecoration(labelText: 'Количество'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Пожалуйста, введите количество';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Количество должно быть числом';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _caloriesController,
                decoration: const InputDecoration(labelText: 'Калории'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Пожалуйста, введите количество калорий';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Калории должны быть числом';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _fatController,
                decoration: const InputDecoration(labelText: 'Жиры (г)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Пожалуйста, введите количество жиров';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Жиры должны быть числом';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _proteinController,
                decoration: const InputDecoration(labelText: 'Белки (г)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Пожалуйста, введите количество белков';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Белки должны быть числом';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _carbohydrateController,
                decoration: const InputDecoration(labelText: 'Углеводы (г)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Пожалуйста, введите количество углеводов';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Углеводы должны быть числом';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _pickImage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                child: const Text(
                  'Изменить изображение',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
              const SizedBox(height: 10),
              _imagePath != null
                  ? _buildImage(_imagePath!)
                  : widget.food.img != 'assets/images/default_image.png'
                      ? Image.asset(
                          widget.food.img,
                          width: 300,
                          height: 300,
                          fit: BoxFit.cover,
                        )
                      : const Text('Изображение не выбрано'),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
