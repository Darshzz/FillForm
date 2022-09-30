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
    // Observer used to bind with api response
    var formModel: PublishRelay<FormModel> = .init()

    // Get Data From Plist
    func getPlist<T>(_ name: String) -> T? {
        if let fileUrl = Bundle.main.url(forResource: name, withExtension: "plist"),
           let data = try? Data(contentsOf: fileUrl) {
               return try? PropertyListSerialization.propertyList(from: data, options: [], format: nil) as? T // [String: Any] which ever it is
        }
        return nil
    }
}

extension FormViewModel: ViewModelProtocol {
    
    struct Input {
        // Input for calling plist data
        let fetchSignal: Observable<()>
        let disposeBag: DisposeBag
    }
    
    struct Output {
        
    }
    
    func transform(_ input: Input, _ outputHandler: @escaping (Output) -> Void) {
        input.disposeBag.insert(setupQuestions(with: input.fetchSignal))
    }
    
    func setupQuestions(with signal: Observable<()>) -> Disposable {
        let result: [[Any]]? = getPlist("Questions")
        
        print(result ?? "Unable to serialise fro Plist")
        
        print(FormModel(data: result!).questionAnswers)
        
        return signal
            .flatMap({ () -> Observable<FormModel> in
                Observable.just(FormModel(data: result!))
            })
            .bind(to: formModel)
    }
}
