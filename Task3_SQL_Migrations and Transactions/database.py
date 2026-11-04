
from sqlalchemy import create_engine
from sqlalchemy.orm import declarative_base, sessionmaker

# PostgreSQL database URL
DATABASE_URL = "postgresql+psycopg2://postgres:YOUR_PASSWORD@localhost:5432/postgres"

# Create engine with connection pooling
engine = create_engine(
    DATABASE_URL,
    pool_size=5,
    max_overflow=10,
    echo=True
)

# Create session
SessionLocal = sessionmaker(
    bind=engine,
    autoflush=False,
    autocommit=False
)

# Base class for ORM models
Base = declarative_base()
