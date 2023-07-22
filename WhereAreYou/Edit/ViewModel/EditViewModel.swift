//
//  EditViewModel.swift
//  WhereAreYou
//
//  Created by 유영웅 on 2023/07/22.
//

import Foundation
import PhotosUI
import SwiftUI

@MainActor
class EditViewModel:ObservableObject{
    @Published var data:Data? = nil
    @Published var selection:PhotosPickerItem? = nil
}


struct Page:Codable{
    
}
