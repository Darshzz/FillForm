//
//  FormModel.swift
//  FillForm
//
//  Created by Darsh on 28/09/22.
//

import Foundation
import UIKit
import RxDataSources

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
    
    
    class QuestionAnswers: Codable, AnimatableSectionModelType {
        
        //typealias Item = Answers
        required init(original: FormModel.QuestionAnswers, items: [FormModel.Answers]) {
            self.items = original.items
            self.question = original.question
        }
        
        var uuid: UUID = UUID()
        typealias Identity = UUID
        var identity: UUID {
          return uuid //Use this
        }
        
        var items: [FormModel.Answers]
        var question: String
        
        init(data: [String: Any]) {
            
            items = []
            question = data["question"] as! String
            
            for value in data["answer"] as! [[String: Any]] {
                items.append(Answers(data: value))
            }
        }
    }
    
    class Answers: Codable, IdentifiableType, Equatable {
        var cellHeight: Int!
        var cellType: String!
        var answer: Bool = false
        var question: String!
        var subAnswer: String?
        var subQuestion: String?
        var base64ImageString: String? // this will base64 image for now.
        var isText: Bool!
        var isImage: Bool!
        var title: String?
        var isCheckBox: Bool!
        var keyboardType: Int!
        
        var uuid: UUID = UUID()
        typealias Identity = UUID
        var identity: Identity {
          return uuid
        }
                    
        init(data: [String: Any]) {
            cellHeight = (data["cellHeight"] as? Int) ?? 45
            cellType = data["cellType"] as? String
            answer = (data["answer"] as? Bool) ?? false
            question = data["option"] as? String
            subAnswer = data["subAnswer"] as? String
            subQuestion = data["subQuestion"] as? String
            base64ImageString = ""
            isText = data["isText"] as? Bool
            isImage = data["isImage"] as? Bool
            title = data["title"] as? String
            isCheckBox = data["isCheckBox"] as? Bool
            keyboardType = data["keyboardType"] as? Int
        }
        
        static func ==(lhs: Answers, rhs: Answers) -> Bool {
          return lhs.uuid == rhs.uuid
        }
    }
}
