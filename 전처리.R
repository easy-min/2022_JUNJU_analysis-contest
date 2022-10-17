library(tidyverse)
library(lubridate)
library(ggplot2)
library(ggmap)
library(dplyr)
library(readxl)
library(writexl)
library(descr)

### [엑셀 불러오기] ###
불법주정차단속 <- read.csv('전라북도 전주시_불법주정차 단속현황_수정.csv', fileEncoding = "euc-kr", stringsAsFactors = T)

### [변수 추가 및 삭제] ###
불법주정차단속$단속요일 <- weekdays(불법주정차단속$단속일자) #요일변수 추가
불법주정차단속$단속월 <- month(불법주정차단속$단속일자) #월변수 추가
불법주정차단속$단속년도 <- year(불법주정차단속$단속일자) #년도변수 추가

### [변수 속성 수정] ###
불법주정차단속$단속일자 <- as.Date(불법주정차단속$단속일자) #날짜형
불법주정차단속$단속월 <- as.factor(불법주정차단속$단속월) #factor형
불법주정차단속 <- rename(불법주정차단속, 장소 = 단속장소명)

### [결측치(NA)제거] ###
불법주정차단속 <- na.omit(불법주정차단속) #결측치가 극히 일부기 때문에 삭제 (평균 대체 어려움)
sum(is.na(불법주정차단속$단속요일)) #결측치 0인 것 확인

### [변수 순서 변경] ###
불법주정차단속$단속요일 <- factor(불법주정차단속$단속요일, levels=c("월요일", "화요일", "수요일", "목요일", "금요일", "토요일", "일요일")) #변수 순서 변경

### [좌표.csv 불러오기] ###
고정cctv_최종 <- read.csv('고정cctv_최종.csv', stringsAsFactors = T)
이동cctv_최종 <- read.csv('이동cctv_최종.csv')
이동cctv_최종$x <- as.numeric(이동cctv_최종$x)
이동cctv_최종$y <- as.numeric(이동cctv_최종$y)
민원_최종 <- read.csv('민원_최종.csv')
민원_최종$x <- as.numeric(민원_최종$x)
민원_최종$y <- as.numeric(민원_최종$y)
summary(민원_최종)

### [좌표 생성] ###
register_google(key = "AIzaSyCAU0ZoUqQi7OxEPa5eNs8Bcv2MTTY8N94")
junju_map <- get_googlemap('전주', maptype = 'roadmap', zoom = 11)
ggmap(junju_map)
ggmap(junju_map) + geom_point(data = 고정cctv_최종, aes(x = x, y = y, size = 0.1))
ggmap(junju_map) + geom_point(data = 이동cctv_최종, aes(x = x, y = y, size = 0.02))
ggmap(junju_map) + geom_point(data = 민원_최종, aes(x = x, y = y, size = 0.01))

table(불법주정차단속&단속구분)
