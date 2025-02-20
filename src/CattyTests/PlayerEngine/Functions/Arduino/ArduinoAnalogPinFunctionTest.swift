/**
 *  Copyright (C) 2010-2022 The Catrobat Team
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

class ArduinoAnalogPinFunctionTest: XCTestCase {

    var function: ArduinoAnalogPinFunction!
    var bluetoothService: BluetoothService!

    override func setUp() {
        super.setUp()
        bluetoothService = BluetoothService.sharedInstance()
        function = ArduinoAnalogPinFunction { [ weak self ] in self?.bluetoothService }
    }

    override func tearDown() {
        bluetoothService = nil
        function = nil
        super.tearDown()
    }

    func testDefaultValue() {
        XCTAssertEqual(type(of: function).defaultValue, function.value(parameter: "invalidParameter" as AnyObject), accuracy: Double.epsilon)
        XCTAssertEqual(type(of: function).defaultValue, function.value(parameter: 110 as AnyObject), accuracy: Double.epsilon)
        XCTAssertEqual(type(of: function).defaultValue, function.value(parameter: 0.5 as AnyObject), accuracy: Double.epsilon)
    }

    func testValue() {
        // TODO: add tests
    }

    func testParameter() {
        XCTAssertEqual(.number(defaultValue: 0), function.firstParameter())
    }

    func testTag() {
        XCTAssertEqual("analogPin", type(of: function).tag)
    }

    func testName() {
        XCTAssertEqual(kUIFESensorArduinoAnalog, type(of: function).name)
    }

    func testRequiredResources() {
        XCTAssertEqual(ResourceType.bluetoothArduino, type(of: function).requiredResource)
    }

    func testIsIdempotent() {
        XCTAssertFalse(type(of: function).isIdempotent)
    }

    func testFormulaEditorSections() {
        UserDefaults.standard.set(true, forKey: kUseArduinoBricks)

        let sections = function.formulaEditorSections()
        XCTAssertEqual(1, sections.count)
        XCTAssertEqual(.sensors(position: type(of: function).position, subsection: .arduino), sections.first)

        UserDefaults.standard.set(false, forKey: kUseArduinoBricks)
        XCTAssertEqual(0, function.formulaEditorSections().count)
    }
}
