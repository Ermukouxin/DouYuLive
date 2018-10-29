//
//  RecommendViewModel.swift
//  DouYuLive
//
//  Created by ZXC on 2018/10/11.
//  Copyright © 2018年 ZXC. All rights reserved.
//

import UIKit

class RecommendViewModel {
    // MARK: - 懒加载属性
    lazy var anchorGroupModelArray : [AnchorGroupModel] = [AnchorGroupModel]()
    lazy var cycleModelArray : [CycleModel] = [CycleModel]()
    private lazy var prettyGroupModel : AnchorGroupModel = AnchorGroupModel()
    private lazy var recommendGroupModel : AnchorGroupModel = AnchorGroupModel()
}

// MARK: - 发送网络请求
extension RecommendViewModel {
    
    // reason: '-[__NSCFNumber length]: unrecognized selector sent to instance 0xb000000001e00323'
    //    var room_id : Int = 0
    //    var room_id : String = ""
    // 请求回来的数据，看控制台输出的是什么类型，就定义为什么类型
    // 开始的时候讲room_id定义成为了String类型，结果在转模型的时候，崩溃了，报以上的reason

    func requestData(finishCallBack : @escaping ()->()) {
        let parameters : [String : String] = ["limit" : "4", "offset" : "0", "time" : NSDate.getCurrentTime()]
        
        //0, 创建队列group
        let dispathGroup = DispatchGroup()
        
        
        //1, 请求推荐数据
        //  http://capi.douyucdn.cn/api/v1/getbigDataRoom?time=1539333778
        dispathGroup.enter()
        NetWorkTools.requestData(URLString: "http://capi.douyucdn.cn/api/v1/getbigDataRoom", requestType: .GET, parameters: ["time" : NSDate.getCurrentTime()]) { (result) in
            // 1,Any转字典
            guard let resultDict = result as? [String : Any] else { return }
            // 2,取出字典数组
            guard let resultArray = resultDict["data"] as? [[String : Any]] else { return }
            // 3,给AnchorGroupModel对象赋值
            self.recommendGroupModel.tag_name = "热门"
            self.recommendGroupModel.icon_url = "home_header_hot"
            
            for dict in resultArray {
                self.recommendGroupModel.anchorListModelArray.append(AnchorModel(dict: dict))
            }
            /* 转模型数据打印
             for model in hotGroupModel.anchorListModelArray {
             print("++++\(model.nickname)")
             }
             */

            dispathGroup.leave()
        }
        
        //2, 请求颜值数据
        // http://capi.douyucdn.cn/api/v1/getVerticalRoom?limt=4&offset=0&time=1539333376
        dispathGroup.enter()
        NetWorkTools.requestData(URLString: "http://capi.douyucdn.cn/api/v1/getVerticalRoom", requestType: .GET, parameters: parameters) { (result) in
            // 1,转成字典
            guard let resultDict = result as? [String : Any] else { return }
            // 2,取出对应的字典数组
            guard let resultArray = resultDict["data"] as? [[String : Any]] else { return }
            
            // 3,转成AnchorModel模型
            // 颜值模型属于一个图书的分组模型，所以只需要创建一个分组模型对象，就可以保存完一个颜值直播的所有数据了
            /*
             let prettyGroupModel = AnchorGroupModel()
             prettyGroupModel.tag_name = "颜值"
             prettyGroupModel.icon_url = "home_header_phone"
             */
            self.prettyGroupModel.tag_name = "颜值"
            self.prettyGroupModel.icon_url = "home_header_phone"
            
            for dict in resultArray {
            self.prettyGroupModel.anchorListModelArray.append(AnchorModel(dict: dict))
            }
            /* 打印测试转模型数据
             for model in anchorGroupModel.AnchorListModelArray {
             print("+++++++\(model.nickname)")
             }
             */
            dispathGroup.leave()
        }
        
        //3, 请求游戏数据
        //   http://capi.douyucdn.cn/api/v1/getHotCate?limt=4&offset=0&time=1539310932
        dispathGroup.enter()
        NetWorkTools.requestData(URLString: "http://capi.douyucdn.cn/api/v1/getHotCate", requestType: .GET, parameters: parameters ) { (result) in
            
            //1,将result转成字典
            guard let resultDict = result as? [String : Any] else { return }
            
            //2,取出字典中的数组
            guard let resultArray = resultDict["data"] as? [[String : Any]] else { return }
            
            //3,遍历数组，取出字典，进行转模型操作
            for dict in resultArray {
                let anchorGroupModel : AnchorGroupModel = AnchorGroupModel(dict: dict)
                self.anchorGroupModelArray.append(anchorGroupModel)
            }
            
            /* 打印转模型数据
             for groups in self.anchorGroupModelArray {
             for model in groups.AnchorListModelArray {
             print(model.nickname)
             }
             }
             */
            dispathGroup.leave()
        }
        
        // 所有的数据请求完成之后，对数据进行排序，添加到数组里面
        // dispathGroup.notify(queue: <#T##DispatchQueue#>, execute: <#T##() -> Void#>)
        dispathGroup.notify(queue: DispatchQueue.main) {
            self.anchorGroupModelArray.insert(self.prettyGroupModel, at: 0)
            self.anchorGroupModelArray.insert(self.recommendGroupModel, at: 0)
            
            // 触发时间，告诉外面数据请求完了，回调出去
            finishCallBack()
        }
    }
    
    // 请求轮播图数据
    // http://www.douyutv.com/api/v1/slide/6?version=2.300
    func retquetCycleData(finishCallBack : @escaping ()->()) {
        NetWorkTools.requestData(URLString: "http://www.douyutv.com/api/v1/slide/6", requestType: .GET, parameters: ["version" : "2.300"]) { (result) in
            guard let resutDict = result as? [String : Any] else { return }
            guard let resultArray = resutDict["data"] as? [[String : Any]] else { return }
            
            for dict in resultArray {
                 self.cycleModelArray.append(CycleModel(dict: dict))
            }
            finishCallBack()
        }
    }

}
