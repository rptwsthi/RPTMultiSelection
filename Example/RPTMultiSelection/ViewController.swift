//
//  ViewController.swift
//  RPTMultiSelection
//
//  Created by rptwsthi on 02/10/2020.
//  Copyright (c) 2020 rptwsthi. All rights reserved.
//

import UIKit
import RPTMultiSelection

class TheData {
    public static func datas () -> [TheData] {
        let c = arc4random_uniform(21)//[0, 20]
        
        var tds : [TheData] = []
        for i in 0...c {
            let td = TheData(title: "I am mr. title \(i)")
            tds.append(td)
        }
        
        return tds
    }
    
    var title : String!
    var selected : Bool!
    
    init(title t:String, selected s:Bool = false) {
        title = t
        selected = s
    }
}

class ViewController: UITableViewController, RPTMultiSelectionDelegate, RPTMultiSelectionDataSource {
    @IBOutlet var multiSelection: RPTMultiSelection!
    @IBOutlet var textField: UITextField!
    var theData : [TheData]! {
        didSet {
            multiSelection.delegate = self
            multiSelection.dataSource = self
            self.multiSelection.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.multiSelection.setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //if you wanna use areadt created structure
        /*let msp = RPTMultiSelection.initializeFromNib()
        msp.delegate = self
        msp.dataSource = self
        textField.inputView = msp*/
        
        // if you want to create your own design
        theData = TheData.datas()
        textField.inputView = multiSelection
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:-
    //protocol RPTMultiSelectionDelegate
    func selectionView(_ view:RPTMultiSelection, didChecked : Bool, cell : UITableViewCell?, at:IndexPath) {
        let td = theData[at.row]
        let text = (self.textField.text ?? "") + ", " + td.title
        self.textField.text = text.trimmingCharacters(in: CharacterSet(charactersIn: ", "))
        td.selected = didChecked
    }
    
    //RPTMultiSelectionDataSource
    func selectionView(_ view:RPTMultiSelection, numberOfRowInSection section:Int) -> Int {
        return theData.count
    }

    func selectionView(_ view: RPTMultiSelection, cellForRowAt indexPath: IndexPath) -> RPTMSCell {
        let td = theData[indexPath.row]
        return view.defaultCell(forRowAt: indexPath, withTitle: td.title, checked: td.selected)
    }
}
