//
//  RSGraphQLError.swift
//  RiseEDU
//
//  Created by Nympe Yang on 2019/5/6.
//

import UIKit
import Apollo

class RSGraphQLError: NSObject
{
    var key: String = ""
    var message: String = ""
    
    class func configServerMessage(errors: [GraphQLError]) -> RSGraphQLError
    {
        var graphError = RSGraphQLError()
        
        for error in errors {
            if let val = error["validation"] {
                let dic = val as! Dictionary<String, AnyObject>
                
                for (key, value) in dic {
                    if value is Array<Any> {
                        graphError.message = convertToNext(array: value as! Array<Any>)
                    } else {
                        graphError.message = String.init(format: "%@", value as! CVarArg)
                    }
                    
                    graphError.key = key
                    
                    return graphError
                }
                
            } else {
                if error.description == "custom_error" {
   
                    if let description = error["description"] {
                        graphError.message = description as! String
                    } else {
                        graphError.message = error.message ?? ""
                    }
                    graphError.key = "custom_error"
                    
                    return graphError
                    
                } else {
                    graphError.message = error.message ?? ""
                }
                
            }
        }
        
        return graphError
    }
    
    static func convertToNext(array: Array<Any>) -> String {
        if let str = array.first {
            if str is String {
                return str as! String
            } else if str is Array<Any> {
                return convertToNext(array: str as! Array<Any>)
            } else {
                return "\(str)"
            }
        } else {
            return ""
        }
    }
}
