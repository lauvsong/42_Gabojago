# 🌏녹색 탐지기🌏
![](https://images.velog.io/images/sophia5460/post/a9077c0f-77ec-49bf-9e94-14e417732c03/image.png)
<br>
> 녹색탐지기는 Google mobile vision 을 이용해서 바코드 스캔을 통해 물건을 찍었을 때, 환경오염 부하나 폐기물 발생이 적은지 확인하는 어플리케이션입니다.
---
# 목차
---
1. ### [팀원 소개](#-팀원-소개)
2. ### [사용 기술 및 언어](#-사용-기술-및-언어)
3. ### [서비스의 목적](#-서비스의-목적)
4. ### [기능 플로우](#-기능-플로우)
5. ### [기능 소개](#-기능-소개)

- - 5-1 [바코드 스캔](#-바코드-스캔)
- - 5-2 [사용자 랭킹](#-사용자-랭킹)
- - 5-3 [카테고리 랭킹](#-카테고리-랭킹)

6. ### [기대효과](#-기대효과)
7. ### [DB Schema 및 명세서](#-DB-Schema-및-명세서)
8. ### [시연 영상](#-시연-영상)
---
# 👨‍👩‍👧‍👦 팀원 소개

|    👨‍👨‍👧    |                        팀장 & 디자이너                        |                             Back-end                              |                        Front-end                        |                             Back-end                             |
| :------: | :------------------------------------------------: | :------------------------------------------------------------: | :-----------------------------------------------: | :---------------------------------------------------------: |
| **Name** |      👩🏻‍💻 [김보경](https://github.com/bokyung29)      |            👩🏻‍💻 [김혜송](https://github.com/lauvsong)            | 👨‍💻  [강정인](https://github.com/Armalcolite) |        👩🏻‍💻 [조소연](https://github.com/algosipdahack)         |
---
# 🧨 사용 기술 및 언어
![image](https://user-images.githubusercontent.com/84591000/152622149-32958d69-ff15-4b9b-8c65-4c99f4556857.png)

## Google 기술
- Google mobile vision
- Google lens
- Google flutter
- Google Cloud Platform (GCP) - compute engine
- Google login

---
# 💡 서비스의 목적

지구온난화와 환경오염이 가속화됨에 따라 환경파괴가 증가하면서 세계 곳곳에서 이상 기후현상과 해수면 상승 등 다양한 문제들이 지속적으로 발생하고 있습니다.

이에 따라 기존에 환경파괴를 야기하는 화석연료 대신에 공해와 환경오염이 적은 대체 에너지원을 이용한 물품들의 생산이 증가하였습니다. 

해당 제품들의 사용을 소비자에게 장려하기 위해 **Google Mobile Vision** 기술을 이용하여 어떠한 제품이 환경친화적인지를 소비자가 인식할 수 있도록 하는 서비스를 기획하게 되었습니다. 

#### 바코드 스캔을 통해 제품들의 정보를 획득하여 환경오염 부하나 폐기물 발생이 적은지를 파악한 후 환경친화도가 높은 제품의 사용을 장려하여 생활 쓰레기로 인한 환경오염을 감소시키는 것이 목적입니다. 
---

# ✔ 기능 플로우
![image](https://user-images.githubusercontent.com/84591000/152622334-1b770bab-0131-489e-88ae-cc62b9cc2c20.png)

---

# 🎨 기능 소개
## 바코드 스캔
![image](https://user-images.githubusercontent.com/84591000/152616835-123725de-f421-498d-b7bc-82b456de7ba8.png)
![image](https://user-images.githubusercontent.com/84591000/152616850-0abbc7f5-7e4f-42b4-87fc-f091ba19ebea.png)
<br>
- 구글 렌즈를 사용하여 특정 제품의 바코드를 스캔합니다.
- 스캔 후 해당 제품의 환경 기여도와 환경 인증을 반영하여 점수로 반환합니다.
<br>

![image](https://user-images.githubusercontent.com/84591000/152616920-6939eeec-ff39-4d06-9263-3660fe8321ad.png)
- 만약 해당 제품이 worst 제품일 시 하단에 같은 카테고리의 점수가 높은 제품을 추천합니다.
<br>

## 사용자 랭킹
![image](https://user-images.githubusercontent.com/84591000/152616948-b9cc3448-231d-45c5-80c0-a44eebc52b62.png)
- 환경친화적인 제품을 스캔할 때마다 그린포인트를 획득하여 등급을 올리실 수 있습니다.
- 사용자의 등급 별 순위를 확인하실 수 있습니다.
<br>

## 카테고리 랭킹
![image](https://user-images.githubusercontent.com/84591000/152617034-ffe3f26c-8c1a-4772-9461-3691828411cd.png)
![image](https://user-images.githubusercontent.com/84591000/152616998-f1badb0e-6fad-4d5b-8426-3ffedcc1efb0.png)
- 환경친화적인 제품을 카테고리 별로 확인하실 수 있으며 검색량 순에 따라 제품들이 정렬되어 보여집니다.
---
# 📈 기대효과
- 바코드 스캔 시 해당 제품의 환경 기여도를 시각적으로 보여줌으로써 소비자들이 환경에 대한 경각심을 느낄 수 있습니다.
- 환경 친화적인 제품을 소비할 때마다 티어가 상승하고, 사용자들 간의 순위가 상승하면서 환경 친화적인 제품을 소비하고 싶은 욕구를 자극합니다.
- 환경 기여도가 낮은 제품을 소비할 시 환경 기여도가 높은 제품을 추천해줌으로써 소비의 방향성을 전환시킬 수 있습니다.
- 어떠한 제품이 환경친화적인지 모르는 경우 카테고리 별 분류를 통해 제품에 대한 정보를 얻을 수 있고 이를 통해 해당 제품을 생산한 기업들의 이미지를 제고시키는 효과를 얻을 수 있습니다.
<br>

![image](https://user-images.githubusercontent.com/84591000/152617238-66ccaae2-9e68-4119-a295-83fa586102b2.png)
- 메인 화면에 기후변화의 위험성을 상기시키는 문구를 추가하여 사용자에게 지속적으로 노출이 될 수 있게끔 함으로써 환경에 대해 다시 한번 생각할 수 있게 끔 합니다.
- ---
# 🧾 DB Schema 및 명세서
![image](https://user-images.githubusercontent.com/84591000/152617402-88cafb46-626f-418b-bf63-016fddd726e1.png)
- **Tables**
    - users
    - favorites
    - tiers
    - products
    - categories

## [명세서] swagger 주소
https://app.swaggerhub.com/apis-docs/gabojago/gabojago/1.2.0
- ---
# 🎥 시연 영상
https://user-images.githubusercontent.com/41888956/152628561-449e9a74-227b-415c-9333-b7ff029124fe.mp4


## [협업 기록] Notion 주소
https://gabojago.notion.site/a3128ce9b5cb49c5be9f212ee35845de

# 발표 ppt
[42조 가보자고 ppt_최종.pdf](https://github.com/gdsckoreahackathon2022/42_Gabojago/files/8007348/42.ppt_.pdf)
[42조 가보자고 ppt_최종.pptx](https://github.com/gdsckoreahackathon2022/42_Gabojago/files/8007349/42.ppt_.pptx)

# 발표 대본
[가보자고 발표 대본.pdf](https://github.com/gdsckoreahackathon2022/42_Gabojago/files/8007090/default.pdf)

# 실행 파일
```
하단 압축 파일 내부 APK 실행
```
[Team42_녹색탐지기.zip](https://github.com/lauvsong/42_Gabojago/files/8007375/Team42_.zip)
