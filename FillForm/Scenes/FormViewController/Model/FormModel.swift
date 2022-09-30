//
//  FormModel.swift
//  FillForm
//
//  Created by Darsh on 28/09/22.
//

import Foundation
import UIKit

class FormModel: Codable {
    var questionAnswers: [[QuestionAnswers]]
    
    init(data: [[Any]]) {
        questionAnswers = []
        for value in data {
            var items: [QuestionAnswers] = []
            for item in value {
                items.append(QuestionAnswers(data: item as! [String: Any]))
            }
            questionAnswers.append(items)
        }
    }
    
    
    class QuestionAnswers: Codable {
        var question: String
        var answers: [Answers]
        
        init(data: [String: Any]) {
            
            answers = []
            question = data["question"] as! String
            
            for value in data["answer"] as! [[String: Any]] {
                answers.append(Answers(data: value))
            }
        }
    }
    
    class Answers: Codable {
        var answer: String?
        var question: String!
        var subAnswer: String?
        var subQuestion: String?
        var base64ImageString: String? // this will base64 image for now.
        var isText: Bool!
        var isImage: Bool!
        var title: String?
        var isCheckBox: Bool!
        var keyboardType: Int!
                    
        init(data: [String: Any]) {
            answer = data["answer"] as? String
            question = data["question"] as? String
            subAnswer = data["subAnswer"] as? String
            subQuestion = data["subQuestion"] as? String
            base64ImageString = ""
            isText = data["isText"] as? Bool
            isImage = data["isImage"] as? Bool
            title = data["title"] as? String
            isCheckBox = data["isCheckBox"] as? Bool
            keyboardType = data["keyboardType"] as? Int
        }
    }
}
