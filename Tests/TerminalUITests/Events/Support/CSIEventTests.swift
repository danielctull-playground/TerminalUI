import AsyncAlgorithms
@testable import TerminalUI
import Testing

@Suite("CSIEvent")
struct CSIEventTests {

  @Test func `no csi events passed`() async throws {

    var iterator = [
      CSI(command: "a"),
      CSI(command: "b"),
      CSI(command: "c"),
    ]
    .async
    .csiEvents()
    .makeAsyncIterator()

    #expect(try await iterator.next() as? CSI == CSI(command: "a"))
    #expect(try await iterator.next() as? CSI == CSI(command: "b"))
    #expect(try await iterator.next() as? CSI == CSI(command: "c"))
  }

  @Test func `csi event throws failure`() async throws {

    struct Foo: CSIEvent {
      init(csi: CSI) throws {
        throw Failure()
      }
    }

    var iterator = [
      CSI(command: "a"),
      CSI(command: "b"),
      CSI(command: "c"),
    ]
    .async
    .csiEvents(Foo.self)
    .makeAsyncIterator()

    #expect(try await iterator.next() as? CSI == CSI(command: "a"))
    #expect(try await iterator.next() as? CSI == CSI(command: "b"))
    #expect(try await iterator.next() as? CSI == CSI(command: "c"))
  }

  @Test func `csi event`() async throws {

    struct Wrapper: CSIEvent, Equatable {
      let csi: CSI
    }

    var iterator = [
      CSI(command: "a"),
      CSI(command: "b"),
      CSI(command: "c"),
    ]
    .async
    .csiEvents(Wrapper.self)
    .makeAsyncIterator()

    #expect(try await iterator.next() as? Wrapper == Wrapper(csi: CSI(command: "a")))
    #expect(try await iterator.next() as? Wrapper == Wrapper(csi: CSI(command: "b")))
    #expect(try await iterator.next() as? Wrapper == Wrapper(csi: CSI(command: "c")))
  }

  @Test func `failures remain as CSI`() async throws {

    struct Wrapper: CSIEvent, Equatable {
      let csi: CSI
      init(csi: CSI) throws {
        switch csi.command {
        case "a": self.csi = csi
        case "c": self.csi = csi
        default: throw Failure()
        }
      }
    }

    var iterator = [
      CSI(command: "a"),
      CSI(command: "b"),
      CSI(command: "c"),
      CSI(command: "d"),
    ]
    .async
    .csiEvents(Wrapper.self)
    .makeAsyncIterator()

    #expect(try await iterator.next() as? Wrapper == Wrapper(csi: CSI(command: "a")))
    #expect(try await iterator.next() as? CSI == CSI(command: "b"))
    #expect(try await iterator.next() as? Wrapper == Wrapper(csi: CSI(command: "c")))
    #expect(try await iterator.next() as? CSI == CSI(command: "d"))
  }

  @Test func `multiple csi event types`() async throws {

    struct A: CSIEvent {
      init(csi: CSI) throws {
        guard csi.command == "a" else { throw Failure() }
      }
    }

    struct B: CSIEvent {
      init(csi: CSI) throws {
        guard csi.command == "b" else { throw Failure() }
      }
    }

    struct C: CSIEvent {
      init(csi: CSI) throws {
        guard csi.command == "c" else { throw Failure() }
      }
    }

    var iterator = [
      CSI(command: "a"),
      CSI(command: "b"),
      CSI(command: "c"),
      CSI(command: "d"),
    ]
    .async
    .csiEvents(A.self, B.self, C.self)
    .makeAsyncIterator()

    #expect(try await iterator.next() is A)
    #expect(try await iterator.next() is B)
    #expect(try await iterator.next() is C)
    #expect(try await iterator.next() as? CSI == CSI(command: "d"))
  }

  @Test func `csi event type order determines parse priority`() async throws {

    struct First: CSIEvent, Equatable {
      let csi: CSI
    }

    struct Second: CSIEvent, Equatable {
      let csi: CSI
    }

    var iterator = [
      CSI(command: "a"),
      CSI(command: "b"),
      CSI(command: "c"),
      CSI(command: "d"),
    ]
    .async
    .csiEvents(First.self, Second.self)
    .makeAsyncIterator()

    #expect(try await iterator.next() as? First == First(csi: CSI(command: "a")))
    #expect(try await iterator.next() as? First == First(csi: CSI(command: "b")))
    #expect(try await iterator.next() as? First == First(csi: CSI(command: "c")))
    #expect(try await iterator.next() as? First == First(csi: CSI(command: "d")))
  }

  private struct Failure: Error {}
}
