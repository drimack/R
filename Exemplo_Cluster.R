############# ANÁLISE HIERARQUICA DE CLUSTER #######
#### Single Linkage: para juntar grupos sempre usa a ligação mais próxima entre grupos, ou seja, distância minima entre os grupos #####


library(car) # tem gráficos "bonitinhos", um deles é o scatterplot.
library(RcmdrMisc) # R comander é uma interface gráfica do R
library(factoextra) # feita para analisar PCA e analise de Cluster

exemplo1 <- read.csv2("exemplo1.csv", stringsAsFactors=FALSE)

# grafico de dispersão
scatterplot(V2~V1, 
            regLine=FALSE, 
            smooth=FALSE, 
            id=list(method='mahal', n=7,labels=exemplo1$Respondente), 
            boxplots=FALSE, 
            xlab="Lealdade à Loja", 
            ylab="Lealdade à Marca", 
            main="Análise de Clusters", 
            cex=2.5, 
            data=exemplo1)

# Matriz de Distancias (Euclidiana)
dist(exemplo1[2:3], method="euclidean")

# Solução cluster hierárquico com método single Linkage (sempre agrupa pelo mais próximo)
hc1 <- hclust(dist(exemplo1[2:3]) , # pegando a 2ª e 3º coluna
              method= "single")
plot(hc1, 
     main= "Dendrograma para a solução hc1", 
     xlab= "Número da observação em Exemplo1", 
     sub="Method=single; Distance=euclidian")

# o comando merge mostra como foi feita a junção no dendograma
# qdo esta com sinal de "menos" é a junção da observação. 
# Quando está positivo, é que junta na linha que já estava construinda
hc1$merge

# Para plotar o dendograma mais bonito
dendro1 <- as.dendrogram(hc1)

plot(dendro1, 
     main= "Cluster Dendrogram for Solution hc1",
     xlab= "Observation Number in Data Set exemplo1", 
     sub="Method=single; Distance=euclidian")

rect.hclust(hc1, k=3)

# Sumário da análise
# Para escolher quantas hierarquias (niveis)
as.factor(cutree(hc1, k=3))

# conta quantos casos tem cada grupo de cluster
summary(as.factor(cutree(hc1, k = 3))) # Cluster Sizes

# o comando by é semelhante ao tapply
# colMeans calcula a média dos centróides
by(exemplo1[,2:3], as.factor(cutree(hc1, k = 3)), colMeans)

# Análise de Componentes Principais (PCA - Principal Component Analysis)
# Sumarizar os dados que contém muitas variáveis (p) por um conjunto menor de
# (k) variáveis compostas derivadas a partir do conjunto original.

# análise de componentes principais é uma análise fatorial (agrupamento de variaveis para reduzir a dimensionalidade dos dados)
# Este grafico sempre pega os 2 componentes principais (variaveis) que mais explicam a variabilidade dos dados
biplot(princomp(exemplo1[,2:3]), 
       xlabs = as.character(cutree(hc1, k = 3)))

# Matriz de covariância dos dados 
cov(exemplo1[,2:3])

# Matriz de correlação dos dados
cor(exemplo1[,2:3])

# o quanto da variancia dos dados cada componente absorveu
screeplot(princomp(exemplo1[,2:3]), cor = T)

# Analises Posteriores
# Salva no BD qual cluster a variável pertence
exemplo1$cluster1 <- as.factor(cutree(hc1, k = 3))
exemplo1

# Análises Posteriores – Médias por Cluster
# cria um sumário do BD
numSummary(exemplo1[,c("V1", "V2", "Idade"), 
                    drop=FALSE], 
           groups=exemplo1$cluster1,
           statistics=c("mean", "sd", "IQR", "quantiles"), 
           quantiles=c(0,.25,.5,.75,1))

# no resultado, a mediana do grupo 02 é menor do que o grupo 3 em relação a idade
boxplot(Idade ~ cluster1, data=exemplo1)

#Teste de Significancia - ANOVA
# Quando usar a ANOVA (Analise Of Variance): quando o Y for numérico e o X categórico com mais de dois niveis
summary(aov(Idade ~cluster1, data=exemplo1))
TukeyHSD(aov(Idade ~cluster1, data=exemplo1))

# Plotando os centróides
# gera um dataframe para cada cluster mostra o endereço do centroide.
centroides1<- aggregate(cbind(V1, V2) ~ cluster1, 
                        data=exemplo1, 
                        FUN=mean)

dev.off() # esse comando foi necessário pois tentei rodar o scatterplot e estava dando erro. Ele reseta os gráficos
scatterplot(V2~V1 | cluster1, 
            regLine=FALSE, 
            smooth=FALSE, 
            id=list(method='mahal',n=7), 
            boxplots=FALSE, 
            xlab="Lealdade à Loja", 
            ylab="Lealdade à Marca", 
            main="Análise de Clusters", 
            cex=2.5, 
            by.groups=TRUE, 
            data=exemplo1, 
            col=c('black', 'red', 'blue')
            )
points(centroides1$V1, centroides1$V2, pch=20) # coloca no grafico onde estão os centróides

# Critério da Soma de Distancias ao Quadrado (wss)
# Faz uma análise do cluster
#  k.max=6: número máximo de clusters
fviz_nbclust(exemplo1[2:3], hcut, method = "wss", k.max=6)


#### Complete Linkage: Considera a distancia máxima entre os grupos para juntar #####
# Executando o mesmo exemplo com o método Complete

hc2 <- hclust(dist(exemplo1[,2:3]) , method= "complete")
hc2
plot(hc2, 
     main= "Dendrograma para a solução hc2", 
     xlab= "Número da observação em Exemplo1", 
     sub="Method=complete; Distance=euclidian")





