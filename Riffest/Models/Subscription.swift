import Foundation
import UIKit

class RMSubscription: NSObject {
    
    var card_id: String?
    var name: String?
    var card_brand: String?
    var cardholder_name: String?
    var card_last_four: String?
    var address_line1: String?
    var address_line2: String?
    var address_city: String?
    var address_zip: String?
    var address_state: String?
    var country: String?
    
    override init() {
        super.init()
    }
    init(withDictionary dic: NSDictionary) {
        self.card_id = dic.value(forKey: "card_id") as? String ?? ""
        self.name = dic.value(forKey: "name") as? String ?? ""
        self.card_brand = dic.value(forKey: "card_brand") as? String ?? ""
        self.cardholder_name = dic.value(forKey: "cardholder_name") as? String ?? ""
        self.card_last_four = dic.value(forKey: "card_last_four") as? String ?? ""
        self.address_line1 = dic.value(forKey: "address_line1") as? String ?? ""
        self.address_line2 = dic.value(forKey: "address_line2") as? String ?? ""
        self.address_city = dic.value(forKey: "address_city") as? String ?? ""
        self.address_zip = dic.value(forKey: "address_zip") as? String ?? ""
        self.address_state = dic.value(forKey: "address_state") as? String ?? ""
        self.country = dic.value(forKey: "country") as? String ?? ""
    }

}
