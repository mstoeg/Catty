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

extension StartZigzagStitchBrick: CBXMLNodeProtocol {

    static func parse(from xmlElement: GDataXMLElement, with context: CBXMLParserContext) -> Self {
        CBXMLParserHelper.validate(xmlElement, forNumberOfChildNodes: 1, andFormulaListWithTotalNumberOfFormulas: 2)
        let lengthFormula = CBXMLParserHelper.formula(in: xmlElement, forCategoryName: "LENGTH", with: context)
        let widthFormula = CBXMLParserHelper.formula(in: xmlElement, forCategoryName: "WIDTH", with: context)
        let brick = self.init()
        brick.length = lengthFormula
        brick.width = widthFormula

        return brick
    }

    func xmlElement(with context: CBXMLSerializerContext) -> GDataXMLElement? {
        let brick = super.xmlElement(for: "StartZigzagStitchBrick", with: context)
        let formulaList = GDataXMLElement(name: "formulaList", context: context)

        let lengthFormula = self.length?.xmlElement(with: context)
        lengthFormula?.addAttribute(GDataXMLElement(name: "category", stringValue: "LENGTH", context: nil))
        formulaList?.addChild(lengthFormula, context: context)

        let widthFormula = self.width?.xmlElement(with: context)
        widthFormula?.addAttribute(GDataXMLElement(name: "category", stringValue: "WIDTH", context: nil))
        formulaList?.addChild(widthFormula, context: context)

        brick?.addChild(formulaList, context: context)
        return brick
    }
}
