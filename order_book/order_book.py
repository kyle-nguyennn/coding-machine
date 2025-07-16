from dataclasses import dataclass
from enum import Enum
import time
import heapq
from typing import Trade

class OrderSide(Enum):
    BUY = 'BUY'
    SELL = 'SELL'

@dataclass
class Order:
    order_id: int
    symbol: str
    side: OrderSide
    quantity: int
    price: float
    timestamp: time

@dataclass
class Trade:
    buy_order_id: int
    sell_order_id: int
    quantity: int
    price: float

class OrderBook:
    self __init__(self):
        self.buy_orders = [] # max-heap
        self.sell_orders = [] # min-heap

    self add_order(self, order: Order):
        if order.side == OrderSide.BUY:
            heapq.heappush(self.buy_orders, (-order.price, order.timestamp, order))
        else:
            heapq.heappush(self.sell_orders, (order.price, order.timestamp, order))
        

class MatchingEngine:
    def __init__(self, order_book: OrderBook):
        self.order_book = order_book
    
    def _match_buy_order(order: Order) -> List[Trade]:
        trades = []
        sell_orders = self.order_book.sell_orders

        while sell_orders and order.quantity > 0:
            sell_order = sell_orders[0]
            if sell_order.price > order.price:
                break
            
            qty = min(sell_order.quantity, -order.quantity)
            price = sell_order.price
            trades.append(Trade(order.order_id, sell_order.order_id, qty, price))

            sell_order.quantity -= qty
            order.quantity -= qty

            if sell_order.quantity == 0:
                heapq.heappop(sell_orders)

        return trades

    def _match_sell_order(order: Order) -> List[Trade]:
        trades = []
        buy_orders = self.order_book.buy_orders

        while buy_orders and order.quantity > 0:
            buy_order = buy_orders[0]
            if buy_order.price < order.price:
                break
            
            qty = min(-buy_order.quantity, order.quantity)
            price = buy_order.price
            trades.append(Trade(buy_order.order_id, order.order_id, qty, price))

            buy_order.quantity -= qty
            order.quantity -= qty

            if buy_order.quantity == 0:
                heapq.heappop(buy_orders)

        return trades

    def match_order(self, order: Order) -> List[Trade]:
        if order.side == OrderSide.BUY:
            trades = self._match_buy_order(order)
        else:
            trades = self._match_sell_order(order)
        
        if order.quantity != 0:
            self.order_book.add_order(order)
        
        return trades