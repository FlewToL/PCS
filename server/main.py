import asyncio

from fastapi import FastAPI, HTTPException

from api_flutter.database.models import Food, CartItem, OrderResponse, CheckoutRequest, Order, OrderItemResponse
from test import logger
from typing import List
import uvicorn

from api_flutter.database import Goods
from api_flutter.database.connection import async_session_factory
from api_flutter.database.tables_creation import create_tables
from api_flutter.services.sql_queries import (
    get_all_goods,
    get_goods_by_id,
    add_new_goods,
    delete_goods,
    update_goods,
    get_all_goods_in_favorite,
    get_goods_in_favorite_by_id,
    delete_goods_from_favorite,
    add_goods_in_favorite,
    get_all_goods_in_cart,
    get_good_quantity_in_cart,
    add_or_increment_good_in_cart,
    remove_or_decrement_good_in_cart,
    remove_good_from_cart,
    create_order,
    get_all_orders,
    get_order_items_sql
)

app = FastAPI(
    title="Food-Market API",
    description="API для управления товарами Food-Market",
    version="1.0.0"
)

# Внутреннее хранилище для продуктов
foods: List[Food] = []
favorite: List[Food] = []
current_id: int = 1  # Переменная для генерации уникальных ID


# Вспомогательная функция для генерации нового ID
def get_next_id() -> int:
    global current_id
    next_id = current_id
    current_id += 1
    return next_id


# Маршрут для получения всех продуктов
@app.get("/foods", response_model=List[Food], summary="Получить все продукты")
async def get_all_foods():
    async with async_session_factory() as session:
        goods = await get_all_goods(session=session)
        return goods


# Маршрут для получения продуктов по ID
@app.get("/foods/{food_id}", response_model=Food, summary="Получить продукт по ID")
async def get_food(food_id: int):
    async with async_session_factory() as session:
        food = await get_goods_by_id(session=session, goods_id=food_id)
        return food


# Маршрут для добавления нового продукта
@app.post("/foods", response_model=Food, status_code=201, summary="Добавить новый продукт")
async def add_food(new_food: Food):
    async with async_session_factory() as session:
        new_food = Goods(**new_food.dict())
        food = await add_new_goods(session=session, new_food=new_food)
        if not food:
            raise HTTPException(status_code=500, detail="Ошибка при добавлении продукта в базу данных")
        return food


# Маршрут для обновления существующего продукта
@app.put("/foods/{food_id}", response_model=Food, summary="Обновить продукт")
async def update_food(food_id: int, updated_food: Food):
    async with async_session_factory() as session:
        food = await update_goods(session=session, goods_id=food_id, updated_data=updated_food.dict(exclude_unset=True))
        if not food:
            raise HTTPException(status_code=500, detail="Ошибка при обновлении продукта")
        return food


# Маршрут для удаления продукта
@app.delete("/foods/{food_id}", status_code=204, summary="Удалить продукт")
async def delete_food(food_id: int):
    async with async_session_factory() as session:
        await delete_goods(session=session, goods_id=food_id)
        return


# Маршрут для получения всех продуктов в избранном
@app.get("/favorite", response_model=List[Food], summary="Получить все продукты")
async def get_all_foods_in_favorite():
    async with async_session_factory() as session:
        goods = await get_all_goods_in_favorite(session=session, user_id=1)
        return goods


# Маршрут для получения продуктов в избранном по ID
@app.get("/favorite/{food_id}", response_model=Food, summary="Получить продукт по ID")
async def get_food_in_favorite(food_id: int):
    async with async_session_factory() as session:
        goods = await get_goods_in_favorite_by_id(session=session, user_id=1, good_id=food_id)
        return goods


# Маршрут для добавления продукта в избранное
@app.post("/favorite", response_model=Food, status_code=201, summary="Добавить новый продукт в избранное")
async def add_food_in_favorite(fav: Food):
    async with async_session_factory() as session:
        await add_goods_in_favorite(session=session, user_id=1, good_id=fav.id)
        good = await get_goods_in_favorite_by_id(session=session, user_id=1, good_id=fav.id)
        return good


# Маршрут для удаления продукта из избранного
@app.delete("/favorite/{food_id}", status_code=204, summary="Удалить продукт")
async def delete_food_from_favorite(food_id: int):
    async with async_session_factory() as session:
        await delete_goods_from_favorite(session=session, user_id=1, good_id=food_id)
        good = await get_goods_in_favorite_by_id(session=session, user_id=1, good_id=food_id)
        return good


# Маршрут для получения всех продуктов в корзине
@app.get("/incart", response_model=List[CartItem], summary="Получить кол-во всех продуктов в корзине")
async def get_all_cart():
    async with async_session_factory() as session:
        goods = await get_all_goods_in_cart(session=session, user_id=1)
        return goods


# Маршрут для получения продукта в корзине по ID
@app.get("/incart/{food_id}", response_model=int, summary="Получить кол-во продукта из корзины по ID")
async def get_cart_quantity(food_id: int):
    print(111)
    async with async_session_factory() as session:
        goods = await get_good_quantity_in_cart(session=session, user_id=1, good_id=food_id)
        return goods


# Маршрут для увеличения количества продукта в корзине
@app.put("/incart/{food_id}/increment", response_model=CartItem, summary="Увеличить продукт в корзине")
async def increment_in_cart(food_id: int):
    async with async_session_factory() as session:
        cart_item = await add_or_increment_good_in_cart(session=session, user_id=1, good_id=food_id)
        return cart_item


# Маршрут для уменьшения количества продукта в корзине
@app.put("/incart/{food_id}/decrement", response_model=CartItem, summary="Уменьшить продукт в корзине")
async def decrement_in_cart(food_id: int):
    async with async_session_factory() as session:
        cart_item = await remove_or_decrement_good_in_cart(session=session, user_id=1, good_id=food_id)
        return cart_item


# Маршрут для удаления продукта из корзины
@app.delete("/incart/{food_id}", response_model=CartItem, summary="Удалить из корзины")
async def delete_in_cart(food_id: int):
    async with async_session_factory() as session:
        cart_item = await remove_good_from_cart(session=session, user_id=1, good_id=food_id)
        return cart_item


# Маршрут для оформления заказа
@app.post("/checkout", response_model=OrderResponse, status_code=201, summary="Оформить заказ")
async def checkout(data: CheckoutRequest):
    print(data)
    async with async_session_factory() as session:
        order = await create_order(session, data.user_id, data.order_items)
        if order:
            return order
        else:
            raise HTTPException(status_code=400, detail="Не удалось оформить заказ")


@app.get("/orders", response_model=List[Order], summary="Получить все заказы пользователя")
async def get_orders(user_id: int):
    async with async_session_factory() as session:
        orders = await get_all_orders(session, user_id)
        if not orders:
            raise HTTPException(status_code=404, detail="Заказы не найдены")
        return [Order.model_validate(order) for order in orders]


@app.get("/orders/{order_id}/items", response_model=List[OrderItemResponse], summary="Получить товары из заказа")
async def get_order_items(order_id: int):
    async with async_session_factory() as session:
        order_items = await get_order_items_sql(session, order_id)
        if not order_items:
            raise HTTPException(status_code=404, detail="Товары не найдены в заказе")

        # Преобразуем ORM объекты в Pydantic модель, добавив данные из связанных объектов
        return [
            OrderItemResponse(
                id=item.id,
                order_id=item.order_id,
                good_id=item.good_id,
                quantity=item.quantity,
                product_name=item.good.title,  # Название продукта из связанного объекта 'good'
                product_price=item.good.salePrice,  # Цена продукта
                product_image=item.good.img  # Изображение продукта
            ) for item in order_items
        ]


@app.on_event("startup")
async def startup_event():
    # sample_foods = [
    #     Food(
    #         id=get_next_id(),
    #         art="veg_food",
    #         title="Лук репчатый, кг",
    #         desc="Состав: Лук.",
    #         weight=1000,
    #         expDate="9 дней, 0 ℃",
    #         price=59.99,
    #         salePrice=49.99,
    #         count=54,
    #         brand="Овощная База",
    #         calories=1.0,
    #         fat=0.1,
    #         protein=1.1,
    #         carbohydrate=9.0,
    #         img="assets/images/onion.webp",
    #         inCart=0
    #     ),
    #     Food(
    #         id=get_next_id(),
    #         art="veg_food",
    #         title="Салат Мини Шпинат, 65г",
    #         desc="Состав: Салат Мини Шпинат.",
    #         weight=65,
    #         expDate="9 дней, 2-4 ℃",
    #         price=119.99,
    #         salePrice=119.99,
    #         count=150,
    #         brand="Овощная База",
    #         calories=23.0,
    #         fat=0.3,
    #         protein=2.9,
    #         carbohydrate=2.0,
    #         img="assets/images/salat.webp",
    #         inCart=0
    #     ),
    # ]
    # foods.extend(sample_foods)
    logger.success("Application startup: приложение успешно запущено.")


def main():
    asyncio.run(create_tables())
    uvicorn.run("main:app", host="", port=3000, reload=True)


if __name__ == "__main__":
    main()
