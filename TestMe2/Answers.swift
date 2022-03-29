//
//  Answers.swift
//  TestMeApp
//
//  Created by Stan Shockley on 3/15/22.
//

import Foundation

//Question struct and setting to default values
class Questions {
    
    var questionNumber : String = ""
    var questionText : String = ""
    var questionChoiceA : String = ""
    var questionChoiceB : String = ""
    var questionChoiceC : String = ""
    var questionChoiceD : String = ""
    var questionAnswer : String = ""
    
    //Initialize question struct
    init(questionNumber : String, questionText : String, questionChoiceA : String, questionChoiceB : String, questionChoiceC : String, questionChoiceD : String, questionAnswer : String){
        
        self.questionNumber = questionNumber
        self.questionText = questionText
        self.questionChoiceA = questionChoiceA
        self.questionChoiceB = questionChoiceB
        self.questionChoiceC = questionChoiceC
        self.questionChoiceD = questionChoiceD
        self.questionAnswer = questionAnswer
    }
}

//Answer struct that creates variable for question answers
class Answers {
    
    var questionAnswer1 : String = ""
    var questionAnswer2 : String = ""
    var questionAnswer3 : String = ""
    var questionAnswer4 : String = ""
    var questionAnswer5 : String = ""
    var questionAnswer6 : String = ""
    var questionAnswer7 : String = ""
    var questionAnswer8 : String = ""
    var questionAnswer9 : String = ""
    var questionAnswer10 : String = ""
    var questionAnswer11 : String = ""
    var questionAnswer12 : String = ""
    var questionAnswer13 : String = ""
    var questionAnswer14 : String = ""
    var questionAnswer15 : String = ""
    
    init(){
    }
}
