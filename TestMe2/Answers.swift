//
//  Answers.swift
//  TestMeApp
//
//  Created by Stan Shockley on 3/15/22.
//

import Foundation

class Questions {
    
    var questionNumber : String = ""
    var questionText : String = ""
    var questionChoiceA : String = ""
    var questionChoiceB : String = ""
    var questionChoiceC : String = ""
    var questionChoiceD : String = ""
    var questionAnswer : String = ""
    
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
