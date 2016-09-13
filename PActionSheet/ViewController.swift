//
//  ViewController.swift
//  PActionSheet
//
//  Created by 邓杰豪 on 2016/9/13.
//  Copyright © 2016年 邓杰豪. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        let btn = UIButton.init(type: .custom)
        btn.frame = CGRect.init(x: 0, y: 0, width: 100, height: 100)
        btn.backgroundColor = UIColor.white
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        btn.setTitleColor(UIColor.black, for: .normal)
        btn.setTitle("1", for: .normal)
        btn.addTarget(self, action: #selector(self.didSelectAction(sender:)), for: .touchUpInside)
        self.view.addSubview(btn)


        self.view.backgroundColor = UIColor.blue

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func didSelectAction(sender:UIButton)
    {
        let arr = ["1","2"]
        let ppppp = PActionSheet.showActionSheetWithTitle(title: "1", cancelButtonTitle: "2", destructiveButtonTitle: "3", otherButtonTitles:arr as NSArray) { (actionSheet:PActionSheet, index:NSInteger) in
            print(actionSheet)
            print(index)
        }
        ppppp.show()
    }


}

