namespace java com.rbkmoney.xrates.base
namespace erlang base

/**
 * Отметка во времени согласно RFC 3339.
 *
 * Строка должна содержать дату и время в UTC в следующем формате:
 * `2016-03-22T06:12:27Z`.
 */
typedef string Timestamp

/**
 * Временной интервал
 */
struct TimestampInterval {
    1: required Timestamp lower_bound_inclusive
    2: required Timestamp upper_bound_exclusive
}

/** Рациональное число. */
struct Rational {
    1: required i64 p
    2: required i64 q
}

/** Сумма в минимальных денежных единицах. */
typedef i64 Amount