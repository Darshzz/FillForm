//
//  FormViewWorker.swift
//  FillForm
//
//  Created by Darsh on 11/10/22.
//

import Foundation
import UIKit

struct FormViewWorker {
    
    func callApiHere(_ formModel: [[FormModel.QuestionAnswers]], _ images: [UIImage]) {
        print(prepareJson(formModel, images))
    }
}

// Prepare your json for body parameter
extension FormViewWorker {
    
    func prepareJson(_ formModel: [[FormModel.QuestionAnswers]], _ images: [UIImage]) -> [String : Any] {
        
        var selectedAnswer: [Any] = []
        for section in formModel {
            
            for model in section {
                
                let answers = model.items.filter({ $0.answer })
                var items: [Any] = []
                
                if section.count > 2, !answers.isEmpty {
                    let subQuestions = section[3].items.filter({ $0.selectedOption!.contains(answers.first!.selectedOption ?? "0") })
                    
                    var subQuestionItem: [Any] = []
                    subQuestions.forEach { subItem in
                        subQuestionItem.append(["subAnswer": subItem.subAnswer,
                                                "subQuestion": subItem.subQuestion])
                    }
                    
                    if !subQuestionItem.isEmpty {
                        items.append(["answer": answers.first!.answer ? "yes":"no",
                               "question": answers.first!.question,
                                "subQuestionAnswers": subQuestionItem])
                    }else {
                        items.append(["answer": answers.first!.answer ? "yes":"no",
                               "question": answers.first!.question])
                    }
                    
                }else {
                
                answers.forEach { item in
                    if item.cellType == Constants.galleryCellType {
                        images.enumerated().forEach { (index, image) in
                            items.append(["answer": item.answer ? "yes":"no",
                                   "question": "Picture\(index + 1)",
                                   "base64ImageString": image.resizeImage()!.base64()])
                        }
                    }else {
                        items.append(["answer": item.answer ? "yes":"no",
                               "question": item.question,
                               "subAnswer": item.subAnswer!,
                               "subQuestion": item.subQuestion!,
                               "base64ImageString": item.base64ImageString!])
                    }
                }
                }
                
                if !items.isEmpty {
                    selectedAnswer.append(["answers": items,
                                           "question": model.question])
                }
            }
        }
        return ["questionAnswers": selectedAnswer]
    }
}
/*
 {
   "answers": [
     {
       "answer": "yes",
       "question": "Fault ticket assigned to technician",
       "subQuestionAnswers": [
         {
           "subAnswer": "Vijay ",
           "subQuestion": "Name of technician"
         },
         {
           "subAnswer": "8235",
           "subQuestion": "Contact number of technician"
         },
         {
           "subAnswer": "fhgg",
           "subQuestion": "Technician job number"
         },
         {
           "subAnswer": "9/11/2022 12:0 AM",
           "subQuestion": "Date and time of fault ticket assigned to technician"
         }
       ]
     }
   ],
   "question": "How was the vandalism discovered?"
 }
 */
