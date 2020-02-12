//
//  ResultsViewController.swift
//  PersonalQuiz
//
//  Created by Alexey Efimov on 11.02.2020.
//  Copyright © 2020 Alexey Efimov. All rights reserved.
//

import UIKit

class ResultsViewController: UIViewController, UINavigationControllerDelegate {
    var answerChoosen = [Answer]()
    
    // 1. Передать сюда массив с ответами
    // 2. Определить наиболее часто встречающийся тип животного
    // 3. Отобразить результаты в соотвствии с этим животным
    
    @IBOutlet weak var resultPictureTextField: UILabel!
    @IBOutlet weak var resultMessageTextField: UILabel!
    @IBOutlet weak var navigationBar: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: false)
        calcResults()
    }
    
    private func calcResults() {
        var animalScore: [AnimalType: Int] = [.dog:0,.cat:0,.rabbit:0,.turtle:0]
        
        for item in answerChoosen {
            switch item.type {
            case .dog: animalScore[.dog]! += 1; print("dog")
            case .cat: animalScore[.cat]! += 1; print("cat")
            case .rabbit: animalScore[.rabbit]! += 1; print("rabbit")
            case .turtle: animalScore[.turtle]! += 1; print("turtle")
            }
        }
        
        let winnerType = animalScore.sorted {$0.1 > $1.1}.first?.key
        resultPictureTextField.text = String(winnerType!.rawValue)
        resultMessageTextField.text = winnerType?.difinition
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    deinit {
        print("ResultsViewController was been dealocated")
    }

}
