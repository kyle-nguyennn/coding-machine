#include <cstdint>
#include <string_view>

enum class Side { BUY, SELL };

class Order {
public:
    constexpr Order(int id, std::string_view symbol, Side side, int quantity, int64_t price,
                    uint64_t timestamp) noexcept
        : id_{id}, symbol_{symbol}, side_{side}, quantity_{quantity}, price_{price}, timestamp_{timestamp} {}

    // accessors
    constexpr int id() const noexcept { return id_; }
    constexpr std::string_view symbol() const noexcept { return symbol_; }
    constexpr Side side() const noexcept { return side_; }
    constexpr int quantity() const noexcept { return quantity_; }
    constexpr int64_t price() const noexcept { return price_; }
    constexpr uint64_t timestamp() const noexcept { return timestamp_; }

private:
    int id_;
    std::string_view symbol_;
    Side side_;
    int quantity_;
    int64_t price_; // NOTE: use int64_t for precision, with tick_size, assuming 0.001 (same as scale=3) for now
                    // TODO: customizeable tick_size
    uint64_t timestamp_;
};

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
    OrderBook o;
}