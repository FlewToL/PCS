import asyncio

from sqlalchemy.ext.asyncio import create_async_engine, async_sessionmaker
from api_flutter.config.reader import settings
from sqlalchemy.ext.declarative import declarative_base

async_engine = create_async_engine(
    url=settings.DATABASE_URL_asyncpg,
    echo=settings.DEBUG,
)

async_session_factory = async_sessionmaker(async_engine)

Base = declarative_base()
