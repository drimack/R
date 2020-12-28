library(WDI) # baixar os dados do World Bank 
library(magrittr)
library(formattable)
library(cluster) 
library(fpc) 


# inserir o código do indicador desejado para utilizamos a função WDIsearch()
WDIsearch("Inflation")

# lista de indicadores econômicos dos países: 
lista_indicadores <- c("FP.CPI.TOTL.ZG", # inflação (%) 
                       "NY.GDP.PCAP.CD", # Pib per capita (USD) 
                       "NY.GDP.MKTP.KD.ZG", # crescimento do PIB anual (%), 
                       "SL.UEM.TOTL.ZS" # Desemprego (%) 
                       )

# Usaremos inicialmente o ano de 2014 como ano de referência, 
# depois o ano de 2018 para fazer uma comparação da situação do Brasil nestes dois anos.
df2014 <- WDI(indicator = lista_indicadores, 
              country = "all", 
              start = 2014, 
              end = 2014, 
              extra = TRUE) 
str(df2014)
View(df2014)
summary(df2014)

(df2014$region %<>% as.character )

# Remove regiões agregadas
df2014 <- subset(df2014, region != "Aggregates")

# criamos um conjunto de dados (dataframe) denominado dfi2014 
# apenas com as variáveis de interesse para a nossa análise
dfi2014 <- df2014[, lista_indicadores]

#transforma as linhas
row.names(dfi2014) <- df2014$country 
View(dfi2014)

#renomear a coluna
colnames(dfi2014) <- c("Inflacao", "PIB_per_Capita", "Crescimento_PIB", "Desemprego") 
summary(dfi2014)

# remove os valores ausentes
dfi2014 <- na.omit(dfi2014) 

# Cria a taxa de emprego para avaliar o quanto o país é "robusto"
dfi2014$Desemprego <- 100 - dfi2014$Desemprego 
names(dfi2014)[4] <- "Emprego" 
View(dfi2014)

# Para usar o algoritmo K-means para agrupar os países, é necessário:
# Calcular a distância (dissimilaridade) entre os países;
# Escolher o número de grupos (ou clusters) a ser utilizado.

dfi2014["Brazil", ]

#deixando tudo na mesma escala, ou seja, padronizar
# a função scale faz: padroniza um vetor/matriz subtraindo os valores de sua média e dividindo pelo desvio padrão.
dfi2014_escala <- scale(dfi2014) 

# Conferindo o resultado para o Brasil 
dfi2014_escala["Brazil", ] 

# Determinar a Quantidade de Grupos
# Método 1: minimização da soma dos quadrados dos grupos
wss <- (nrow(dfi2014_escala)-1)*sum(apply(dfi2014_escala,2,var)) 
for (i in 2:15) wss[i] <- sum(kmeans(dfi2014_escala, centers=i)$withinss) 



# EXTRA: Número ótimo de clusters
library(factoextra)

fviz_nbclust(dfi2014_escala, kmeans, method = "wss")+
  geom_vline(xintercept = 6, linetype = 2)
# Fim EXTRA

# A soma dos quadrados dos grupos se mantém praticamente estável a partir de aproximadamente 8 segmentos ou grupos
plot(1:15, 
     wss, 
     type="b", 
     xlab="Número de Grupos", 
     ylab="Soma dos quadrados dentro dos grupos")

# Método 2: Pelo segundo método, criaremos um dendrograma para analisar a distribuição hierárquica dos grupos 
# considerando 4 grupos (azul), 5 grupos (vermelho) ou 8 grupos (verde)
dendo <- dfi2014_escala %>% dist %>% hclust 
plot(dendo) 
rect.hclust(dendo, k = 4, border = "blue") 
rect.hclust(dendo, k = 5, border = "red") 
rect.hclust(dendo, k = 8, border = "green")

# Análise dos Resultados
# Uma outra possibilidade de visualização gráfica dos grupos, 
# que facilita a análise e interpretação dos resultados, 
# é apresentar os grupos,  considerando as variáveis que mais os discriminam

grupos <- kmeans(dfi2014_escala, centers=5) 
grupos
clusplot(dfi2014_escala, grupos$cluster, color=TRUE, shade=TRUE, labels=2, lines=0)

print(grupos)

# Refazer a análise com 4 cluster
grupos <- kmeans(dfi2014_escala, centers=4) 
clusplot(dfi2014_escala, grupos$cluster, color=TRUE, shade=TRUE, labels=2, lines=0)

# as instruções a seguir mostram a distância entre o Brasil e alguns outros países (
# Análise: o Brasil tem uma distância euclidiana de 0,5247 em relação ao Chile, 2,2062 em relação aos Estados Unidos e 4,0367 em relação à Noruega
dfi2014_escala[c("Brazil", "Chile", "Colombia", "Norway", "United States"),] %>% dist

mat_brasil <- dfi2014_escala %>% dist(diag = TRUE, upper = TRUE) %>% as.matrix

# 5 países com MENOR dissimilaridade 
mat_brasil[, "Brazil"] %>% sort() %>% head(6)

# 5 países com MAIOR dissimilaridade 
mat_brasil[, "Brazil"] %>% sort() %>% tail(5)


# Vamos criar os segmentos, ou seja, os grupos e seus respectivos países
# fixar uma seed (semente) para garantir a reprodutibilidade da análise: 
set.seed(123)

# criar os clusters ou grupos 
lista_clusteres <- kmeans(dfi2014_escala, centers = 5)$cluster

# função customizada para calcular a média dos indicadores para cada cluster 
cluster.summary <- function(data, groups) { 
  x <- round(aggregate(data, list(groups), mean), 2) 
  x$qtd <- as.numeric(table(groups)) 
  
  # colocar coluna de quantidade na segunda posição 
  x <- x[, c(1, 6, 2, 3, 4, 5)] 
  return(x) }

(tabela <- cluster.summary(dfi2014, lista_clusteres))

# Para melhorar a apresentação visual do resultado acima, 
# usaremos o pacote formattable com uma função para colorir de verde 
# o valor caso seja superior ou igual à média do indicador e vermelho em caso contrário.
colorir.valor <- function(x) ifelse(x >= mean(x), style(color = "green"), style(color = "red"))

nome_colunas <- c("Cluster", 
                  "Quantidade de países do Grupo", 
                  "Taxa de Inflação (%)", 
                  "PIB Per Capita (US$)",
                  "Crescimento anual do PIB (%)", 
                  "Taxa de Emprego (%)")

formattable(
  tabela,
  list(
    pib_per_capita = formatter("span", style = x ~ colorir.valor(x)),
    crescimento_pib = formatter("span", style = x ~ colorir.valor(x)),
    emprego = formatter("span", style = x ~ colorir.valor(x))
  ),  col.names = nome_colunas, format = "markdown", pad = 0
)

# Para finalizar, vamos determinar qual é o cluster do Brasil e quais os outros países estão no mesmo grupo?
dfi2014$cluster <- lista_clusteres
dfi2014["Brazil",]

cl_brasil <- dfi2014["Brazil", ]$cluster
x <- dfi2014[dfi2014$cluster == cl_brasil, ]
x[order(-x$PIB_per_Capita),] %>% knitr::kable()



