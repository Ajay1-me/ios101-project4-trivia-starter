//
//  ViewController.swift
//  Trivia
//
//  Created by Mari Batilando on 4/6/23.
//

import UIKit

class TriviaViewController: UIViewController {
    let triviaService = TriviaQuestionService()
 
  @IBOutlet weak var currentQuestionNumberLabel: UILabel!
  @IBOutlet weak var questionContainerView: UIView!
  @IBOutlet weak var questionLabel: UILabel!
  @IBOutlet weak var categoryLabel: UILabel!
  @IBOutlet weak var answerButton0: UIButton!
  @IBOutlet weak var answerButton1: UIButton!
  @IBOutlet weak var answerButton2: UIButton!
  @IBOutlet weak var answerButton3: UIButton!
  
  private var questions = [TriviaQuestion]()
  private var currQuestionIndex = 0
  private var numCorrectQuestions = 0
  private var shouldResetGame = false
  
  override func viewDidLoad() {
    super.viewDidLoad()
    addGradient()
    questionContainerView.layer.cornerRadius = 8.0
    // TODO: FETCH TRIVIA QUESTIONS HERE
      
    fetchQuestions()
  }
    // A method to fetch questions and handle the response
    func fetchQuestions() {
        if shouldResetGame {
            // Reset the flag and fetch new questions
            shouldResetGame = false
            triviaService.resetGame() // Reset game parameters as needed
        }
        triviaService.fetchQuestions { [weak self] result in
            guard let self = self else { return }

            DispatchQueue.main.async {
                switch result {
                case .success(let questions):
                    print("Successfully fetched questions:", questions)

                    self.questions = questions
                    self.updateQuestion(withQuestionIndex: 0) // Update UI with the first question
                case .failure(let error):
                    print("Error fetching questions: \(error)")
                    // Handle the error, e.g., display an error message to the user
                }
            }
        }
    }
    // A method to reset the game
    func resetGame() {
        shouldResetGame = true // Set the reset flag to true
        triviaService.resetGame() // Reset the game parameters, e.g., number of questions
        numCorrectQuestions = 0 // Reset the score
        currQuestionIndex = 0 // Reset the question index
        updateQuestion(withQuestionIndex: currQuestionIndex) // Display the first question
    }
    
    private func displayQuestion(_ question: String) {
       let decodedQuestion = decodeHTMLEntities(in: question)
       questionLabel.text = decodedQuestion
    }
    
    
  private func updateQuestion(withQuestionIndex questionIndex: Int) {
    /*currentQuestionNumberLabel.text = "Question: \(questionIndex + 1)/\(questions.count)"
    let question = questions[questionIndex]
    questionLabel.text = question.question
    categoryLabel.text = question.category
    let answers = ([question.correctAnswer] + question.incorrectAnswers).shuffled()
    if answers.count > 0 {
      answerButton0.setTitle(answers[0], for: .normal)
    }*/
      
      guard questionIndex >= 0, questionIndex < questions.count else {
          // Handle the case where the questionIndex is out of bounds
          // For example, reset the game or show an error message
          return
      }

      currentQuestionNumberLabel.text = "Question: \(questionIndex + 1)/\(questions.count)"
      let question = questions[questionIndex]
      questionLabel.text = question.question
      categoryLabel.text = question.category
      
      if question.type == "boolean" {
          // For True or False questions, display only two answer options
          answerButton0.setTitle("True", for: .normal)
          answerButton1.setTitle("False", for: .normal)
          answerButton2.isHidden = true
          answerButton3.isHidden = true
      } else {
          // For multiple-choice questions, shuffle and display all answer options
          let answers = ([question.correct_answer] + question.incorrect_answers).shuffled()
          answerButton0.setTitle(answers[0], for: .normal)
          answerButton1.setTitle(answers[1], for: .normal)
          answerButton2.setTitle(answers[2], for: .normal)
          answerButton3.setTitle(answers[3], for: .normal)
      }
      
      let answers = ([question.correct_answer] + question.incorrect_answers).shuffled()
      
      answerButton0.setTitle(answers[0], for: .normal)
    if answers.count > 1 {
      answerButton1.setTitle(answers[1], for: .normal)
      answerButton1.isHidden = false
    }
    if answers.count > 2 {
      answerButton2.setTitle(answers[2], for: .normal)
      answerButton2.isHidden = false
    }
    if answers.count > 3 {
      answerButton3.setTitle(answers[3], for: .normal)
      answerButton3.isHidden = false
    }
  }
  
  private func updateToNextQuestion(answer: String) {
    if isCorrectAnswer(answer) {
      numCorrectQuestions += 1
    }
    currQuestionIndex += 1
    guard currQuestionIndex < questions.count else {
      showFinalScore()
      return
    }
    updateQuestion(withQuestionIndex: currQuestionIndex)
  }
  
  private func isCorrectAnswer(_ answer: String) -> Bool {
      if currQuestionIndex < questions.count {
          return answer == questions[currQuestionIndex].correct_answer
      } else {
          return false // Handle the case where currQuestionIndex is out of bounds
      }
      //return answer == questions[currQuestionIndex].correctAnswer
  }
  
  private func showFinalScore() {
    let alertController = UIAlertController(title: "Game over!",
                                            message: "Final score: \(numCorrectQuestions)/\(questions.count)",
                                            preferredStyle: .alert)
    let resetAction = UIAlertAction(title: "Reset", style: .default) { [unowned self] _ in
      shouldResetGame = true // Set the reset flag to true
      currQuestionIndex = 0
      numCorrectQuestions = 0
        updateQuestion(withQuestionIndex: self.currQuestionIndex)
    }
    alertController.addAction(resetAction)
    present(alertController, animated: true, completion: nil)
  }
  
  private func addGradient() {
    let gradientLayer = CAGradientLayer()
    gradientLayer.frame = view.bounds
    gradientLayer.colors = [UIColor(red: 0.54, green: 0.88, blue: 0.99, alpha: 1.00).cgColor,
                            UIColor(red: 0.51, green: 0.81, blue: 0.97, alpha: 1.00).cgColor]
    gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
    gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
    view.layer.insertSublayer(gradientLayer, at: 0)
  }
  
  @IBAction func didTapAnswerButton0(_ sender: UIButton) {
    updateToNextQuestion(answer: sender.titleLabel?.text ?? "")
  }
  
  @IBAction func didTapAnswerButton1(_ sender: UIButton) {
    updateToNextQuestion(answer: sender.titleLabel?.text ?? "")
  }
  
  @IBAction func didTapAnswerButton2(_ sender: UIButton) {
    updateToNextQuestion(answer: sender.titleLabel?.text ?? "")
  }
  
  @IBAction func didTapAnswerButton3(_ sender: UIButton) {
    updateToNextQuestion(answer: sender.titleLabel?.text ?? "")
  }
}

