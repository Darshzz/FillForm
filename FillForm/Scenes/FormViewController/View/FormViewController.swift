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
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var progressView: ProgressView!
    @IBOutlet weak var alertView: ToastAlertView!
    
    let fetchSignal: PublishSubject<()> = .init()
    let postApiSignal: PublishSubject<()> = .init()
    var dataSource: RxTableViewSectionedReloadDataSource<FormModel.QuestionAnswers>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupOutput()
        fetchSignal.onNext(())
    }
    
    override func setupOutput() {
        super.setupOutput()
        
        let input = FormViewModel.Input(fetchSignal: fetchSignal, postFormSignal: postApiSignal, disposeBag: disposeBag)
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
                self.alertView.setText(error)
            })
    }
    
    private func updateButtonUI(_ isSubmit: Bool) {
        
        btnNext.setTitle(isSubmit ? Constants.submit : Constants.next, for: .normal)
        btnNext.backgroundColor = isSubmit ? #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1) : #colorLiteral(red: 0.8171867132, green: 0.00278799003, blue: 0.01103944983, alpha: 1)
    }
    
    // MARK: IBAction Methods
    @IBAction func btnCancel_Action(_ sender: Any) {
        viewModel.cancelSignal.onNext(())
    }
    
    @IBAction func btnNext_Action(_ sender: Any) {
       // Validiate all fields
        guard viewModel.validateFields() else { return }
       // jum to next for if not last page else hit api if last page.
        guard !viewModel.lastFormPage() else {
            postApiSignal.onNext(())
            return
        }
        
        viewModel.increaseIndex()
        viewModel.handleQuestions.onNext(viewModel.formModel.value[viewModel.currentFormIndex])

        progressView.next()
        
        updateButtonUI(viewModel.lastFormPage())
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
        (cell as! CellTypeProtocol).signalMultipleImages?
            .subscribe(onNext: { [weak self] images in
                self?.viewModel.multipleImages = images
                self?.updateButtonUI(images.count < Constants.minImageCount)
            })
            .disposed(by: disposeBag)
        return cell
    }
}

extension FormViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
           if let header = view as? UITableViewHeaderFooterView {
               header.backgroundView?.backgroundColor = UIColor.green
               header.textLabel?.textColor = .black
           }
       }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section != 0 {
            let sectionCount = dataSource?.sectionModels.count ?? 0
            
            if (dataSource?.sectionModels[0].question.contains("alarm") ?? false) {
                let item = dataSource?.sectionModels[indexPath.section].items[indexPath.row]
                let cellHeight = CGFloat(item!.answer ? item!.cellHeight : Constants.defaultCellHeight)
                
                if let model = dataSource?.sectionModels[0].items[0], model.answer, indexPath.section == 1 {
                    return cellHeight

                }else if let model = dataSource?.sectionModels[0].items[1], model.answer, indexPath.section == 2 || indexPath.section == 3 {
                    
                    if indexPath.section == 3 {
                        let model = dataSource?.sectionModels[2].items
                        if model![0].answer || model![1].answer {
                            if let item = dataSource?.sectionModels[3].items, item[indexPath.row].selectedOption == "1" {
                                return CGFloat(item[indexPath.row].cellHeight)
                            }
                        }else if model![2].answer {
                            if let item = dataSource?.sectionModels[3].items, item[indexPath.row].selectedOption == "2" {
                                return CGFloat(item[indexPath.row].cellHeight)
                            }
                        }
                        return 0
                    }
                    return cellHeight
                }
                return 0
            }
            
            guard sectionCount > 1, let model = dataSource?.sectionModels[0].items[0], model.answer else {
                return 0
            }
        }
  
        guard let model = dataSource?.sectionModels[indexPath.section].items[indexPath.row], model.answer else {
            return CGFloat(Constants.defaultCellHeight)
        }
        return CGFloat(model.cellHeight ?? Constants.defaultCellHeight)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section != 0 {
            let sectionCount = dataSource?.sectionModels.count ?? 0
            
            if let model = dataSource?.sectionModels[0].items[0], sectionCount > 2, model.answer {
                return section <= 1 ? 30 : 0
            }else if let model = dataSource?.sectionModels[0].items[1], sectionCount > 2, model.answer  {
                return section == 2 ? 30 : 0
            }
            
            guard sectionCount > 1, let model = dataSource?.sectionModels[0].items[0], model.answer else {
                return 0
            }
        }
        return 30
    }
}
