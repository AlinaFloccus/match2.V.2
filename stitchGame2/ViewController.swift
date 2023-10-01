//
//  ViewController.swift
//  stitchGame2
//
//  Created by Alina Floccus on 23.09.2023.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var timerLabel: UILabel!
    
    var imageArray = ["Austria", "Denmark", "France", "Italy", "Netherlands", "Norway", "Sweden", "Switzerland", "Austria", "Denmark", "France", "Italy", "Netherlands", "Norway", "Sweden", "Switzerland"]
    
    var isOpened = false
    var buttonState = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    
    var firstMove = 0
    
    var timeScore = 0
    
    var timer: Timer?
    var seconds = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       
        
        let start = UIAlertController(title: "", message:"", preferredStyle: .alert)
                
        start.addAction(UIAlertAction(title: "Начать игру", style: .default, handler: { [self] action in
            self.clearGame()
        }))
        self.present(start, animated: true, completion: nil)
    }


    @objc func timerScore() {
        seconds += 1
        
        var text = ""
        var minutes = seconds / 60
        
        if minutes > 0 {
            text += "\(minutes) мин., "
        }
        text += "\(seconds % 60) сек."
        
        timerLabel.text = text
        print("seconds is \(seconds)")
    }
    
    func clearGame() {
        buttonState = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
        firstMove = 0
        isOpened = false
        for tag in 1...16 {
            let button = view.viewWithTag(tag) as! UIButton
            button.setBackgroundImage(nil, for: .normal)
        }
        
        timer?.invalidate()
        seconds = 0
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerScore), userInfo: nil, repeats: true)
        imageArray.shuffle()
    }
    
    
    @IBAction func game(_ sender: UIButton) {
        print("в начале \(isOpened)")
        print("tag элемента \(sender.tag)")
        
        if buttonState[sender.tag-1] == 0 {
            // переворачиваем картинку
            sender.setBackgroundImage(UIImage(named: imageArray[sender.tag-1]), for: .normal)
            
            // чтобы не нажимали кнопку повторно
            if firstMove == sender.tag {
                return
            }
            
            print("картинка в кнопке установилась \(imageArray[sender.tag-1])")
            
            
            if isOpened {
                
                let previousButton = view.viewWithTag(firstMove) as! UIButton
                
                // сравнить изображения
                let firstImage: String = imageArray[previousButton.tag-1]
                let secondImage: String = imageArray[sender.tag-1]
                print(firstImage, secondImage)
                
                if firstImage == secondImage {
                    print("совпадают")
                    buttonState[sender.tag-1] = 1
                    buttonState[previousButton.tag-1] = 1
                    print(buttonState)
                    
                } else {
                    // закрыть изображения
                    Timer.scheduledTimer(withTimeInterval: 1, repeats: false) {_ in
                        sender.setBackgroundImage(nil, for: .normal)
                        previousButton.setBackgroundImage(nil, for: .normal)
                    }
                }
                
            } else {
                firstMove = sender.tag
                print("firstMove is \(firstMove)")
            }
            
            isOpened = !isOpened
        }
        // Для отображение модалки
        var sumArray = 0
        for check in buttonState {
            if check == 0 {
                break
            } else {
                sumArray += check
            }
        }
        if sumArray < 16 {
            return
        } else {
            var text = ""
            var minutes = seconds / 60
            
            if minutes > 0 {
                text += "\(minutes) мин., "
            }
            text += "\(seconds % 60) сек."
            
            let alert = UIAlertController(title: "Игра закончена!", message:"Вы прошли игру за \(text)", preferredStyle: .alert)
            timer?.invalidate()
                    
                    alert.addAction(UIAlertAction(title: "Начать заново", style: .default, handler: { [self] action in
                        self.clearGame()
                 
                    }))
                    self.present(alert, animated: true, completion: nil)
        }
    }
}
