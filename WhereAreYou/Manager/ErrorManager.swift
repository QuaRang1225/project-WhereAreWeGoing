//
//  ErrorManager.swift
//  WhereAreYou
//
//  Created by 유영웅 on 1/23/24.
//

import Foundation
import Firebase


class ErrorManager{
    static func getErrorMessage(error:NSError) -> String{
        switch error.code {
        case AuthErrorCode.weakPassword.rawValue:
            return "비밀번호는 최소 6글자 이상이어야 합니다."
        case AuthErrorCode.userNotFound.rawValue,AuthErrorCode.wrongPassword.rawValue:
            return "이메일 혹은 비밀번호가 일치하지 않습니다."
        case AuthErrorCode.emailAlreadyInUse.rawValue:
            return "이미 사용 중인 이메일입니다."
        case AuthErrorCode.webNetworkRequestFailed.rawValue:
            return "네트워크 연결에 실패 하였습니다."
        case AuthErrorCode.wrongPassword.rawValue:
            return "비밀번호가 일치하지 않습니다!"
        case AuthErrorCode.internalError.rawValue:
            return "잘못된 요청입니다."
        default:
            print(error)
            return "로그인에 실패했습니다."
        }
    }
}
