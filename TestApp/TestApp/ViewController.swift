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
    
    var isAreaPickerViewVisible = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NetworkController.sharedInstance.vc = self
        NetworkController.sharedInstance.getMaskInfo()
        NetworkController.sharedInstance.getＳentence()
        setTableView()
        setAreaPickerBtn()
    }
    
    func setTableView(){
        self.maskInfoTable.delegate = self
        self.maskInfoTable.dataSource = self
    }
    func setAreaPickerBtn(){
        areaPickerBtn.setTitle("選擇區域", for: .normal)
        areaPickerBtn.setTitleColor(.white, for: .normal)
    }
    @IBAction func areaPickerBtnClick(_ sender: Any) {
        isAreaPickerViewVisible.toggle()
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
//extension ViewController:UIPopoverPresentationControllerDelegate{
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        segue.destination.preferredContentSize = CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height * 0.3)
//        segue.destination.popoverPresentationController?.delegate = self
//    }
//    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
//        return .none
//    }
//}
