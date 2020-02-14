//
//  MultiSelectionView.swift
//  RPTMultiSelection_Example
//
//  Created by Arpit on 2/10/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit


/*class RPTMSData {
    public class func pickerDataArray (titles:[String?], datas rawDatasArray: [Any?]) -> [RPTMSData] {
        var pda : [RPTMSData] = []
        
        var i : Int = 0
        for t in titles {
            let pd = RPTMSData(title: t, rawData: rawDatasArray[i])
            
            pda.append(pd)
            i += 1
        }
        return pda
    }
    
    var title : String!
    var selected : Bool! = false
    var rawData : Any?
    
    init(title t:String? = "", rawData r: Any?) {
        title = t
        rawData = r
    }
}


class RPTMSDataSource {
    var selectionData : [[RPTMSData]]! = []
    
    init(with selections:[[RPTMSData]]) {
        self.selectionData = selections
    }
    
    var numberOfComponent : Int {
        get {
            return selectionData.count
        }
    }
    
    func numberOfRowIn(selection:Int) -> Int {
        if selection < selectionData.count {
            return selectionData[selection].count
        }
        return 0
    }
    
    func data(forRow row: Int, forComponent selection: Int) -> RPTMSData {
        return selectionData[selection][row]
    }
    
    func append (selection:[RPTMSData]) {
        self.selectionData.append(selection)
    }
}*/


class IndicatorView : UIView {
    override init(frame: CGRect) {
        super.init(frame:frame)
        self.setUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder:coder)
        self.setUI()
    }
    
    func setUI () {
        var f = self.frame
        f.size.height = f.size.width
        let c = self.center
        self.frame = f
        self.center = c
        
        self.layer.cornerRadius = f.size.height / 2
        self.layer.masksToBounds = true
    }
}


class RPTMSCell : UITableViewCell {
    @IBOutlet var selectionIndicator : IndicatorView?
    @IBOutlet var titleLabel : UILabel?
    
    var indicatorColor : UIColor! = .green {
        didSet {
            self.selectionIndicator?.layer.borderColor = indicatorColor.cgColor
        }
    }
    
    var checked: Bool! {
        didSet {
            if checked == true {
                if self.selectionIndicator != nil {
                    self.selectionIndicator?.backgroundColor = indicatorColor
                }else{
                    self.backgroundColor = indicatorColor
                }
            } else {
                if self.selectionIndicator != nil {
                    self.selectionIndicator?.backgroundColor = UIColor.clear
                }else{
                    self.backgroundColor = UIColor.clear
                }
            }
        }
    }
}

class RPTMultiSelection : UIView, UITableViewDelegate, UITableViewDataSource {
    var delegate : RPTMultiSelectionDelegate!
    var dataSource : RPTMultiSelectionDataSource!
    var selected : [IndexPath:Bool]? = [:]
    @IBOutlet var tableView : UITableView!
    @IBInspectable var indicatorColor : UIColor! = .green
    
    
    func delay(_ delay:Double, closure:@escaping ()->()) {
        let when = (DispatchTime.now() + delay)
        DispatchQueue.main.asyncAfter(deadline:when, execute: closure)
    }

    
    class func initializeFromNib() -> RPTMultiSelection {
        return UINib(nibName: "RPTMultiSelection", bundle: nil).instantiate(withOwner: RPTMultiSelection.self, options: nil)[0] as! RPTMultiSelection
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        //Set table view up
        if tableView == nil {
            //let margins = self.layoutMarginsGuide
            //tableView.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
            var f = self.frame
            f.origin = CGPoint.zero
            self.tableView = UITableView.init(frame: f)
            self.addSubview(self.tableView)
            self.tableView.delegate = self
            self.tableView.dataSource = self
            self.registerCell(nibName: "RPTMSCell", identifier: "c_multiSelection")
        }
    }
    
    func reloadData() {
        self.tableView.reloadData()
    }
    
    func setupUI() {
        var f = self.frame
        f.origin = CGPoint.zero
        tableView.frame = f
    }
    
    func registerCell(nibName:String, identifier:String)  {
        let bundle = Bundle(for: self.classForCoder)
        let nibName = UINib(nibName: nibName, bundle:bundle)
        self.tableView.register(nibName, forCellReuseIdentifier: identifier)
    }
    
    //UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.numberOfSection(in: self)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.selectionView(self, numberOfRowInSection: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return dataSource.selectionView(self, cellForRowAt: indexPath)
    }
    
    //UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        if let c = cell as? RPTMSCell {
            let isi = !c.checked //is selected inverse
            print ("isi = ", isi)
            c.checked = isi
            delegate.selectionView(self, didChecked : isi, cell : c, at:indexPath)
        }
        //..
        delegate.selectionView(self, didSelect: cell, at: indexPath)
    }
    
    //Support
    func defaultCell(forRowAt indexPath: IndexPath, withTitle t: String?, checked:Bool = false) -> RPTMSCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "c_multiSelection") as! RPTMSCell
        cell.checked = checked
        cell.titleLabel?.text = t
        return cell
    }
}

protocol RPTMultiSelectionDelegate {
    func selectionView(_ view:RPTMultiSelection, didChecked : Bool, cell : UITableViewCell?, at:IndexPath)
    func selectionView(_ view:RPTMultiSelection, didSelect cell : UITableViewCell?, at:IndexPath)
}

extension RPTMultiSelectionDelegate {
    func selectionView(_ view:RPTMultiSelection, didChecked : Bool, cell : UITableViewCell?, at:IndexPath) {}
    func selectionView(_ view:RPTMultiSelection, didSelect cell : UITableViewCell?, at:IndexPath){}
}

protocol RPTMultiSelectionDataSource {
    func numberOfSection(in view:RPTMultiSelection) -> Int
    func selectionView(_ view:RPTMultiSelection, numberOfRowInSection section:Int) -> Int
    func selectionView(_ view:RPTMultiSelection, cellForRowAt indexPath:IndexPath) -> RPTMSCell
    func selectionView(_ view:RPTMultiSelection, heightForRowAt indexPath:IndexPath) -> Float
}

extension RPTMultiSelectionDataSource {
    func numberOfSection(in view:RPTMultiSelection) -> Int {
        return 1
    }
    
    func selectionView(_ view:RPTMultiSelection, heightForRowAt indexPath:IndexPath) -> Float {
        return 44
    }
}
