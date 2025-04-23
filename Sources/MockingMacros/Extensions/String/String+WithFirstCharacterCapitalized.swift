//
//  String+WithFirstCharacterCapitalized.swift
//  MockingMacros
//
//  Created by Gray Campbell on 2/28/25.
//

import Foundation

extension String {

    /// Returns a copy of the string with the first character capitalized.
    ///
    /// - Returns: A copy of the string with the first character capitalized.
    func withFirstCharacterCapitalized() -> String {
        let firstCharacter = self.prefix(1).capitalized
        let remainingCharacters = self.dropFirst()

        return String(firstCharacter) + String(remainingCharacters)
    }
}
