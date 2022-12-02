//
// Copyright (c) 2022 Dediĉi
// SPDX-License-Identifier: AGPL-3.0-only
//

import Foundation
import DediciVaporFluentToolbox
import DediciVaporToolbox
import Vapor

internal struct MessageListNew: ResourceCreateListRequestBody {
    typealias Item = MessageNew
    typealias Resource = Message
    typealias Element = Item

    var items: [MessageNew]
}
