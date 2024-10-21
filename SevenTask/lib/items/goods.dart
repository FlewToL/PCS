import 'package:flutter/material.dart';
import 'package:medicine_app/objects/goods_class.dart';

class GoodsItem extends StatefulWidget {
  final Goods item;

  const GoodsItem({super.key, required this.item});

  @override
  State<StatefulWidget> createState() => _StateGoodsItem();
}

class _StateGoodsItem extends State<GoodsItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // Добавляем отступы между контейнерами
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0.0),
      decoration: BoxDecoration(
        color: Colors.white, // Белый фон
        border: Border.all(color: Colors.grey.shade300), // Серая обводка
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.item.title,
              style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w400,
                fontFamily: 'Montserrat',
              ),
            ),
            const SizedBox(height: 16.0),
            // Используем Stack вместо Row
            SizedBox(
              height: 60.0, // Фиксированная высота для корректного размещения
              child: Stack(
                children: [
                  Positioned(
                    left: 0,
                    top: 0,
                    bottom: 28,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '${widget.item.days} ${_getDayWord(widget.item.days)}',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w400,
                          fontSize: 18.0,
                          fontFamily: 'Montserrat',
                        ),
                      ),
                    ),
                  ),
                  // Цена, позиционируем слева
                  Positioned(
                    left: 0,
                    top: 30,
                    bottom: 0,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '${widget.item.price.round()} ₽',
                        style: const TextStyle(
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Montserrat',
                          fontSize: 22.0,
                        ),
                      ),
                    ),
                  ),
                  // Кнопка "Добавить", позиционируем справа
                  Positioned(
                    right: 0,
                    top: 10,
                    bottom: 0,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          widget.item.inCart += 1;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1A6DE7),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(16.0), // Закругления
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 8.0,
                        ),
                      ),
                      child: const Text(
                        'Добавить',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Montserrat',
                        ),
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

  // Метод для правильного склонения слова "день"
  String _getDayWord(int days) {
    if (days % 10 == 1 && days % 100 != 11) {
      return 'день';
    } else if ([2, 3, 4].contains(days % 10) &&
        ![12, 13, 14].contains(days % 100)) {
      return 'дня';
    } else {
      return 'дней';
    }
  }
}
