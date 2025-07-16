#include <cstdint>
#include <string_view>
#include <chrono>
#include <iostream>
#include <stdexcept>

enum class Side { BUY, SELL };
// bi-directional conversion Side <-> string
constexpr std::string_view to_string(Side side) {
    switch (side) {
        case Side::BUY: return "BUY";
        case Side::SELL: return "SELL";
    }
    return "Unknown";
}

constexpr Side from_string(std::string_view str) {
    if (str == "BUY") return Side::BUY;
    if (str == "SELL") return Side::SELL;
    throw std::invalid_argument("Invalid side string");
}

struct Order { // use stuct for data object
    int id;
    std::string_view symbol;
    Side side;
    int quantity;
    int64_t price; // NOTE: use int64_t for precision, with tick_size, assuming 0.001 (same as scale=3) for now
                    // TODO: customizeable tick_size
    uint64_t timestamp;

    // Default comparison: C++20 spaceship operator
    auto operator<=>(const Order&) const = default; // TODO: to order Order by price and timestamp to allow for natural order in the order_book's priority queue
};
// for printing order
std::ostream& operator<<(std::ostream& os, const Order& order) {
    os << "Order{id=" << order.id
        << ", symbol=" << order.symbol
        << ", side=" << to_string(order.side)
        << ", quantity=" << order.quantity
        << ", price=" << order.price
        << ", timestamp=" << order.timestamp << "}";
    return os;
}

class OrderBook {
public:
    // default constructor
    OrderBook() = default;
    // remove copy constructor
    OrderBook(const OrderBook &) = delete;
    // remove copy assignment
    OrderBook &operator=(const OrderBook &) = delete;
    // move constructor
    OrderBook(OrderBook &&) = default;
    // move assignment
    OrderBook &operator=(OrderBook &&) = default;
};

int main() {
    // Get current time as timestamp
    auto now = std::chrono::system_clock::now();
    auto timestamp = std::chrono::duration_cast<std::chrono::microseconds>(
        now.time_since_epoch()).count();

    Order o {
        .id = 1,
        .symbol = "SPY",
        .side = Side::BUY,
        .quantity = 100,
        .price = 145000, // tick_size = 0.001
        .timestamp = static_cast<uint64_t>(timestamp)
    };
    std::cout << o << std::endl;
    OrderBook b;
}