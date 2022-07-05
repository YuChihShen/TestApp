//
//  ViewController.swift
//  TestApp
//
//  Created by 王佶立 on 2022/7/3.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var maskInfoTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NetworkController.sharedInstance.vc = self
        NetworkController.sharedInstance.getMaskInfo()
        setTableView()
        
    }
    
    func setTableView(){
        self.maskInfoTable.delegate = self
        self.maskInfoTable.dataSource = self
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
        cell.name.text = maskInfo.name
        cell.phone.text = maskInfo.phone
        cell.adultMaskCount.text = "大人口罩數量：\(maskInfo.adultCount)"
        cell.childMaskCount.text = "小孩口罩數量：\(maskInfo.childCount)"
        cell.address.text = maskInfo.address
        cell.updatedDate.text = maskInfo.updatedate
        return cell
    }
    
    
}
