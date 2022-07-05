//
//  ViewController.swift
//  TestApp
//
//  Created by 王佶立 on 2022/7/3.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var maskInfoTable: UITableView!
    
    let networkController = NetworkController()
    override func viewDidLoad() {
        super.viewDidLoad()
        networkController.getMaskInfo()
        // Do any additional setup after loading the view.
    }


}
extension ViewController:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MaskInfoCell", for: indexPath) as! MaskInfoTableViewCell
        
        return cell
    }
    
    
}
