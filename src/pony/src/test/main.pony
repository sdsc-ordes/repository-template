use "pony_test"

actor Main is TestList
  new create(env: Env) =>
    PonyTest(env, this)

  fun tag tests(test: PonyTest) =>
    test(_TestPingCounter)

class _TestPingCounter is UnitTest
  fun name(): String => "ping/counter increments"

  fun apply(h: TestHelper) =>
    var counter: U64 = 0
    counter = counter + 1
    h.assert_eq[U64](counter, 1)
