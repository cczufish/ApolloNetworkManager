# ApolloNetworkManager
a GraphiQL tool for swift language ApolloNetworkManager 

Graphql 

官方文档 ： https://www.apollographql.com/docs/ios/installation.html#adding-build-step

中文文档： http://graphql.cn

线上调试：https://www.graphqlbin.com

请先看官方的文档

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





