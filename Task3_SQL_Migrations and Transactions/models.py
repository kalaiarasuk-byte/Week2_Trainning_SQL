
from sqlalchemy import (
    Column,
    Integer,
    String,
    ForeignKey,
    Numeric,
    DateTime
)
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func

from database import Base


# Customer Model
class Customer(Base):

    __tablename__ = "customers_orm"

    id = Column(Integer, primary_key=True, index=True)
    name = Column(String(100), nullable=False)
    city = Column(String(100))

    orders = relationship(
        "Order",
        back_populates="customer"
    )


# Product Model
class Product(Base):

    __tablename__ = "products_orm"

    id = Column(Integer, primary_key=True, index=True)
    name = Column(String(100), nullable=False)
    price = Column(Numeric(10, 2), nullable=False)
    stock = Column(Integer, nullable=False)

    orders = relationship(
        "Order",
        back_populates="product"
    )


# Order Model
class Order(Base):

    __tablename__ = "orders_orm"

    id = Column(Integer, primary_key=True, index=True)

    customer_id = Column(
        Integer,
        ForeignKey("customers_orm.id"),
        nullable=False
    )

    product_id = Column(
        Integer,
        ForeignKey("products_orm.id"),
        nullable=False
    )

    qty = Column(Integer, nullable=False)
    total_amount = Column(Numeric(10, 2), nullable=False)

    created_at = Column(
        DateTime,
        server_default=func.now()
    )

    customer = relationship(
        "Customer",
        back_populates="orders"
    )

    product = relationship(
        "Product",
        back_populates="orders"
    )
