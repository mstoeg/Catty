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
#import "Brick.h"
#import "Script.h"
#import "BrickManager.h"
#import "IfLogicBeginBrick.h"
#import "LoopBeginBrick.h"
#import "BroadcastScript.h"
#import "CBMutableCopyContext.h"
#import "Util.h"

@implementation Brick

- (NSString*)brickTitle
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must implement %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

- (BOOL)isSelectableForObject
{
    return YES;
}

- (BOOL)isAnimateable
{
    return NO;
}

- (BOOL)isFormulaBrick
{
    return ([self conformsToProtocol:@protocol(BrickFormulaProtocol)]);
}

- (BOOL)isIfLogicBrick
{
    return NO;
}

- (BOOL)isLoopBrick
{
    return NO;
}

- (BOOL)isBluetoothBrick
{
    return NO;
}

- (BOOL)isPhiroBrick
{
    return NO;
}

- (BOOL)isArduinoBrick
{
    return NO;
}

- (BOOL)isDisabledForBackground
{
    return NO;
}

- (NSString*)description
{
    return @"Brick (NO SPECIFIC DESCRIPTION GIVEN! OVERRIDE THE DESCRIPTION METHOD!";
}

- (void)performFromScript:(Script*)script
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

- (BOOL)isEqualToBrick:(Brick*)brick
{
    if([self class] != [brick class])
        return NO;

    NSArray *firstPropertyList = [[Util propertiesOfInstance:self] allValues];
    NSArray *secondPropertyList = [[Util propertiesOfInstance:brick] allValues];
    
    if([firstPropertyList count] != [secondPropertyList count])
        return NO;
    
    NSUInteger index;
    for(index = 0; index < [firstPropertyList count]; index++) {
        NSObject *firstObject = [firstPropertyList objectAtIndex:index];
        NSObject *secondObject = [secondPropertyList objectAtIndex:index];
        
        // prevent recursion (e.g. Script->Brick->Script->Brick...)
        if([firstObject isKindOfClass:[Script class]] && [secondObject isKindOfClass:[Script class]])
            continue;
    
        if(![Util isEqual:firstObject toObject:secondObject])
            return NO;
    }
    
    return YES;
}

- (void)setDefaultValuesForObject:(SpriteObject*)spriteObject
{
    // Override this method in Brick implementation
}

#pragma mark - Copy
// This function must be overriden by Bricks with references to other Bricks (e.g. ForeverBrick)
- (id)mutableCopyWithContext:(CBMutableCopyContext*)context
{
    return [self mutableCopyWithContext:context AndErrorReporting:YES];
}

- (id)mutableCopyWithContext:(CBMutableCopyContext*)context AndErrorReporting:(BOOL)reportError
{
    if (! context) NSError(@"%@ must not be nil!", [CBMutableCopyContext class]);
    Brick *brick = [[self class] new];
    [context updateReference:self WithReference:brick];

    NSDictionary *properties = [Util propertiesOfInstance:self];
    for (NSString *propertyKey in properties) {
        id propertyValue = [properties objectForKey:propertyKey];
        Class propertyClazz = [propertyValue class];        
        if ([propertyValue conformsToProtocol:@protocol(CBMutableCopying)]) {
            id updatedReference = [context updatedReferenceForReference:propertyValue];
            if (updatedReference) {
                [brick setValue:updatedReference forKey:propertyKey];
            } else {
                id propertyValueClone = [propertyValue mutableCopyWithContext:context];
                [brick setValue:propertyValueClone forKey:propertyKey];
            }
        } else if ([propertyValue conformsToProtocol:@protocol(NSMutableCopying)]) {
            // standard datatypes like NSString are already conforming to the NSMutableCopying protocol
            id propertyValueClone = [propertyValue mutableCopyWithZone:nil];
            [brick setValue:propertyValueClone forKey:propertyKey];
        } else if (propertyClazz == [@(YES) class]) {
            // 64-bit bool -> typedef bool BOOL
            [brick setValue:propertyValue forKey:propertyKey];
        } else if (propertyClazz == [@(1) class]) {
            // 32-bit bool -> typedef signed char BOOL
            [brick setValue:propertyValue forKey:propertyKey];
        } else if (reportError) {
            NSError(@"Property %@ of class %@ in Brick of class %@ does not conform to CBMutableCopying protocol. Implement mutableCopyWithContext method in %@", propertyKey, [propertyValue class], [self class], [self class]);
        }
    }
    return brick;
}

- (void)removeFromScript
{
    NSUInteger index = 0;
    for (Brick *brick in self.script.brickList) {
        if (brick == self) {
            [self.script.brickList removeObjectAtIndex:index];
            break;
        }
        ++index;
    }
}

- (void)removeReferences
{
    self.script = nil;
}

- (NSInteger)getRequiredResources
{
    //OVERRIDE IN EVERY BRICK
    NSInteger resources = kNoResources;

    return resources;
}

- (Class<BrickCellProtocol>)brickCell
{
    NSString *brickName = NSStringFromClass([self class]);
    return NSClassFromString([brickName stringByAppendingString:@"Cell"]);
}

@end
