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

import Foundation

class RunningStitchPattern: StitchPatternProtocol {
    unowned let stream: EmbroideryStream
    var stitchLen: CGFloat

    init(for embroideryStream: EmbroideryStream,
         at currentPosition: CGPoint,
         with stitchingLength: CGFloat) {

        stream = embroideryStream
        stitchLen = stitchingLength

        stream.add(Stitch(atPosition: currentPosition))
    }

    func spriteDidMove(to pos: CGPoint) {
        guard var lastPos = stream.last?.getPosition() else {
            fatalError("RunningStitch Mode running on empty EmbroideryStream. Should never happen")
        }
        let delta = CGVector(from: lastPos, to: pos)
        let e = delta.normalized()

        let sqLen = (stitchLen * stitchLen)
        while CGPoint.squaredDistance(from: lastPos, to: pos) > sqLen {
            lastPos += e * stitchLen
            stream.add(Stitch(atPosition: lastPos))
        }
        stream.add(Stitch(atPosition: pos))
    }
}
