#### TEXT MINING ####

library(xml2)
library(rvest)
library(tm)
library(NLP)
library(SnowballC)
library(wordcloud)
library(RColorBrewer)
library(stringr)

hyatt = read_html("https://www.tripadvisor.co.id/Hotel_Review-g3916131-d307076-Reviews-Hyatt_Regency_Yogyakarta-Ngaglik_Sleman_District_Yogyakarta_Region_Java.html")
hyatt
ulasan = html_nodes(hyatt, ".cPQsENeY")
ulasan.text = html_text(ulasan)
ulasan.text

ulasan.text.baru = gsub("\n","",ulasan.text)
ulasan.text.baru
write.csv(ulasan.text.baru,"C:\\Users\\nab\\Documents\\ulasantextbaru.csv")

dokumen = readLines("C:\\Users\\nab\\Documents\\ulasantextbaru.csv")
dokumen
dokumen = VCorpus(VectorSource(dokumen))
dokumen
str(dokumen)

DTMdokumen = DocumentTermMatrix(dokumen,control=list(tolower=T,removeNumbers=T,
             stopwords=T,removePunctuation=T,stemming=T))
DTMdokumen
inspect(DTMdokumen)
str(DTMdokumen)
DTMdokumen$dimnames$Terms
length(DTMdokumen$dimnames$Terms)

freqdokumen = findFreqTerms(DTMdokumen, 2) #kata yang muncul 2 kali atau lebih

dokDTM = TermDocumentMatrix(dokumen)
dokDTM

ma = as.matrix(dokDTM)
vec = sort(rowSums(ma),decreasing = T)
## melihat 6 data terbanyak yang digunakan ##
dec = data.frame(word=names(vec),freq = vec)
head(dec,15)
str(dec)
dec$word
dec$freq

wordcloud(words = dec$word, freq = dec$freq, min.freq = 1, max.words = 50,
          random.order = F, rot.per = 0.35, colors = brewer.pal(8,"Dark2"))

veec = as.list(findAssocs(dokDTM, terms=c("ramah","fasilitas","nyaman"),
        corlimit = c(0.15,0.15,0.15,0.15,0.15)))
veec
