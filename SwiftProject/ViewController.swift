


//
//  ViewController.swift
//  TestingWhiteBoard
//
//  Created by yu shuhui on 2020/2/18.
//  Copyright © 2020 yu shuhui. All rights reserved.
//

import UIKit
import Apollo

class ViewController: UIViewController {
    
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ApolloNetworkManager.shared.apiurl = "https://dev.api.xxxxx.com/graphql" // 自己服务器的端点地址
        
        /*调用完登录接口再去调用第二个接口*/
        ApolloNetworkManager.shared.performMutation(mutation: UsersMutation.init(username: "13500000000", password: "123456"), client: ApolloNetworkManager.shared.apollo){ (result,error) in
            if let err = error{
                print(err)
            }else{
                if let data = result?.data?.createUserToken {
                    UserDefaults.standard.set(data.token, forKey: "token")
                    UserDefaults.standard.set(data.token, forKey: "studentid")
                }
            }
        }
        
        
        ApolloNetworkManager.shared.performFetch(fetch: AppSettingQuery(), client: ApolloNetworkManager.shared.apolloClientWithToken) { (result,error) in
            if let err = error{
                print(err)
            }else{
                if let data = result?.data?.appsetting {
                    print(data.cdnUrl)
                    
                }
            }
        }
        
    }
        
}




