from fastapi import FastAPI, HTTPException
from pydantic import BaseModel, Field
from typing import List
import uvicorn

app = FastAPI(
    title="Food-Market API",
    description="API для управления товарами Food-Market",
    version="1.0.0"
)


# Pydantic модель для Food
class Food(BaseModel):
    id: int = Field(default=None, description="Уникальный идентификатор продукта")
    art: str = Field(..., description="Артикул продукта")
    title: str = Field(..., description="Название продукта")
    desc: str = Field(..., description="Описание продукта")
    weight: int = Field(..., gt=0, description="Вес продукта в граммах")
    expDate: str = Field(..., description="Срок годности продукта (дни)")
    price: float = Field(..., gt=0, description="Цена продукта")
    salePrice: float = Field(..., gt=0, description="Цена по акции")
    count: int = Field(..., ge=0, description="Количество в наличии")
    brand: str = Field(..., description="Бренд продукта")
    calories: float = Field(..., ge=0, description="Калорийность продукта")
    fat: float = Field(..., ge=0, description="Количество жиров (г)")
    protein: float = Field(..., ge=0, description="Количество белков (г)")
    carbohydrate: float = Field(..., ge=0, description="Количество углеводов (г)")
    img: str = Field(..., description="URL изображения продукта")
    inCart: int = Field(default=0, ge=0, description="Количество продукта в корзине")


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
    return foods


# Маршрут для получения продуктов по ID
@app.get("/foods/{food_id}", response_model=Food, summary="Получить продукт по ID")
async def get_food(food_id: int):
    for food in foods:
        if food.id == food_id:
            return food
    raise HTTPException(status_code=404, detail="Продукт не найден")


# Маршрут для добавления нового продукта
@app.post("/foods", response_model=Food, status_code=201, summary="Добавить новый продукт")
async def add_food(new_food: Food):
    new_food.id = get_next_id()
    foods.append(new_food)
    return new_food


# Маршрут для обновления существующего продукта
@app.put("/foods/{food_id}", response_model=Food, summary="Обновить продукт")
async def update_food(food_id: int, updated_food: Food):
    for index, food in enumerate(foods):
        if food.id == food_id:
            updated_food.id = food_id
            foods[index] = updated_food
            return updated_food
    raise HTTPException(status_code=404, detail="Продукт не найден")


# Маршрут для удаления продукта
@app.delete("/foods/{food_id}", status_code=204, summary="Удалить продукт")
async def delete_food(food_id: int):
    for index, food in enumerate(foods):
        if food.id == food_id:
            del foods[index]
            return
    raise HTTPException(status_code=404, detail="Продукт не найден")


# Маршрут для получения всех продуктов в избранном
@app.get("/favorite", response_model=List[Food], summary="Получить все продукты")
async def get_all_foods():
    return favorite


# Маршрут для получения продуктов в избранном по ID
@app.get("/favorite/{food_id}", response_model=Food, summary="Получить продукт по ID")
async def get_food(food_id: int):
    for food in favorite:
        if food.id == food_id:
            return food
    raise HTTPException(status_code=404, detail="Продукт не найден")


# Маршрут для добавления продукта в избранное
@app.post("/favorite", response_model=Food, status_code=201, summary="Добавить новый продукт в избранное")
async def add_food(fav: Food):
    if not any(food.id == fav.id for food in foods):
        raise HTTPException(status_code=404, detail="Продукт не найден")

    if fav.id in favorite:
        raise HTTPException(status_code=400, detail="Продукт уже в избранном")

    favorite.append(fav)
    return fav


# Маршрут для удаления продукта из избранного
@app.delete("/favorite/{food_id}", status_code=204, summary="Удалить продукт")
async def delete_food(food_id: int):
    for index, food in enumerate(favorite):
        if food.id == food_id:
            del favorite[index]
            return
    raise HTTPException(status_code=404, detail="Продукт не найден")


# Маршрут для получения всех продуктов в корзине
@app.get("/incart", response_model=List[Food], summary="Получить все продукты")
async def get_all_cart():
    cart_list = []
    for food in foods:
        if food.inCart > 0:
            cart_list.append(food)
    return cart_list


# Маршрут для получения продукта в корзине по ID
@app.get("/incart/{food_id}", response_model=int, summary="Получить продукт из корзины по ID")
async def get_cart(food_id: int):
    for food in foods:
        if food.id == food_id:
            return food.inCart
    raise HTTPException(status_code=404, detail="Продукт не найден")


# Маршрут для увеличения количества продукта в корзине
@app.put("/incart/{food_id}/increment", response_model=Food, summary="Увеличить продукт в корзине")
async def increment_in_cart(food_id: int):
    for food in foods:
        if food.id == food_id:
            food.inCart += 1
            return food
    raise HTTPException(status_code=404, detail="Продукт не найден")


# Маршрут для уменьшения количества продукта в корзине
@app.put("/incart/{food_id}/decrement", response_model=Food, summary="Уменьшить продукт в корзине")
async def decrement_in_cart(food_id: int):
    for food in foods:
        if food.id == food_id:
            if food.inCart > 0:
                food.inCart -= 1
                return food
    raise HTTPException(status_code=404, detail="Продукт не найден")


# Маршрут для добавления продукта в корзину
@app.put("/incart/{food_id}/add", response_model=Food, summary="Добавить в корзину")
async def add_in_cart(food_id: int):
    for food in foods:
        if food.id == food_id:
            food.inCart = 1
            return food
    raise HTTPException(status_code=404, detail="Продукт не найден")


# Маршрут для удаления продукта из корзины
@app.put("/incart/{food_id}/delete", response_model=Food, summary="Удалить из корзины")
async def delete_in_cart(food_id: int):
    for food in foods:
        if food.id == food_id:
            food.inCart = 0
            return food
    raise HTTPException(status_code=404, detail="Продукт не найден")


# Инициализация сервера с некоторыми данными для тестирования
@app.on_event("startup")
async def startup_event():
    sample_foods = [
        Food(
            id=get_next_id(),
            art="veg_food",
            title="Лук репчатый, кг",
            desc="Состав: Лук.",
            weight=1000,
            expDate="9 дней, 0 ℃",
            price=59.99,
            salePrice=49.99,
            count=54,
            brand="Овощная База",
            calories=40.0,
            fat=0.1,
            protein=1.1,
            carbohydrate=9.0,
            img="assets/images/onion.webp",
            inCart=0
        ),
        Food(
            id=get_next_id(),
            art="veg_food",
            title="Салат Мини Шпинат, 65г",
            desc="Состав: Салат Мини Шпинат.",
            weight=65,
            expDate="9 дней, 2-4 ℃",
            price=119.99,
            salePrice=119.99,
            count=150,
            brand="Овощная База",
            calories=23.0,
            fat=0.3,
            protein=2.9,
            carbohydrate=2.0,
            img="assets/images/salat.webp",
            inCart=0
        ),
    ]
    foods.extend(sample_foods)
    print("Application startup: Добавлены образцы продуктов.")


if __name__ == "__main__":
    uvicorn.run("main:app", host="127.0.0.1", port=3000, reload=True)


