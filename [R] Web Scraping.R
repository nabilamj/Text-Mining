#### WEB SCRAPING ####

library(xml2)
library(rvest)
library(ggplot2)

lamanweb = read_html("https://www.imdb.com/search/title/?title_type=feature&release_date=2019-01-01,2019-12-31&start=51&ref_=adv_prv")
lamanweb

runtime.data.laman = html_nodes(lamanweb,'.runtime')
runtime.data.laman
runtime.data = html_text(runtime.data.laman)
runtime.data
runtime.data = gsub("min","",runtime.data)
runtime.data
runtime.data = as.numeric(runtime.data)
runtime.data

genre.data.laman = html_nodes(lamanweb,'.genre')
genre.data = html_text(genre.data.laman)
genre.data
genre.data = gsub("\n","",genre.data)
genre.data = gsub(" ","",genre.data)
genre.data = gsub(",.*","",genre.data)
genre.data = as.factor(genre.data)
genre.data

rating.data.laman = html_nodes(lamanweb,'.ratings-imdb-rating strong')
rating.data = html_text(rating.data.laman)
rating.data
rating.data = as.numeric(rating.data)
rating.data

gross.data.laman = html_nodes(lamanweb,'.ghost~ .text-muted+ span')
gross.data = html_text(gross.data.laman)
gross.data
gross.data = gsub("M","",gross.data)
gross.data = substring(gross.data,2,6)
length(gross.data)
## Missing data diganti dengan nilai NA
for (i in c(4,6,7,8,9,10,15,16,17,18,19,20,21,25,26,28,29,31,33,34,35,37,38,40,42,44,45,47,49))
{
  a = gross.data[1:(i-1)]
  b = gross.data[i:length(gross.data)]
  gross.data = append(a,list("NA"))
  gross.data = append(gross.data,b)
}
gross.data = as.numeric(unlist(gross.data))
length(gross.data)

kumpulan.data.film = data.frame(Runtime = runtime.data,
                                Genre = genre.data, 
                                Rating = rating.data,
                                Gross.Pendapatan = gross.data)
kumpulan.data.film

qplot(data = kumpulan.data.film, Runtime, fill = Genre, bins = 30)
ggplot(kumpulan.data.film,aes(x=Runtime,y=Gross.Pendapatan))+geom_point(aes(size=Rating,col=Genre))
