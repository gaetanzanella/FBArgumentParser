//
//  FBArgumentsDecoder.swift
//  FBArgumentParser
//
//  Created by Gaétan Zanella on 26/07/2021.
//

import Foundation

enum DecodingError: Error {
    case invalidType
}

struct FBArgumentsDecoder: Decoder {

    let arguments: [String: String]

    var codingPath: [CodingKey] = []
    var userInfo: [CodingUserInfoKey : Any] = [:]

    // MARK: - Public

    func value(for key: String) -> String? {
        arguments[key]
    }

    // MARK: - Decoder

    func container<Key>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key> where Key : CodingKey {
        let container = KeyeredArgumentContainer(decoder: self, type: type)
        return KeyedDecodingContainer(container)
    }

    func unkeyedContainer() throws -> UnkeyedDecodingContainer {
        fatalError()
    }

    func singleValueContainer() throws -> SingleValueDecodingContainer {
        fatalError()
    }
}

struct SingleValueDecoder: Decoder {

    var parsedElement: Any?
    var codingPath: [CodingKey] = []
    var userInfo: [CodingUserInfoKey : Any] = [:]

    // MARK: - Decoder

    func container<Key>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key> where Key : CodingKey {
        fatalError()
    }

    func unkeyedContainer() throws -> UnkeyedDecodingContainer {
        fatalError()
    }

    func singleValueContainer() throws -> SingleValueDecodingContainer {
        SingleValueContainer(
            underlying: self,
            codingPath: codingPath,
            parsedElement: parsedElement
        )
    }
}

struct SingleValueContainer: SingleValueDecodingContainer {

    var underlying: SingleValueDecoder
    var codingPath: [CodingKey]
    var parsedElement: Any?

    func decodeNil() -> Bool {
      return parsedElement == nil
    }

    func decode<T>(_ type: T.Type) throws -> T where T : Decodable {
      guard let element = parsedElement as? T else {
          throw DecodingError.invalidType
      }
      return element
    }
}

class KeyeredArgumentContainer<K: CodingKey>: KeyedDecodingContainerProtocol {

    let decoder: FBArgumentsDecoder

    init(decoder: FBArgumentsDecoder, type: K.Type) {
        self.decoder = decoder
    }

    func decode<T>(_ type: T.Type, forKey key: K) throws -> T where T : Decodable {
        let value = decoder.value(for: key.stringValue)
        if let element = value as? T {
            return element
        } else {
            let decoder = SingleValueDecoder(parsedElement: value)
            return try T.init(from: decoder)
        }
    }

    func contains(_ key: K) -> Bool {
        decoder.value(for: key.stringValue) != nil
    }

    func decodeNil(forKey key: K) throws -> Bool {
        fatalError()
    }

    func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type, forKey key: K) throws -> KeyedDecodingContainer<NestedKey> where NestedKey : CodingKey {
        fatalError()
    }

    func nestedUnkeyedContainer(forKey key: K) throws -> UnkeyedDecodingContainer {
        fatalError()
    }

    func superDecoder() throws -> Decoder {
        fatalError()
    }

    func superDecoder(forKey key: K) throws -> Decoder {
        fatalError()
    }

    var codingPath: [CodingKey] = []

    var allKeys: [K] {
        fatalError()
    }
}
