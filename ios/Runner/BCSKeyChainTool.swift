//
//  BCSKeyChainTool.swift
//  Butterfly
//
//  Created by mac on 2019/11/7.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit

class BCSKeyChainTool: NSObject {
    /// 查询
    static func getKeychainQuery(service: String) -> NSMutableDictionary {
        return NSMutableDictionary.init(objects: [kSecClassGenericPassword, service, service, kSecAttrAccessibleAfterFirstUnlock], forKeys: [kSecClass as! NSCopying, kSecAttrService as! NSCopying, kSecAttrAccount as! NSCopying, kSecAttrAccessible as! NSCopying])
    }
    /// 保存
    static func save(service: String, data: Any) {
        // Get search dictionary
        let keychainQuery = self.getKeychainQuery(service: service)
        // Delete old item before add new item
        SecItemDelete(keychainQuery)
        // Add new object to search dictionary(Attention:the data format)
        keychainQuery.setObject(NSKeyedArchiver.archivedData(withRootObject: data), forKey: kSecValueData as! NSCopying)
        // Add item to keychain with the search dictionary
        SecItemAdd(keychainQuery, nil)
    }
    
    /// 加载
    static func load(service: String) -> String {
        var ret: String = ""
        let keychainQuery = self.getKeychainQuery(service: service)
        // Configure the search setting
        // Since in our simple case we are expecting only a single attribute to be returned (the password) we can set the attribute kSecReturnData to kCFBooleanTrue
        keychainQuery.setObject(kCFBooleanTrue, forKey: kSecReturnData as! NSCopying)
        keychainQuery.setObject(kSecMatchLimitOne, forKey: kSecMatchLimit as! NSCopying)
        var keyData: CFTypeRef?
        if SecItemCopyMatching(keychainQuery, &keyData) == noErr {
            ret = NSKeyedUnarchiver.unarchiveObject(with: keyData as! Data) as! String
        }
        return ret
    }
    
    /// 删除
    static func deleteKeyData(service: String) {
        let keychainQuery = self.getKeychainQuery(service: service)
        SecItemDelete(keychainQuery)
    }
}
