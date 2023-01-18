# Hapit(해핏)

## ADS


내 앱은, 스스로 습관을 형성하기 어려운 사람들을 위해 귀여운 요소들을 통한 습관 런닝 메이트 역할을 수행할 것이다.
왜냐하면, 습관 형성을 위한 꾸준한 실천을 유지하기 위해서는 흥미를 느낄 수 있도록 재미있게 동기부여 해줄 필요가 있기 때문이다.

## 페르소나


1. 제주도에 거주중이고 10대에 귀여운 것을 선호하고 습관 형성에 관심이 있는 여성 이수영씨
2. 서울에 거주중이고 20대에 건강한 식습관에 관심이 많고 귀여운 것을 선호하는 남성 김재혁씨
3. 부산에 거주중이고 30대에 운동습관을 만들고 싶어하고 귀여운 것을 선호하는 남성 이감자씨

## 주요기능 및 스크린샷


현재까지 설정한 주요기능

- 로그인 및 회원가입
- 3개의 탭으로 구성된 메인 뷰(로그인 후 바로 보여지는 뷰)
    
    홈탭
    
        챌린지 추가기능
    
        챌린지 및 습관 리스트 
    
        챌린지 및 습관 리스트의 주간 캘린더 및 일지 확인(챌린지&습관리스트의 디테일 뷰)
    
    소셜탭
    
        챌린지 랭킹
    
        친구의 챌린지 확인(친구의 챌린지 리스트)
    
        친구의 챌린지 일지 (친구의 챌린지의 디테일 뷰)
    
    마이페이지탭
    
        프로필 설정 및 닉네임 변경
        
        획득한 리워드 전시관
    

## 프로젝트 설치 및 실행방법


프로젝트 설치 및 실행 방법

1. 프로젝트를 클론해주세요.(Branch: main)
2. 프로젝트를 빌드해주세요.
3. 실행방법

3개의 탭으로 구성된 메인 뷰(**홈,소셜,마이페이지**)

***소셜페이지는 현재 이번주 구현과제가 아니므로 디테일한 부분을 신경쓰지 못한 점 양해 부탁드립니다.**

1.로그인 실행 방법 안내
    - 현재 로그인 뷰는 프로토타입 구현을 완료하였습니다. 또한 현재 파이어베이스를 사용하려고 했던 계획을 변경하여 AWS로 변경하게되면서 현재 소셜 로그인은 아직 미구현 상태 입니다.

        1. 로그인

          로그인버튼 누르면 홈으로 이동합니다.

        2. 회원가입

          회원가입 누르고 입력은 모두해야하고 동의한 후, 맨 마지막 스크린 버튼 누르면 자동로그인 되면서 홈 뷰로 이동합니다.

2. 홈탭 실행 방법 안내

    - 홈뷰에는 **챌린지**와 **습관**으로 구분하였습니다.

        **챌린지란**? 습관이 형성되기 전 단계로 66일 챌린지 기간을 수행하는 동안의 습관을 말합니다.

        **습관이란**? 챌린지 수행이 완료된 습관으로 습관 형성이 이루어졌다고 보는 습관을 말합니다.

        따라서 **챌린지**는 습관이 체화중인 단계, **습관**은 체화가 완료된, 계속 이어나갈 습관을 의미합니다.

    1. 습관 추가하기

        새로운 챌린지를 입력합니다.

        챌린지의 목표(예: 아침에 물한잔 마시기)를 정하고 알림을 설정할 수 있습니다.

    2. 챌린지 또는 습관을 선택

        챌린지나 습관에 대한 디테일 뷰를 나타냅니다.

        -> 디테일 뷰에서는 주간 캘린더가 상단에 나타나고 해당 날짜를 클릭하면 일일 일지(습관기록)을 확인할 수 있습니다.
        
        2-1. 일지작성

            당일에 일지가 작성되어 있지 않은 경우 추가버튼이 나타나게되고 새롭게 일지를 추가하여 작성할 수 있습니다.

3. 소셜탭 실행 방법 안내

    - 소셜뷰에서는 친구들이 수행하고 있는 챌린지 개수, 습관 개수 등을 통해 랭킹으로 보여줍니다.

    1. 랭킹에 나타나있는 친구들의 셀을 선택

        해당하는 친구들의 습관리스트를 보여주는 뷰를 나타냅니다.(뷰 미완성)

            -> 여기부분부터 미완성이고 예시를 들기위해 습관리스트를 붙여놓은 상태입니다.

        1-1. 친구들의 습관리스트를 선택(뷰 미완성)

            해당하는 친구의 습관리스트의 디테일 뷰를 나타냅니다.

                -> 친구습관의 디데일 뷰는 개인 습관과 같은 형식의 뷰이며 친구가 공개 허용해놓은 일지를 보여주게 됩니다.

4. 마이페이지 실행 방법 안내

    - 마이페이지는 프로필과 리워드, 설정으로 구성되어있습니다.

    1. 프로필 선택 및 닉네임 변경

        리워드로 받은 젤리 배찌들 중 하나를 선택하여 현재프로필을 선택해서 설정할 수 있습니다.

        닉네임 변경 버튼 선택 시 닉네임을 변경할 수 있습니다.

    2. 리워드 전시

        내가 획득한 리워드들을 전시해놓는 전시관으로 해당 리워드들을 확인할 수 있습니다.

## 참여자


김예원, 박진형, 박민주, 추현호, 이주희, 신현준, 김응관

## 라이센스

