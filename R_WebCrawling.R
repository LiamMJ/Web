###########################
# 웹 크롤링 (Web Crawling)

# 2. 영화 리뷰 분석 
###########################

# 패키지 설치 
# install.packages("stringr")

# 패키지 로드 
library(rvest)
library(ggplot2)
library(xml2)

# 크롤링 기본 연습 
# http://www.naver.com 을 naver_html 이라는 이름으로 읽어오기 

naver_html = read_html("http://naver.com")

# 특정 태그나 특정 요소의 값만 추출 
naver_node = html_node(naver_html, ".ah_l") %>% html_nodes(".ah_k")

naver_node

# 글자만 추출하기 
html_text(naver_node)

# 정리 

# read_html()을 통해서 xml 문서를 읽기 
# html_nodes()를 통해 특정 태그 or 속성 값을 갖는 요소만 추출 
# html_text()를 통해 위 요소 내  text만 추출 

################
# 리플 읽어오기 
################

# 일어올 페이지 파악 
# 구글 크롬 권장 개발자 도구 

movie_url = "https://movie.naver.com/movie/bi/mi/pointWriteFormList.nhn?code=140652&type=after&isActualPointWriteExecute=false&isMileageSubscriptionAlready=false&isMileageSubscriptionReject=false&page="

movie_url1 = paste0(movie_url,"1")

movie_url1








# 페이지 자동 변환해서 읽어오기

# 페이지 번호 생성

page = c(1:100)



# 변수 만들기

alltxt = c()





# 페이지 자동으로 읽어오기 

for (i in page){
  movie_url1 = paste0(movie_url,i)
  movie_html = read_html(movie_url1)
  movie_node = html_nodes(movie_html,css=".score_result") %>% html_nodes("p")
  movie_txt = html_text(movie_node)
  movie_alltxt = append(alltxt,movie_txt)
  print(i)
}

head(movie_alltxt)







#######################################################
# 분석
#######################################################

# 문제점 많음 
# 자바 설치 jdk  7 
#  http://www.oracle.com/technetwork/java/javase/downloads/index-jsp-138363.html


install.packages("rJava")
install.packages("KoNLP")

library(rJava)
library(KoNLP)

useSejongDic()


# 수집한 텍스트 확인 

head(movie_alltxt)


# 문자열 전처리

movie_alltxt = str_to_lower(alltxt)# 영문자 소문자로 변환
movie_alltxt = gsub("관람객","",alltxt) # 관람객 단어 제거
movie_alltxt = gsub("[ㄱ-ㅣ]","",alltxt) # ㅋㅋㅋ ,ㅜㅠ 등 제거
movie_alltxt = gsub("[[:punct:]]","",alltxt) # 구두점 제거
movie_alltxt = str_trim(alltxt,side="right") #공백 제거




# 2글자 이상 단어만 추출 

noun.list = sapply(movie_alltxt,USE.NAMES = F,FUN = extractNoun)
noun.list = lapply(noun.list, function (x) return(x[str_length(x) >=2 ]))

head(noun.list)





# 워드 클라우드

install.packages("wordcloud2")

library(wordcloud2)




allnoun = unlist(noun.list)
head(allnoun,20)



# 단어별 개수 정리

allnoun.table = table(allnoun)
allnoun.table = sort(allnoun.table,decreasing = T)
head(allnoun.table,30)
allnoun






# 그림 그리기 

wordcloud2(allnoun.table,minSize = 5)
