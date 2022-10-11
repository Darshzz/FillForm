//
//  ViewController.swift
//  FillForm
//
//  Created by Darsh on 28/09/22.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources


class FormViewController: BaseViewController<FormViewModel>, Storyboarded {

    // MARK:- Properties
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var progressView: ProgressView!
    @IBOutlet weak var alertView: ToastAlertView!
    
    let fetchSignal: PublishSubject<()> = .init()
    var dataSource: RxTableViewSectionedReloadDataSource<FormModel.QuestionAnswers>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupOutput()
        fetchSignal.onNext(())
    }
    
    override func setupOutput() {
        super.setupOutput()
        
        let input = FormViewModel.Input(fetchSignal: fetchSignal, disposeBag: disposeBag)
        viewModel.transform(input, setupInput(input:))
    }

    override func setupInput(input: FormViewModel.Output) {
        super.setupInput(input: input)
        
        disposeBag.insert([
            setUpTableViewObserving(signal: input.updateTableViewSignal),
            configureAlertErrorView(signal: input.updateAlertError)
        ])
    }
    
    private func setUpTableViewObserving(signal: Driver<[[FormModel.QuestionAnswers]]>) -> Disposable {
        
        signal
            .drive(with: self, onNext: { (`self`, result) in
                if result.count > 0, self.tableView.delegate ==  nil {
                    self.setUpTableViewSection(Observable.of(result[self.viewModel.currentFormIndex]))
                    self.viewModel.handleQuestions.onNext(result[self.viewModel.currentFormIndex])
                }
            })
    }
    
    private func setUpTableViewSection(_ result: Observable<[FormModel.QuestionAnswers]>) {
        
        tableView
            .rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        dataSource = RxTableViewSectionedReloadDataSource<FormModel.QuestionAnswers>(configureCell: { dataSource, table, indexPath, item in
            return self.createCell(model: item, from: table, indexPath: indexPath)
        })

        dataSource!.titleForHeaderInSection = { dataSource, index in
            return dataSource.sectionModels[index].question
        }
        
        viewModel.handleQuestions.asObservable().bind(to: tableView.rx.items(dataSource: dataSource!))
            .disposed(by: disposeBag)
    }
    
    private func configureAlertErrorView(signal: Driver<String>) -> Disposable {
        signal
            .drive(with: self, onNext: { (`self`, error) in
                print("Error message for validations == \n",error)
                self.alertView.setText(error)
            })
    }
    
    // MARK: IBAction Methods
    @IBAction func btnCancel_Action(_ sender: Any) {
        viewModel.cancelSignal.onNext(())
    }
    
    @IBAction func btnNext_Action(_ sender: Any) {
        guard !viewModel.lastFormPage(), viewModel.validateFields() else { return }
        
        viewModel.increaseIndex()
        viewModel.handleQuestions.onNext(viewModel.formModel.value[viewModel.currentFormIndex])
        
        progressView.next()
    }
    
    @IBAction func btnPrevious_Action(_ sender: Any) {
        viewModel.decreaseIndex()
        viewModel.handleQuestions.onNext(viewModel.formModel.value[viewModel.currentFormIndex])
        
        progressView.previous()
    }
}

extension FormViewController {
    
    func createCell(model: FormModel.Answers, from table: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: model.cellType)!
        
        (cell as! CellTypeProtocol).configure(model, indexPath)
        (cell as! CellTypeProtocol).signalItemSelected?
            .subscribe(onNext: { [weak self] indexpath in
                self?.viewModel.updateSelection(indexpath)
            })
            .disposed(by: disposeBag)
        (cell as! CellTypeProtocol).signalMultipleItemSelected?
            .subscribe(onNext: { [weak self] (indexpath, isSelect) in
                self?.viewModel.updateMultipleSelection(indexpath, isSelect)
            })
            .disposed(by: disposeBag)
        return cell
    }
}

extension FormViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section != 0 {
            let sectionCount = dataSource?.sectionModels.count ?? 0
            guard sectionCount > 1, let model = dataSource?.sectionModels[0].items[0], model.answer else {
                return 0
            }
        }
        
        guard let model = dataSource?.sectionModels[indexPath.section].items[indexPath.row], model.answer else {
            return 45
        }
        return CGFloat(model.cellHeight ?? 45)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section != 0 {
            let sectionCount = dataSource?.sectionModels.count ?? 0
            guard sectionCount > 1, let model = dataSource?.sectionModels[0].items[0], model.answer else {
                return 0
            }
        }
        return 30
    }
}
