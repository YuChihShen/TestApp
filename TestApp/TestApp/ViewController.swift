//
//  ViewController.swift
//  TestApp
//
//  Created by 王佶立 on 2022/7/3.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var maskInfoTable: UITableView!
    @IBOutlet weak var areaPickerBtn: UIButton!
    
    @IBOutlet weak var chSentence: UILabel!
    @IBOutlet weak var enSentence: UILabel!
    
    let screenWidth = UIScreen.main.bounds.size.width
    let screenHeight = UIScreen.main.bounds.size.height
    var areaPickerView = UIPickerView()
    var isAreaPickerViewVisible = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NetworkController.sharedInstance.vc = self
        NetworkController.sharedInstance.getMaskInfo()
        NetworkController.sharedInstance.getＳentence()
        setTableView()
        setAreaPickerBtn()
        setAreaPickerView()
    }
    
    func setTableView(){
        self.maskInfoTable.delegate = self
        self.maskInfoTable.dataSource = self
    }
    func setAreaPickerBtn(){
        areaPickerBtn.setTitle("選擇區域", for: .normal)
        areaPickerBtn.setTitleColor(.white, for: .normal)
    }
    func setAreaPickerView(){
        
        areaPickerView.frame = CGRect(x: 0,y: screenHeight,width: screenWidth,height: screenHeight * 0.3)
        areaPickerView.delegate = self
        areaPickerView.backgroundColor = .lightGray
        areaPickerView.clipsToBounds = true
        areaPickerView.layer.cornerRadius = 10
        view.addSubview(areaPickerView)
    }
    @IBAction func areaPickerBtnClick(_ sender: Any) {
        appearAreaPickerView()
    }
    @IBAction func tapScreen(_ sender: Any) {
        isAreaPickerViewVisible = true
        appearAreaPickerView()
    }
    func appearAreaPickerView(){
        isAreaPickerViewVisible.toggle()
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: { [self] in
            areaPickerView.frame.origin.y = !isAreaPickerViewVisible ? screenHeight :screenHeight - areaPickerView.frame.height
        }, completion: nil)
    }
}
extension ViewController:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return NetworkController.sharedInstance.maskInfoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MaskInfoCell", for: indexPath) as! MaskInfoTableViewCell
        let maskInfo = NetworkController.sharedInstance.maskInfoList[indexPath.row]
        cell.id = maskInfo.id ?? ""
        cell.name.text = maskInfo.name
        cell.phone.text = maskInfo.phone
        cell.adultMaskCount.text = "大人口罩數量：\(maskInfo.adultCount)"
        cell.childMaskCount.text = "小孩口罩數量：\(maskInfo.childCount)"
        cell.address.text = maskInfo.address
        cell.updatedDate.text = maskInfo.updatedate
        return cell
    }
    
}
extension ViewController:UIPickerViewDelegate,UIPickerViewDataSource{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return NetworkController.sharedInstance.areaList.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return NetworkController.sharedInstance.areaList[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let area = NetworkController.sharedInstance.areaList[row]
        areaPickerBtn.setTitle(area , for:.normal)
        isAreaPickerViewVisible = true
        appearAreaPickerView()
        NetworkController.sharedInstance.searchMaskInfo(area: area)
    }
}
