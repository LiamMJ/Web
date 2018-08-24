###########################
# 웹 크롤링 (Web Crawling)

# 1. 공항 이용객 분석 
###########################

# 브라우저는 구글 크롬을 이용 (개발자 도구) Ctrl + Shift + i

# 패키지 설치 
install.packages("rvest")
install.packages("xml2")

# 패키지 로드 
library(rvest)
library(ggplot2)
library(ggmap)
library(xml2)

# html 파일 가져오기 
html.airports = read_html("https://en.wikipedia.org/wiki/List_of_busiest_airports_by_passenger_traffic")

# 가져온 파일에서 첫 번째 테이블만 추출하기 
df = html_table(html_nodes(html.airports, "table")[[1]], fill = TRUE)

head(df)

########## 전처리 시작 ##########

# 6번째 열의 이름을 total로 변경하기 
colnames(df)[6] = "total"

# total 열의 필요 없는 부분 제거하기 
df$total

df$total = gsub('\\[[0-9+\\]', '', df$total)

# total 열의 쉼표 제거하기 
df$total

df$total = gsub(',', '', df$total)

# total 열을 숫자로 변환하기 
df$total = as.numeric(df$total)

# 공항들의 위도와 경도값 알아오기 
gc = geocode(df$Airport)

# 위도 경도 값과 원래 자료와 합치기 
df = cbind(df, gc)

# 세계 지도 불러오기 
world = map_data("world")

# 지도 위에 그리기 
ggplot(df, aes(x = lon, y = lat)) +
  geom_polygon(data = world, aes(x = long, y = lat, group = group), fill = "grey75", color = "grey70") +
  geom_point(color = "dark red", alpha = .25, aes(size = total)) +
  geom_point(color = "dark red", alpha = .75, shape = 1, aes(size = total)) +
  theme(legend.position = 'none')

# geom_polygon 지도를 도형 모양으로 표현
# 경도 = lon, 위도 = lat 
# shape = 1 가운데 비우기 