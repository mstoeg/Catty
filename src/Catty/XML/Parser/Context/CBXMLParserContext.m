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

#import "CBXMLParserContext.h"
#import "GDataXMLElement+CustomExtensions.h"
#import "CBXMLNodeProtocol.h"
#import "Util.h"
#import "Pocket_Code-Swift.h"

@implementation CBXMLParserContext

#pragma mark - Initialisation
- (instancetype)initWithLanguageVersion:(CGFloat)languageVersion andRootElement:(GDataXMLElement *)rootElement
{
    self = [super init];
    if (self) {
        _languageVersion = languageVersion;
        _rootElement = rootElement;
    }
    return self;
}

#pragma mark - CatrobatLanguageVersion check
- (id)parseFromElement:(GDataXMLElement*)xmlElement withClass:(Class<CBXMLNodeProtocol>)modelClass
{
    if (self.languageVersion >= 0.93f && self.languageVersion <= [[Util catrobatLanguageVersion] floatValue]) {
        return [modelClass parseFromElement:xmlElement withContext:self];
    } else {
        NSError(@"Unsupported CatrobatLanguageVersion %g", self.languageVersion);
    }
    return nil;
}

- (bool)isEqualToLanguageVersion:(CGFloat)languageVersion
{
    if (round(self.languageVersion * 10000) == round(languageVersion * 10000)) {
        return YES;
    } else {
        return NO;
    }
}

- (bool)isGreaterThanOrEqualToLanguageVersion:(CGFloat)languageVersion
{
    if (round(self.languageVersion * 10000) >= round(languageVersion * 10000)) {
        return YES;
    } else {
        return NO;
    }
}

- (bool)isGreaterThanLanguageVersion:(CGFloat)languageVersion
{
    if (round(self.languageVersion * 10000) > round(languageVersion * 10000)) {
        return YES;
    } else {
        return NO;
    }
}

- (bool)isSmallerThanOrEqualToLanguageVersion:(CGFloat)languageVersion
{
    if (round(self.languageVersion * 10000) <= round(languageVersion * 10000)) {
        return YES;
    } else {
        return NO;
    }
}

- (bool)isSmallerThanLanguageVersion:(CGFloat)languageVersion
{
    if (round(self.languageVersion * 10000) < round(languageVersion * 10000)) {
        return YES;
    } else {
        return NO;
    }
}

#pragma mark - Getters and Setters
- (NSMutableArray*)programVariableList
{
    if (! _programVariableList) {
        _programVariableList = [NSMutableArray array];
    }
    return _programVariableList;
}

- (NSMutableArray*)programListOfLists
{
    if (! _programListOfLists) {
        _programListOfLists = [NSMutableArray array];
    }
    return _programListOfLists;
}

- (NSMutableSet<NSString*>*)unsupportedElements
{
    if (! _unsupportedElements) {
        _unsupportedElements = [[NSMutableSet alloc] init];
    }
    return _unsupportedElements;
}

- (NSMutableSet<NSString*>*)physicsObjectNames
{
    if (! _physicsObjectNames) {
        _physicsObjectNames = [[NSMutableSet alloc] init];
    }
    return _physicsObjectNames;
}


- (void)setLanguageVersion:(CGFloat)languageVersion
{
    _languageVersion = languageVersion;
}

#pragma mark - Copy
- (id)mutableCopy
{
    CBXMLParserContext *copiedContext = [super mutableCopy];
    copiedContext.programVariableList = [self.programVariableList mutableCopy];
    copiedContext.programListOfLists = [self.programListOfLists mutableCopy];
    [copiedContext setLanguageVersion:self.languageVersion];
    copiedContext.rootElement = self.rootElement;
    copiedContext.currentSceneElement = self.currentSceneElement;
    return copiedContext;
}

@end
