//
//  StoreManager.swift
//  RiseEDU
//
//  Created by yu shuhui on 2018/4/24.
//

import UIKit
import Apollo



extension StoreManager: HTTPNetworkTransportPreflightDelegate {
    func networkTransport(_ networkTransport: HTTPNetworkTransport, shouldSend request: URLRequest) -> Bool {
        return true
    }
    
    func networkTransport(_ networkTransport: HTTPNetworkTransport,
                          willSend request: inout URLRequest) {
        
        request.timeoutInterval = 10 // 接口超时时间10s
        
        let appversion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String // app版本号
        let iosVersion = UIDevice.current.systemVersion //iOS系统版本
        let modelName = "iPhone" //设备具体型号
        
        // 用于没有登录的时候的请求
        if UserDefaults.standard.object(forKey: "token")  == nil {
            request.allHTTPHeaderFields = ["AppVersion": appversion, "OsName": iosVersion, "DeviceName": modelName,"AppName":"PARENT"]
        } else { // 用于登录后的请求
            
            let token = UserDefaults.standard.object(forKey: "token") as! String
            var idStr = ""
            if UserDefaults.standard.object(forKey: "studentid") is NSNumber {
                let id =  UserDefaults.standard.object(forKey: "studentid") as! NSNumber
                idStr = id.stringValue
            } else {
                let id =  UserDefaults.standard.object(forKey: "studentid") as! String
                idStr = id
            }
            
            request.allHTTPHeaderFields = ["AppVersion": appversion, "OsName": iosVersion, "DeviceName": modelName,"AppName":"PARENT","Authorization": "bearer \(token)","LoginId":idStr]
            
        }
        
    }
}
// 业务回调
public typealias OperationResultHandler<Operation: GraphQLOperation> = (_ result: GraphQLResult<Operation.Data>?, _ error: Error?) -> Void

class StoreManager: NSObject {
    
    static let shared = StoreManager()
    
    var apiurl:String! // 服务器地址 endPoint
    
    // noauth
    private(set) lazy var apollo: ApolloClient = {
        let url = apiurl + "/noauth"
        
        let httpNetworkTransport = HTTPNetworkTransport(url: URL(string: url)!)
        httpNetworkTransport.delegate = self
        
        return ApolloClient(networkTransport: httpNetworkTransport)
    }()
    
    // auth
    private(set) lazy var apolloClientWithToken: ApolloClient = {
        let url = apiurl
        
        let httpNetworkTransport = HTTPNetworkTransport(url: URL(string: url!)!)
        httpNetworkTransport.delegate = self
        
        return ApolloClient(networkTransport: httpNetworkTransport)
    }()
    
    
    // get
    func performFetch<Fetch: GraphQLQuery>(fetch: Fetch,client:ApolloClient,  resultHandler: OperationResultHandler<Fetch>? = nil) {
        
        let cachePolicy: CachePolicy
        cachePolicy = .fetchIgnoringCacheCompletely
        
        client.fetch(query: fetch, cachePolicy: cachePolicy) { result in
            //            print(result)
            
            switch result {
            case .success(let graphQLResult):
                
                if let errors = graphQLResult.errors {
                    let dic = errors[0]
                    let str: String = dic["message"] as! String
                    if str == "Unauthorized" {
                        // RiseSetupController.logout()
                    } else {
                        let err:Error = errors[0]
                        resultHandler!(nil, err)
                    }
                }else{
                    resultHandler!(graphQLResult,nil)
                }
                
                
            case .failure(let error):
                if error is GraphQLHTTPResponseError {
                    let customError = error as! GraphQLHTTPResponseError
                    if customError.response.statusCode == 429 {
                        //  SVProgressHUD.showError(withStatus: "网络错误请重试！code:\(customError.response.statusCode)")
                    } else if customError.response.statusCode == 401 || customError.response.statusCode == 403 {
                        //  RiseSetupController.logout()
                    }
                    else if customError.response.statusCode == -1001 ||  customError.response.statusCode == -1003{
                        //                        SVProgressHUD.showError(withStatus: "请求超时")
                    }
                    //                    resultHandler!(nil,error)
                }
                
            }
            
        }
    }
    
    // post
    func performMutation<Mutation: GraphQLMutation>(mutation: Mutation, queue: DispatchQueue = DispatchQueue.main, client:ApolloClient,  resultHandler: OperationResultHandler<Mutation>? = nil) {
        
        client.perform(mutation: mutation, queue: queue) { result in
            print(result)
            switch result {
            case .success(let graphQLResult):
                
                if let errors = graphQLResult.errors {
                    let dic = errors[0]
                    let str: String = dic["message"] as! String
                    if str == "Unauthorized" {
                        // logout()
                    } else {
                        let err:Error = errors[0]
                        resultHandler!(nil, err)
                    }
                }else{
                    resultHandler!(graphQLResult,nil)
                }
                
                
            case .failure(let error):
                if error is GraphQLHTTPResponseError {
                    let customError = error as! GraphQLHTTPResponseError
                    if customError.response.statusCode == 429 {
                        //  SVProgressHUD.showError(withStatus: "网络错误请重试！code:\(customError.response.statusCode)")
                    } else if customError.response.statusCode == 401 || customError.response.statusCode == 403 {
                        //  logout()
                    }
                    else if customError.response.statusCode == -1001 ||  customError.response.statusCode == -1003{
                        //                        SVProgressHUD.showError(withStatus: "请求超时")
                    }
                    //                   resultHandler!(result)
                }
                
            }
        }
    }
    
    // upload
    func upload<Operation: GraphQLOperation>(client:ApolloClient,
                                             operation: Operation,
                                             files: [GraphQLFile],
                                             resultHandler: GraphQLResultHandler<Operation.Data>? = nil){
        client.upload(operation: operation, files: files, resultHandler: resultHandler)
    }
    
    
}



