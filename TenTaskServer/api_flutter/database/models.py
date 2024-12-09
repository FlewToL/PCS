from typing import Annotated

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


