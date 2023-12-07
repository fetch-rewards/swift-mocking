//
//  main.swift
//  MockedClient
//
//  Created by Gray Campbell on 11/4/23.
//

import Foundation
import Mocked

@Mocked
public protocol Dependency<Item> where Item: Identifiable {
    associatedtype Item where Item: Hashable
    associatedtype Items: RandomAccessCollection where Items.Element == Item
    var items: Items { get async throws }
    var selectedItem: Item { get set }
    func item(id: Item.ID) async throws -> Item
    func someFunction(with id: Item.ID, param: @escaping () -> Void) -> Int
}
