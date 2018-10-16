//
//  NetWorkTools.swift
//  DouYuLive
//
//  Created by ZXC on 2018/10/11.
//  Copyright © 2018年 ZXC. All rights reserved.
//

import UIKit
import Alamofire

enum RequestType {
    case GET
    case POST
}

class NetWorkTools {
    
    // 创建类方法 在方法前面加上一个class就可以了
    class func requestData(URLString : String, requestType : RequestType, parameters : [String : Any]? = nil, finishCallBack : @escaping (_ requestResult : Any)->()) {
        let httpMethod = requestType == .GET ? HTTPMethod.get : HTTPMethod.post
        
        // 使用Alamofire进行数据请求
        // Alamofire.request(<#T##url: URLConvertible##URLConvertible#>, method: <#T##HTTPMethod#>, parameters: <#T##Parameters?#>, encoding: <#T##ParameterEncoding#>, headers: <#T##HTTPHeaders?#>)

        Alamofire.request(URLString, method: httpMethod, parameters: parameters).responseJSON { (response) in

            // 对数据进行校验
            guard let result = response.result.value else {
                print(response.result.error ?? "")
                return
            }

            // 将数据回调出去
            finishCallBack(result)
        }
        
    }
}
