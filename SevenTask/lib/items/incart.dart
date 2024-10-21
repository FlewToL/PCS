import 'package:flutter/material.dart';
import 'package:medicine_app/objects/goods_class.dart';

class CartItem extends StatefulWidget {
  final Goods item;
  final VoidCallback onUpdate;

  const CartItem({super.key, required this.item, required this.onUpdate});

  @override
  State<StatefulWidget> createState() => _StateCartItem();
}

class _StateCartItem extends State<CartItem> {
  String _getPatientWord(int count) {
    if (count % 10 == 1 && count % 100 != 11) {
      return 'пациент';
    } else if ([2, 3, 4].contains(count % 10) &&
        ![12, 13, 14].contains(count % 100)) {
      return 'пациента';
    } else {
      return 'пациентов';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8.0, right: 30.0),
                child: Text(
                  widget.item.title,
                  style: const TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              const SizedBox(height: 32.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Цена
                  Text(
                    '${widget.item.price.round()} ₽',
                    style: const TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${widget.item.inCart} ${_getPatientWord(widget.item.inCart)}',
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w300,
                          fontSize: 18.0,
                        ),
                      ),
                      const SizedBox(width: 16.0),
                      Container(
                        width: 72, // Уменьшенная ширина контейнера
                        height: 36,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F5F9),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 24,
                              height: 24,
                              child: IconButton(
                                icon: const Icon(
                                  Icons.remove,
                                  size: 24,
                                  color: Color(0xFFB8C1CC),
                                ),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(
                                  minWidth: 24,
                                  minHeight: 24,
                                ),
                                onPressed: () {
                                  setState(() {
                                    if (widget.item.inCart > 0) {
                                      widget.item.inCart -= 1;
                                      widget.onUpdate();
                                    }
                                  });
                                },
                              ),
                            ),
                            const SizedBox(width: 6),
                            Container(
                              width: 1,
                              height: 16,
                              color: const Color(0xFFEBEBEB),
                            ),
                            const SizedBox(width: 6),
                            SizedBox(
                              width: 24,
                              height: 24,
                              child: IconButton(
                                icon: const Icon(
                                  Icons.add,
                                  size: 24,
                                  color: Color(0xFF939396),
                                ),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(
                                  minWidth: 24,
                                  minHeight: 24,
                                ),
                                onPressed: () {
                                  setState(() {
                                    widget.item.inCart += 1;
                                    widget.onUpdate();
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          Positioned(
            top: -10,
            right: -10,
            child: IconButton(
              icon: const Icon(
                Icons.close,
                size: 24,
                color: Color(0xFF7D7D99),
              ),
              onPressed: () {
                setState(() {
                  widget.item.inCart = 0;
                  widget.onUpdate();
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
