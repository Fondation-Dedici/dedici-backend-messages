//
// Copyright (c) 2022 Dediĉi
// SPDX-License-Identifier: AGPL-3.0-only
//

import Foundation
import DediciVaporFluentToolbox
import Vapor

internal struct MessageListDelete: ResourceDeleteListRequestBody {
    typealias Resource = Message
    typealias Element = UUID

    var items: [Element]
}
