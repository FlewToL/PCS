import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shop_app/src/objects/food_class.dart';
import 'package:image_picker/image_picker.dart';

class AddFoodPage extends StatefulWidget {
  final Function(Food) onAddFood;

  const AddFoodPage({super.key, required this.onAddFood});

  @override
  State<AddFoodPage> createState() => _AddFoodPageState();
}

class _AddFoodPageState extends State<AddFoodPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _expDateController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _salePriceController = TextEditingController();
  final TextEditingController _countController = TextEditingController();
  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _caloriesController = TextEditingController();
  final TextEditingController _fatController = TextEditingController();
  final TextEditingController _proteinController = TextEditingController();
  final TextEditingController _carbohydrateController = TextEditingController();

  String? _imagePath;

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _imagePath = image.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Добавить новый товар',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
        ),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.black,
        actions: [
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.check, size: 26,),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                Food newFood = Food(
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
                widget.onAddFood(newFood);
                Navigator.pop(context);
              }
            },
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
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Название'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Пожалуйста, введите название товара';
                  }
                  return null;
                },
              ),
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
              TextFormField(
                controller: _weightController,
                decoration: const InputDecoration(labelText: 'Вес'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Пожалуйста, введите вес товара';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _expDateController,
                decoration:
                    const InputDecoration(labelText: 'Условия хранения'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Пожалуйста, введите условия хранения товара';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Цена'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Пожалуйста, введите цену товара';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _salePriceController,
                decoration: const InputDecoration(labelText: 'Цена по скидке'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Пожалуйста, введите скидочную цену товара.\n'
                        'Если без скидки, укажите такую же цену как и в поле '
                        '"Цена"';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _countController,
                decoration: const InputDecoration(labelText: 'В наличии'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Пожалуйста, введите кол-во товара на складе';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _brandController,
                decoration: const InputDecoration(labelText: 'Производитель'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Пожалуйста, введите название производителя товара';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _caloriesController,
                decoration: const InputDecoration(labelText: 'Калории'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Пожалуйста, укажите калории';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _fatController,
                decoration: const InputDecoration(labelText: 'Жиры на 100г'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Пожалуйста, укажите жиры на 100г';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _proteinController,
                decoration: const InputDecoration(labelText: 'Белки на 100г'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Пожалуйста, укажите белки на 100г';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _carbohydrateController,
                decoration:
                    const InputDecoration(labelText: 'Углеводы на 100г'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Пожалуйста, укажите углеводы на 100г';
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
                  'Загрузить изображение',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
              const SizedBox(height: 10),
              _imagePath != null
                  ? Image.file(
                      File(_imagePath!),
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
