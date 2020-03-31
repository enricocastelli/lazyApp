//
//  Common.swift
//  StayHome
//
//  Created by Enrico Castelli on 23/03/2020.
//  Copyright © 2020 EC. All rights reserved.
//

import Foundation

class Logger {
    
    static func error(_ error: Error,_ request: URLRequest? = nil) {
        print("⚠️💔 - ERROR - \(Date()) - \((error as NSError).description)")
    }
    
    static func warning(_ warning: String) {
        print("⚠️💙 - WARNING - \(warning)")
    }
}


extension Data {
    
    func prettyPrint() {
        print(utf8() ?? "No Data")
    }
    
    func utf8() -> String? {
        return String(data: self, encoding: String.Encoding.utf8)
    }
}

func isSimulator() -> Bool {
    var systemInfo = utsname()
    uname(&systemInfo)
    let machineMirror = Mirror(reflecting: systemInfo.machine)
    let identifier = machineMirror.children.reduce("") { identifier, element in
        guard let value = element.value as? Int8, value != 0 else { return identifier }
        return identifier + String(UnicodeScalar(UInt8(value)))
    }
    return identifier == "i386" || identifier == "x86_64"
}

func random(min: Int, max: Int) -> Double {
    return Double((arc4random_uniform(UInt32(max)))*100)/100
}
