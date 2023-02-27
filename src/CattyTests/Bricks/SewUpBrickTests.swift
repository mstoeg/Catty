/**
 *  Copyright (C) 2010-2023 The Catrobat Team
 *  (http://developer.catrobat.org/credits)
 *
 *  This program is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU Affero General Public License as
 *  published by the Free Software Foundation, either version 3 of the
 *  License, or (at your option) any later version.
 *
 *  An additional term exception under section 7 of the GNU Affero
 *  General Public License, version 3, is available at
 *  (http://developer.catrobat.org/license_additional_term)
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 *  GNU Affero General Public License for more details.
 *
 *  You should have received a copy of the GNU Affero General Public License
 *  along with this program.  If not, see http://www.gnu.org/licenses/.
 */

import XCTest

@testable import Pocket_Code

final class SewUpBrickTests: XCTestCase {

    func testSewUpBrickRight() {
        let referenceStream = EmbroideryStream(fromArray: [
            Stitch(x: EmbroideryDefines.sewUpSteps, y: 0),
            Stitch(x: 0, y: 0),
            Stitch(x: -EmbroideryDefines.sewUpSteps, y: 0),
            Stitch(x: 0, y: 0)
        ])

        let object = SpriteObject()
        let scene = Scene(name: "sew up brick test scene")
        object.scene = scene

        let spriteNode = CBSpriteNode(spriteObject: object)
        object.spriteNode = spriteNode
        spriteNode.position = CGPoint(x: 0, y: 0)
        spriteNode.catrobatRotation = 90

        let script = Script()
        script.object = object

        let brick = SewUpBrick()
        brick.script = script

        let action = brick.actionBlock()
        XCTAssertEqual(spriteNode.embroideryStream.count, 0)

        action()
        XCTAssertEqual(spriteNode.embroideryStream.count, referenceStream.count)
        for i in 0..<referenceStream.count {
            XCTAssertEqual(spriteNode.embroideryStream[i].embroideryDimensions(),
                           referenceStream[i].embroideryDimensions())
        }
    }

    func testSewUpBrickUp() {
        let referenceStream = EmbroideryStream(fromArray: [
            Stitch(x: 0, y: EmbroideryDefines.sewUpSteps),
            Stitch(x: 0, y: 0),
            Stitch(x: 0, y: -EmbroideryDefines.sewUpSteps),
            Stitch(x: 0, y: 0)
        ])

        let object = SpriteObject()
        let scene = Scene(name: "sew up brick test scene")
        object.scene = scene

        let spriteNode = CBSpriteNode(spriteObject: object)
        object.spriteNode = spriteNode
        spriteNode.position = CGPoint(x: 0, y: 0)
        spriteNode.catrobatRotation = 0

        let script = Script()
        script.object = object

        let brick = SewUpBrick()
        brick.script = script

        let action = brick.actionBlock()
        XCTAssertEqual(spriteNode.embroideryStream.count, 0)

        action()
        XCTAssertEqual(spriteNode.embroideryStream.count, referenceStream.count)
        for i in 0..<referenceStream.count {
            XCTAssertEqual(spriteNode.embroideryStream[i].embroideryDimensions(),
                           referenceStream[i].embroideryDimensions())
        }
    }

    func testSewUpBrickLeft() {
        let referenceStream = EmbroideryStream(fromArray: [
            Stitch(x: -EmbroideryDefines.sewUpSteps, y: 0),
            Stitch(x: 0, y: 0),
            Stitch(x: EmbroideryDefines.sewUpSteps, y: 0),
            Stitch(x: 0, y: 0)
        ])

        let object = SpriteObject()
        let scene = Scene(name: "sew up brick test scene")
        object.scene = scene

        let spriteNode = CBSpriteNode(spriteObject: object)
        object.spriteNode = spriteNode
        spriteNode.position = CGPoint(x: 0, y: 0)
        spriteNode.catrobatRotation = -90

        let script = Script()
        script.object = object

        let brick = SewUpBrick()
        brick.script = script

        let action = brick.actionBlock()
        XCTAssertEqual(spriteNode.embroideryStream.count, 0)

        action()
        XCTAssertEqual(spriteNode.embroideryStream.count, referenceStream.count)
        for i in 0..<referenceStream.count {
            XCTAssertEqual(spriteNode.embroideryStream[i].embroideryDimensions(),
                           referenceStream[i].embroideryDimensions())
        }
    }

    func testSewUpBrickDown() {
        let referenceStream = EmbroideryStream(fromArray: [
            Stitch(x: 0, y: -EmbroideryDefines.sewUpSteps),
            Stitch(x: 0, y: 0),
            Stitch(x: 0, y: EmbroideryDefines.sewUpSteps),
            Stitch(x: 0, y: 0)
        ])

        let object = SpriteObject()
        let scene = Scene(name: "sew up brick test scene")
        object.scene = scene

        let spriteNode = CBSpriteNode(spriteObject: object)
        object.spriteNode = spriteNode
        spriteNode.position = CGPoint(x: 0, y: 0)
        spriteNode.catrobatRotation = 180

        let script = Script()
        script.object = object

        let brick = SewUpBrick()
        brick.script = script

        let action = brick.actionBlock()
        XCTAssertEqual(spriteNode.embroideryStream.count, 0)

        action()
        XCTAssertEqual(spriteNode.embroideryStream.count, referenceStream.count)
        for i in 0..<referenceStream.count {
            XCTAssertEqual(spriteNode.embroideryStream[i].embroideryDimensions(),
                           referenceStream[i].embroideryDimensions())
        }
    }

}
