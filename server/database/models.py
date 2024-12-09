from typing import Annotated, List, Optional
from pydantic import BaseModel, Field, ConfigDict

from sqlalchemy import BigInteger, ForeignKey
from sqlalchemy.orm import Mapped, mapped_column, relationship

from api_flutter.database.connection import Base

user_id_unique = Annotated[int, mapped_column(BigInteger, unique=True)]
user_id_pk = Annotated[int, mapped_column(BigInteger, primary_key=True, )]
user_id_pk_fk = Annotated[int, mapped_column(BigInteger, ForeignKey("users.user_id"), primary_key=True)]

user_nick_uniq = Annotated[str, mapped_column(unique=True)]

id_pk = Annotated[int, mapped_column(primary_key=True, autoincrement=True)]
id_uniq = Annotated[int, mapped_column(unique=True)]

bigint = Annotated[int, mapped_column(BigInteger)]


class Users(Base):
    __tablename__ = "users"
    id: Mapped[id_pk]
    first_name: Mapped[str]
    middle_name: Mapped[str]
    last_name: Mapped[str]
    sign_up_date: Mapped[int] = mapped_column(BigInteger)

    favorites = relationship("Favorite", back_populates="user")
    cart = relationship("Cart", back_populates="user")
    orders = relationship("Orders", back_populates="user")


class Goods(Base):
    __tablename__ = "goods"
    id: Mapped[id_pk]
    art: Mapped[str]
    title: Mapped[str]
    desc: Mapped[str]
    weight: Mapped[int]
    expDate: Mapped[str]
    price: Mapped[float]
    salePrice: Mapped[float]
    count: Mapped[int]
    brand: Mapped[str]
    calories: Mapped[float]
    fat: Mapped[float]
    protein: Mapped[float]
    carbohydrate: Mapped[float]
    img: Mapped[str]
    inCart: Mapped[int]

    favorites = relationship("Favorite", back_populates="good")
    cart = relationship("Cart", back_populates="good")


class Favorite(Base):
    __tablename__ = "favorites"

    user_id: Mapped[int] = mapped_column(ForeignKey("users.id"), primary_key=True)
    good_id: Mapped[int] = mapped_column(ForeignKey("goods.id"), primary_key=True)

    user = relationship("Users", back_populates="favorites")
    good = relationship("Goods", back_populates="favorites")


class Cart(Base):
    __tablename__ = "cart"

    user_id: Mapped[int] = mapped_column(ForeignKey("users.id"), primary_key=True)
    good_id: Mapped[int] = mapped_column(ForeignKey("goods.id"), primary_key=True)
    quantity: Mapped[int] = mapped_column(default=1)

    user = relationship("Users", back_populates="cart")
    good = relationship("Goods", back_populates="cart")


class Orders(Base):
    __tablename__ = "orders"

    id: Mapped[id_pk]
    user_id: Mapped[int] = mapped_column(ForeignKey("users.id"))
    created_at: Mapped[int] = mapped_column(BigInteger)
    total_price: Mapped[float]

    user = relationship("Users", back_populates="orders")
    order_items = relationship("OrderItem", back_populates="order")


class OrderItem(Base):
    __tablename__ = "order_items"

    id: Mapped[id_pk]
    order_id: Mapped[int] = mapped_column(ForeignKey("orders.id"))
    good_id: Mapped[int] = mapped_column(ForeignKey("goods.id"))
    quantity: Mapped[int]

    order = relationship("Orders", back_populates="order_items")
    good = relationship("Goods")


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

    model_config = ConfigDict(from_attributes=True)


class CartItem(BaseModel):
    good: Food
    quantity: int

    model_config = ConfigDict(from_attributes=True)


class OrderItemRequest(BaseModel):
    good_id: int
    quantity: int


class CheckoutRequest(BaseModel):
    user_id: int
    order_items: List[OrderItemRequest]


class OrderResponse(BaseModel):
    order_id: int
    total_price: float


class Order(BaseModel):
    id: int
    user_id: int
    created_at: int
    total_price: float

    model_config = ConfigDict(from_attributes=True)


class OrderItemResponse(BaseModel):
    id: int
    order_id: int
    good_id: int
    quantity: int
    product_name: str  # Название продукта
    product_price: float  # Цена продукта
    product_image: str  # URL изображения продукта (если есть)

    class Config:
        orm_mode = True  # Для работы с ORM
        from_attributes = True  # Для использования from_orm


