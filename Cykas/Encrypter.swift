//
//  File.swift
//  Cykas
//
//  Created by Domenico Antonio Tropeano on 03/04/2017.
//  Copyright © 2017 Maurizio Casciano. All rights reserved.
//

import Foundation
import RNCryptor

class Encrypter {
    static func encrypt(data: Data, password:String) -> Data {
    let ciphertext = RNCryptor.encrypt(data: data as Data, withPassword: password)
    return ciphertext
    }
    
    static func decrypt(data: Data,password:String)-> Data{
        var originalData:Data=Data()
        do{
        originalData = try RNCryptor.decrypt(data: data, withPassword: password)
        }catch{
            print(error)
        }
        return originalData
    }
}
