//
//  CDatePickerView.swift
//  PetChart
//
//  Created by 김학철 on 2020/09/30.
//

import UIKit

typealias PickerColuser = (String?, Date?) ->Void
enum PickerType: Int {
    case year
    case month
    case yearMonth
    case yearMonthDay
    case time
}

class CDatePickerView: UIView {
    
    @IBOutlet var xib: UIView!
    @IBOutlet weak var btnFullClose: UIButton!
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var btnOk: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var enableValueChange:Bool = false
    
    var arrYear: [Int] = []
    var arrMonth: [Int] = []
    var arrDay: [Int] = []
    var selYear: Int = 0
    var selMonth: Int = 0
    var selDay: Int = 0
    
    var minDate: Date? = nil
    var maxDate: Date? = nil
    var apointDate: Date? = nil;
    var completion: PickerColuser?
    var type:PickerType = .yearMonthDay
    
    var local: Locale?
    var minuteInterval: Int = 1
    
    var selDate: Date? = nil
    
    convenience init?(type: PickerType, completion:PickerColuser?) {
        self.init(frame: UIScreen.main.bounds)
        self.type = type
        self.completion = completion
        self.loadXib()
    }
    
    convenience init?(type: PickerType, minDate: Date?, maxDate: Date?, apointDate: Date?, completion:PickerColuser?) {
        self.init(frame: UIScreen.main.bounds)
        self.type = type
        self.minDate = minDate
        self.maxDate = maxDate
        self.apointDate = apointDate
        self.completion = completion
        
        self.loadXib()
    }
    override class func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
    }
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    func loadXib() {
        xib = Bundle(for: Swift.type(of: self)).loadNibNamed("CDatePickerView", owner: self, options: nil)?.first as? UIView
        self.addSubview(xib)
        xib.translatesAutoresizingMaskIntoConstraints = false
        xib.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        xib.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        xib.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        xib.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
    }
    
    func show() {
        self.backgroundColor = UIColor.clear
        let window = AppDelegate.instance()?.window
        window?.addSubview(self)
        if type == .year || type == .month || type == .yearMonth {
            picker.isHidden = false
            datePicker.isHidden = true
            picker.delegate = self
            self.makeComponetsData()
            self.defaultApointPicker()
        }
        else {
            picker.isHidden = true
            datePicker.isHidden = false
            
            datePicker.calendar = Calendar(identifier: .gregorian)
            if let local = local {
                datePicker.locale = local
            }
            else {
                datePicker.locale = Locale.current
            }
            
            let curDate = Date()
            if type == .time {
                datePicker.datePickerMode = .time
                datePicker.minuteInterval = minuteInterval
                datePicker.setDate(curDate, animated: true)
                selDate = curDate
            }
            else {
                datePicker.datePickerMode = .date
                datePicker.minimumDate = minDate
                datePicker.maximumDate = maxDate
                if apointDate == nil {
                    self.apointDate = Date()
                }
                selDate = apointDate
                datePicker.setDate(apointDate!, animated: true)
            }
        }
    }
    func makeComponetsData() {
        if type == .year {
            let minYear: Int = (minDate?.getYear())!
            let maxYear: Int = (maxDate?.getYear())!
            for i in 0..<(maxYear - minYear) {
                arrYear.append((i+minYear))
            }
        }
        else if type == .month {
            for i in 0..<12 {
                arrMonth.append((i+1))
            }
        }
        else if type == .yearMonth {
            let minYear: Int = (minDate?.getYear())!
            let maxYear: Int = (maxDate?.getYear())!
            for i in 0..<(maxYear - minYear+1) {
                arrYear.append((i+minYear))
            }
            
            for i in 0..<12 {
                arrMonth.append((i+1))
            }
        }
    }

    func defaultApointPicker() {
        if apointDate == nil {
            self.apointDate = Date()
        }
        
        if type == .year {
            selYear = (apointDate?.getYear())!
            let row: Int = arrYear.firstIndex(of: selYear) ?? 0
            picker.selectRow(row, inComponent: 0, animated: true)
        }
        else if type == .month {
            selMonth = (apointDate?.getMonth())!
            picker.selectRow(selMonth-1, inComponent: 0, animated: true)
        }
        else if type == .yearMonth {
            selYear = (apointDate?.getYear())!
            selMonth = (apointDate?.getMonth())!
            let row: Int = arrYear.firstIndex(of: selYear) ?? 0
            picker.selectRow(row, inComponent: 0, animated: true)
            picker.selectRow((selMonth-1), inComponent: 1, animated: true)
        }
    }
    func dismiss() {
        self.completion = nil
        self.removeFromSuperview()
    }
    
    @IBAction func onClickedButtonActions(_ sender: UIButton) {
        if sender == btnFullClose {
            self.dismiss()
        }
        else if sender == btnOk {
            self.finishCompletion()
            self.dismiss()
        }
    }
    
    //UIDatePicker
    @IBAction func datePickerValueChange(_ sender: UIDatePicker) {
        self.selDate = sender.date
    }
    @IBAction func datePickerTouchUpInside(_ sender: UIDatePicker) {
        if enableValueChange {
            self.selDate = sender.date
            self.finishCompletion()
        }
    }
}

extension CDatePickerView: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if type == .yearMonth {
            return 2
        }
        else {
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if type == .year {
            return arrYear.count
        }
        else if type == .month {
            return arrMonth.count
        }
        else if type == .yearMonth {
            if component == 0 {
                return arrYear.count
            }
            else {
                return arrMonth.count
            }
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        var cell: UILabel? = view as? UILabel ?? nil
        if type == .year {
            if cell == nil {
                let lbCol = UILabel.init(frame:CGRect.init(x: 0, y: 0, width: pickerView.bounds.width, height: 44))
                lbCol.textColor = UIColor.black
                lbCol.font = UIFont.systemFont(ofSize: 15)
                lbCol.textAlignment = NSTextAlignment.center
                cell = lbCol
            }
            cell?.text = String(format: "%04d 년", arrYear[row])
        }
        else if type == .month {
            if cell == nil {
                let lbCol = UILabel.init(frame:CGRect.init(x: 0, y: 0, width: pickerView.bounds.width, height: 44))
                lbCol.textColor = UIColor.black
                lbCol.font = UIFont.systemFont(ofSize: 15)
                lbCol.textAlignment = NSTextAlignment.center
                cell = lbCol
            }
            cell?.text = String(format: "%02d 월", arrMonth[row])
        }
        else if type == .yearMonth {
            if cell == nil {
                let space: CGFloat = 100
                let lr: CGFloat = 0
                let width:CGFloat = (pickerView.bounds.width - 2*lr - space)/2
                if component == 0 {
                    let lbCol = UILabel.init(frame:CGRect.init(x: lr, y: 0, width: width, height: 44))
                    lbCol.textColor = UIColor.black
                    lbCol.font = UIFont.systemFont(ofSize: 15)
                    lbCol.textAlignment = NSTextAlignment.right
                    cell = lbCol
                }
                else {
                    let lbCol = UILabel.init(frame:CGRect.init(x:width+lr+space, y: 0, width: width, height: 44))
                    lbCol.textColor = UIColor.black
                    lbCol.font = UIFont.systemFont(ofSize: 15)
                    lbCol.textAlignment = NSTextAlignment.left
                    cell = lbCol
                }
            }
            
            if component == 0 {
                cell?.text = String(format: "%04d 년", arrYear[row])
            }
            else {
                cell?.text = String(format: "%02d 월", arrMonth[row])
            }
        }
        return cell!
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if type == .year {
            selYear = arrYear[row]
        }
        else if type == .month {
            selMonth = arrMonth[row]
        }
        else if type == .yearMonth {
            let maxYear:Int = (maxDate?.getYear())!
            let maxMonth:Int = (maxDate?.getMonth())!
            let minYear:Int = (minDate?.getYear())!
            let minMonth:Int = (minDate?.getMonth())!

            if component == 0 {
                selYear = arrYear[row]
            }
            else {
                selMonth = arrMonth[row]
                if selYear >= maxYear && selMonth > maxMonth {
                    selMonth = maxMonth
                    pickerView.selectRow(selMonth-1, inComponent: 1, animated: true)
                }
                if selYear <= minYear && selMonth < minMonth {
                    selMonth = minMonth
                    pickerView.selectRow(selMonth-1, inComponent: 1, animated: true)
                }
            }
            
        }
        if enableValueChange && self.completion != nil {
            self.finishCompletion()
        }
    }
    
    func finishCompletion() {
        var strDate: String = ""
        if type == .year {
            strDate = String(format: "%04d", selYear)
            completion?(strDate, nil)
        }
        else if type == .month {
            strDate = String(format: "%02d", selMonth)
            completion?(strDate, nil)
        }
        else if type == .yearMonth {
            strDate = String(format: "%04d-%02d", selYear, selMonth)
            completion?(strDate, nil)
        }
        else if type == .yearMonthDay {
            if let selDate = selDate {
                let df = CDateFormatter()
                df.dateFormat = "yyyy-MM-dd"
                completion?(df.string(from: selDate), selDate)
            }
        }
        else if type == .time {
            if let selDate = selDate {
                let df = CDateFormatter()
                df.dateFormat = "hh:mm a"
                let strDate = df.string(from: selDate)
                completion?(strDate, selDate)
            }
        }
    }
}
