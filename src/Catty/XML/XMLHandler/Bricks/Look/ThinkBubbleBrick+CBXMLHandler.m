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

#import "ThinkBubbleBrick+CBXMLHandler.h"
#import "CBXMLParserHelper.h"
#import "CBXMLValidator.h"
#import "GDataXMLElement+CustomExtensions.h"
#import "Formula+CBXMLHandler.h"
#import "CBXMLParserContext.h"
#import "CBXMLSerializerContext.h"
#import "CBXMLSerializerHelper.h"
#import "Pocket_Code-Swift.h"

@implementation ThinkBubbleBrick (CBXMLHandler)

+ (instancetype)parseFromElement:(GDataXMLElement*)xmlElement withContext:(CBXMLParserContext*)context
{
    if([context isGreaterThanLanguageVersion:0.996]) {
        [CBXMLParserHelper validateXMLElement:xmlElement forNumberOfChildNodes:1];
    } else {
        [CBXMLParserHelper validateXMLElement:xmlElement forNumberOfChildNodes:2];
        [XMLError exceptionIfNil:[xmlElement childWithElementName:@"type"] message:@"Parsed type-attribute is invalid or empty!"];
    }
    
    Formula *formula = [CBXMLParserHelper formulaInXMLElement:xmlElement forCategoryName:@"STRING" withContext:context];
    ThinkBubbleBrick *thinkBrick = [self new];
    thinkBrick.formula = formula;
    
    return thinkBrick;
}

- (GDataXMLElement*)xmlElementWithContext:(CBXMLSerializerContext*)context
{
    GDataXMLElement *brick = [super xmlElementForBrickType:@"ThinkBubbleBrick" withContext:context];
    GDataXMLElement *formulaList = [GDataXMLElement elementWithName:@"formulaList" context:context];
    GDataXMLElement *formula = [self.formula xmlElementWithContext:context];
    [formula addAttribute:[GDataXMLElement attributeWithName:@"category" escapedStringValue:@"STRING"]];
    [formulaList addChild:formula context:context];
    [brick addChild:formulaList context:context];;
    
    return brick;
}

@end
