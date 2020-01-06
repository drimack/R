library(tidyverse)
library(ggplot2)


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

## Pg 12 - Exercicio 01
## 1) O que há de errado com este código? Porque os pontos não estão pretos (correto é azul)?
## Resposta: porque a cor está inluida no argumento de mapeamento e deveria estar no estetico
ggplot(mpg)+
  geom_point(aes(displ, hwy), colour = "blue")

## Pg 12 - Exercicio 03
## 3) Mapeie uma variável continua para color, size e shape.
## Como essas estéticas se comportam de maneira diferente para variáveis categóricas e contínuas?

## com variavel continua na cor
glimpse(mpg)

ggplot(mpg, aes(x = displ, y = hwy, colour = cty)) +
  geom_point()

## com variavel continua no size

ggplot(mpg, aes(x = displ, y = hwy, size = cty)) +
  geom_point()


## com variavel continua no shape dá erro, isso porque uma variável numérica possui ordem, 
## mas, os shapes não possuem ordem, por exemplo, um quadrado não é menor ou maior que um circulo.

ggplot(mpg, aes(x = displ, y = hwy, shape = cty)) +
  geom_point()

## Pg 12 - Exercicio 04
## 4) O que acontece se você mapear a mesma variável a várias estéticas?
## Resposta: O código executa, mas fica redundante mapear a mesma variável para estéticas diferentes
ggplot(mpg)+
  geom_point(aes(displ, hwy, colour = cty, size = cty))


## Pg 12 - Exercicio 05
## 5) O que a estética stroke faz? Com que formas ela trabalha? (Dica: use ?geom_point)
## Resposta: Stroke serve para mudar a largura da borda

ggplot(mpg)+
  geom_point(aes(cty, cyl), 
             shape = 21, 
             colour = "green", 
             fill = "red", 
             size = 2, 
             stroke = 5
             )

## Pg 13 - Exercicio 06
## 6) O que acontece se você mapear uma estética a algo diferente de um nome de variável, como aes(coloar = displ < 5)
## Resposta: O ggplot cria como se fosse uma categorica de displ Sim para < que 5 e Nao para > que 5

ggplot(mpg, aes(displ, hwy, colour = displ < 5))+
  geom_point()



#Facetas (facet): muito utilizado com variavel categorica
#o facet é uma camada do ggplot e vc sempre como o ~ antes da variável categórica

ggplot(data = mpg)+
  geom_point(mapping = aes(x = displ, y = hwy))+
  facet_wrap(~ drv)

#determinando a qtde de linhas no facet (faceta)
ggplot(data = mpg)+
  geom_point(mapping = aes(x = displ, y = hwy))+
  facet_wrap(~ manufacturer, nrow = 4)


## Pg 15 - Exercicio 01
## 1) O que acontece se você criar facetas em uma variável contínua?
## Resposta: A variável continua é transformada em variável categórica
ggplot(mpg, aes(displ, cyl))+
  geom_point()+
  facet_wrap(~year)

## Pg 15 - Exercicio 02
## 2) O que significam  células em um gráfico com facet_grid(drv~cyl)
## Como elas se relacional a este gráfico.
## Resposta: facet grid coloca o drv a direita e o cyl acima de tudo
ggplot(mpg)+
  geom_point(aes(hwy, cty))+
  facet_grid(drv~cyl)

## Pg 15 - Exercicio 03
## 3) Que gráficos o código a seguir faz? O que . faz?
## Resposta: Cria grids vertical (eixo y)
ggplot(data = mpg)+
  geom_point(mapping = aes(x = displ, y = hwy))+
  facet_grid(drv ~ .)

ggplot(data = mpg)+
  geom_point(mapping = aes(x = displ, y = hwy))+
  facet_wrap(drv ~ .)

## Resposta: Cria grids horizontal (eixo x)
ggplot(data = mpg)+
  geom_point(mapping = aes(x = displ, y = hwy))+
  facet_grid(.~ drv )

ggplot(data = mpg)+
  geom_point(mapping = aes(x = displ, y = hwy))+
  facet_grid(.~ cyl )

ggplot(data = mpg)+
  geom_point(mapping = aes(x = displ, y = hwy))+
  facet_wrap(.~ cyl )

## Pg 15 - Exercicio 04
## 4) Pegue o primeiro gráfico em facetas dessa seção.
## Quais são as vantagem de usar facetas, em vez de estética de cor?
## Quais são as desvantagens?
## Como o equilibrio poderia mudar se você tivesse um conjunto de dados maior?
## Resposta: Vantagem: analisar multiplas categorias, ficando organizado nas facetas as categorias. Melhor análise por categoria
## Resposta: Desvantagem: Não conseguir visualizar o inter-relacionamento entre as categorias, como é no mesmo gráfico

ggplot(mpg)+
  geom_point(aes(displ, hwy))+
  facet_wrap(~class, nrow = 2 )


## Pg 16 - Exercicio 05
## 5) Leia ?facet_wrap. O que nrow faz?o que ncol faz? 
## Quais outras opções controlam o layout de painéis individuais? Porque facet_grid() não tem nrow e ncol?
## Resposta: nrow e ncol determina o numero de linhas e colunas. Porém, para ser usada, tem que ter pelo menos uma variável categórica
## Resposta: no grid não tem nrow e nem ncol, pois, a própria função escolha quantas linhas e colunas terão.

ggplot(mpg)+
  geom_point(aes(displ, hwy))+
  facet_wrap(~fl, nrow = 2 )

ggplot(mpg)+
  geom_point(aes(displ, hwy))+
  facet_grid(~fl)

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

## Pg 20 - Exercicio 01
## 1) Que geom você usario para desenhar um grafico de linha?
## Um diagrama de caixa (boxplot)?
## Um histograma
## Um gráfico de área
## Resposta
geom_line()
geom_boxplot()
geom_histogram()
geom_area()

## Pg 20 - Exercicio 02
## 2) Execute este código em sua cabeça e preveja como será o resultado
## Depois execute o código em R e confira suas previsões
## Resposta: faz uma linha para cada drv (tração)
ggplot(mpg, aes(displ, hwy, color = drv)) +
  geom_point() +
  geom_smooth(se = FALSE ) #sem o intervalo de confiança


#sem o intervalo de confiança e com filter - pg 20
ggplot(mpg, aes(displ, hwy))+
  geom_point(aes(colour=class))+
  geom_smooth(data = filter(mpg, class == "subcompact"),#filtrando a linha
              se = FALSE #sem o intervalo de confiança
  )


## Pg 20 - Exercicio 03
## 3) O que show.legend = FALSE faz? O que acontece se você removê-lo?
## Porque você acha que usei isso anteriormente no capítulo?
## Resposta: sem legenda
ggplot(mpg, aes(displ, hwy, colour = drv))+
  geom_smooth( show.legend = FALSE)

ggplot(data = mpg) +
  geom_smooth(mapping = aes(x = displ, y = hwy, colour = drv))

## Pg 20 - Exercicio 04
## 4) O que o argumento se para geom_smooth? faz?
## Resposta: adiciona faixa de erros em tempo de execução



## Pg 21 - Exercicio 06
## 6a) 
ggplot(mpg, aes(displ, hwy))+
  geom_point()+
  geom_smooth(se = FALSE )

## Pg 21 - Exercicio 06
## 6b) 
ggplot(mpg, aes(displ, hwy))+
  geom_point()+
  geom_smooth(aes(colour = drv), show.legend = FALSE, se = FALSE)


## Pg 21 - Exercicio 06
## 6c) 
ggplot(mpg, aes(displ, hwy, colour = drv))+
  geom_point()+
  geom_smooth( se = FALSE)


## Pg 21 - Exercicio 06
## 6d) 
ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(colour = drv)) +
  geom_smooth(se = FALSE)

## Pg 21 - Exercicio 06
## 6e) 
ggplot(mpg, aes(displ,hwy)) +
  geom_point(aes(colour = drv)) +
  geom_smooth(aes(linetype = drv), se = FALSE)

## Pg 21 - Exercicio 06
## 6f)
ggplot(mpg, aes(displ, hwy)) +
  geom_point(size = 4, color = "white") +
  geom_point(aes(colour = drv))

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


### PROPORTION (proporcao, representatividade)
## GEOM BAR

#======+ 
# pg 22
#======+

#=====================================================
# INTERPRETACAO: existem mais diamantes com corte bom
#====================================================

## Lembrando; no geom_bar, quando for utilizar o stat padrao
## que é o count, então NAO precisa colocar o eixo Y

## por padrão, se eu nao colocar o y, o ggplot entende assim
ggplot(diamonds) + 
  geom_bar(aes(x=  cut, y =  ..count..), stat = "count")


## mas posso escrever assim
## pg 22

(diamonds)
ggplot(diamonds)+
  geom_bar(aes(x = cut))

## geom_bar com mudança de stats (estatistica). 
## ao invés de usar o stats default que é o count
## ele usará o peso de cada barra que está presente no dado. 
## Lembrando: No geom_bar, quando NAO for utilizar o stat padrao, que é o count
## então precisa colocar o eixo y, pois o eixo Y será o peso.

## pg 23

demo <- tribble(
  ~a, ~b,
  "bar_1", 20,
  "bar_2", 30,
  "bar_3", 40
)

ggplot(demo)+
  geom_bar(aes(x=a, y =b), stat = "identity")

## pg 24
## utilizando a proporçao em vez de count
## se for utilizar a proporcao, tem que setar a variável y
## geom_bar com prop e com count

 ggplot( diamonds) +
  geom_bar( aes(x = cut, y = ..prop.., group = 1))
 
 
 ## ou pode escrever assim, com stat(prop)
 ggplot( diamonds) +
   geom_bar( aes(x = cut, stat(prop), group = 1))
 

 ## mostrando a tabela acima
 plt <- ggplot(data = diamonds) +
   geom_bar(mapping = aes(x = cut, y = ..prop.., group = 1))
 plt_b <- ggplot_build(plt)
 plt_b$data[[1]]
 
 
 ## geom_bar com prop porém com percentual na escala
 ggplot(data = diamonds) + 
   geom_bar(mapping = aes(x = cut, y = ..prop.., group = 1), stat = "count") + 
   scale_y_continuous(labels = scales::percent_format())
 
 
 ggplot(diamonds, aes(x=cut, group=interaction(clarity, color), fill=color)) + 
   geom_bar(aes(y=..prop..), stat="count", position=position_dodge()) +
   scale_y_continuous(limits=c(0,1),labels = scales::percent) +
   ylab("Percent of Sample") +
   ggtitle("Show precentages in bar chart")
 
 
 ## geom_bar com proporcao dentro de cada barra
 ## acrescentando paleta de cores - Set
 ggplot(diamonds, aes(x = color)) + 
   geom_bar(aes( y = ..count../sum(..count..), fill = cut)) + 
   scale_fill_brewer(palette = "Set3") + 
   ylab("Percent") + 
   ggtitle("Show precentages in bar chart")
 
 
 ## Transformações estatísticas
 ## Pg 26 - Exercicio 01
 ## 1) Qual é o geom padrão associado a stat_summary()? 
 ## Como você poderia reescrever o gráfico anterior usando essa função geom, em vez da função stat?
 ## Resposta: 
 ggplot(diamonds)+
   stat_summary(aes(cut, depth),
                fun.ymin = min,
                fun.ymax = max,
                fun.y = median)
 
 ## Transformações estatísticas
 ## Pg 26 - Exercicio 03
 ## 3) A maioria dos geoms e stats vem em pares, que são quase sempre usados juntos.
 ## Leia a documentação e faça uma lista de todos os pares.
 ## O que eles têm em comum?
 ## Resposta: Todos são iguais, exceto os abaixo e além disso,
 ## os geoms são camadas de graficos, e os stats são camadas de estatísticas
 geom_bar(); stat_count()
 geom_count(); stat_sum()
 geom_freqpoly(); stat_bin()
 geom_histogram(); stat_bin()
 
 ## Pg 26 - Exercicio 04
 ## 4) Quais variáveis stat_smooth() calcula? Quais parâmetros controlam seu comportamento?
 ## Resposta: abaixo
   #y: valor previsto
   #ymin: menor valor no intervalo de confiança
   #ymax: maior valor no intervalo de confiança
   #se: erro padrão
 
 ## Pg 26 - Exercicio 05
 ## 5) Quais variáveis stat_smooth() calcula? 
 ## Quais parâmetros controlam seu comportamento?
 ## Resposta: o parâmetro group = 1 é para dar peso e a soma do peso é igual a 1 (100%)
 ## sem o group = 1, todas as barras serão do mesmo tamanho e terão o mesmo peso.
 
 ggplot(diamonds) +
   geom_bar(aes(cut, ..count.. / sum(..count..), fill = color))

 
 ## PIE CHART
 ggplot(diamonds, aes(x="", y = ..count.., fill=cut))+
   geom_bar(width = 1)+
   coord_polar(theta = "y", start=0) #coord_polar: transforma em pie chart
 
 
 
## GEOM COLUMN
Titanic
Titanic <- as.data.frame(Titanic)
View(Titanic)


ggplot(Titanic) + 
  geom_col(aes(x = Class, y = Freq, fill = Survived), position = "dodge") + #dodge: evita objetos sobrepostos lado a lado
  coord_flip() +
  theme(legend.position = "top")

 
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

#=========================================
# adicionando SMOOOTH: plotam previsões
#com 2 geoms
#=========================================
ggplot(mpg)+
  geom_point(aes(displ, hwy))+
  geom_smooth(aes(displ, hwy))

#com 2 geom's, porém , com variavel global
ggplot(mpg, aes(displ, hwy))+
  geom_point()+
  geom_smooth()


#com 2 geom's, porém, com cor na classe
mpg$class <- factor(mpg$class)
mpg$drv <- factor(mpg$drv)

ggplot(mpg, aes(displ, hwy))+
  geom_point(aes(colour=class))+
  geom_smooth()



### BOX PLOT
## DIAGRAMA DE CAIXA; Calculam o resumo da distribuição


