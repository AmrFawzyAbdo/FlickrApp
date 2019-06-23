//
//  FlickerTests.swift
//  FlickerTests
//
//  Created by Amr fawzy on 6/22/19.
//  Copyright © 2019 Amr fawzy. All rights reserved.
//

import XCTest
@testable import Flicker

class FlickerTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testFetchingPhotos() {
        let service = PhotosService()
        service.test = true
        let presenter = PhotosPresenter(photosService: service)
        presenter.setText("bmw")
        
        XCTAssertTrue(presenter.getPhotosCount() == 100, "Success in fetching photos")
        XCTAssertTrue(presenter.getPhoto(atIndex: 0).url.absoluteString == "https://farm66.staticflickr.com/65535/48108567203_aa977643aa_m.jpg", "Success in generating photo url from model")
    }
    
    func testFetchingGroups() {
        let service = GroupsService()
        service.test = true
        let presenter = GroupsPresenter(groupsService: service)
        presenter.setText("bmw")
        
        XCTAssertTrue(presenter.getGroupsCount() == 100, "Success in fetching groups")
        let group = presenter.getGroup(atIndex: 0)
        XCTAssertTrue(group.photoUrl.absoluteString == "https://farm4.staticflickr.com/3658/buddyicons/1080011@N20_r.jpg", "Success in generating group photo url from group model")
        XCTAssertTrue(group.members == "Number of members are: 4785", "Success in formatting members count from group model")
        XCTAssertTrue(group.count == "Count: 69475", "Success in formatting count from group model")
        XCTAssertTrue(group.topicCount == "Topic Count: 2", "Success in formatting topic count from group model")
    }

}
