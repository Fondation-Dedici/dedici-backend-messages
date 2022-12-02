//
// Copyright (c) 2022 Dediĉi
// SPDX-License-Identifier: AGPL-3.0-only
//

import Foundation
import Vapor

internal enum MessageType: Int, Content {
    case newSession = 0
    case sessionMessage = 1
}
