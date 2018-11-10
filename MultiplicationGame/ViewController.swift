//
//  ViewController.swift
//  TimesCar
//
//  Created by Nick Wen on 2018/10/19.
//  Copyright © 2018 Nick Wen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var winButton: UIButton!
    
    @IBOutlet weak var finishLineImageView: UIImageView!
    
    @IBOutlet var questionLabels: [UILabel]!
    
    @IBOutlet var carImageViews: [UIImageView]!
    @IBOutlet var questionViews: [UIView]!
    
    @IBOutlet var topChoiceButtons: [UIButton]!
    
    @IBOutlet var bottomChoiceButtons: [UIButton]!
    
    
        
    
    
    var questions = [Question]()
    var questionIndexes = [Int](repeating: 0, count: 2)//創建重複0值2次的整數陣列。

    let top = 1//上面題目區索引值為1,下面題目區索引值為0
    let choiceNumbers = [Int](1...99)//產生包含1~99的陣列
    
    
    func createQuestion() -> Question {//創建題目實例

        let numberRange = 1...9//乘法數字範圍值1~9
        let number1 = Int.random(in: numberRange)//乘法第一個數字
        let number2 = Int.random(in: numberRange)//乘法第二個數字
        let choiceRange = 0...3//按鈕index,有四個答案按鈕
        let answerIndex = Int.random(in: choiceRange)//準備等等要放正確答案的按鈕索引0...3隨機挑一個
        let answer = number1 * number2//答案
//        print("choiceNumbers: \(choiceNumbers)")
        var choices = choiceNumbers.filter { (number) -> Bool in//避免答案重複出現,先將陣列中出現答案的數值去除
            return answer != number
        }
        
//        print("choices: \(choices)")
        choices.shuffle()//將陣列隨機調整順序(類似洗牌)
        choices[answerIndex] = answer//放入正確答案
        
        let question = Question(title: (number1, number2), choices: Array(choices[choiceRange]))//slice array cast to array
        questions.append(question)
//        print("questions: \(questions)")
        return question
    }
    
    func showQuestion(location: Int, question: Question) {//顯示題目
        questionLabels[location].text = "\(question.title.0) × \(question.title.1)"
        if location == top {
            for (i, button) in topChoiceButtons.enumerated() {//topChoiceButtons.enumerated()陣列轉型為tuple
                button.setTitle(question.choices[i].description, for: .normal)
            }
        } else {
            for (i, button) in bottomChoiceButtons.enumerated() {
                button.setTitle(question.choices[i].description, for: .normal)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        questionViews[top].transform = CGAffineTransform(rotationAngle: CGFloat.pi)//將題目順時針旋轉180度
        carImageViews[top].transform = CGAffineTransform(rotationAngle: CGFloat.pi)//將小馬順時針旋轉180度
        initGame()//初始化遊戲
    }
    
    func initGame() {
        questions.removeAll()//將答案都移除
        let question = createQuestion()//重新創建遊戲
        for i in 0...1 {
            questionIndexes[i] = 0
            showQuestion(location: i, question: question)
            carImageViews[i].frame.origin.x = 91//移動兩個image位置到左邊91位置
        }
    }
    
   

    @IBAction func winButtonPressed(_ sender: Any) {
        
        winButton.isHidden = true
        initGame()//按下勝利button 重置遊戲
        
    }
    @IBAction func choiceButtonPressed(_ sender: UIButton) {
        
        let questionViewTag = sender.superview!.tag//sender.superview!表示外層的view,tag=0表示下面的view、1表示上面的view
        var questionIndex = questionIndexes[questionViewTag]
        let question = questions[questionIndex]
        let answer = question.title.0 * question.title.1
        let choice = question.choices[sender.tag]//sender.tag範圍為0~3
        if choice == answer {//若答對
            UIView.animate(withDuration: 0.5) {//以0.5秒速度移動位置
                self.carImageViews[questionViewTag].center.x += 50

            }
        }
        
        if carImageViews[questionViewTag].frame.maxX >= finishLineImageView.frame.minX {//若小馬或小鴨的圖片右邊界碰觸到終點區塊的左邊界則勝利
            if questionViewTag == 0 {//0表示下面的player,1表示上面的player
                winButton.setTitle("小鴨 抵達終點", for: .normal)

            } else {
                winButton.setTitle("獨角獸 抵達終點", for: .normal)

            }
            winButton.isHidden = false//重啟按鈕打開
        }
        
        questionIndex += 1
        questionIndexes[questionViewTag] = questionIndex//分別紀錄上下玩家答到第幾題
        if questionIndex >= questions.count {//答題速度快者要繼續創建題目
            _ = createQuestion()
        }
        showQuestion(location: questionViewTag, question: questions[questionIndex])
    }
    
}

