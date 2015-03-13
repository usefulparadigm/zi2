게시판형 웹사이트를 위한 루비온레일스 엔진
(A Ruby on Rails engine for bulletin board based website)

## 주요 특징(Features) ##

  * Rails 2.1 기반
  * 설치 후 간단한 설정만으로 바로 사용
  * 기본 SNS 기능(지인맺기)
  * 오픈아이디 지원

## 설치(Installation) ##

  1. svn checkout http://zi2.googlecode.com/svn/trunk your\_app\_name
  1. cd your\_app\_name
  1. rake db:migrate
  1. rake test
  1. rake secret으로 secret 키 생성하여 config/environment.rb 속 secret키값 변경
  1. ruby script/server
  1. 브라우저에서 http://localhost:3000/admin으로 접속 (ID/PW: admin/admin)
  1. 게시판 그룹(group) 및 게시판(board) 생성

Done!

[![](http://pds12.egloos.com/pds/200809/04/44/d0004344_48bf919dc66d8.gif)](http://zi2.usefulparadigm.com/)
