library(tidyverse)


#dataframe
#displ: Tamanho do motor em litros (cilindrada)
#hwy: Eficiencia do combustivel. < eficiencia > consumo de combustivel.
#class: tipo de carro: compacto; médio ou SUV
mpg
(mpg) #visualiza as 10 primeiras linhas do data frame
head(mpg, n = 5) #visualiza a qtde de linhas que deseja
View(mpg) #visualiza o data frame

#ATENCAO: o + no ggplot sempre deve ficar ao final de cada linha, e nunca no inicio.

#Galeria do ggplot: http://www.ggplot2-exts.org/gallery/


ggplot(data = mpg)+
  geom_point(mapping = aes(x = displ, y = hwy))

#help do dataframe
?mpg

#adiciona uma 3ª variavel e coloca cor
#pode tambem utilizar o ingles britanico e colocar colour
#os parametros esteticos (aes) ficam dentro da funcao aes()
#interpretacao: as cores mostram que os outliers são carros 
#com 2 lugares - 2seater, normalmente esse tipo de carro é esportivo, por isso que consome bastante combustivel
#aes: propriedades visuais
ggplot(data = mpg)+
  geom_point(mapping = aes(x = displ, y = hwy, color = class))

#utilizando variavel continua para colour
ggplot(data = mpg)+
  geom_point(mapping = aes(x = displ, y = hwy, colour = year))

#para deixar todos os pontos azul, tem que deixar fora da função aes()
ggplot(data = mpg)+
  geom_point(mapping = aes(x = displ, y = hwy), color = "blue")


#mudar o tamanho do ponto de acordo com a classificacao dele
#o ideal é utizar o size com uma variavel classificatoria 
ggplot(data = mpg)+
  geom_point(mapping = aes(x = displ, y = hwy, size = class))

#size com variavel continua
ggplot(data = mpg)+
  geom_point(mapping = aes(x = displ, y = hwy, size = year))

#determinando o tamanho do ponto
ggplot(data = mpg)+
  geom_point(mapping = aes(x = displ, y = hwy), size = 2)


#alpha no aes: controla a transparencia (degrade)
#o ideal é utilizar o alpha com variveis discretas (numéricas e contável, ex, qtde de pessoas)
ggplot(data = mpg)+
  geom_point(mapping = aes(x = displ, y = hwy, alpha = class))

#com numero de cilindradas (variavel discreta) no alpha
ggplot(data = mpg)+
  geom_point(mapping = aes(x = displ, y = hwy, alpha = cyl))

#colocando o alpha fora da aes() e passando parametro, 
#é possivel determinar o "grau" de preenchimento
ggplot(data = mpg)+
  geom_point(mapping = aes(x = displ, y = hwy), alpha = 0.5)


#muda o tipo de forma, porém, o limite é até 6 formas
#variavel continua não pode ser mapeada no shape
ggplot(data = mpg)+
  geom_point(mapping = aes(x = displ, y = hwy, shape = class))

#com o tipo de tração (drv) no shape
ggplot(data = mpg)+
  geom_point(mapping = aes(x = displ, y = hwy, shape = drv))

#alterando o tipo de shape (forma). Pg 12
ggplot(data = mpg)+
  geom_point(mapping = aes(x = displ, y = hwy), shape = 4)

#Facetas (facet): muito utilizado com variavel categorica
#o facet é uma camada do ggplot e vc sempre como o ~ antes da variável categórica

ggplot(data = mpg)+
  geom_point(mapping = aes(x = displ, y = hwy))+
  facet_wrap(~ drv)

#determinando a qtde de linhas no facet (faceta)
ggplot(data = mpg)+
  geom_point(mapping = aes(x = displ, y = hwy))+
  facet_wrap(~ manufacturer, nrow = 4)


#Pg 15: interpetração: 
#os tipos de cilindrada são: 4, 5, 6 e 8
#para os modelos de tração nas 4 rodas, os cilindro sçao apenas 4, 6 e 8 
#a concentração dos modelos está em 4 cilindradas e tração frontal
ggplot(data = mpg)+
  geom_point(mapping = aes(x = displ, y = hwy))+
  facet_wrap(drv ~ cyl)

#Pg 15: interpetração:
ggplot(data = mpg)+
  geom_point(mapping = aes(x = displ, y = cyl))

#Pg 15: interpetração:
ggplot(data = mpg)+
  geom_point(mapping = aes(x = displ, y = hwy))+
  facet_wrap(drv ~ .)

#Pg 15: interpetração: com o . ou sem o . (ponto) no facet_wrap nao faz diferenca. 
#A diferença do ponto está no facet grid
ggplot(data = mpg)+
  geom_point(mapping = aes(x = displ, y = hwy))+
  facet_wrap(. ~ drv)


# You can facet by multiple variables
#Outro jeito de fazer 
ggplot(mpg, aes(displ, hwy)) +
  geom_point() +
  facet_wrap(vars(cyl, drv))

#Facet: coloca o label de cada variavel
ggplot(mpg, aes(displ, hwy)) +
  geom_point() +
  facet_wrap(c("cyl", "drv"), labeller = "label_both")

#Facet grid (facet_grid) utilizado qdo tem 2 variáveis discretas
ggplot(mpg, aes(x = displ, y = hwy)) + 
  geom_point()+
  facet_grid(. ~ cyl)

ggplot(mpg, aes(x = displ, y = hwy)) + 
  geom_point()+
  facet_grid(cyl ~ .)

#escrevendo o anterior de outro jeito, porem, o resultado é o mesmo
ggplot(mpg, aes(displ, hwy)) + 
  geom_point()+
  facet_grid(cyl ~ .)


ggplot(mpg)+
  geom_point(aes(displ, hwy), size = 1, color = "purple")+
  facet_grid(cyl ~ ., labeller = "label_both")


##########  The different types of graphs

###COMPARISON among times (entre tempos)
## BAR CHART
ggplot(mpg, aes(year, fill = drv))+
geom_bar(na.rm = FALSE,)+
  xlab("Ano de Fabricação")+ #titulo eixo x
  ylab("Qtde de carro")+ #titulo eixo y
  ggtitle("Tipos de tração por ano")+ #titulo do gráfico
  scale_fill_hue(name="Tração")+ #titulo legenda
  theme_minimal()

#total de motor por classe
ggplot(mpg, aes(class)) + 
  geom_bar(aes(fill = drv), position = position_stack(reverse = TRUE))+
  coord_flip() +
  theme(legend.position = "top")


###COMPARISON over time (ao longo do tempo)
## LINE CHART
#aplha: densidade (transparencia da linha)
ggplot(mpg, aes(year, cyl))+
  geom_line(color="#69b3a2", size=1, alpha=0.9, linetype=4)+
  ggtitle("Evolução das cilindradas")

#===============
# LOAD PACKAGES
#===============
library(readr)
library(tidyverse)
library(stringr)

#============================
# READ DATA FROM INTERNET
#============================
(stock_amzn <- read_csv("http://sharpsightlabs.com/wp-content/uploads/2017/09/AMZN_stock.csv"))

#========
# INSPECT
#========
stock_amzn %>% names() #nome das colunas
stock_amzn %>% head() #6 primeiras linhas
stock_amzn %>% tail() #6 ultimas linhas

#================================
# CHANGE COLUMN NAMES: lower case
#================================
colnames(stock_amzn) <- str_to_lower(colnames(stock_amzn)) 
#ou
colnames(stock_amzn) <- colnames(stock_amzn) %>% str_to_lower()

#======
# PLOT 
#======
ggplot(stock_amzn, aes(date, close)) +
  geom_line(colour = 'cyan')+ #cor da linha
  geom_area(fill = 'cyan', alpha = .1)+ #preenchimento dentro do grafico e densidade do preenchimento 
  labs(x = 'Ano'
       , y = 'Closing\nPrice'
       , title = "Amazon's stock price has increased dramatically\nnover the last 20 years (Preço das ações da Amazon)")+
  theme(text = element_text(family = 'Gill Sans', color = "#444444")
        ,panel.background = element_rect(fill = '#444B5A')
        ,panel.grid.minor = element_line(color = '#4d5566')
        ,panel.grid.major = element_line(color = '#586174')
        ,plot.title = element_text(size = 22)
        ,axis.title = element_text(size = 18, color = '#555555')
        ,axis.title.y = element_text(vjust = 1, angle = 0)
        ,axis.title.x = element_text(hjust = 0)
  ) 

stock_amzn <- stock_amzn %>%  mutate(low2 = low * -1)

###DISTRIBUTION
## SCATTER PLOT (single variable)

(mtcars)

#quanto mais "pesado"o carro, mais ele consome combustivel, ou seja, 
#a medida que o peso do carro aumenta, as milhas por galão fica menor. 
#Sendo assim, o carro pesado roda menos
ggplot(mtcars,aes(wt, mpg)) +
  geom_point(colour = "#808000")


#utilizando variavel categorica para colocar a cor
#Se não transformar a variável am em fator, ela cria uma escala continua de 0, 0.25, 0.5, 0.75 e 1
#Isso ocorre porque a variável am é uma variável numérica. 
#Por isso a necessidade de criar um fator, assim, o fator transforma em variável discreta.
mtcars$am <- factor(mtcars$am)

ggplot(mtcars) +
  geom_point(aes(wt, mpg, colour = am))

#mudando o tipo de shape como legenda
ggplot(mtcars) +
  geom_point(aes(wt, mpg, shape = am))

#mudando o tipo de tamanho da legenda
#o size deve ser usado com variavel discreta
#este grafico tambem é conhecido com bubble chart
ggplot(mtcars) +
  geom_point(aes(wt, mpg, size = cyl))

#mudando a transparencia
ggplot(mtcars) +
  geom_point(aes(wt, mpg, alpha = cyl))

#juntando size e alpha (transparência)
ggplot(mtcars) +
  geom_point(aes(x = wt, y = mpg, size = cyl), alpha = 0.3, colour = 'green')

