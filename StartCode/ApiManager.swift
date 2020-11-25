//
//  ApiManager.swift
//  StartCode
//
//  Created by 김학철 on 2020/11/23.
//

import UIKit

class ApiManager: NSObject {
    static let shared = ApiManager()

    ///휴대폰 인증코드 요청
    func requestPhoneAuthCode(param:[String:Any], success:ResSuccess?, failure:ResFailure?) {
        NetworkManager.shared.request(.post, "/phone/authcode", param) { (response) in
            success?(response)
        } failure: { (error) in
            failure?(error)
        }
    }
    ///휴대폰 인증체크
    func requestPhoneAuthCheck(param:[String:Any], success:ResSuccess?, failure:ResFailure?) {
        NetworkManager.shared.request(.post, "/phone/authcheck", param) { (response) in
            success?(response)
        } failure: { (error) in
            failure?(error)
        }
    }
    ///회원 아이디 체크
    func requestMemberIdCheck(param:[String:Any], success:ResSuccess?, failure:ResFailure?) {
        NetworkManager.shared.request(.post, "/sign/idcheck", param) { (response) in
            success?(response)
        } failure: { (error) in
            failure?(error)
        }
    }
    ///회원 닉네임 체크
    func requestMemberNickNameCheck(param:[String:Any], success:ResSuccess?, failure:ResFailure?) {
        NetworkManager.shared.request(.post, "/sign/nickcheck", param) { (response) in
            success?(response)
        } failure: { (error) in
            failure?(error)
        }
    }
    ///회원 가입
    func requestMemberSignUp(param:[String:Any], success:ResSuccess?, failure:ResFailure?) {
        NetworkManager.shared.request(.post, "/sign/up", param) { (response) in
            success?(response)
        } failure: { (error) in
            failure?(error)
        }
    }
    ///회원 로그인
    func requestMemberSignIn(param:[String:Any], success:ResSuccess?, failure:ResFailure?) {
        NetworkManager.shared.request(.post, "/sign/in", param) { (response) in
            success?(response)
        } failure: { (error) in
            failure?(error)
        }
    }
    ///회원 토큰갱싱
    func requestUpdateToken(param:[String:Any], success:ResSuccess?, failure:ResFailure?) {
        NetworkManager.shared.request(.post, "/sign/updatatoken", param) { (response) in
            success?(response)
        } failure: { (error) in
            failure?(error)
        }
    }
    ///휴대폰, 비빌번호 인증코드 요청(회원로그인 된 상태)map_type:2 휴대폰 인증, 3: 비밀번호 인증
    func requestPhoneReAuthCode(param:[String:Any], success:ResSuccess?, failure:ResFailure?) {
        NetworkManager.shared.request(.post, "/phone/reqcode", param) { (response) in
            success?(response)
        } failure: { (error) in
            failure?(error)
        }
    }
    ///아이디, 비밀번호 찾기, type: id, pass
    func requestFindIdOrPassword(param:[String:Any], success:ResSuccess?, failure:ResFailure?) {
        NetworkManager.shared.request(.post, "/sign/findidbypass", param) { (response) in
            success?(response)
        } failure: { (error) in
            failure?(error)
        }
    }
    ///공지사항_리스트
    func requestNoticeList(param:[String:Any], success:ResSuccess?, failure:ResFailure?) {
        NetworkManager.shared.request(.post, "/notice/list", param) { (response) in
            success?(response)
        } failure: { (error) in
            failure?(error)
        }
    }
    /// 공지사항_상세
    /// - parameter: akey:String, post_id:Int
    func requestNoticeDetail(param:[String:Any], success:ResSuccess?, failure:ResFailure?) {
        NetworkManager.shared.request(.post, "/notice/detail", param) { (response) in
            success?(response)
        } failure: { (error) in
            failure?(error)
        }
    }
    /// 이벤트_리스트
    func requestEventList(param:[String:Any], success:ResSuccess?, failure:ResFailure?) {
        NetworkManager.shared.request(.post, "/event/list", param) { (response) in
            success?(response)
        } failure: { (error) in
            failure?(error)
        }
    }
    /// 이벤트_상세
    func requestEventDetail(param:[String:Any], success:ResSuccess?, failure:ResFailure?) {
        NetworkManager.shared.request(.post, "/event/detail", param) { (response) in
            success?(response)
        } failure: { (error) in
            failure?(error)
        }
    }
    /// 고객센터_리스트
    func requestContactUsList(param:[String:Any], success:ResSuccess?, failure:ResFailure?) {
        NetworkManager.shared.request(.post, "/advice/list", param) { (response) in
            success?(response)
        } failure: { (error) in
            failure?(error)
        }
    }
    /// 고객센터_상세
    /// - parameter: token, post_id
    func requestContactUsDetail(param:[String:Any], success:ResSuccess?, failure:ResFailure?) {
        NetworkManager.shared.request(.post, "/advice/detail", param) { (response) in
            success?(response)
        } failure: { (error) in
            failure?(error)
        }
    }
    /// 고객센터_작성
    /// - parameter: token, post_title, post_content
    func requestContactUsWrite(param:[String:Any], success:ResSuccess?, failure:ResFailure?) {
        NetworkManager.shared.request(.post, "/advice/write", param) { (response) in
            success?(response)
        } failure: { (error) in
            failure?(error)
        }
    }
    ///커뮤니티 리스트
    /// - parameter: token, page, per_page, findex:desc, category_id:optional, skeyword:optional
    func requestTalkList(param:[String:Any], success:ResSuccess?, failure:ResFailure?) {
        NetworkManager.shared.request(.post, "/community/list", param) { (response) in
            success?(response)
        } failure: { (error) in
            failure?(error)
        }
    }
    ///커뮤니티 상세
    /// - parameter: token, post_id
    func requestTalkDetail(param:[String:Any], success:ResSuccess?, failure:ResFailure?) {
        NetworkManager.shared.request(.post, "/community/detail", param) { (response) in
            success?(response)
        } failure: { (error) in
            failure?(error)
        }
    }
    ///커뮤니티 작성
    /// - parameter: token, post_title: "화장법", post_content:"", post_category:"연애인", post_file:Image,
    func requestTalkWrite(param:[String:Any], success:ResSuccess?, failure:ResFailure?) {
        NetworkManager.shared.request(.post, "/community/write", param) { (response) in
            success?(response)
        } failure: { (error) in
            failure?(error)
        }
    }
    ///커뮤니티 수정
    /// - parameter: token, post_id:Int, post_title: "화장법", post_content:"", post_tag:"연애인", post_file:Image,
    func requestTalkModify(param:[String:Any], success:ResSuccess?, failure:ResFailure?) {
        NetworkManager.shared.request(.post, "/community/modify", param) { (response) in
            success?(response)
        } failure: { (error) in
            failure?(error)
        }
    }
    /// 커뮤니티_카테고리
    /// - parameter: token
    func requestTalkCategory(param:[String:Any], success:ResSuccess?, failure:ResFailure?) {
        NetworkManager.shared.request(.post, "/community/category", param) { (response) in
            success?(response)
        } failure: { (error) in
            failure?(error)
        }
    }
    /// FAQ 리스트
    /// - parameter: akey, page, per_page, fqr_key:"app"
    func requestFAQList(param:[String:Any], success:ResSuccess?, failure:ResFailure?) {
        NetworkManager.shared.request(.post, "/faq/list", param) { (response) in
            success?(response)
        } failure: { (error) in
            failure?(error)
        }
    }
    /// 내 정보
    /// - parameter: token
    func requestMyInfo(param:[String:Any], success:ResSuccess?, failure:ResFailure?) {
        NetworkManager.shared.request(.post, "/user/info", param) { (response) in
            success?(response)
        } failure: { (error) in
            failure?(error)
        }
    }
    /// 내 정보 수정
    /// - parameter: token, mem_nickname, mem_profile_content, mem_receive_email
    func requestModifyMyInfo(param:[String:Any], success:ResSuccess?, failure:ResFailure?) {
        NetworkManager.shared.request(.post, "/user/save", param) { (response) in
            success?(response)
        } failure: { (error) in
            failure?(error)
        }
    }
    /// 비밀번호 변경
    /// - parameter: token, c_password, n_password
    func requestModifyPassword(param:[String:Any], success:ResSuccess?, failure:ResFailure?) {
        NetworkManager.shared.request(.post, "/user/change_password", param) { (response) in
            success?(response)
        } failure: { (error) in
            failure?(error)
        }
    }
    /// 나의 스크랩
    /// - parameter: token, scr_id
    func requestMyScrap(param:[String:Any], success:ResSuccess?, failure:ResFailure?) {
        NetworkManager.shared.request(.post, "/mypage/scrap", param) { (response) in
            success?(response)
        } failure: { (error) in
            failure?(error)
        }
    }
    /// 나의 스크랩 삭제
    /// - parameter: token, scr_id
    func requestMyScrapDelete(param:[String:Any], success:ResSuccess?, failure:ResFailure?) {
        NetworkManager.shared.request(.post, "/mypage/scrap_delete", param) { (response) in
            success?(response)
        } failure: { (error) in
            failure?(error)
        }
    }
    /// 나의 츄 사용내역
    /// - parameter: token, page
    func requestMyChuHistory(param:[String:Any], success:ResSuccess?, failure:ResFailure?) {
        NetworkManager.shared.request(.post, "/mypage/chu_history", param) { (response) in
            success?(response)
        } failure: { (error) in
            failure?(error)
        }
    }
    /// 나의 게시글
    /// - parameter: token, page, category_id
    func requestMyPostHistory(param:[String:Any], success:ResSuccess?, failure:ResFailure?) {
        NetworkManager.shared.request(.post, "/mypage/community", param) { (response) in
            success?(response)
        } failure: { (error) in
            failure?(error)
        }
    }
    /// 나의 질문내역
    /// - parameter: token, page, category_id
    func requestMyQnaList(param:[String:Any], success:ResSuccess?, failure:ResFailure?) {
        NetworkManager.shared.request(.post, "/mypage/ask", param) { (response) in
            success?(response)
        } failure: { (error) in
            failure?(error)
        }
    }
    /// 내픽
    /// - parameter: token, page, per_page
    func requestMyPickList(param:[String:Any], success:ResSuccess?, failure:ResFailure?) {
        NetworkManager.shared.request(.post, "/mypage/pick", param) { (response) in
            success?(response)
        } failure: { (error) in
            failure?(error)
        }
    }
    /// 게시판 추천/비추천
    /// - parameter: token, post_id, like_type:1, 0
    func requestPostRecomend(param:[String:Any], success:ResSuccess?, failure:ResFailure?) {
        NetworkManager.shared.request(.post, "/postact/like", param) { (response) in
            success?(response)
        } failure: { (error) in
            failure?(error)
        }
    }
    /// 댓글 추천/비추천
    /// - parameter: token, cmt_id, like_type:1, 0
    func requestCommentRecomend(param:[String:Any], success:ResSuccess?, failure:ResFailure?) {
        NetworkManager.shared.request(.post, "/postact/comment_like", param) { (response) in
            success?(response)
        } failure: { (error) in
            failure?(error)
        }
    }
    /// 스크랩
    /// - parameter: token, post_id
    func requestPostScrap(param:[String:Any], success:ResSuccess?, failure:ResFailure?) {
        NetworkManager.shared.request(.post, "/postact/scrap", param) { (response) in
            success?(response)
        } failure: { (error) in
            failure?(error)
        }
    }
    /// 본글 신고하기
    /// - parameter: token, post_id
    func requestPostWarning(param:[String:Any], success:ResSuccess?, failure:ResFailure?) {
        NetworkManager.shared.request(.post, "/postact/blame", param) { (response) in
            success?(response)
        } failure: { (error) in
            failure?(error)
        }
    }
    /// 댓글 신고하기
    /// - parameter: token, cmt_id
    func requestPostCommentWarning(param:[String:Any], success:ResSuccess?, failure:ResFailure?) {
        NetworkManager.shared.request(.post, "/postact/comment_blame", param) { (response) in
            success?(response)
        } failure: { (error) in
            failure?(error)
        }
    }
    /// 댓글 작성
    /// - parameter: token, post_id, cmt_conent, cmt_id, mode:c =>생성, cu=> 업데이트
    func requestCommentWrite(param:[String:Any], success:ResSuccess?, failure:ResFailure?) {
        NetworkManager.shared.request(.post, "/comment/update", param) { (response) in
            success?(response)
        } failure: { (error) in
            failure?(error)
        }
    }
    /// 댓글 삭제
    /// - parameter: token, cmt_id
    func requestDeleteComment(param:[String:Any], success:ResSuccess?, failure:ResFailure?) {
        NetworkManager.shared.request(.post, "/postact/delete_comment", param) { (response) in
            success?(response)
        } failure: { (error) in
            failure?(error)
        }
    }
    /// 본글 삭제
    /// - parameter: token, post_id
    func requestDeletePost(param:[String:Any], success:ResSuccess?, failure:ResFailure?) {
        NetworkManager.shared.request(.post, "/postact/delete", param) { (response) in
            success?(response)
        } failure: { (error) in
            failure?(error)
        }
    }
    /// 1:1 질문, 뷰티 질문, 메이크업 진단
    /// - parameter: token, post_title, post_content, post_category:1:1,메이크업진단,뷰티질문 , post_file,
    /// recv_mem_id: 1:1 질문일때, post_tag: 아티스트, 셀럽(뷰티, 메이크업) 질문할때
    func requestAskWrite(param:[String:Any], success:ResSuccess?, failure:ResFailure?) {
        NetworkManager.shared.request(.post, "/ask/write", param) { (response) in
            success?(response)
        } failure: { (error) in
            failure?(error)
        }
    }
    ///질문 리스트
    /// - parameter: token, page, per_page, category_id:헤어, skeyword, findex: post_like, desc
    func requestAskList(param:[String:Any], success:ResSuccess?, failure:ResFailure?) {
        NetworkManager.shared.request(.post, "/ask/list", param) { (response) in
            success?(response)
        } failure: { (error) in
            failure?(error)
        }
    }
    ///질문 채택하기
    /// - parameter: token, cmt_id
    func requestAskChoose(param:[String:Any], success:ResSuccess?, failure:ResFailure?) {
        NetworkManager.shared.request(.post, "/ask/choose", param) { (response) in
            success?(response)
        } failure: { (error) in
            failure?(error)
        }
    }
    ///질문 상세
    /// - parameter: token, post_id
    func requestAskDetail(param:[String:Any], success:ResSuccess?, failure:ResFailure?) {
        NetworkManager.shared.request(.post, "/ask/detail", param) { (response) in
            success?(response)
        } failure: { (error) in
            failure?(error)
        }
    }
    ///상점(아이템 리스트)
    /// - parameter: token, page, per_page, ctag
    func requestShopList(param:[String:Any], success:ResSuccess?, failure:ResFailure?) {
        NetworkManager.shared.request(.post, "/shop/lists", param) { (response) in
            success?(response)
        } failure: { (error) in
            failure?(error)
        }
    }
    /// 광고 가져오기
    /// -  parameter: akey:
    func requestAdvertisement(param:[String:Any], success:ResSuccess?, failure:ResFailure?) {
        NetworkManager.shared.request(.post, "/app/ad", param) { (response) in
            success?(response)
        } failure: { (error) in
            failure?(error)
        }
    }
    ///결제완료
    func requestPayCompleteState(param:[String:Any], success:ResSuccess?, failure:ResFailure?) {
        NetworkManager.shared.request(.post, "https://api.ohguohgu.com/app/pay_comp_state", param) { (response) in
            success?(response)
        } failure: { (error) in
            failure?(error)
        }
    }
    /// 전문가 Main top
    /// - parameter: akey, page, per_page, {skeyword, findx}
    func requestExpertMainTop(param:[String:Any], success:ResSuccess?, failure:ResFailure?) {
        NetworkManager.shared.request(.post, "/expert/top_list", param) { (response) in
            success?(response)
        } failure: { (error) in
            failure?(error)
        }
    }
    /// 전문가 리스트
    /// - parameter: akey, page:1, per_page:10, skeyword:전문가2, findx, sfield:mem_nickname
    func requestExpertList(param:[String:Any], success:ResSuccess?, failure:ResFailure?) {
        NetworkManager.shared.request(.post, "/expert/lists", param) { (response) in
            success?(response)
        } failure: { (error) in
            failure?(error)
        }
    }
    /// 전문가 상세
    /// - parameter: token, mem_id
    func requestExpertDetail(param:[String:Any], success:ResSuccess?, failure:ResFailure?) {
        NetworkManager.shared.request(.post, "/expert/detail", param) { (response) in
            success?(response)
        } failure: { (error) in
            failure?(error)
        }
    }
    /// 전문가 리뷰달기
    /// - parameter: token, recv_mem_id, rating, message
    func requestWriteExpertReview(param:[String:Any], success:ResSuccess?, failure:ResFailure?) {
        NetworkManager.shared.request(.post, "/expert/review", param) { (response) in
            success?(response)
        } failure: { (error) in
            failure?(error)
        }
    }
    /// 전문가 내픽
    /// - parameter: token, pick_mem_id, flag
    func requestExpertMyPick(param:[String:Any], success:ResSuccess?, failure:ResFailure?) {
        NetworkManager.shared.request(.post, "/expert/mypick", param) { (response) in
            success?(response)
        } failure: { (error) in
            failure?(error)
        }
    }
    
}

