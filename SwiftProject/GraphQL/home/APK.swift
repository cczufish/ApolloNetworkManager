// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

public final class AppSettingQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query AppSetting {
      appsetting {
        __typename
        cdn_url
        library_cdn_url
        micro_api_url
        web_domain
        ucloud_bucket
      }
    }
    """

  public let operationName: String = "AppSetting"

  public init() {
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("appsetting", type: .object(Appsetting.selections)),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(appsetting: Appsetting? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "appsetting": appsetting.flatMap { (value: Appsetting) -> ResultMap in value.resultMap }])
    }

    /// 应用初始化
    public var appsetting: Appsetting? {
      get {
        return (resultMap["appsetting"] as? ResultMap).flatMap { Appsetting(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "appsetting")
      }
    }

    public struct Appsetting: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["AppSetting"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("cdn_url", type: .scalar(String.self)),
        GraphQLField("library_cdn_url", type: .scalar(String.self)),
        GraphQLField("micro_api_url", type: .scalar(String.self)),
        GraphQLField("web_domain", type: .scalar(String.self)),
        GraphQLField("ucloud_bucket", type: .scalar(String.self)),
      ]

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(cdnUrl: String? = nil, libraryCdnUrl: String? = nil, microApiUrl: String? = nil, webDomain: String? = nil, ucloudBucket: String? = nil) {
        self.init(unsafeResultMap: ["__typename": "AppSetting", "cdn_url": cdnUrl, "library_cdn_url": libraryCdnUrl, "micro_api_url": microApiUrl, "web_domain": webDomain, "ucloud_bucket": ucloudBucket])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      /// CDN前缀
      public var cdnUrl: String? {
        get {
          return resultMap["cdn_url"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "cdn_url")
        }
      }

      /// 图书馆资源CDN域名
      public var libraryCdnUrl: String? {
        get {
          return resultMap["library_cdn_url"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "library_cdn_url")
        }
      }

      /// 微服务网关API域名
      public var microApiUrl: String? {
        get {
          return resultMap["micro_api_url"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "micro_api_url")
        }
      }

      /// Web域名
      public var webDomain: String? {
        get {
          return resultMap["web_domain"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "web_domain")
        }
      }

      /// Ucloud Bucket
      public var ucloudBucket: String? {
        get {
          return resultMap["ucloud_bucket"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "ucloud_bucket")
        }
      }
    }
  }
}
