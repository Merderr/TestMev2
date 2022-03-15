//
//  Answers.swift
//  TestMe2
//
//  Created by Stan Shockley on 3/15/22.
//

import Foundation

class Answers {
    
    var questionNumber : Int = 0
    var questionText : String = ""
    var questionChoiceA : String = ""
    var questionChoiceB : String = ""
    var questionChoiceC : String = ""
    var questionChoiceD : String = ""
    
    init(questionNumber : Int, questionText : String, questionChoiceA : String, questionChoiceB : String, questionChoiceC : String, questionChoiceD : String){
        
        self.questionNumber = questionNumber
        self.questionText = questionText
        self.questionChoiceA = questionChoiceA
        self.questionChoiceB = questionChoiceB
        self.questionChoiceC = questionChoiceC
        self.questionChoiceD = questionChoiceD
        
    }
}
