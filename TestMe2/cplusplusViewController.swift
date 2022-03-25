//
//  qViewController.swift
//  TestMe2
//
//  Created by admin on 3/15/22.
//

import UIKit
import SQLite3

class cplusplusQViewController: UIViewController {
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var NumberLabel: UILabel!
    @IBOutlet weak var AnsA: UILabel!
    @IBOutlet weak var AnsB: UILabel!
    @IBOutlet weak var AnsC: UILabel!
    @IBOutlet weak var AnsD: UILabel!
    @IBOutlet weak var testQuestion: UILabel!
    @IBOutlet weak var AnsACheckBox: UIButton!
    @IBOutlet weak var AnsBCheckBox: UIButton!
    @IBOutlet weak var AnsCCheckBox: UIButton!
    @IBOutlet weak var AnsDCheckBox: UIButton!
    
    let q1CorrectAnswer: String = "A"
    let q2CorrectAnswer: String = "B"
    let q3CorrectAnswer: String = "C"
    let q4CorrectAnswer: String = "D"
    let q5CorrectAnswer: String = "A"
    
    let correctAnswerArray = ["A","B","C","D"]
    var answersArray = ["","","",""]
    let savedAnswer = Answers()
    
    var db : OpaquePointer?
    var stuList = [User]()
    var quesList = [Questions]()
    var questionAnswer : String = ""
    var questionNumber : String = ""
    var countdownTimer: Timer!
    var totalTime = 1800
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fileP = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("UserDB.sqlite")
        print("Db path is ", fileP)
        
        if sqlite3_open(fileP.path, &db) != SQLITE_OK {
            print("Cannot open database")
        }
        
    }
    
    @IBAction func startQuiz(_ sender: Any) {
        
        stuList.removeAll()
        let query = "select * from cplusplusQuestions where Number = 1"
        var stmt : OpaquePointer?
        
        if sqlite3_prepare_v2(db, query, -2, &stmt, nil) != SQLITE_OK {
            let err = String(cString: sqlite3_errmsg(db)!)
            print("There is an error", err)
            return
        }
        
        while(sqlite3_step(stmt) == SQLITE_ROW) {
            let number = String(sqlite3_column_int(stmt, 0))
            let question = String(cString: sqlite3_column_text(stmt, 1))
            let ansA = String(cString: sqlite3_column_text(stmt, 2))
            let ansB = String(cString: sqlite3_column_text(stmt, 3))
            let ansC = String(cString: sqlite3_column_text(stmt, 4))
            let ansD = String(cString: sqlite3_column_text(stmt, 5))
            let qAns = String(cString: sqlite3_column_text(stmt, 6))
            quesList.append(Questions(questionNumber: number, questionText: question, questionChoiceA: ansA, questionChoiceB: ansB, questionChoiceC: ansC, questionChoiceD: ansD, questionAnswer: qAns))
            NumberLabel.text! = number
            testQuestion.text! = question
            AnsA.text! = ansA
            AnsB.text! = ansB
            AnsC.text! = ansC
            AnsD.text! = ansD
        }
        
        AnsACheckBox.setImage(UIImage(systemName: "checkmark.circle")! as UIImage, for: UIControl.State.normal)
        AnsBCheckBox.setImage(UIImage(systemName: "checkmark.circle")! as UIImage, for: UIControl.State.normal)
        AnsCCheckBox.setImage(UIImage(systemName: "checkmark.circle")! as UIImage, for: UIControl.State.normal)
        AnsDCheckBox.setImage(UIImage(systemName: "checkmark.circle")! as UIImage, for: UIControl.State.normal)
    
        startTimer()
    }
    
    
    @IBAction func SelectAnsA(_ sender: Any) {
        AnsACheckBox.setImage(UIImage(systemName: "checkmark.circle.fill")! as UIImage, for: UIControl.State.normal)
        AnsBCheckBox.setImage(UIImage(systemName: "checkmark.circle")! as UIImage, for: UIControl.State.normal)
        AnsCCheckBox.setImage(UIImage(systemName: "checkmark.circle")! as UIImage, for: UIControl.State.normal)
        AnsDCheckBox.setImage(UIImage(systemName: "checkmark.circle")! as UIImage, for: UIControl.State.normal)
    }
    
    
    @IBAction func SelectAnsB(_ sender: Any) {
        AnsBCheckBox.setImage(UIImage(systemName: "checkmark.circle.fill")! as UIImage, for: UIControl.State.normal)
        AnsACheckBox.setImage(UIImage(systemName: "checkmark.circle")! as UIImage, for: UIControl.State.normal)
        AnsCCheckBox.setImage(UIImage(systemName: "checkmark.circle")! as UIImage, for: UIControl.State.normal)
        AnsDCheckBox.setImage(UIImage(systemName: "checkmark.circle")! as UIImage, for: UIControl.State.normal)
    }
    
    @IBAction func SelectAnsC(_ sender: Any) {
        AnsCCheckBox.setImage(UIImage(systemName: "checkmark.circle.fill")! as UIImage, for: UIControl.State.normal)
        AnsBCheckBox.setImage(UIImage(systemName: "checkmark.circle")! as UIImage, for: UIControl.State.normal)
        AnsACheckBox.setImage(UIImage(systemName: "checkmark.circle")! as UIImage, for: UIControl.State.normal)
        AnsDCheckBox.setImage(UIImage(systemName: "checkmark.circle")! as UIImage, for: UIControl.State.normal)
        
    }
    
    
    @IBAction func SelectAnsD(_ sender: Any) {
        
        AnsDCheckBox.setImage(UIImage(systemName: "checkmark.circle.fill")! as UIImage, for: UIControl.State.normal)
        AnsBCheckBox.setImage(UIImage(systemName: "checkmark.circle")! as UIImage, for: UIControl.State.normal)
        AnsCCheckBox.setImage(UIImage(systemName: "checkmark.circle")! as UIImage, for: UIControl.State.normal)
        AnsACheckBox.setImage(UIImage(systemName: "checkmark.circle")! as UIImage, for: UIControl.State.normal)
    }
    
    
    @IBAction func saveAnswer(_ sender: Any) {
        
        let numLabel = NumberLabel.text! as! NSString
        //let n = questionNumber as! NSString
        let qA = questionAnswer as! NSString
        var stmt : OpaquePointer?
        let query = "insert into Answers (Quiz, QuestionNumber, QuestionAnswer) values (?,?,?)"
        
        if sqlite3_prepare_v2(db, query, -1, &stmt, nil) != SQLITE_OK {
            let err = String(cString: sqlite3_errmsg(db)!)
            print("There is a prepare error", err)
        }
        
        if sqlite3_bind_text(stmt, 2, numLabel.utf8String, -1, nil) != SQLITE_OK {
            let err = String(cString: sqlite3_errmsg(db)!)
            print("There is a bind error", err)
        }
        
        if sqlite3_bind_text(stmt, 3, qA.utf8String, -1, nil) != SQLITE_OK {
            let err = String(cString: sqlite3_errmsg(db)!)
            print("There is a bind error", err)
        }
        
        if sqlite3_step(stmt) != SQLITE_DONE {
            let err = String(cString: sqlite3_errmsg(db)!)
            print("There is a step error", err)
        }
        
        print(questionAnswer)
        print("Data has been saved")
        
        if numLabel == "1" {
            savedAnswer.questionAnswer1 = questionAnswer
        }
        else if numLabel == "2" {
            savedAnswer.questionAnswer2 = questionAnswer
        }
        else if numLabel == "3" {
            savedAnswer.questionAnswer3 = questionAnswer
        }
        else if numLabel == "4" {
            savedAnswer.questionAnswer4 = questionAnswer
        }
        
        var finalScore: Double = 0.0
        var v = 0
        var w = 0
        var x = 0
        var y = 0
        
        if savedAnswer.questionAnswer1 == correctAnswerArray[0] {
            v = 1
        }
        if savedAnswer.questionAnswer2 == correctAnswerArray[1] {
            w = 1
        }
        if savedAnswer.questionAnswer3 == correctAnswerArray[2] {
            x = 1
        }
        if savedAnswer.questionAnswer4 == correctAnswerArray[3] {
            y = 1
        }
        
        var z = Double(v + w + x + y)
        finalScore = Double((z / 4) * 100)
        print(finalScore)
        
    }
    
    
    
    @IBAction func ViewNext(_ sender: Any) {
        var i : Int = 0
        var j = Int(NumberLabel.text!)
        i = j!
        i+=1
        
        stuList.removeAll()
        var queryString = "select * from cplusplusQuestions where Number = \(i)"
        var stmt : OpaquePointer?
        
        if sqlite3_prepare_v2(db, queryString, -2, &stmt, nil) != SQLITE_OK {
            let err = String(cString: sqlite3_errmsg(db)!)
            print("There is a next question error", err)
            return
        }
        
        while(sqlite3_step(stmt) == SQLITE_ROW) {
            let number = String(cString: sqlite3_column_text(stmt, 0))
            let question = String(cString: sqlite3_column_text(stmt, 1))
            let ansA = String(cString: sqlite3_column_text(stmt, 2))
            let ansB = String(cString: sqlite3_column_text(stmt, 3))
            let ansC = String(cString: sqlite3_column_text(stmt, 4))
            let ansD = String(cString: sqlite3_column_text(stmt, 5))
            let qAns = String(cString: sqlite3_column_text(stmt, 6))
            quesList.append(Questions(questionNumber: number, questionText: question, questionChoiceA: ansA, questionChoiceB: ansB, questionChoiceC: ansC, questionChoiceD: ansD, questionAnswer: qAns))
            NumberLabel.text! = number
            testQuestion.text! = question
            AnsA.text! = ansA
            AnsB.text! = ansB
            AnsC.text! = ansC
            AnsD.text! = ansD
        }
        
        AnsACheckBox.setImage(UIImage(systemName: "checkmark.circle")! as UIImage, for: UIControl.State.normal)
        AnsBCheckBox.setImage(UIImage(systemName: "checkmark.circle")! as UIImage, for: UIControl.State.normal)
        AnsCCheckBox.setImage(UIImage(systemName: "checkmark.circle")! as UIImage, for: UIControl.State.normal)
        AnsDCheckBox.setImage(UIImage(systemName: "checkmark.circle")! as UIImage, for: UIControl.State.normal)
    }
    
    func startTimer() {
        countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    
    @objc func updateTime() {
        timerLabel.text = "\(timeFormatted(totalTime))"
        
        if totalTime != 0 {
            totalTime -= 1
        } else {
            endTimer()
        }
    }
    
    func endTimer() {
        countdownTimer.invalidate()
    }
    
    func timeFormatted(_ totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds / 60) % 60
        //     let hours: Int = totalSeconds / 3600
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    
    
}
