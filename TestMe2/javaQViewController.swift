//
//  qViewController.swift
//  TestMe2
//
//  Created by admin on 3/15/22.
//

import UIKit
import SQLite3

class javaQViewController: UIViewController {
    
    //Outlet references for view controller controls. Data to be captured for SQLite read/write purposes
    
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
    @IBOutlet weak var timerLabel: UILabel!
    
    //Create array with correct answers to compare user answers in order to calculate score
    let correctAnswerArray = ["A","A","C","D","D","D","C","A","A","D","A","B","C","D","C"]
    
    //Create an instance of the Answers class to save user quiz answers for final score reference & caculation
    let savedAnswer = Answers()
    
    //Create parameter variables for SQLite database connection and queries
    var db : OpaquePointer?
    var stuList = [User]()
    //Create an instance of the Qustions class to populate the quiz screen control outlet content
    var quesList = [Questions]()
    var questionAnswer : String = ""
    //var questionNumber : String = ""
    var countdownTimer: Timer!
    var totalTime = 1800
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fileP = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("UserDB.sqlite")
        print("Database path is ", fileP)
        
        if sqlite3_open(fileP.path, &db) != SQLITE_OK {
            print("Cannot open database")
        }
    }
    
    @IBAction func ViewQuestion(_ sender: Any) {
        startTimer()
        stuList.removeAll()
        //Create query that will pull only the first question from the database question table
        let query = "select * from javaQuestions where Number = 1"
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
            let cAns = String(cString: sqlite3_column_text(stmt, 6))
            let qAns = String(cString: sqlite3_column_text(stmt, 6))
            //Assign values to instance variables and write values to view controller controls
            quesList.append(Questions(questionNumber: number, questionText: question, questionChoiceA: ansA, questionChoiceB: ansB, questionChoiceC: ansC, questionChoiceD: ansD, questionAnswer: qAns))
            NumberLabel.text! = number
            testQuestion.text! = question
            AnsA.text! = ansA
            AnsB.text! = ansB
            AnsC.text! = ansC
            AnsD.text! = ansD
        }
        
        //Set default image for answer selection button conrols
        AnsACheckBox.setImage(UIImage(systemName: "checkmark.circle")! as UIImage, for: UIControl.State.normal)
        AnsBCheckBox.setImage(UIImage(systemName: "checkmark.circle")! as UIImage, for: UIControl.State.normal)
        AnsCCheckBox.setImage(UIImage(systemName: "checkmark.circle")! as UIImage, for: UIControl.State.normal)
        AnsDCheckBox.setImage(UIImage(systemName: "checkmark.circle")! as UIImage, for: UIControl.State.normal)
        
    }
    @IBAction func SelectAnsA(_ sender: Any) {
        //On click actions to change the selected answer choice image while keeping others default. Also set the questionAnswer variable to be added as a Questions instance variable and saved and compared to the answer array index of the particular question. Process repeated for each respective answer choice
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
        
        //Declare and initialize parameter variables to be written to Answers table
        let numLabel = NumberLabel.text! as! NSString
        let qA = questionAnswer as! NSString
        var stmt : OpaquePointer?
        let query = "insert into Answers (QuestionNumber, QuestionAnswer) values (?,?)"
        
        if sqlite3_prepare_v2(db, query, -1, &stmt, nil) != SQLITE_OK {
            let err = String(cString: sqlite3_errmsg(db)!)
            print("There is a prepare error", err)
        }
        
        if sqlite3_bind_text(stmt, 1, numLabel.utf8String, -1, nil) != SQLITE_OK {
            let err = String(cString: sqlite3_errmsg(db)!)
            print("There is a bind error", err)
        }
        
        if sqlite3_bind_text(stmt, 2, qA.utf8String, -1, nil) != SQLITE_OK {
            let err = String(cString: sqlite3_errmsg(db)!)
            print("There is a bind error", err)
        }
        
        if sqlite3_step(stmt) != SQLITE_DONE {
            let err = String(cString: sqlite3_errmsg(db)!)
            print("There is a step error", err)
        }
        
        print(questionAnswer)
        print("Data has been saved")
        
        //Use numLabel value to determine which questionAnswer instance variable to save selected questionAnswer to. One for each quiz question
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
        else if numLabel == "5" {
            savedAnswer.questionAnswer5 = questionAnswer
        }
        else if numLabel == "6" {
            savedAnswer.questionAnswer6 = questionAnswer
        }
        else if numLabel == "7" {
            savedAnswer.questionAnswer7 = questionAnswer
        }
        else if numLabel == "8" {
            savedAnswer.questionAnswer8 = questionAnswer
        }
        else if numLabel == "9" {
            savedAnswer.questionAnswer9 = questionAnswer
        }
        else if numLabel == "10" {
            savedAnswer.questionAnswer10 = questionAnswer
        }
        else if numLabel == "11" {
            savedAnswer.questionAnswer11 = questionAnswer
        }
        else if numLabel == "12" {
            savedAnswer.questionAnswer12 = questionAnswer
        }
        else if numLabel == "13" {
            savedAnswer.questionAnswer13 = questionAnswer
        }
        else if numLabel == "14" {
            savedAnswer.questionAnswer14 = questionAnswer
        }
        else if numLabel == "15" {
            savedAnswer.questionAnswer15 = questionAnswer
        }
        
        //Initialize score and correct answer count for each question. "0" if question is incorrect, "1" if answer is correct
        var finalScore: Double = 0.0
        var a = 0
        var b = 0
        var c = 0
        var d = 0
        var e = 0
        var f = 0
        var g = 0
        var h = 0
        var i = 0
        var j = 0
        var k = 0
        var l = 0
        var m = 0
        var n = 0
        var o = 0
        
        if savedAnswer.questionAnswer1 == correctAnswerArray[0] {
            a = 1
        }
        if savedAnswer.questionAnswer2 == correctAnswerArray[1] {
            b = 1
        }
        if savedAnswer.questionAnswer3 == correctAnswerArray[2] {
            c = 1
        }
        if savedAnswer.questionAnswer4 == correctAnswerArray[3] {
            d = 1
        }
        if savedAnswer.questionAnswer5 == correctAnswerArray[4] {
            e = 1
        }
        if savedAnswer.questionAnswer6 == correctAnswerArray[5] {
            f = 1
        }
        if savedAnswer.questionAnswer7 == correctAnswerArray[6] {
            g = 1
        }
        if savedAnswer.questionAnswer8 == correctAnswerArray[7] {
            h = 1
        }
        if savedAnswer.questionAnswer9 == correctAnswerArray[8] {
            i = 1
        }
        if savedAnswer.questionAnswer10 == correctAnswerArray[9] {
            j = 1
        }
        if savedAnswer.questionAnswer11 == correctAnswerArray[10] {
            k = 1
        }
        if savedAnswer.questionAnswer12 == correctAnswerArray[11] {
            l = 1
        }
        if savedAnswer.questionAnswer13 == correctAnswerArray[12] {
            m = 1
        }
        if savedAnswer.questionAnswer14 == correctAnswerArray[13] {
            n = 1
        }
        if savedAnswer.questionAnswer15 == correctAnswerArray[14] {
            o = 1
        }
        
        //Calculate sum of correct answer choice and use equation to calculate the user final quiz score
        var z = Double(a+b+c+d+e+f+g+h+i+j+k+l+m+n+o)
        finalScore = Double((z / 15) * 100)
        print(finalScore)
        
        //Query to write final score into TempVariables table
        let javafinalScore = finalScore as! NSNumber
        let finalscorequery = "insert into TempVariables (javaScoretemp) values (?)"
        
        if sqlite3_prepare_v2(db,finalscorequery,-1,&stmt,nil) != SQLITE_OK {
            let err = String(cString: sqlite3_errmsg(db)!)
            print(err)
        }
        if sqlite3_bind_int(stmt, 9, Int32(javafinalScore.uint32Value)) != SQLITE_OK {
            let err = String(cString: sqlite3_errmsg(db)!)
            print(err)
        }
        if sqlite3_step(stmt) != SQLITE_DONE {
            let err = String(cString: sqlite3_errmsg(db)!)
            print(err)
        }
        
        let finalscoreupdatequery = "UPDATE User SET javaScore = (SELECT TempVariables.javaScoretemp FROM TempVariables WHERE TempVariables.javaScoretemp != ' ' ) WHERE Username = (SELECT tempUser FROM TempVariables WHERE TempVariables.tempUser = User.Username)"
        
        if sqlite3_prepare_v2(db,finalscoreupdatequery,-1,&stmt,nil) != SQLITE_OK {
            let err = String(cString: sqlite3_errmsg(db)!)
            print(err)
        }
       
        if sqlite3_step(stmt) != SQLITE_DONE {
            let err = String(cString: sqlite3_errmsg(db)!)
            print(err)
        }
    }
    
    //Functionality to step through database selecting questions to read and write to view controller based on question number
    @IBAction func ViewNext(_ sender: Any) {
        var i : Int = 0
        var j = Int(NumberLabel.text!)
        i = j!
        i+=1
        
        stuList.removeAll()
        var queryString = "select * from javaQuestions where Number = \(i)"
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
        let nextViewController = storyboard?.instantiateViewController(withIdentifier: "userView") as! cplusplusQViewController
        self.present(nextViewController, animated: true, completion: nil)
    }
    
    func timeFormatted(_ totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds / 60) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
