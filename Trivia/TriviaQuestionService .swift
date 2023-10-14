//
//  TriviaQuestionService .swift
//  Trivia
//
//  Created by Ajaydeep Singh on 10/13/23.
//

import Foundation

class TriviaQuestionService {
    private let baseUrl = "https://opentdb.com/api.php"
    private var defaultParameters: [String: String] = ["amount": "10"]

    // A method to fetch questions from the API
    func fetchQuestions(completion: @escaping (Result<[TriviaQuestion], Error>) -> Void) {
        // Combine default parameters with any additional ones (if needed)
        let parameters = defaultParameters

        // Construct the URL with the parameters
        if let url = createURLWithParameters(baseUrl: baseUrl, parameters: parameters) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                } else if let data = data {
                    do {
                        // Parse the JSON response into an array of TriviaQuestion objects
                        let decodedData = try JSONDecoder().decode(TriviaQuestionsResponse.self, from: data)
                        let questions = decodedData.results
                        
                        
                        print("Decoded Data:", decodedData)
                        completion(.success(questions))
                    } catch {
                        print("Error decoding data:", error)

                        completion(.failure(error))
                    }
                }
            }.resume()
        }
    }
    // A method to reset the game (e.g., change the number of questions)
    func resetGame() {
        // Update the number of questions or any other parameters you want to change
        defaultParameters["amount"] = "10" // For example, reset to 10 questions
    }
    
    
    // Helper method to create a URL with parameters
    private func createURLWithParameters(baseUrl: String, parameters: [String: String]) -> URL? {
        var components = URLComponents(string: baseUrl)
        components?.queryItems = parameters.map { URLQueryItem(name: $0, value: $1) }
        return components?.url
    }
}

