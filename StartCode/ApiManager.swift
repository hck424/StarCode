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
        NetworkManager.shared.request(.post, "/\(hostUrl)/phone/authcode", param) { (response) in
            success?(response)
        } failure: { (error) in
            failure?(error)
        }
    }
    ///휴대폰 인증체크
    func requestPhoneAuthCheck(param:[String:Any], success:ResSuccess?, failure:ResFailure?) {
        NetworkManager.shared.request(.post, "/\(hostUrl)/phone/authcheck", param) { (response) in
            success?(response)
        } failure: { (error) in
            failure?(error)
        }
    }
    ///회원 아이디 체크
    func requestMemberIdCheck(param:[String:Any], success:ResSuccess?, failure:ResFailure?) {
        NetworkManager.shared.request(.post, "/\(hostUrl)/sign/idcheck", param) { (response) in
            success?(response)
        } failure: { (error) in
            failure?(error)
        }
    }
    ///회원 닉네임 체크
    func requestMemberNickNameCheck(param:[String:Any], success:ResSuccess?, failure:ResFailure?) {
        NetworkManager.shared.request(.post, "/\(hostUrl)/sign/nickcheck", param) { (response) in
            success?(response)
        } failure: { (error) in
            failure?(error)
        }
    }
    ///회원 가입
    func requestMemberSignUp(param:[String:Any], success:ResSuccess?, failure:ResFailure?) {
        NetworkManager.shared.requestFileUpload(.post, "/\(hostUrl)/sign/up", param) { (response) in
            success?(response)
        } failure: { (error) in
            failure?(error)
        }
    }
    ///회원 로그인
    func requestMemberSignIn(param:[String:Any], success:ResSuccess?, failure:ResFailure?) {
        NetworkManager.shared.request(.post, "/\(hostUrl)/sign/in", param) { (response) in
            success?(response)
        } failure: { (error) in
            failure?(error)
        }
    }
    ///회원 토큰갱싱
    func requestUpdateToken(param:[String:Any], success:ResSuccess?, failure:ResFailure?) {
        NetworkManager.shared.request(.post, "/\(hostUrl)/sign/updatatoken", param) { (response) in
            success?(response)
        } failure: { (error) in
            failure?(error)
        }
    }
    ///휴대폰, 비빌번호 인증코드 요청(회원로그인 된 상태)map_type:2 휴대폰 인증, 3: 비밀번호 인증
    func requestPhoneReAuthCode(param:[String:Any], success:ResSuccess?, failure:ResFailure?) {
        NetworkManager.shared.request(.post, "/\(hostUrl)/phone/reqcode", param) { (response) in
            success?(response)
        } failure: { (error) in
            failure?(error)
        }
    }
    ///아이디, 비밀번호 찾기, type: id, pass
    func requestFindIdOrPassword(param:[String:Any], success:ResSuccess?, failure:ResFailure?) {
        NetworkManager.shared.request(.post, "/\(hostUrl)/sign/findidbypass", param) { (response) in
            success?(response)
        } failure: { (error) in
            failure?(error)
        }
    }
    ///공지사항_리스트
    func requestNoticeList(param:[String:Any], success:ResSuccess?, failure:ResFailure?) {
        NetworkManager.shared.request(.post, "/\(hostUrl)/notice/list", param) { (response) in
            success?(response)
        } failure: { (error) in
            failure?(error)
        }
    }
    /// 공지사항_상세
    /// - parameter: akey:String, post_id:Int
    func requestNoticeDetail(param:[String:Any], success:ResSuccess?, failure:ResFailure?) {
        NetworkManager.shared.request(.post, "/\(hostUrl)/notice/detail", param) { (response) in
            success?(response)
        } failure: { (error) in
            failure?(error)
        }
    }
    /// 이벤트_리스트
    func requestEventList(param:[String:Any], success:ResSuccess?, failure:ResFailure?) {
        NetworkManager.shared.request(.post, "/\(hostUrl)/event/list", param) { (response) in
            success?(response)
        } failure: { (error) in
            failure?(error)
        }
    }
    /// 이벤트_상세
    func requestEventDetail(param:[String:Any], success:ResSuccess?, failure:ResFailure?) {
        NetworkManager.shared.request(.post, "/\(hostUrl)/event/detail", param) { (response) in
            success?(response)
        } failure: { (error) in
            failure?(error)
        }
    }
    /// 고객센터_리스트
    func requestContactUsList(param:[String:Any], success:ResSuccess?, failure:ResFailure?) {
        NetworkManager.shared.request(.post, "/\(hostUrl)/advice/list", param) { (response) in
            success?(response)
        } failure: { (error) in
            failure?(error)
        }
    }
    /// 고객센터_상세
    /// - parameter: token, post_id
    func requestContactUsDetail(param:[String:Any], success:ResSuccess?, failure:ResFailure?) {
        NetworkManager.shared.request(.post, "/\(hostUrl)/advice/detail", param) { (response) in
            success?(response)
        } failure: { (error) in
            failure?(error)
        }
    }
    /// 고객센터_작성
    /// - parameter: token, post_title, post_content
    func requestContactUsWrite(param:[String:Any], success:ResSuccess?, failure:ResFailure?) {
        NetworkManager.shared.request(.post, "/\(hostUrl)/advice/write", param) { (response) in
            success?(response)
        } failure: { (error) in
            failure?(error)
        }
    }
    ///커뮤니티 리스트
    /// - parameter: token, page, per_page, findex:desc, category_id:optional, skeyword:optional
    func requestTalkList(param:[String:Any], success:ResSuccess?, failure:ResFailure?) {
        NetworkManager.shared.request(.post, "/\(hostUrl)/community/list", param) { (response) in
            success?(response)
        } failure: { (error) in
            failure?(error)
        }
    }
    ///커뮤니티 상세
    /// - parameter: token, post_id
    func requestTalkDetail(param:[String:Any], success:ResSuccess?, failure:ResFailure?) {
        NetworkManager.shared.request(.post, "/\(hostUrl)/community/detail", param) { (response) in
            success?(response)
        } failure: { (error) in
            failure?(error)
        }
    }
    ///커뮤니티 작성
    /// - parameter: token, post_title: "화장법", post_content:"", post_category:"연애인", post_file:Image,
    func requestTalkWrite(param:[String:Any], success:ResSuccess?, failure:ResFailure?) {
        NetworkManager.shared.requestFileUpload(.post, "/\(hostUrl)/community/write", param) { (response) in
            success?(response)
        } failure: { (error) in
            failure?(error)
        }
    }
    ///커뮤니티 수정
    /// - parameter: token, post_id:Int, post_title: "화장법", post_content:"", post_tag:"연애인", post_file:Image,
    func requestTalkModify(param:[String:Any], success:ResSuccess?, failure:ResFailure?) {
        NetworkManager.shared.requestFileUpload(.post, "/\(hostUrl)/community/modify", param) { (response) in
            success?(response)
        } failure: { (error) in
            failure?(error)
        }
    }
    /// 커뮤니티_카테고리
    /// - parameter: token
    func requestTalkCategory(param:[String:Any], success:ResSuccess?, failure:ResFailure?) {
        NetworkManager.shared.request(.post, "/\(hostUrl)/community/category", param) { (response) in
            success?(response)
        } failure: { (error) in
            failure?(error)
        }
    }
    ///전문가의 일상
    func requestExpertLifeList(param:[String:Any], success:ResSuccess?, failure:ResFailure?) {
        NetworkManager.shared.request(.post, "/\(hostUrl)/expertlife/list", param) { (response) in
            success?(response)
        } failure: { (error) in
            failure?(error)
        }
    }
    ///전문가의 일상 상세
    func requestExpertLifeDetail(param:[String:Any], success:ResSuccess?, failure:ResFailure?) {
        NetworkManager.shared.request(.post, "/\(hostUrl)/expertlife/detail", param) { (response) in
            success?(response)
        } failure: { (error) in
            failure?(error)
        }
    }
    /// FAQ 리스트
    /// - parameter: akey, page, per_page, fqr_key:"app"
    func requestFAQList(param:[String:Any], success:ResSuccess?, failure:ResFailure?) {
        NetworkManager.shared.request(.post, "/\(hostUrl)/faq/list", param) { (response) in
            success?(response)
        } failure: { (error) in
            failure?(error)
        }
    }
    /// 내 정보
    /// - parameter: token
    func requestMyInfo(param:[String:Any], success:ResSuccess?, failure:ResFailure?) {
        NetworkManager.shared.request(.post, "/\(hostUrl)/user/info", param) { (response) in
            success?(response)
        } failure: { (error) in
            failure?(error)
        }
    }
    /// 내 정보 수정
    /// 츄설정및 1:1 알림설정
    /// - parameter: token, mem_nickname, mem_profile_content, mem_receive_email
    func requestModifyMyInfo(param:[String:Any], success:ResSuccess?, failure:ResFailure?) {
        NetworkManager.shared.requestFileUpload(.post, "/\(hostUrl)/user/save", param) { (response) in
            success?(response)
        } failure: { (error) in
            failure?(error)
        }
    }
    /// 비밀번호 변경
    /// - parameter: token, c_password, n_password
    func requestModifyPassword(param:[String:Any], success:ResSuccess?, failure:ResFailure?) {
        NetworkManager.shared.request(.post, "/\(hostUrl)/user/change_password", param) { (response) in
            success?(response)
        } failure: { (error) in
            failure?(error)
        }
    }
    /// 나의 스크랩
    /// - parameter: token, scr_id
    func requestMyScrap(param:[String:Any], success:ResSuccess?, failure:ResFailure?) {
        NetworkManager.shared.request(.post, "/\(hostUrl)/mypage/scrap", param) { (response) in
            success?(response)
        } failure: { (error) in
            failure?(error)
        }
    }
    /// 나의 스크랩 삭제
    /// - parameter: token, scr_id
    func requestMyScrapDelete(param:[String:Any], success:ResSuccess?, failure:ResFailure?) {
        NetworkManager.shared.request(.post, "/\(hostUrl)/mypage/scrap_delete", param) { (response) in
            success?(response)
        } failure: { (error) in
            failure?(error)
        }
    }
    /// 나의 츄 사용내역
    /// - parameter: token, page
    func requestMyChuHistory(param:[String:Any], success:ResSuccess?, failure:ResFailure?) {
        NetworkManager.shared.request(.post, "/\(hostUrl)/mypage/chu_history", param) { (response) in
            success?(response)
        } failure: { (error) in
            failure?(error)
        }
    }
    /// 나의 게시글
    /// - parameter: token, page, category_id
    func requestMyPostHistory(param:[String:Any], success:ResSuccess?, failure:ResFailure?) {
        NetworkManager.shared.request(.post, "/\(hostUrl)/mypage/community", param) { (response) in
            success?(response)
        } failure: { (error) in
            failure?(error)
        }
    }
    /// 나의 질문내역
    /// - parameter: token, page, category_id
    func requestMyQnaList(param:[String:Any], success:ResSuccess?, failure:ResFailure?) {
        NetworkManager.shared.request(.post, "/\(hostUrl)/mypage/ask", param) { (response) in
            success?(response)
        } failure: { (error) in
            failure?(error)
        }
    }
    /// 내가 처리할 문의내역 (전문가)
    /// - parameter: token, page, category_id:1:1, post_state: 0
    func requestMyAnswerList(param:[String:Any], success:ResSuccess?, failure:ResFailure?) {
        NetworkManager.shared.request(.post, "/\(hostUrl)/mypage/question", param) { (response) in
            success?(response)
        } failure: { (error) in
            failure?(error)
        }
    }
    
    ///전문가 답변 상세 PASS /answer/comment
    //mode: pass, c 업데이트
    func requestAnswerComment(param:[String:Any], success:ResSuccess?, failure:ResFailure?) {
        NetworkManager.shared.requestFileUpload(.post, "/\(hostUrl)/answer/comment", param) { (response) in
            success?(response)
        } failure: { (error) in
            failure?(error)
        }
    }
    /// 픽 등록
    func requestPickRegist(param:[String:Any], success:ResSuccess?, failure:ResFailure?) {
        NetworkManager.shared.request(.post, "/\(hostUrl)/expert/mypick", param) { (response) in
            success?(response)
        } failure: { (error) in
            failure?(error)
        }
    }
    /// 내픽
    /// - parameter: token, page, per_page
    func requestMyPickList(param:[String:Any], success:ResSuccess?, failure:ResFailure?) {
        NetworkManager.shared.request(.post, "/\(hostUrl)/mypage/pick", param) { (response) in
            success?(response)
        } failure: { (error) in
            failure?(error)
        }
    }
    /// 게시판 추천/비추천
    /// - parameter: token, post_id, like_type:1, 0
    func requestPostRecomend(param:[String:Any], success:ResSuccess?, failure:ResFailure?) {
        NetworkManager.shared.request(.post, "/\(hostUrl)/postact/like", param) { (response) in
            success?(response)
        } failure: { (error) in
            failure?(error)
        }
    }
    /// 댓글 추천/비추천
    /// - parameter: token, cmt_id, like_type:1, 0
    func requestCommentRecomend(param:[String:Any], success:ResSuccess?, failure:ResFailure?) {
        NetworkManager.shared.request(.post, "/\(hostUrl)/postact/comment_like", param) { (response) in
            success?(response)
        } failure: { (error) in
            failure?(error)
        }
    }
    /// 스크랩
    /// - parameter: token, post_id
    func requestPostScrap(param:[String:Any], success:ResSuccess?, failure:ResFailure?) {
        NetworkManager.shared.request(.post, "/\(hostUrl)/postact/scrap", param) { (response) in
            success?(response)
        } failure: { (error) in
            failure?(error)
        }
    }
    /// 본글 신고하기
    /// - parameter: token, post_id
    func requestPostWarning(param:[String:Any], success:ResSuccess?, failure:ResFailure?) {
        NetworkManager.shared.request(.post, "/\(hostUrl)/postact/blame", param) { (response) in
            success?(response)
        } failure: { (error) in
            failure?(error)
        }
    }
    /// 전문가 1:1 글 신고하기
    /// - parameter: token, post_id
    func requestAnswerBlame(param:[String:Any], success:ResSuccess?, failure:ResFailure?) {
        NetworkManager.shared.request(.post, "/\(hostUrl)/answer/blame", param) { (response) in
            success?(response)
        } failure: { (error) in
            failure?(error)
        }
    }
    /// 댓글 신고하기
    /// - parameter: token, cmt_id
    func requestPostCommentWarning(param:[String:Any], success:ResSuccess?, failure:ResFailure?) {
        NetworkManager.shared.request(.post, "/\(hostUrl)/postact/comment_blame", param) { (response) in
            success?(response)
        } failure: { (error) in
            failure?(error)
        }
    }
    
    /// 댓글 작성
    /// - parameter: token, post_id, cmt_conent, cmt_id, mode:c =>생성, cu=> 업데이트
    func requestCommentWrite(param:[String:Any], success:ResSuccess?, failure:ResFailure?) {
        NetworkManager.shared.requestFileUpload(.post, "/\(hostUrl)/comment/update", param) { (response) in
            success?(response)
        } failure: { (error) in
            failure?(error)
        }
    }
    /// 댓글 삭제
    /// - parameter: token, cmt_id
    func requestDeleteComment(param:[String:Any], success:ResSuccess?, failure:ResFailure?) {
        NetworkManager.shared.request(.post, "/\(hostUrl)/postact/delete_comment", param) { (response) in
            success?(response)
        } failure: { (error) in
            failure?(error)
        }
    }
    /// 본글 삭제
    /// - parameter: token, post_id
    func requestDeletePost(param:[String:Any], success:ResSuccess?, failure:ResFailure?) {
        NetworkManager.shared.request(.post, "/\(hostUrl)/postact/delete", param) { (response) in
            success?(response)
        } failure: { (error) in
            failure?(error)
        }
    }
    /// 1:1 질문, 뷰티 질문, 메이크업 진단
    /// - parameter: token, post_title, post_content, post_category:1:1,메이크업진단,뷰티질문 , post_file,
    /// recv_mem_id: 1:1 질문일때, post_tag: 아티스트, 셀럽(뷰티, 메이크업) 질문할때
    func requestAskWrite(param:[String:Any], success:ResSuccess?, failure:ResFailure?) {
        NetworkManager.shared.requestFileUpload(.post, "/\(hostUrl)/ask/write", param) { (response) in
            success?(response)
        } failure: { (error) in
            failure?(error)
        }
    }
    /// Ai 질문
    /// - parameter: token, post_title, post_content, post_category:1:1,ai , post_file,
    /// recv_mem_id: 1:1 질문일때, post_tag: 아티스트, 셀럽(뷰티, 메이크업) 질문할때
    func requestAiAskRegist(param:[String:Any], success:ResSuccess?, failure:ResFailure?) {
        NetworkManager.shared.requestFileUpload(.post, "/\(hostAiUrl)/ask/write", param) { (response) in
            success?(response)
        } failure: { (error) in
            failure?(error)
        }
    }
    ///질문 리스트
    /// - parameter: token, page, per_page, category_id:헤어, skeyword, findex: post_like, desc
    func requestAskList(param:[String:Any], success:ResSuccess?, failure:ResFailure?) {
        NetworkManager.shared.request(.post, "/\(hostUrl)/ask/list", param) { (response) in
            success?(response)
        } failure: { (error) in
            failure?(error)
        }
    }
    ///질문 채택하기
    /// - parameter: token, cmt_id
    func requestAskChoose(param:[String:Any], success:ResSuccess?, failure:ResFailure?) {
        NetworkManager.shared.request(.post, "/\(hostUrl)/ask/choose", param) { (response) in
            success?(response)
        } failure: { (error) in
            failure?(error)
        }
    }
    ///질문 상세체크
    func requestAnswerOpenCheck(_ param:[String:Any], success:ResSuccess?, failure:ResFailure?) {
        NetworkManager.shared.request(.post, "/\(hostUrl)/answer/opencheck", param) { (response) in
            success?(response)
        } failure: { (error) in
            failure?(error)
        }
    }
    ///일반유저 질문상세
    func requestAskDetail(param:[String:Any], success:ResSuccess?, failure:ResFailure?) {
        NetworkManager.shared.requestFileUpload(.post, "/\(hostUrl)/ask/detail", param) { (response) in
            success?(response)
        } failure: { (error) in
            failure?(error)
        }
    }
    ///전문가답변 상세
    /// - parameter: token, post_id
    func requestAnswerDetail(param:[String:Any], success:ResSuccess?, failure:ResFailure?) {
        NetworkManager.shared.request(.post, "/\(hostUrl)/answer/detail", param) { (response) in
            success?(response)
        } failure: { (error) in
            failure?(error)
        }
    }
    ///상점(아이템 리스트)
    /// - parameter: token, page, per_page, ctag
    func requestChuShopList(param:[String:Any], success:ResSuccess?, failure:ResFailure?) {
        NetworkManager.shared.request(.post, "/\(hostUrl)/shop/lists", param) { (response) in
            success?(response)
        } failure: { (error) in
            failure?(error)
        }
    }
    /// 광고 가져오기
    /// -  parameter: akey:
    func requestAdvertisement(param:[String:Any], success:ResSuccess?, failure:ResFailure?) {
        NetworkManager.shared.request(.post, "/\(hostUrl)/app/ad", param) { (response) in
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
        NetworkManager.shared.request(.post, "/\(hostUrl)/expert/top_list", param) { (response) in
            success?(response)
        } failure: { (error) in
            failure?(error)
        }
    }
    /// 전문가 리스트
    /// - parameter: akey, page:1, per_page:10, skeyword:전문가2, findx, sfield:mem_nickname
    func requestExpertList(param:[String:Any], success:ResSuccess?, failure:ResFailure?) {
        NetworkManager.shared.request(.post, "/\(hostUrl)/expert/lists", param) { (response) in
            success?(response)
        } failure: { (error) in
            failure?(error)
        }
    }
    /// 전문가 상세
    /// - parameter: token, mem_id
    func requestExpertDetail(param:[String:Any], success:ResSuccess?, failure:ResFailure?) {
        NetworkManager.shared.request(.post, "/\(hostUrl)/expert/detail", param) { (response) in
            success?(response)
        } failure: { (error) in
            failure?(error)
        }
    }
    /// 전문가 리뷰달기
    /// - parameter: token, recv_mem_id, rating, message
    func requestWriteExpertReview(param:[String:Any], success:ResSuccess?, failure:ResFailure?) {
        NetworkManager.shared.request(.post, "/\(hostUrl)/expert/review", param) { (response) in
            success?(response)
        } failure: { (error) in
            failure?(error)
        }
    }
    /// 전문가 내픽
    /// - parameter: token, pick_mem_id, flag
    func requestExpertMyPick(param:[String:Any], success:ResSuccess?, failure:ResFailure?) {
        NetworkManager.shared.request(.post, "/\(hostUrl)/expert/mypick", param) { (response) in
            success?(response)
        } failure: { (error) in
            failure?(error)
        }
    }
    /// CHU 선물
    func requestGiveChu(param:[String:Any], success:ResSuccess?, failure:ResFailure?) {
        NetworkManager.shared.request(.post, "/\(hostUrl)/expert/give", param) { (response) in
            success?(response)
        } failure: { (error) in
            failure?(error)
        }
    }
    /// 유저의 댓글, 문의내역갯수 뱃지
    func requestUserBadge(param:[String:Any], success:ResSuccess?, failure:ResFailure?) {
        NetworkManager.shared.request(.post, "/\(hostUrl)/user/badge", param) { (response) in
            success?(response)
        } failure: { (error) in
            failure?(error)
        }
    }
    ///환전 요청 정보, 계좌리스트, 약관
    func requestExchangeInfo(success:ResSuccess?, failure:ResFailure?) {
        NetworkManager.shared.request(.post, "/\(hostUrl)/app/excinfo", nil) { (response) in
            success?(response)
        } failure: { (error) in
            failure?(error)
        }
    }
    ///환전요청
    func requestExchageChu(param:[String:Any], success:ResSuccess?, failure:ResFailure?) {
        NetworkManager.shared.request(.post, "/\(hostUrl)/mypage/exchange", nil) { (response) in
            success?(response)
        } failure: { (error) in
            failure?(error)
        }
    }
    
    func requestAiAnalysisResult(param:[String:Any], success:ResSuccess?, failure:ResFailure?) {
        var url = "http://3.35.104.151:5001/predict?"
        for (key, value) in param {
            url.append("\(key)=\(value)&")
        }
        url = String(url.dropLast())
        
        NetworkManager.shared.request(.get, url, nil) { (response) in
            success?(response)
        } failure: { (error) in
            failure?(error)
        }
    }
}

