//
//  UImageTest.swift
//  testImage
//
//  Created by longxiang on 2017/4/30.
//  Copyright © 2017年 longxiang. All rights reserved.
//

import XCTest
@testable import testImage
import CoreGraphics
class UImageTest: XCTestCase {
    
    var sut:UIImage!
    override func setUp() {
        super.setUp()
        sut = UIImage.init(named: "test")
    }
    
    func testBeyondMaxLimit() {
        let expectCompressBtyes = 300 * 1024
        let compressTuple       = sut.compress(threadhold: expectCompressBtyes)
       
        guard let _ = compressTuple?.image else {
            XCTAssertNil(nil, "compress error")
            return
        }
        guard let _ = compressTuple?.imageBase64 else {
            XCTAssertNil(nil, "compress error")
            return
        }
        guard let imageData = compressTuple?.imageData else {
            XCTAssertNil(nil, "compress error")
            return
        }
        let isNotCompressSucess = !((imageData.count < expectCompressBtyes) && (imageData.count > expectCompressBtyes - 50 * 1024))
        XCTAssertFalse(isNotCompressSucess,"compress error")
    }
    
    func testBeyondMinLimit() {
        let expectCompressBtyes = 600 * 1024
        let compressTuple       = sut.compress(threadhold: expectCompressBtyes)
        guard let _ = compressTuple?.image else {
            XCTAssertNil(nil, "compress error")
            return
        }
        guard let _ = compressTuple?.imageBase64 else {
            XCTAssertNil(nil, "compress error")
            return
        }
        guard let imageData = compressTuple?.imageData else {
            XCTAssertNil(nil, "compress error")
            return
        }
        let isNotCompressSucess = !(imageData.count > expectCompressBtyes - 50 * 1024)
        XCTAssertFalse(isNotCompressSucess,"compress error")
    }
    
    func testNormalCompress() {
      
    }
}
