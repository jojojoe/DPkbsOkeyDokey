//
//  DPkbsBgEffectBar.swift
//  DPbsOkeyDokey
//
//  Created by nataliya on 2022/6/2.
//

import UIKit

class DPkbsBgEffectBar: UIView {
    
    
    var currentDanweiIndex: Int = 1
    var collection: UICollectionView!
    var currentSelectItem: ODStyleItem?
    var didSelectBlock: ((ODStyleItem)->Void)?
    let danweiPicker = UIPickerView()
    var effectTypeList: [String] = ["💠", "🔲", "🎆"]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
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
        collection.register(cellWithClass: ASCgymBgEffectCell.self)
        collection.clipsToBounds = false
    }

    
}

extension DPkbsBgEffectBar: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int { return 1 }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return effectTypeList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        var pickerLabel = view as? UILabel
        
        if (pickerLabel == nil) {
            pickerLabel = UILabel()
            pickerLabel?.font = UIFont(name: "AppleSDGothicNeo-SemiBold", size: 18)
            pickerLabel?.textAlignment = NSTextAlignment.center
            pickerLabel?.color(UIColor.white)
        }
        pickerLabel?.text = effectTypeList[row]
        return pickerLabel!
    }
     
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        currentDanweiIndex = row
        collection.reloadData()
        
    }
    
}

extension DPkbsBgEffectBar: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: ASCgymBgEffectCell.self, for: indexPath)
        var styleItem: ODStyleItem = DPbsManager.default.styleList_effect[0]
        if currentDanweiIndex == 0 {
            styleItem =  DPbsManager.default.styleList_effect[indexPath.item]
           
        } else if currentDanweiIndex == 1 {
            styleItem =  DPbsManager.default.styleList_color[indexPath.item]
            
        } else if currentDanweiIndex == 2 {
            styleItem =  DPbsManager.default.styleList_photo[indexPath.item]
            
        }
//        cell.layer.cornerRadius = 6
//        cell.layer.masksToBounds = true
        
        cell.bgImgV.image(styleItem.thumbImg)
        
        if currentSelectItem?.templateId == styleItem.templateId {
            cell.selectV.isHidden = false
        } else {
            cell.selectV.isHidden = true
        }
        
        if indexPath.item >= 2 {
            cell.provipImgV.isHidden = false
        } else {
            cell.provipImgV.isHidden = true
        }
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if currentDanweiIndex == 0 {
            return DPbsManager.default.styleList_effect.count
        } else if currentDanweiIndex == 1 {
            return DPbsManager.default.styleList_color.count
        } else if currentDanweiIndex == 2 {
            return DPbsManager.default.styleList_photo.count
        } else {
            return DPbsManager.default.styleList_color.count
        }
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
}

extension DPkbsBgEffectBar: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 60, height: 44)
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

extension DPkbsBgEffectBar: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        var item: ODStyleItem = DPbsManager.default.styleList_color[0]
        currentSelectItem = item
        if currentDanweiIndex == 0 {
            item = DPbsManager.default.styleList_effect[indexPath.item]
            currentSelectItem = item
        } else if currentDanweiIndex == 1 {
            item = DPbsManager.default.styleList_color[indexPath.item]
            currentSelectItem = item
        } else if currentDanweiIndex == 2 {
            item = DPbsManager.default.styleList_photo[indexPath.item]
            currentSelectItem = item
        }
        
        didSelectBlock?(item)
        
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }
}


class ASCgymBgEffectCell: UICollectionViewCell {
    let bgImgV = UIImageView()
    let selectV = UIView()
    let provipImgV = UIImageView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        //
//        backgroundColor(UIColor(hexString: "#161616")!)
        //
        bgImgV.adhere(toSuperview: contentView)
            .contentMode(.scaleAspectFill)
        bgImgV.layer.cornerRadius = 8
        bgImgV.clipsToBounds()
        bgImgV.snp.makeConstraints {
            $0.left.right.top.bottom.equalToSuperview()
        }
        //
        selectV.adhere(toSuperview: contentView)
            .backgroundColor(UIColor.clear)
        selectV.layer.borderColor = UIColor(hexString: "EDCC78")?.cgColor
        selectV.layer.borderWidth = 2
        selectV.layer.cornerRadius = 8
        selectV.snp.makeConstraints {
            $0.left.right.top.bottom.equalToSuperview()
        }
        
        provipImgV.adhere(toSuperview: contentView)
            .image("vippro")
            .contentMode(.scaleAspectFit)
        provipImgV.snp.makeConstraints {
            $0.top.equalToSuperview().offset(-4)
            $0.right.equalToSuperview().offset(4)
            $0.width.equalTo(32/2)
            $0.height.equalTo(26/2)
        }
        
        
    }
}



