//
//  TriviaQuestion.swift
//  Trivia
//
//  Created by Mari Batilando on 4/6/23.
//

import Foundation

struct TriviaQuestion: Codable {
  let category: String
  let type: String
  let question: String
  let correct_answer: String
  let incorrect_answers: [String]
}
