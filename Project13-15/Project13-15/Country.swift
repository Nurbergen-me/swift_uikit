//
//  Country.swift
//  Project13-15
//
//  Created by Nurbergen Yeleshov on 12.01.2021.
//

import Foundation

struct Country: Codable, PropertyLoopable {
    var name: String
    var capital: String
    var region: String
    var population: Int
}

protocol PropertyLoopable
{
    func allProperties() throws -> [String: Any]
}

extension PropertyLoopable
{
    func allProperties() throws -> [String: Any] {

        var result: [String: Any] = [:]

        let mirror = Mirror(reflecting: self)

        guard let style = mirror.displayStyle, style == .struct || style == .class else {
            //throw some error
            throw NSError(domain: "hris.to", code: 777, userInfo: nil)
        }

        for (labelMaybe, valueMaybe) in mirror.children {
            guard let label = labelMaybe else {
                continue
            }

            result[label] = valueMaybe
        }

        return result
    }
}
