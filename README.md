# ApolloNetworkManager

a GraphiQL tool for swift language ApolloNetworkManager 

Graphql 

官方文档 ： https://www.apollographql.com/docs/ios/installation.html#adding-build-step

中文文档： http://graphql.cn

线上调试：https://www.graphqlbin.com

请先看官方的文档


安装

pod ‘ApolloNetworkManager’

使用

调用逻辑

```javascript

        ApolloNetworkManager.shared.apiurl = "https://dev.api.xxxxx.com/graphql" // 自己服务器的端点地址
        ApolloNetworkManager.shared.httpHeader = [:] // 自己服务器的httpHeader信息

        /*调用完登录接口再去调用第二个接口*/
        ApolloNetworkManager.shared.performMutation(mutation: UsersMutation.init(username: "13500000000", password: "123456"), client: StoreManager.shared.apollo){ (result,error) in
            if let err = error{
                print(err)
            }else{
                if let data = result?.data?.createUserToken {
                    UserDefaults.standard.set(data.token, forKey: "token")
                    UserDefaults.standard.set(data.token, forKey: "studentid")
                }
            }
        }
        
        
        ApolloNetworkManager.shared.performFetch(fetch: AppSettingQuery(), client: StoreManager.shared.apolloClientWithToken) { (result,error) in
            if let err = error{
                print(err)
            }else{
                if let data = result?.data?.appsetting {
                    print(data.cdnUrl)
                    
                }
            }
        }
        
        
```


写在前面：
项目
项目运行
项目运行不起来
项目运行不起来的
项目运行不起来的，
项目运行不起来的，主要
项目运行不起来的，主要看
项目运行不起来的，主要看逻辑
项目运行不起来的，主要看逻辑，
项目运行不起来的，主要看逻辑，供参考



首先说一下我们项目的大概逻辑，我们这边是有2个端点地址，一个是noauth的，一个是auth的，一开始就有2个scheme.json文件。

所以我这边是设置了2个script分别在2个目录里面的graphql文件生成对应的swift文件

如下2个图所示

项目里面 WechatIMG35.png

```javascript

# Type a script or drag a script file from your workspace to insert its path.

APOLLO_FRAMEWORK_PATH="${SRCROOT}/${TARGET_NAME}/GraphQL/"

if [ -z "$APOLLO_FRAMEWORK_PATH" ]; then
echo "error: Couldn't find Apollo.framework in FRAMEWORK_SEARCH_PATHS; make sure to add the framework to your project."
exit 1
fi

cd "${SRCROOT}/${TARGET_NAME}/GraphQL/login"
"${APOLLO_FRAMEWORK_PATH}"/run-bundled-codegen.sh codegen:generate --target=swift --includes=./**/*.graphql --localSchemaFile="schema.json" API.swift

```

项目里面 WechatIMG36.png

```javascript

# Type a script or drag a script file from your workspace to insert its path.

APOLLO_FRAMEWORK_PATH="${SRCROOT}/${TARGET_NAME}/GraphQL/"

if [ -z "$APOLLO_FRAMEWORK_PATH" ]; then
echo "error: Couldn't find Apollo.framework in FRAMEWORK_SEARCH_PATHS; make sure to add the framework to your project."
exit 1
fi

cd "${SRCROOT}/${TARGET_NAME}/GraphQL/home"
"${APOLLO_FRAMEWORK_PATH}"/run-bundled-codegen.sh codegen:generate --target=swift --includes=./**/*.graphql --localSchemaFile="schema.json" APK.swift


```


![avatar](https://github.com/cczufish/ApolloNetworkManager/blob/master/WechatIMG35.png)

![avatar](https://github.com/cczufish/ApolloNetworkManager/blob/master/WechatIMG36.png)

项目结构 

![avatar](https://github.com/cczufish/ApolloNetworkManager/blob/master/WechatIMG34.png)

```javascript

│   │   ├── home
│   │   │   ├── APK.swift
│   │   │   ├── FetchLessons.graphql
│   │   │   └── schema.json
│   │   ├── login
│   │   │   ├── API.swift
│   │   │   ├── schema.json
│   │   │   └── users.graphql
│   │   └── run-bundled-codegen.sh

```

主要代码

```javascript

import UIKit
import Apollo



extension ApolloNetworkManager: HTTPNetworkTransportPreflightDelegate {
    func networkTransport(_ networkTransport: HTTPNetworkTransport, shouldSend request: URLRequest) -> Bool {
        return true
    }
    
    func networkTransport(_ networkTransport: HTTPNetworkTransport,
                          willSend request: inout URLRequest) {
        
        request.timeoutInterval = 10 // 接口超时时间10s
        
        request.allHTTPHeaderFields = httpHeader
        
    }
}

// 业务回调
public typealias OperationResultHandler<Operation: GraphQLOperation> = (_ result: GraphQLResult<Operation.Data>?, _ error: Error?) -> Void

class ApolloNetworkManager: NSObject {
    
    static let shared = ApolloNetworkManager()
    
    var apiurl:String! // 服务器地址 endPoint
    
    var httpHeader:[String:String] = [:]

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


```




