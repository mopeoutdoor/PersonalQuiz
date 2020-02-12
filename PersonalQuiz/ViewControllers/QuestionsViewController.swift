//
//  QuestionsViewController.swift
//  PersonalQuiz
//
//  Created by Alexey Efimov on 11.02.2020.
//  Copyright © 2020 Alexey Efimov. All rights reserved.
//

import UIKit

class QuestionsViewController: UIViewController {
    
    // MARK: - IB Outlets
    @IBOutlet var questionLabel: UILabel!
    
    @IBOutlet var singleStackView: UIStackView!
    @IBOutlet var multipleStackView: UIStackView!
    @IBOutlet var rangedStackView: UIStackView!
    
    @IBOutlet var singleButtons: [UIButton]!
    @IBOutlet var multipleLabels: [UILabel]!
    @IBOutlet var multipleSwitches: [UISwitch]!
    @IBOutlet var rangedLabels: [UILabel]!
    
    @IBOutlet var rangedSlider: UISlider!
    @IBOutlet var progressView: UIProgressView!
    
    // MARK: - Private properties
    private let questions = Question.getQuestions()
    private var questionIndex = 0
    private var answerChoosen: [Answer] = []
    private var currentAnswers: [Answer] {
        return questions[questionIndex].answers
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    // MARK: - IB Actions
    @IBAction func singleAnswerButtonPressed(_ sender: UIButton) {
        guard let answerIndex = singleButtons.firstIndex(of: sender) else { return }
        let currentAnswer = currentAnswers[answerIndex]
        answerChoosen.append(currentAnswer)
        nextQuestion()
    }
    
    @IBAction func multipleAnswerButtonPressed() {
        for (multipleSwitch, answer) in zip(multipleSwitches, currentAnswers) {
            if multipleSwitch.isOn {
                answerChoosen.append(answer)
            }
        }
        
        nextQuestion()
    }
    
    @IBAction func rangedAnswerButtonPressed() {
        let index = Int(round(rangedSlider.value * Float(currentAnswers.count - 1)))
        let currentAnswer = currentAnswers[index]
        answerChoosen.append(currentAnswer)
        nextQuestion()
    }
    
    deinit {
        print("QuestionsViewController was been dealocated")
    }

}

// MARK: - Private Methods
extension QuestionsViewController {
    private func updateUI() {
        
        // Hide everything
        for stackView in [singleStackView, multipleStackView, rangedStackView] {
            stackView?.isHidden = true
        }
        
        // Get current question
        let currentQuestion = questions[questionIndex]
        
        // Set current question for question label
        questionLabel.text = currentQuestion.text
        
        // Calculate progress
        let totalProgress = Float(questionIndex) / Float(questions.count)
        
        // Set progress for progress view
        progressView.setProgress(totalProgress, animated: true)
        
        // Set navigation title
        title = "Вопрос № \(questionIndex + 1) из \(questions.count)"
        
        showCurrentAnswers(for: currentQuestion)
    }
    
    private func showCurrentAnswers(for question: Question) {
        switch question.type {
        case .single: showSingleStackView(with: currentAnswers)
        case .multiple: showMultipleStackView(with: currentAnswers)
        case .ranged: showRangedStackView(with: currentAnswers)
        }
    }
    
    
    /// Show single stack view
    /// - Parameter answers: array with answers
    ///
    /// Discription of method
    private func showSingleStackView(with answers: [Answer]) {
        singleStackView.isHidden = false
        
        for (button, answer) in zip(singleButtons, answers) {
            button.setTitle(answer.text, for: .normal)
        }
    }
    
    private func showMultipleStackView(with answers: [Answer]) {
        multipleStackView.isHidden = false
        
        for (label, answer) in zip(multipleLabels, answers) {
            label.text = answer.text
        }
    }
    
    private func showRangedStackView(with answers: [Answer]) {
        rangedStackView.isHidden = false
        
        rangedLabels.first?.text = answers.first?.text
        rangedLabels.last?.text = answers.last?.text
    }
}

// MARK: - Navigation
extension QuestionsViewController {
    private func nextQuestion() {
        questionIndex += 1
        
        if questionIndex < questions.count {
            updateUI()
        } else {
            performSegue(withIdentifier: "ResultSegue", sender: nil)
        }
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //let navigationController = segue.destination as! UINavigationController
        let destinationVC = segue.destination as! ResultsViewController
        destinationVC.answerChoosen = answerChoosen
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    
}
