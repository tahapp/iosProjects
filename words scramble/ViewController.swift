//
//  ViewController.swift
//  8 swifty word
//
//  Created by Taha Saleh on 7/21/22.
//

import UIKit

class ViewController: UIViewController
{

    let scoreLabel = UILabel()
    let cluesLabel = UILabel()
    let answerLabel = UILabel()
    let currentAnswer = UITextField()
    var letterButtons = [UIButton]()
    var score = 0
    {
        didSet
        {
            scoreLabel.text = "score = \(score)"
        }
    }
    
    var answersFullWord : [String] = []
    var submittedAnswers = [String]()
    let noRepeat : NSCountedSet = NSCountedSet()
    var level = 1
    override func viewDidLoad()
    {
        super.viewDidLoad()
      
        
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        cluesLabel.translatesAutoresizingMaskIntoConstraints = false
        answerLabel.translatesAutoresizingMaskIntoConstraints = false
        currentAnswer.translatesAutoresizingMaskIntoConstraints = false
        
        scoreLabel.text = "score = \(score)"
        scoreLabel.font = .systemFont(ofSize: 20)
        
   
        answerLabel.text = ""
        answerLabel.numberOfLines = 10
        answerLabel.font = .systemFont(ofSize: 25)
        answerLabel.textAlignment  = .right
        answerLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        
        cluesLabel.text = ""
        cluesLabel.numberOfLines = 10
        cluesLabel.font = .systemFont(ofSize: 25)
        cluesLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        
        currentAnswer.placeholder = "Tap letters to guess"
        currentAnswer.translatesAutoresizingMaskIntoConstraints = false
        currentAnswer.textAlignment = .center
        currentAnswer.font = .systemFont(ofSize: 40)
        
        
        view.addSubview(scoreLabel)
        view.addSubview(answerLabel)
        view.addSubview(cluesLabel)
        view.addSubview(currentAnswer)
        
        let submit = UIButton(type: .system)
        submit.translatesAutoresizingMaskIntoConstraints = false
        submit.setTitle("SUBMIT", for: .normal)
        submit.titleLabel?.font = .systemFont(ofSize: 20)
        submit.addTarget(self, action: #selector(submitAnswer), for: .touchUpInside)
        
        let cancel = UIButton(type: .system)
        cancel.translatesAutoresizingMaskIntoConstraints = false
        cancel.setTitle("CANCEL", for: .normal)
        cancel.titleLabel?.font = .systemFont(ofSize: 20)
        cancel.addTarget(self, action: #selector(clearAnswer), for: .touchUpInside)
        
        view.addSubview(submit)
        view.addSubview(cancel)
        
        let buttonsContainer = UIView()
        
        buttonsContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonsContainer)
        
        NSLayoutConstraint.activate([
            scoreLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scoreLabel.rightAnchor.constraint(equalTo: view.rightAnchor,constant: -10),
            
            cluesLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor,constant: 20),
            cluesLabel.leftAnchor.constraint(equalTo: view.leftAnchor,constant: 100),
            cluesLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6,constant: -100),
            
            answerLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor,constant: 20),
            answerLabel.rightAnchor.constraint(equalTo: view.rightAnchor,constant: -100),
            answerLabel.heightAnchor.constraint(equalTo: cluesLabel.heightAnchor),
            answerLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.3),
            
            currentAnswer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            currentAnswer.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            currentAnswer.topAnchor.constraint(equalTo: cluesLabel.bottomAnchor,constant:20),
            
            submit.topAnchor.constraint(equalTo: currentAnswer.bottomAnchor,constant: 5),
            submit.centerXAnchor.constraint(equalTo: view.centerXAnchor,constant: -100),
            submit.heightAnchor.constraint(equalToConstant: 44),
            
            cancel.topAnchor.constraint(equalTo: currentAnswer.bottomAnchor,constant: 5),
            cancel.centerXAnchor.constraint(equalTo: view.centerXAnchor,constant: 100),
            cancel.centerYAnchor.constraint(equalTo: submit.centerYAnchor),
            cancel.heightAnchor.constraint(equalToConstant: 44),
            
            buttonsContainer.widthAnchor.constraint(equalToConstant: 720),
            buttonsContainer.heightAnchor.constraint(equalToConstant: 320),
            buttonsContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonsContainer.topAnchor.constraint(equalTo: submit.bottomAnchor,constant: 20),
            buttonsContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,constant: -20)
        ])
        
        let width : Int = 144
        let height : Int = 80
        
        for column in 0..<4
        {
            for row in 0..<5
            {
                let button = UIButton(frame: CGRect(x: row * width, y: column * height, width: width, height: height))
                button.setTitleColor(.black, for: .normal)
                button.layer.borderWidth = 1
                button.titleLabel?.font = .systemFont(ofSize: 30)
                button.addTarget(self, action: #selector(bitsTapped), for: .touchUpInside)
                buttonsContainer.addSubview(button)
                letterButtons.append(button)
            }
        }
        loadLevel(level: level)
    }

    func loadLevel(level:Int)
    {
        
        var answersBits : [String] = []
        var clueString = ""
        var solutionString = ""
        guard let file = Bundle.main.url(forResource: "level\(level)", withExtension: "txt")else {return}
        
        do
        {
            let content = try String(contentsOf: file)
            var lines = content.components(separatedBy: "\n")
            lines.shuffle()
            for (index ,line) in lines.enumerated()
            {
                let parts = line.components(separatedBy:": ")
                let solution = parts[0]
                let clue = parts[1]
                
                clueString += "\(index+1). \(clue)\n"
                let solutionWord = solution.replacingOccurrences(of: "|", with: "")
                solutionString += "\(solutionWord.count) letters\n"
                
                answersFullWord.append(solutionWord)
                answersBits.append(contentsOf: solution.components(separatedBy: "|"))
            }
        }catch
        {
            print("could not read the file")
        }
        answerLabel.text = solutionString.trimmingCharacters(in: .whitespacesAndNewlines)
        cluesLabel.text = clueString.trimmingCharacters(in: .whitespacesAndNewlines)
        answersBits.shuffle()
        
        for (i,n) in letterButtons.enumerated()
        {
            
            n.setTitle(answersBits[i], for: .normal)
        }
    }
    
    @objc func bitsTapped(_ sender : UIButton)
    {
        
        
        guard let bits = sender.currentTitle else{return }
        
        noRepeat.add(sender)
        let transparentYello = UIColor.yellow.withAlphaComponent(0.5)
        sender.backgroundColor = transparentYello
        if noRepeat.count(for: sender) > 1
        {
            let ac = UIAlertController(title: "can't use it twice", message:nil, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "ok", style: .default))
            ac.popoverPresentationController?.sourceView = view
            present(ac, animated: true)
            return
        }
        currentAnswer.text?.append(bits)
        
       
    }
    
    @objc func clearAnswer()
    {
        currentAnswer.text?.removeAll()
        for (_,n) in noRepeat.enumerated(){
            let button = n as? UIButton
            button?.backgroundColor = .clear
        }
        noRepeat.removeAllObjects()
        
    }
    
    
    @objc func submitAnswer()
    {
        
        guard let answer = currentAnswer.text else{return}
        if submittedAnswers.contains(answer)
        {
            let ac = UIAlertController(title: "Word submitted already", message:"try different word", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "ok", style: .default))
            ac.popoverPresentationController?.sourceView = view
            present(ac, animated: true){
                return
            }
            
        }
       else if answersFullWord.contains(answer)
        {
            
            var answersLabelarray = answerLabel.text?.components(separatedBy: "\n")
            
            guard let index = answersFullWord.firstIndex(of: answer) else{return}
            answersLabelarray?[index] = answer
            let text = answersLabelarray?.joined(separator: "\n")
            answerLabel.text  = text
            clearAnswer()
            score += 1
            submittedAnswers.append(answer)
        }else
        {
            let ac = UIAlertController(title: "Word not found!", message:"look again", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "ok", style: .default))
            ac.popoverPresentationController?.sourceView = view
            present(ac, animated: true,completion: { [unowned self] in
                self.score -= 1
            })
        }
        
        if submittedAnswers.count >= 7
        {
            levelUp()
        }
    }
    
    
    func levelUp()
    {
        level += 1
        if level > 2
        {
            level = 1
            let ac = UIAlertController(title: "finished the game", message:"you reached the final level ", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "ok", style: .default))
            ac.popoverPresentationController?.sourceView = view
            present(ac, animated: true)
            
            return
        }
        
        answersFullWord.removeAll(keepingCapacity: true)
        submittedAnswers.removeAll(keepingCapacity: true)
        noRepeat.removeAllObjects()
        
        loadLevel(level: level)
    }
}

