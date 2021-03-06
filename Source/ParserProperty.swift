//
//  ParserProperty.swift
//
//  Copyright (c) 2015-2016 Nike, Inc. (https://www.nike.com)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import Foundation

/**
    Defines a Swift object type used to extract values from a JSON document.

    - String:     Represents a Swift `String` type.
    - UInt:       Represents a Swift `UInt` type.
    - Int:        Represents a Swift `Int` type.
    - Float:      Represents a Swift `Float` type.
    - Double:     Represents a Swift `Double` type.
    - Bool:       Represents a Swift `Bool` type.
    - Array:      Represents a Swift `Array` type.
    - Dictionary: Represents a Swift `Dictionary` type.
    - URL:        Represents a Swift `URL` type.
*/
public enum ParserPropertyType {
    case String
    case UInt
    case Int
    case Float
    case Double
    case Bool
    case Array
    case Dictionary
    case URL
}

/**
    Represents a parser property and all its internal characteristics.
*/
public struct ParserProperty {

    /**
        Indicates how a property value should be decoded.

        - UseDecoder:   Should be decoded with the provided instance of a Decoder.
        - UseDecodable: Should be decoded to an instance of the provided Decodable type.
    */
    public enum DecodingMethod {
        case UseDecoder(Decoder)
        case UseDecodable(Decodable.Type)
    }

    let type: ParserPropertyType
    let keyPath: String
    let optional: Bool
    let decodingMethod: DecodingMethod?

    init(type: ParserPropertyType, keyPath: String, optional: Bool, decodingMethod: DecodingMethod?) {
        self.type = type
        self.keyPath = keyPath
        self.optional = optional
        self.decodingMethod = decodingMethod
    }
}

// MARK: -

/**
    The parser property maker is used to define the list of properties to be validated and extracted from a object.
    If a property is not defined in the list it will be ignored.
*/
public class ParserPropertyMaker {
    var properties = [ParserProperty]()

    /**
        Creates, adds and returns a property for the specified key path, type and optionality.

        NOTE: Compound key paths may be used (e.g. `address.city`). Each property name in the key path MUST be
        separated by a `.` character.

        - parameter keyPath:  Key path for property.
        - parameter type:     Swift object type to be validated and extracted.
        - parameter optional: Specifies if the keyPath is optional. `false` by default.

        - returns: The created parser property.
    */
    public func propertyForKeyPath(keyPath: String, type: ParserPropertyType, optional: Bool = false) -> ParserProperty {
        return addProperty(keyPath: keyPath, type: type, optional: optional, decodingMethod: nil)
    }

    /**
        Creates, adds and returns a property for the specified key path, type, optionality and decodable type.

        NOTE: Compound key paths may be used (e.g. `address.city`). Each property name in the key path MUST be
        separated by a `.` character.

        - parameter keyPath:       Key path for property.
        - parameter type:          Swift object type to be validated and extracted.
        - parameter optional:      Specifies if the keyPath is optional. `false` by default.
        - parameter decodedToType: The `Decodable` type associated to the property. `nil` by default.

        - returns: The created parser property.
    */
    public func propertyForKeyPath(
        keyPath: String,
        type: ParserPropertyType,
        optional: Bool = false,
        decodedToType decodableType: Decodable.Type?)
        -> ParserProperty
    {
        var decodingMethod: ParserProperty.DecodingMethod?

        if let decodableType = decodableType {
            decodingMethod = ParserProperty.DecodingMethod.UseDecodable(decodableType)
        }

        return addProperty(keyPath: keyPath, type: type, optional: optional, decodingMethod: decodingMethod)
    }

    /**
        Creates, adds and returns a property for the specified key path, type, optionality and decoder.

        NOTE: Compound key paths may be used (e.g. `address.city`). Each property name in the key path MUST be
        separated by a `.` character.

        - parameter keyPath:  Key path for property.
        - parameter type:     Swift object type to be validated and extracted.
        - parameter optional: Specifies if the keyPath is optional. `false` by default.
        - parameter decoder:  The `Decoder` associated to the property. `nil` by default.

        - returns: The created parser property.
    */
    public func propertyForKeyPath(
        keyPath: String,
        type: ParserPropertyType,
        optional: Bool = false,
        decoder: Decoder?)
        -> ParserProperty
    {
        var decodingMethod: ParserProperty.DecodingMethod?

        if let decoder = decoder {
            decodingMethod = ParserProperty.DecodingMethod.UseDecoder(decoder)
        }

        return addProperty(keyPath: keyPath, type: type, optional: optional, decodingMethod: decodingMethod)
    }

    func addProperty(
        keyPath keyPath: String,
        type: ParserPropertyType,
        optional: Bool,
        decodingMethod: ParserProperty.DecodingMethod?)
        -> ParserProperty
    {
        let property = ParserProperty(type: type, keyPath: keyPath, optional: optional, decodingMethod: decodingMethod)
        self.properties.append(property)

        return property
    }
}
