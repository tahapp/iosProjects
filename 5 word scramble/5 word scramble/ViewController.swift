//
//  ViewController.swift
//  5 word scramble
//
//  Created by Taha Saleh on 6/5/22.
//

import UIKit

final class TableViewController: UITableViewController
{
    var allWords : [String] = []
    var usedWords : [String] = []
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = .init(barButtonSystemItem: .add, target: self, action: #selector(add))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "restart", style: .plain, target: self, action: #selector(startGame))
        if let fileName = Bundle.main.url(forResource: "start", withExtension: ".txt")
        {
            do {
                 let string = try String(contentsOf: fileName)
                 allWords = string.components(separatedBy: "\n")
            } catch{
                allWords = ["silkworm"]
            }
        }
        startGame()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usedWords.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "word", for: indexPath)
        var config = cell.defaultContentConfiguration()
        config.text = usedWords[indexPath.row]
        config.textProperties.font = .systemFont(ofSize: 30)
        cell.contentConfiguration = config
        return cell
    }
    
    @objc func startGame()
    {
        title = allWords.randomElement()
        usedWords.removeAll()
        tableView.reloadData()
    }
    @objc func add()
    {
        let ac = UIAlertController(title: "enter Answer", message: nil, preferredStyle: .alert)
        ac.addTextField(configurationHandler: {t in
            t.font = .systemFont(ofSize: 20)
        })
        let submitAction = UIAlertAction(title: "Submit", style: .default){
            [unowned self , unowned a = ac] _  in
            guard let answer = a.textFields?[0].text else{return}
            self.submitAnswer(answer)
        }
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    func submitAnswer(_ answer:String)
    {
        let lowerAnswer = answer.lowercased()
        let errorTitle:String
        let errorMessage:String
        if isPossible(word: lowerAnswer)
        {
            if isOrginal(word: lowerAnswer)
            {
                if isReal(word: lowerAnswer)
                {
                    usedWords.insert(lowerAnswer, at: 0)
                    let index = IndexPath(row: 0, section: 0)
                    tableView.insertRows(at : [index], with: .automatic )
                    return
                }else
                {
                    errorTitle = "word not recognize"
                    errorMessage = "you can't make words up"
                }
            }else
            {
                errorTitle = "word used already"
                errorMessage = "be more creative"
            }
        }else
        {
            errorTitle = "word is not possible"
            errorMessage = "you can't spell '\(lowerAnswer)' from \(title!.lowercased())"
        }
        
        let ac  = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
        present(ac, animated: true)
    }
    func isPossible(word:String)->Bool
    {
        guard var titleWord = self.title else{return false}
        for letter in word
        {
            if let index = titleWord.firstIndex(of: letter)
            {
                titleWord.remove(at: index)
            }else{
                return false
            }
        }
        return true
    }
    func isOrginal(word:String)->Bool
    {
        return !usedWords.contains(word)
    }
    func isReal(word:String)->Bool
    {
        let checker = UITextChecker()
        let nsRange = NSRange(location: 0, length: word.utf16.count)
        let missplledRange = checker.rangeOfMisspelledWord(in: word, range: nsRange, startingAt: 0, wrap: false, language: "en")
        return missplledRange.location == NSNotFound
    }
}
 
