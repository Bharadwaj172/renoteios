//
//  UserDefaultsManager.swift
//  TreeFreeNote
//
//  Created by Bhargavi on 07/08/23.
//

import UIKit

@objc class AppPersistenceUtility: NSObject {
    
    class func setObjectToUserDefaults(key: String, dataToBeSaved: Any) {
        if let data = try? NSKeyedArchiver.archivedData(withRootObject: dataToBeSaved, requiringSecureCoding: false) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }
    
    class func getObjectFromUserDefaults(key: String) -> Any? {
        if let storedData = UserDefaults.standard.object(forKey: key) as? Data,
           let decoded = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(storedData) {
            return decoded
        }
        return nil
    }
    
    class func setIntegerToUserDefaults(key: String, dataToBeSaved: Int) {
        UserDefaults.standard.set(dataToBeSaved, forKey: key)
    }
    
    class func getIntegerToUserDefaults(key: String) -> Int? {
        return UserDefaults.standard.integer(forKey:key)
    }
    
    class func setBoolToUserDefaults(key: String, dataToBeSaved: Bool) {
        UserDefaults.standard.set(dataToBeSaved, forKey: key)
    }
    
    class func getBoolFromUserDefaults(key: String) -> Bool? {
        return UserDefaults.standard.bool(forKey: key)
    }
    
    class func removeDateFromUserDefaults(key: String) {
        UserDefaults.standard.removeObject(forKey: key)
    }
    
    class func removeValueFromUserDefaults(key: String) {
        UserDefaults.standard.removeObject(forKey: key)
    }
    
    class func getDateFromUserDefaults(key: String) -> Date? {
        return (UserDefaults.standard.value(forKey: key) as? Date)
    }
    
    
    class func setDateToUserDefaults(key: String, dateToBeSaved: Date) {
        UserDefaults.standard.set(dateToBeSaved, forKey: key)
    }
    
    class func setDictionaryToUserDefaults(key: String, dataToBeSaved: Dictionary<String, Any>) {
        UserDefaults.standard.set(dataToBeSaved, forKey: key)
    }
    
    class func getDictionaryFromUserDefaults(key: String) -> Dictionary<String, Any>? {
        if let storedData = UserDefaults.standard.dictionary(forKey: key) {
            return storedData
        }
        return nil
    }
    
    class func setStringArrayToUserDefaults(key: String, dataToBeSaved: [String]) {
        UserDefaults.standard.set(dataToBeSaved, forKey: key)
    }
    
    class func setDataToSave(key: String, dataToBeSaved: Any) {
        UserDefaults.standard.set(dataToBeSaved, forKey: key)
    }
    
    
    class func getStringArrayFromUserDefaults(key: String) -> [String]? {
        if let storedData = UserDefaults.standard.stringArray(forKey: key) {
            return storedData
        }
        return nil
    }
    
    class func setStringToUserDefaults(key: String, dataToBeSaved: String) {
        UserDefaults.standard.set(dataToBeSaved, forKey: key)
    }
    
    @objc class func getStringFromUserDefaults(key: String) -> String? {
        if let storedData = UserDefaults.standard.object(forKey: key) {
            return storedData as? String
        }
        return nil
    }
    
    //MARK: - Save String values
//    class func setStringValueToKeyChain(key: String, message: String) {
//        KeychainWrapper.standard.set(message, forKey: key)
//    }
//
//    class func getStringValueFromKeyChain(key: String) -> String? {
//        if let data = KeychainWrapper.standard.string(forKey: key) as String? {
//            return data
//        }
//        return nil
//    }
//
//    //MARK: - Save data
//
//    class func setValuesToKeyChain(key: String, data: Data) {
//        KeychainWrapper.standard.set(data, forKey: key)
//    }
//
//    class func getValuesFromKeyChain(key: String) -> Data? {
//        if let data = KeychainWrapper.standard.data(forKey: key) as Data? {
//            return data
//        }
//        return nil
//    }
}
