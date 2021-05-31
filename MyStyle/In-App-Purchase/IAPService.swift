//
//  IAPService.swift
//  MyStyle
//
//  Created by 胡建明 on 2021/5/28.
//

import Foundation
import StoreKit

class IAPService: NSObject {
    private override init() {}
    static let shared = IAPService()
    
    func showUniversalLoadingView(_ show: Bool, loadingText : String = "") {
        let existingView = UIApplication.shared.windows[0].viewWithTag(2021)
        if show {
            if existingView != nil {
                return
            }
            let loadingView = self.makeLoadingView(withFrame: UIScreen.main.bounds, loadingText: loadingText)
            loadingView?.tag = 2021
            UIApplication.shared.windows[0].addSubview(loadingView!)
        } else {
            existingView?.removeFromSuperview()
        }

    }

     func makeLoadingView(withFrame frame: CGRect, loadingText text: String?) -> UIView? {
        let loadingView = UIView(frame: frame)
        loadingView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        //activityIndicator.backgroundColor = UIColor(red:0.16, green:0.17, blue:0.21, alpha:1)
        activityIndicator.layer.cornerRadius = 6
        activityIndicator.center = loadingView.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .large
        activityIndicator.startAnimating()
        activityIndicator.tag = 100 // 100 for example

        loadingView.addSubview(activityIndicator)
        if !text!.isEmpty {
            let lbl = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 30))
            let cpoint = CGPoint(x: activityIndicator.frame.origin.x + activityIndicator.frame.size.width / 2, y: activityIndicator.frame.origin.y + 80)
            lbl.center = cpoint
            lbl.textColor = UIColor.white
            lbl.textAlignment = .center
            lbl.text = text
            lbl.tag = 2021
            loadingView.addSubview(lbl)
        }
        return loadingView
    }
    
    var products = [SKProduct]()
    var paymentQueue = SKPaymentQueue.default()
    var onBuyProductHandler: ((Result<Bool, Error>) -> Void)?
    
    func getProducts() {
        let products: Set = [IAPProducts.banana.rawValue,
                             IAPProducts.pineapple.rawValue,
                             IAPProducts.watermelon.rawValue]
        let request = SKProductsRequest(productIdentifiers: products)
        request.delegate = self
        request.start()
    }
    
    func startObserving() {
        paymentQueue.add(self)
    }
    
    func stopObserving() {
        paymentQueue.remove(self)
    }
    
    func canMakePaymenst() -> Bool {
        return SKPaymentQueue.canMakePayments()
    }
    
    // MARK: - Purchase Products
    
    func buy(product: String, withHandler handler: @escaping((_ result: Result<Bool, Error>) -> Void)) {
        guard let productToPurchase =
                products.filter({ $0.productIdentifier == product }).first else { return }
        let payment = SKPayment(product: productToPurchase)
        paymentQueue.add(payment)
        
        // Keep the completion handler.
        onBuyProductHandler = handler
    }
    
    func purchase(product: String) {
        guard let productToPurchase =
                products.filter({ $0.productIdentifier == product }).first else { return }
        let payment = SKPayment(product: productToPurchase)
        paymentQueue.add(payment)
    }
    
    func restorePurchases() {
        print("restoring purchases")
        paymentQueue.restoreCompletedTransactions()
    }
}

extension IAPService: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        self.products = response.products
        for product in response.products {
            print(product.localizedTitle)
        }
    }
    
    func request(_ request: SKRequest, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func requestDidFinish(_ request: SKRequest) {

    }
}

extension IAPService: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            print(transaction.transactionState.statue(), transaction.payment.productIdentifier)
            switch transaction.transactionState {
            case .purchasing:
                showUniversalLoadingView(true, loadingText: "Loading...")
            default: queue.finishTransaction(transaction)
            }
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, removedTransactions transactions: [SKPaymentTransaction]) {
        showUniversalLoadingView(false)
    }
}

extension SKPaymentTransactionState {
    func statue() -> String{
        switch self {
        case .deferred: return "deferred"
        case .failed: return "failed"
        case .purchased: return "purchased"
        case .purchasing: return "purchasing"
        case .restored: return "restored"
        @unknown default:
            fatalError()
        }
    }
}
