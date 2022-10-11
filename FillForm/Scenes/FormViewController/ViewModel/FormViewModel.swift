//
//  FormViewModel.swift
//  FillForm
//
//  Created by Darsh on 28/09/22.
//

import Foundation
import RxSwift
import RxCocoa

final class FormViewModel {
    
    private let disposeBag = DisposeBag()
    private var worker: FormViewWorker!
    // multiples added in last form
    var multipleImages: [UIImage]!
    
    // Observer used to bind with api response
    var formModel: BehaviorRelay<[[FormModel.QuestionAnswers]]> = .init(value: [])
    var signalAlertError: PublishSubject<String> = .init()
    var handleQuestions = PublishSubject<[FormModel.QuestionAnswers]>()
    var cancelSignal: PublishSubject<()> = .init()
   
    private var index = 0
    var currentFormIndex: Int {
        return index
    }
    
    init(worker: FormViewWorker) {
        self.worker = worker
    }

    // Get Data From Plist
    func getPlist<T>(_ name: String) -> T? {
        if let fileUrl = Bundle.main.url(forResource: name, withExtension: "plist"),
           let data = try? Data(contentsOf: fileUrl) {
               return try? PropertyListSerialization.propertyList(from: data, options: [], format: nil) as? T // [String: Any] which ever it is
        }
        return nil
    }
    
    func lastFormPage() -> Bool {
        return index == (formModel.value.count - 1)
    }
    
    func increaseIndex() {
        // Temporary added -2 till last question paper is not set.
        if index < (formModel.value.count - 1) { index += 1 }
    }
    
    func decreaseIndex() {
        if index == 0 { return }
        index -= 1
    }
    
    func updateSelection(_ indexPath: IndexPath) {
        
        let questions = formModel.value
        _ = questions[currentFormIndex][indexPath.section].items.enumerated().map({ (index, value) in
            
            value.answer = index == indexPath.row
        })
        
        formModel.accept(questions)
        handleQuestions.onNext(questions[currentFormIndex])
    }
    
    func updateMultipleSelection(_ indexPath: IndexPath, _ isSelect: Bool) {
        
        let questions = formModel.value
        
        questions[currentFormIndex][indexPath.section].items[indexPath.row].answer = isSelect
        
        formModel.accept(questions)
        handleQuestions.onNext(questions[currentFormIndex])
    }
}

extension FormViewModel: ViewModelProtocol {
    
    struct Input {
        // Input for calling plist data
        let fetchSignal: Observable<()>
        let postFormSignal: Observable<()>
        let disposeBag: DisposeBag
    }
    
    struct Output {
        let updateTableViewSignal: Driver<[[FormModel.QuestionAnswers]]>
        let updateAlertError: Driver<String>
    }
    
    func transform(_ input: Input, _ outputHandler: @escaping (Output) -> Void) {
        input.disposeBag.insert([setupQuestions(with: input.fetchSignal),
                                 postFormApiCall(with: input.postFormSignal)])
        
        let output = Output(updateTableViewSignal: formModel.asDriver(onErrorJustReturn: []), updateAlertError: signalAlertError.asDriver(onErrorJustReturn: ""))
        outputHandler(output)
    }
    
    func setupQuestions(with signal: Observable<()>) -> Disposable {
        let result: [[Any]]? = getPlist("Questions")
        
        print(result ?? "Unable to serialise fro Plist")
        
        return signal
            .flatMap({ () -> Observable<[[FormModel.QuestionAnswers]]> in
                Observable.just(FormModel(data: result!).questionAnswers)
            })
            .bind(to: formModel)
    }
    
    private func postFormApiCall(with signal: Observable<()>) -> Disposable {
        
        signal
            .subscribe(onNext: { [weak self] _ in
                guard let weakSelf = self else { return }
                weakSelf.worker.callApiHere(weakSelf.formModel.value, weakSelf.multipleImages)
            })
    }
    
    func validateFields() -> Bool {
        var isvalidated = false

        var errorMsg = ""
        for section in formModel.value[currentFormIndex] {
            
            let items = section.items
            
            for model in items {
                // Case 1: if only radio button selection and not selected
                if !model.isText, !model.isImage, !model.answer {
                    isvalidated = false
                    errorMsg = Constants.radioSelection
                // Case 2: if only radio button selection and selected
                }else if !model.isText, !model.isImage, model.answer {
                    isvalidated = true
                    errorMsg = ""
                    break
                // Case 3: if only textfield in option
                }else if model.isText, model.answer, (model.subAnswer ?? "").isEmpty {
                    isvalidated = false
                    errorMsg = Constants.textError + model.question
                    break
                // Case 4: if only image checkbox
                }else if model.isImage, model.answer, (model.base64ImageString ?? "").isEmpty {
                    isvalidated = false
                    errorMsg = Constants.imageError + model.question
                    break
                // Case 5: if both text and image in option
                }else if model.isText, model.isImage, model.answer, (model.subAnswer ?? "").isEmpty, (model.base64ImageString ?? "").isEmpty {
                    isvalidated = false
                    errorMsg = Constants.imageTextError + model.question
                    break
                }else if model.answer {
                    isvalidated = true
                    errorMsg = ""
                }
            }
        }
        // Call observer if there is any error to display.
        if !errorMsg.isEmpty {
            signalAlertError.onNext(errorMsg)
        }
        return isvalidated
    }
}
