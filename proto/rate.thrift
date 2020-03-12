namespace java com.rbkmoney.xrates.rate
namespace erlang rate

include "base.thrift"
include "domain.thrift"

typedef i64 EventID
typedef base.Rational ExchangeRate

/** ISO 4217 */
typedef string CurrencySymbolicCode

typedef string SourceID

typedef i64 SequenceID

struct EventRange {
    1: optional EventID after
    2: required i32 limit
}

exception NoLastEvent {}

struct Currency {
    1: required CurrencySymbolicCode symbolic_code
    2: required i16 exponent
}

union Change {
    1: ExchangeRateCreated created
}

struct ExchangeRateCreated {
    1: required ExchangeRateData exchange_rate_data
}

/**
*  Информация по курсам валют, где:
*  interval - интервал времени в рамках которого действуют заданные курсы
*  quotes - список курсов валют
*/
struct ExchangeRateData {
    1: required base.TimestampInterval interval
    2: required list<Quote> quotes
}

/**
* Курс валют, где:
* source - валюта, из которой конвертируют
* destination - валюта, в которую конвертируют
* exchange_rate - рациональное число конверсии в учете минорных единиц
* payment_system - платежная система, в рамках которой установлен курс
*
* Пример:
* Предположим, что мы конвертируем CLF в RUB по курсу 2640.4546 рублей.
* В итоге source валюта здесь это CLF с экспонентой 4, destination валюта это RUB с экспонентой 2.
* Получается, что одна минорная единица CLF равна 0.26404546 рубля, или 26.404546 копеек (минорная единица рубля).
* В результате в рациональном представлении это будет равно "26404546 / 1000000" или "13202273 / 500000".
*
*/
struct Quote {
    1: required Currency source
    2: required Currency destination
    3: required ExchangeRate exchange_rate
    4: optional domain.BankCardPaymentSystem payment_system
}

struct Event {
    1: required list<Change> changes
}

struct SinkEvent {
    1: required EventID        id
    2: required base.Timestamp created_at
    3: required SourceID       source
    4: required Event          payload
    5: required SequenceID     sequence_id
}

service EventSink {

    list<SinkEvent> GetEvents (1: EventRange range)
        throws ()

    EventID GetLastEventID ()
        throws (1: NoLastEvent ex1)

}