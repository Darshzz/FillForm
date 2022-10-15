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
                answers.forEach { model in
                    if model.cellType == Constants.galleryCellType {
                        images.enumerated().forEach { (index, image) in
                            items.append(["answer": model.answer ? "yes":"no",
                                   "question": "Picture\(index + 1)",
                                   "base64ImageString": image.resizeImage()!.base64()])
                        }
                    }else {
                        items.append(["answer": model.answer ? "yes":"no",
                               "question": model.question,
                               "subAnswer": model.subAnswer!,
                               "subQuestion": model.subQuestion!,
                               "base64ImageString": model.base64ImageString!])
                    }
                }
                selectedAnswer.append(["answers": items,
                                       "question": model.question])
            }
        }
        return ["questionAnswers": selectedAnswer]
    }
}
