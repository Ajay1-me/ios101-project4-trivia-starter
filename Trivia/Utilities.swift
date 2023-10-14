//
//  Utilities.swift
//  Trivia
//
//  Created by Ajaydeep Singh on 10/13/23.
//

import Foundation

func decodeHTMLEntities(in string: String) -> String {
    if let data = string.data(using: .utf8),
        let attributedString = try? NSAttributedString(data: data,
                                                      options: [
                                                          .documentType: NSAttributedString.DocumentType.html,
                                                          .characterEncoding: String.Encoding.utf8.rawValue
                                                      ],
                                                      documentAttributes: nil) {
        return attributedString.string
    } else {
        return string
    }
}
