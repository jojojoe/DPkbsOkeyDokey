//
//  DPkbsFontBar.swift
//  DPbsOkeyDokey
//
//  Created by nataliya on 2022/6/2.
//

import UIKit

class DPkbsFontBar: UIView {
    
    
    var currentDanweiIndex: Int = 1
    var collection: UICollectionView!
    var currentFontStr: String?
    var fontDidSelectBlock: ((String)->Void)?
    let danweiPicker = UIPickerView()
    var languageList: [String] = ["🇨🇳", "🇺🇸", "🇯🇵"]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
//        "🌠🎑💠🔲🔳"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        
        //
        danweiPicker.dataSource = self
        danweiPicker.delegate = self
        danweiPicker.adhere(toSuperview: self)
        danweiPicker.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(15)
            $0.width.equalTo(60)
            $0.height.equalTo(80)
        }
        currentDanweiIndex = 1
        danweiPicker.selectRow(currentDanweiIndex, inComponent: 0, animated: false)
        //
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collection = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        collection.showsHorizontalScrollIndicator = false
        collection.showsVerticalScrollIndicator = false
        collection.delegate = self
        collection.dataSource = self
        collection.backgroundColor = .clear
        addSubview(collection)
        collection.snp.makeConstraints {
            $0.right.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.height.equalTo(50)
            $0.left.equalToSuperview().offset(80)
        }
        collection.register(cellWithClass: ASCgymFontCell.self)
        
    }

    
}

extension DPkbsFontBar: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int { return 1 }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
     
        return languageList.count

    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        var pickerLabel = view as? UILabel
        
        if (pickerLabel == nil) {
            pickerLabel = UILabel()
            pickerLabel?.font = UIFont(name: "AppleSDGothicNeo-SemiBold", size: 18)
            pickerLabel?.textAlignment = NSTextAlignment.center
            pickerLabel?.color(UIColor.white)
        }
        pickerLabel?.text = languageList[row]
        return pickerLabel!
    }
     
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        currentDanweiIndex = row
        collection.reloadData()
    }
    
}

extension DPkbsFontBar: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: ASCgymFontCell.self, for: indexPath)
        var font: String = ""
        if currentDanweiIndex == 0 {
            font =  DPbsManager.default.fontList_zh[indexPath.item]
            cell.fontLabel.text("字体")
        } else if currentDanweiIndex == 1 {
            font =  DPbsManager.default.fontList_en[indexPath.item]
            cell.fontLabel.text("Aa")
        } else if currentDanweiIndex == 2 {
            font =  DPbsManager.default.fontList_jp[indexPath.item]
            cell.fontLabel.text("あ")
        }
        cell.layer.cornerRadius = 6
        cell.layer.masksToBounds = true
        
        cell.fontLabel.font = DPbsManager.default.customFont(fontName: font, size: 16)
//        cell.fontLabel.fontName(16, font)
//        cell.layer.borderWidth = 2
//        cell.layer.borderColor = UIColor(hexString: "#521009")?.cgColor
        if currentFontStr == font {
            cell.fontLabel.color(UIColor(hexString: "#000000")!)
            cell.selectV.isHidden = false
        } else {
            cell.fontLabel.color(UIColor(hexString: "#FFFFFF")!)
            cell.selectV.isHidden = true
        }
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if currentDanweiIndex == 0 {
            return DPbsManager.default.fontList_zh.count
        } else if currentDanweiIndex == 1 {
            return DPbsManager.default.fontList_en.count
        } else if currentDanweiIndex == 2 {
            return DPbsManager.default.fontList_jp.count
        } else {
            return DPbsManager.default.fontList_en.count
        }
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
}

extension DPkbsFontBar: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 60, height: 38)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
}

extension DPkbsFontBar: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        var item = ""
        if currentDanweiIndex == 0 {
            item = DPbsManager.default.fontList_zh[indexPath.item]
        } else if currentDanweiIndex == 1 {
            item = DPbsManager.default.fontList_en[indexPath.item]
        } else if currentDanweiIndex == 2 {
            item = DPbsManager.default.fontList_jp[indexPath.item]
        }
        
        fontDidSelectBlock?(item)
        currentFontStr = item
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }
}


class ASCgymFontCell: UICollectionViewCell {
    let fontLabel = UILabel()
    let selectV = UIView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        //
        backgroundColor(UIColor(hexString: "#161616")!)
        //
        selectV.adhere(toSuperview: contentView)
            .backgroundColor(UIColor(hexString: "#EDCC78")!)
        selectV.snp.makeConstraints {
            $0.left.right.top.bottom.equalToSuperview()
        }
        //
        fontLabel
            .textAlignment(.center)
            .text("Aa")
            .adjustsFontSizeToFitWidth()
            .color(UIColor(hexString: "#FFFFFF")!)
            .adhere(toSuperview: contentView)
        fontLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(50)
            $0.height.equalTo(38)
        }
       
        
        
  
        
    }
}



