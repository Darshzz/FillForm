//
//  FormModel.swift
//  FillForm
//
//  Created by Darsh on 28/09/22.
//

import Foundation

class FormModel: Codable {
    var questionAnswers: [QuestionAnswers]
    
    class QuestionAnswers: Codable {
        var quesrion: String
        var answers: [Answers]
    }
    
    class Answers: Codable {
        var answer: String
        var question: String
        var subAnswer: String?
        var subQuestion: String?
        var base64ImageString: String? // this will base64 image for now.
    }
}
