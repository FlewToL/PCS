from sqlalchemy import select
from sqlalchemy.exc import IntegrityError
from sqlalchemy.ext.asyncio import AsyncSession

from api_flutter.database.models import Goods, Favorite, Cart


async def get_all_goods(session: AsyncSession):
    query = select(Goods)
    result = await session.execute(query)

    return result.scalars().all()


async def get_goods_by_id(session: AsyncSession, goods_id):
    query = select(Goods).filter_by(id=goods_id)
    result = await session.execute(query)

    return result.scalars().first()


async def add_new_goods(session: AsyncSession, new_food):
    session.add(new_food)
    try:
        await session.commit()
        await session.refresh(new_food)
        return new_food
    except Exception as e:
        await session.rollback()
        print(f"Ошибка при добавлении товара: {e}")
        return None


async def update_goods(session: AsyncSession, goods_id, updated_data):
    query = select(Goods).filter_by(id=goods_id)
    result = await session.execute(query)
    food = result.scalars().first()
    if not food:
        return None
    for key, value in updated_data.items():
        setattr(food, key, value)
    try:
        await session.commit()
        await session.refresh(food)
        return food
    except Exception as err:
        await session.rollback()
        print(f"Ошибка при обновлении товара: {err}")
        return None


async def delete_goods(session: AsyncSession, goods_id):
    query = select(Goods).filter_by(id=goods_id)
    result = await session.execute(query)
    food = result.scalars().first()
    if not food:
        return False
    try:
        await session.delete(food)
        await session.commit()
        return True
    except Exception as e:
        await session.rollback()
        print(f"Ошибка при удалении товара: {e}")
        return False


async def get_all_goods_in_favorite(session: AsyncSession, user_id):
    query = select(Goods).join(Favorite).where(Favorite.user_id == user_id)
    result = await session.execute(query)
    goods_list = result.scalars().all()
    return goods_list


async def get_goods_in_favorite_by_id(session: AsyncSession, user_id, good_id):
    query = select(Goods).join(Favorite).where(
        Favorite.user_id == user_id,
        Favorite.good_id == good_id
    )
    result = await session.execute(query)
    good = result.scalars().first()
    return good


async def add_goods_in_favorite(session: AsyncSession, user_id, good_id):
    favorite = Favorite(user_id=user_id, good_id=good_id)
    session.add(favorite)
    try:
        await session.commit()
        return True
    except IntegrityError:
        await session.rollback()
        return False
    except Exception as e:
        await session.rollback()
        print(f"Ошибка при добавлении товара в избранное: {e}")
        return False


async def delete_goods_from_favorite(session: AsyncSession, user_id, good_id):
    query = select(Favorite).where(
        Favorite.user_id == user_id,
        Favorite.good_id == good_id
    )
    result = await session.execute(query)
    favorite = result.scalars().first()
    if not favorite:
        return False
    try:
        await session.delete(favorite)
        await session.commit()
        return True
    except Exception as e:
        await session.rollback()
        print(f"Ошибка при удалении товара из избранного: {e}")
        return False


async def get_all_goods_in_cart(session: AsyncSession, user_id):
    query = (
        select(Goods, Cart.quantity)
        .join(Cart, Goods.id == Cart.good_id)
        .where(Cart.user_id == user_id)
    )
    result = await session.execute(query)
    cart_items = result.all()

    return [{"good": goods, "quantity": quantity} for goods, quantity in cart_items]


async def get_good_quantity_in_cart(session: AsyncSession, user_id, good_id):
    query = select(Cart.quantity).where(
        Cart.user_id == user_id,
        Cart.good_id == good_id
    )
    result = await session.execute(query)
    quantity = result.scalar_one_or_none()
    if quantity is not None:
        return quantity


async def add_or_increment_good_in_cart(session: AsyncSession, user_id, good_id):
    query = select(Cart).where(
        Cart.user_id == user_id,
        Cart.good_id == good_id
    )
    result = await session.execute(query)
    cart_item = result.scalar_one_or_none()

    new_cart_item = None

    if cart_item:
        cart_item.quantity += 1
    else:
        new_cart_item = Cart(user_id=user_id, good_id=good_id, quantity=1)
        session.add(new_cart_item)

    await session.commit()
    await session.refresh(cart_item if cart_item else new_cart_item)

    goods = await session.get(Goods, good_id)
    return goods


async def remove_or_decrement_good_in_cart(session: AsyncSession, user_id, good_id):
    query = select(Cart).where(
        Cart.user_id == user_id,
        Cart.good_id == good_id
    )
    result = await session.execute(query)
    cart_item = result.scalar_one_or_none()

    if cart_item:
        if cart_item.quantity > 1:
            cart_item.quantity -= 1
        else:
            await session.delete(cart_item)
        await session.commit()
        goods = await session.get(Goods, good_id)
        return goods
    else:
        return None


async def remove_good_from_cart(session: AsyncSession, user_id, good_id):
    query = select(Cart).where(
        Cart.user_id == user_id,
        Cart.good_id == good_id
    )
    result = await session.execute(query)
    cart_item = result.scalar_one_or_none()

    if cart_item:
        await session.delete(cart_item)
        await session.commit()

        goods = await session.get(Goods, good_id)
        return goods
    else:
        return None
