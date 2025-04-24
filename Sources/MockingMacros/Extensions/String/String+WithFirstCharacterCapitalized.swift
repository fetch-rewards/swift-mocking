//
//  String+WithFirstCharacterCapitalized.swift
//
//  Copyright © 2025 Fetch.
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
