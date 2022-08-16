//
//  DPbsPurchaseManager.swift
//  DPbsOkeyDokey
//
//  Created by nataliya on 2022/8/9.
//

import Foundation
import NoticeObserveKit
import SwiftyStoreKit
import TPInAppReceipt
import StoreKit
import Alertift
import ZKProgressHUD
import Defaults

struct PurchaseNotificationKeys {
    static let success = "success"
    static let failed = "failed"
}


public class DPksOkeyPurchaseManager {
    public static var `default` = DPksOkeyPurchaseManager()
//    let verifyProductSharedSecret = "efec92078b704f6ba3f5a71ac73e80d4"
    var test: Bool = false
    public var receiptInfo: ReceiptInfo? {
        set {
            guard let newValue = newValue else { return }
            if let data = try? JSONSerialization
                .data(withJSONObject: newValue, options: .init(rawValue: 0)) {
                Defaults[.localIAPReceiptInfo] = data
                Notice.Center.default
                    .post(name: Notice.Names.receiptInfoDidChange, with: nil)
            }
        }
        get {
            guard let data = Defaults[.localIAPReceiptInfo] else { return nil }
            let receiptInfo = try? JSONSerialization
                .jsonObject(with: data, options: .init(rawValue: 0)) as? ReceiptInfo
            return receiptInfo
        }
    }
    
    public enum IAPType: String {
//        case life = "com.widget.theme.pack"
//        case month = "com.superegg.timewidget.onemonth"
        case year = "com.superegg.timewidget.oneyear"
    }
    public enum VerifyLocalReceiptResult {
        case success(receipt: InAppReceipt)
        case error(error: IARError)
    }

    public enum VerifyLocalSubscriptionResult {
        case purchased(expiryDate: Date, items: [InAppReceipt])
        case expired(expiryDate: Date, items: [InAppReceipt])
        case purchasedOnceTime
        case notPurchased
    }
    public let iapTypeList: [IAPType] = [.year]
    
    
    var inSubscription: Bool = false
   

    public func purchaseInfo(block: @escaping (([DPksOkeyPurchaseManager.IAPProduct]) -> Void)) {
        let iapList = iapTypeList.map { $0.rawValue }
        retrieveProductsInfo(iapList: iapList) { items in
            block(items)
        }
    }

    public func restore(_ success: (() -> Void)? = nil) {
        HUD.show()
        SwiftyStoreKit.restorePurchases(atomically: true) { [weak self] results in
            guard let `self` = self else { return }
            if results.restoreFailedPurchases.count > 0 {
                ZKProgressHUD.showError("Restore Failed")
                debugPrint("Restore Failed: \(results.restoreFailedPurchases)")
            } else if results.restoredPurchases.count > 0 {
                for purchase in results.restoredPurchases {
                    if purchase.needsFinishTransaction {
                        SwiftyStoreKit.finishTransaction(purchase.transaction)
                    }
                }
                
                self.refreshReceipt { (_, _) in
                    self.isPurchased { (status) in
                        self.inSubscription = status
                        HUD.hide()
                        if status {
                            Notice.Center.default.post(name: Notice.Names.noti_purchaseCompletion, with: nil)
                            NotificationCenter.default.post(
                                name: NSNotification.Name(rawValue: PurchaseNotificationKeys.success),
                                object: nil,
                                userInfo: nil)
                            
                            Alert.message("Restore Success", success: {
                                success?()
                                
                            })
                            
                            debugPrint("Restore Success: \(results.restoredPurchases)")
                        } else {
                            
                            Alert.error("Nothing to Restore")
                        }
                    }
                }
                    
                
            } else {
                HUD.hide()
                Alert.error("Nothing to Restore")
            }
        }
    }

    public func order(iapType: IAPType, source: String, success: (() -> Void)? = nil) {

        HUD.show()
        SwiftyStoreKit.purchaseProduct(iapType.rawValue) { purchaseResult in
            switch purchaseResult {
            case let .success(purchaseDetail):
                if purchaseDetail.needsFinishTransaction {
                    SwiftyStoreKit.finishTransaction(purchaseDetail.transaction)
                }
                   
                self.refreshReceipt { (_, _) in
                    self.isPurchased { (status) in
                        self.inSubscription = status
                        if status {
                            let currency = purchaseDetail.product.priceLocale.currencySymbol ?? "$"
                            let price = purchaseDetail.product.price.doubleValue
                            
                        } else {
                            
                        }
                        HUD.hide()
                        Notice.Center.default.post(name: Notice.Names.noti_purchaseCompletion, with: nil)
                        NotificationCenter.default.post(
                            name: NSNotification.Name(rawValue: PurchaseNotificationKeys.success),
                            object: nil,
                            userInfo: nil)
                        success?()
                    }
                }
                  
            case let .error(error):

                var errorStr = error.localizedDescription
                switch error.code {
                case .unknown: errorStr = "Unknown error. Please contact support. If you are sure you have purchased it, please click the \"Restore\" button."
                case .clientInvalid: errorStr = "Not allowed to make the payment"
                case .paymentCancelled: errorStr = "Payment cancelled"
                case .paymentInvalid: errorStr = "The purchase identifier was invalid"
                case .paymentNotAllowed: errorStr = "The device is not allowed to make the payment"
                case .storeProductNotAvailable: errorStr = "The product is not available in the current storefront"
                case .cloudServicePermissionDenied: errorStr = "Access to cloud service information is not allowed"
                case .cloudServiceNetworkConnectionFailed: errorStr = "Could not connect to the network"
                case .cloudServiceRevoked: errorStr = "User has revoked permission to use this cloud service"
                default: errorStr = (error as NSError).localizedDescription
                }
                Alert.error(errorStr)
            }
        }
    }
    
    func formateErrorType(error: SKError) -> String {
        if error.code == .unknown {
            return "unknown"
        } else if error.code == .clientInvalid {
            return "clientInvalid"
        } else if error.code == .paymentCancelled {
            return "paymentCancelled"
        } else if error.code == .paymentInvalid {
            return "paymentInvalid"
        } else if error.code == .paymentNotAllowed {
            return "paymentNotAllowed"
        } else if error.code == .storeProductNotAvailable {
            return "storeProductNotAvailable"
        } else if error.code == .cloudServicePermissionDenied {
            return "cloudServicePermissionDenied"
        } else if error.code == .cloudServiceRevoked {
            return "cloudServiceRevoked"
        } else {
            if #available(iOS 12.2, *) {
                if error.code == .privacyAcknowledgementRequired {
                    return "privacyAcknowledgementRequired"
                } else if error.code == .unauthorizedRequestData {
                    return "unauthorizedRequestData"
                } else if error.code == .invalidOfferIdentifier {
                    return "invalidOfferIdentifier"
                } else if error.code == .missingOfferParams {
                    return "missingOfferParams"
                } else if error.code == .invalidOfferPrice {
                    return "invalidOfferPrice"
                }
            } else {
                return "unknown"
            }
        }
        return "unknown"
    }

//    public func verify(_ success: ((ReceiptInfo) -> Void)? = nil) {
//        // need change new secret key
//        #if DEBUG
//        let receiptValidator = AppleReceiptValidator(service: .sandbox, sharedSecret: verifyProductSharedSecret)
//        #else
//        let receiptValidator = AppleReceiptValidator(service: .production, sharedSecret: verifyProductSharedSecret)
//        #endif
//        SwiftyStoreKit.verifyReceipt(using: receiptValidator) { verifyResult in
//            switch verifyResult {
//            case let .success(receipt):
//                self.receiptInfo = receipt
//                success?(receipt)
//            case let .error(error):
//                Alert.error(error.localizedDescription)
//                debugPrint("Verify Error", error.localizedDescription)
//            }
//        }
//    }
}

public extension DPksOkeyPurchaseManager {
    // main method to check if purchased anything
    func isPurchased(completion: @escaping (_ purchased: Bool) -> Void) {
        let dispatchGroup = DispatchGroup()
        let purchases: [IAPType] = [.year]
        var validPurchases: [String: VerifyLocalSubscriptionResult] = [:]
        var errors: [String: Error] = [:]

       
        
        for key in purchases {
            dispatchGroup.enter()
            
            verifyPurchase(key) { [weak self] purchaseResult, error in
                guard let welf = self else {
                    dispatchGroup.leave()
                    return
                }
                if let err = error {
                    errors[key.rawValue] = err
                    dispatchGroup.leave()
                    return
                }
                guard let purchase = purchaseResult else {
                    dispatchGroup.leave()
                    return
                }
                switch purchase {
                case .purchased(let expiryDate):
                    let now = Date()
                    if now < expiryDate.expiryDate {
                        validPurchases[key.rawValue] = purchase
                    }
                    validPurchases[key.rawValue] = purchase

                    dispatchGroup.leave()
                case .expired(let expiryDate):
                    print("Product is expired since \(expiryDate)")
                    DispatchQueue.main.async {
                        let format = DateFormatter()
                        // 2) Set the current timezone to .current, or America/Chicago.
                        format.timeZone = .current
                        // 3) Set the format of the altered date.
                        // format is: Friday, Jul 5, 2019 12:21 AM
                        format.dateFormat = "EEEE, MMM d, yyyy h:mm a"
                        // 4) Set the current date, altered by timezone.
                        let dateString = format.string(from: expiryDate.expiryDate)
                        
                        dispatchGroup.leave()
                    }
                case .purchasedOnceTime:
                    validPurchases[key.rawValue] = purchase
                    dispatchGroup.leave()
                case .notPurchased:
                    dispatchGroup.leave()
                    
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            let hasValid = validPurchases.count > 0
            DPksOkeyPurchaseManager.default.inSubscription = hasValid
            completion(hasValid)
        }
    }
    
    func verifyPurchase(
        _ purchase: IAPType,
        completion: @escaping(VerifyLocalSubscriptionResult?, Error?) -> Void
    ) {
        verifyReceipt { [weak self] (receiptResult, validationError) in
            guard let welf = self else {
                completion(nil, nil)
                return
            }
            if let error = validationError {
                completion(nil, error)
                return
            }
            
            guard let result = receiptResult else {
                completion(nil, nil)
                return
            }
            
            switch result {
            // receipt is validated
            case .success(let receipt):
                let oneTimePurchase = ""//IAPType.life.rawValue
                let item = receipt.purchases.first {
                    return $0.productIdentifier == oneTimePurchase
                }
                
//                // check there is a subscription first
//                //TODO: 判断是否是 一次性购买
//                if productId == IAPType.halfYear.rawValue {
//                    completion(.purchasedOnceTime, nil)
//                    return
//                }
                
                if let _ = item {
                    completion(.purchasedOnceTime, nil)
                    return
                }
                
                let productId = purchase.rawValue
                // check there is a subscription first
                if let subscription = receipt.activeAutoRenewableSubscriptionPurchases(
                    ofProductIdentifier: productId,
                    forDate: Date()
                ) {
                    if let expiryDate = subscription.subscriptionExpirationDate {
                        completion(
                            .purchased(
                                expiryDate: expiryDate,
                                items: [receipt]
                            ),
                            nil
                        )
                        return
                    }
                    // no expiry date?
                    completion(.notPurchased, nil)
                }
                let purchases = receipt.purchases(
                    ofProductIdentifier: productId
                ) { (InAppPurchase, InAppPurchase2) -> Bool in
                    return InAppPurchase.purchaseDate > InAppPurchase2.purchaseDate
                }
                if purchases.isEmpty {
                    completion(.notPurchased, nil)
                }
                else {
                    // get last purchase
                    let lastSubscription = purchases[0]
                    completion(
                        .expired(
                            expiryDate: lastSubscription.subscriptionExpirationDate ?? Date(),
                            items: [receipt]
                        ),
                        nil
                    )
                }
            // validation error
            case .error(let error):
                completion(nil, error)
            }
            
        }
    }
    
    func verifyReceipt(
        completion: @escaping(VerifyLocalReceiptResult?, Error?) -> Void
    ) {
        do {
            let receipt = try InAppReceipt.localReceipt()
            do {
                try receipt.verifyHash()
                completion(.success(receipt: receipt), nil)
            } catch IARError.initializationFailed(let reason) {
                completion(.error(error: .initializationFailed(reason: reason)),nil)
            } catch IARError.validationFailed(let reason) {
                completion(.error(error: IARError.validationFailed(reason: reason)), nil)
            } catch IARError.purchaseExpired {
                completion(.error(error: .purchaseExpired), nil)
            } catch {
                // unknown error
                completion(nil, error)
            }
        } catch {
            completion(
                .error(error: .initializationFailed(reason: .appStoreReceiptNotFound)),
                error
            )
        }
    }
    
    func refreshReceipt(completion: @escaping(FetchReceiptResult?, Error?) -> Void) {
        SwiftyStoreKit.fetchReceipt(forceRefresh: true, completion: { result in
            switch result {
            case .success:
               completion(result, nil)
            case .error(let error):
                completion(nil, error)
            }
        })
    }
}

public extension DPksOkeyPurchaseManager {
    struct IAPProduct: Codable {
        public var iapID: String
        public var price: Double
        public var priceLocale: Locale
        public var localizedPrice: String?
        public var currencyCode: String?
    }

    static var localIAPProducts: [IAPProduct]? = Defaults[.localIAPProducts] {
        didSet { Defaults[.localIAPProducts] = localIAPProducts }
    }

    static var localIAPCacheTime: TimeInterval? = Defaults[.localIAPCacheTime] {
        didSet { Defaults[.localIAPCacheTime] = localIAPCacheTime }
    }

    /// 获取多项价格(maybe sync)
    func retrieveProductsInfo(iapList: [String],
                              completion: @escaping (([IAPProduct]) -> Void)) {
        let oldLocalList = DPksOkeyPurchaseManager.localIAPProducts ?? []
        let localIAPIDList = oldLocalList.compactMap { $0.iapID }
        if localIAPIDList.contains(iapList) {
            completion(oldLocalList)
             
        }
        SwiftyStoreKit.retrieveProductsInfo(Set(iapList)) { result in
            let priceList = result.retrievedProducts.compactMap { $0 }
            let localList = priceList.compactMap { DPksOkeyPurchaseManager.IAPProduct(iapID: $0.productIdentifier, price: $0.price.doubleValue, priceLocale: $0.priceLocale, localizedPrice: $0.localizedPrice, currencyCode: $0.priceLocale.currencyCode) }

            var tempItems = localList
            for iapItem in oldLocalList {
                let identicalItems = localList.filter { $0.iapID == iapItem.iapID }
                if identicalItems.isEmpty {
                    tempItems.append(iapItem)
                }
            }
            DPksOkeyPurchaseManager.localIAPProducts = tempItems
            DPksOkeyPurchaseManager.localIAPCacheTime = Date().unixTimestamp
            completion(tempItems)
        }
    }

    /// 获取单项价格(maybe sync)
    func retrieveProductsInfo(iapID: String,
                              completion: @escaping ((IAPProduct?) -> Void)) {
        retrieveProductsInfo(iapList: [iapID]) { result in
            completion(result.filter { $0.iapID == iapID }.first)
        }
    }
}

extension Defaults.Keys {
    static let localIAPReceiptInfo = Key<Data?>("localIAPReceiptInfo")
    static let localIAPProducts = Key<[DPksOkeyPurchaseManager.IAPProduct]?>("LocalIAPProducts")
    static let localIAPCacheTime = Key<TimeInterval?>("LocalIAPCacheTime")
}

extension Notice.Names {
    static let receiptInfoDidChange =
        Notice.Name<Any?>(name: "ReceiptInfoDidChange")
    static let noti_setupWidgetSuccess =
        Notice.Name<Any?>(name: "noti_setupWidgetSuccess")
    static let noti_purchaseCompletion =
        Notice.Name<Any?>(name: "noti_purchaseCompletion")
    static let noti_loadConfigsFromDB =
        Notice.Name<Any?>(name: "noti_loadConfigsFromDB")
}












