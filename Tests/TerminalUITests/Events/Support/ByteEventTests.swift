import AsyncAlgorithms
@testable import TerminalUI
import Testing

@Suite("ByteEvent")
struct ByteEventTests {

  @Test func `no byte events passed`() async throws {

    var iterator = ([[0x41, 0x42], [0x43], [0x44, 0x45]] as [[Byte]])
      .async
      .parsing()
      .makeAsyncIterator()

    #expect(try await iterator.next() as? Byte == 0x41)
    #expect(try await iterator.next() as? Byte == 0x42)
    #expect(try await iterator.next() as? Byte == 0x43)
    #expect(try await iterator.next() as? Byte == 0x44)
    #expect(try await iterator.next() as? Byte == 0x45)
  }

  @Test func `byte event throws failure`() async throws {

    struct Foo: ByteEvent {
      init(parser: inout Parser<[Byte]>) throws {
        throw Failure()
      }
    }

    var iterator = ([[0x41], [0x42], [0x43], [0x44], [0x45]] as [[Byte]])
      .async
      .parsing(Foo.self)
      .makeAsyncIterator()

    #expect(try await iterator.next() as? Byte == 0x41)
    #expect(try await iterator.next() as? Byte == 0x42)
    #expect(try await iterator.next() as? Byte == 0x43)
    #expect(try await iterator.next() as? Byte == 0x44)
    #expect(try await iterator.next() as? Byte == 0x45)
  }

  @Test func `byte event`() async throws {

    var iterator = ([[0x41], [0x42], [0x43]] as [[Byte]])
      .async
      .parsing(Unbound.self)
      .makeAsyncIterator()

    #expect(try await iterator.next() as? Unbound == Unbound(0x41))
    #expect(try await iterator.next() as? Unbound == Unbound(0x42))
    #expect(try await iterator.next() as? Unbound == Unbound(0x43))
  }

  @Test func `trailing bytes are parsed`() async throws {

    var iterator = ([[0x41, 0x42], [0x43, 0x44, 0x45, 0x46]] as [[Byte]])
      .async
      .parsing(Unbound.self)
      .makeAsyncIterator()

    #expect(try await iterator.next() as? Unbound == Unbound(0x41))
    #expect(try await iterator.next() as? Unbound == Unbound(0x42))
    #expect(try await iterator.next() as? Unbound == Unbound(0x43))
    #expect(try await iterator.next() as? Unbound == Unbound(0x44))
    #expect(try await iterator.next() as? Unbound == Unbound(0x45))
    #expect(try await iterator.next() as? Unbound == Unbound(0x46))
  }

  @Test func `failed parsing results in bytes`() async throws {

    var iterator = ([[0x41], [0x44], [0x42], [0x45], [0x43], [0x46]] as [[Byte]]).async
      .parsing(Small.self)
      .makeAsyncIterator()

    #expect(try await iterator.next() as? Small == Small(0x41))
    #expect(try await iterator.next() as? Byte == 0x44)
    #expect(try await iterator.next() as? Small == Small(0x42))
    #expect(try await iterator.next() as? Byte == 0x45)
    #expect(try await iterator.next() as? Small == Small(0x43))
    #expect(try await iterator.next() as? Byte == 0x46)
  }

  @Test func `multiple byte event types`() async throws {

    var iterator = ([[0x41, 0x44], [0x47, 0x42, 0x45, 0x48], [0x43], [0x46, 0x49]] as [[Byte]])
      .async
      .parsing(Small.self, Large.self, Unbound.self)
      .makeAsyncIterator()

    #expect(try await iterator.next() as? Small == Small(0x41))
    #expect(try await iterator.next() as? Unbound == Unbound(0x44))
    #expect(try await iterator.next() as? Large == Large(0x47))
    #expect(try await iterator.next() as? Small == Small(0x42))
    #expect(try await iterator.next() as? Unbound == Unbound(0x45))
    #expect(try await iterator.next() as? Large == Large(0x48))
    #expect(try await iterator.next() as? Small == Small(0x43))
    #expect(try await iterator.next() as? Unbound == Unbound(0x46))
    #expect(try await iterator.next() as? Large == Large(0x49))
  }

  @Test func `multiple byte event types in single read`() async throws {

    var iterator = ([[0x41, 0x44, 0x47, 0x42, 0x45, 0x48, 0x43, 0x46, 0x49]] as [[Byte]])
      .async
      .parsing(Small.self, Large.self)
      .makeAsyncIterator()

    #expect(try await iterator.next() as? Small == Small(0x41))
    #expect(try await iterator.next() as? Byte == 0x44)
    #expect(try await iterator.next() as? Large == Large(0x47))
    #expect(try await iterator.next() as? Small == Small(0x42))
    #expect(try await iterator.next() as? Byte == 0x45)
    #expect(try await iterator.next() as? Large == Large(0x48))
    #expect(try await iterator.next() as? Small == Small(0x43))
    #expect(try await iterator.next() as? Byte == 0x46)
    #expect(try await iterator.next() as? Large == Large(0x49))
  }

  @Test func `byte event type order determines parse priority`() async throws {

    var iterator = ([[0x41], [0x42], [0x43], [0x44], [0x45], [0x46], [0x47], [0x48], [0x49]] as [[Byte]])
      .async
      .parsing(Unbound.self, Small.self, Large.self)
      .makeAsyncIterator()

    #expect(try await iterator.next() as? Unbound == Unbound(0x41))
    #expect(try await iterator.next() as? Unbound == Unbound(0x42))
    #expect(try await iterator.next() as? Unbound == Unbound(0x43))
    #expect(try await iterator.next() as? Unbound == Unbound(0x44))
    #expect(try await iterator.next() as? Unbound == Unbound(0x45))
    #expect(try await iterator.next() as? Unbound == Unbound(0x46))
    #expect(try await iterator.next() as? Unbound == Unbound(0x47))
    #expect(try await iterator.next() as? Unbound == Unbound(0x48))
    #expect(try await iterator.next() as? Unbound == Unbound(0x49))

  }

  private struct Failure: Error {}

  private struct Small: ByteEvent, Equatable {
    let byte: Byte
    init(_ byte: Byte) {
      self.byte = byte
    }
    init(parser: inout Parser<[Byte]>) throws {
      guard let byte = parser.advance(), byte < 0x44 else { throw Failure() }
      self.byte = byte
    }
  }

  private struct Unbound: ByteEvent, Equatable {
    let byte: Byte
    init(_ byte: Byte) {
      self.byte = byte
    }
    init(parser: inout Parser<[Byte]>) throws {
      guard let byte = parser.advance() else { throw Failure() }
      self.byte = byte
    }
  }

  private struct Large: ByteEvent, Equatable {
    let byte: Byte
    init(_ byte: Byte) {
      self.byte = byte
    }
    init(parser: inout Parser<[Byte]>) throws {
      guard let byte = parser.advance(), byte > 0x46 else { throw Failure() }
      self.byte = byte
    }
  }
}
