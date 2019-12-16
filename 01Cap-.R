library(tidyverse)


#dataframe
#displ: Tamanho do motor em litros (cilindrada)
#hwy: Eficiencia do combustivel. < eficiencia > consumo de combustivel.
#class: tipo de carro: compacto; médio ou SUV
mpg

#ATENCAO: o + no ggplot sempre deve ficar ao final de cada linha, e nunca no inicio.

#Galeria do ggplot: http://www.ggplot2-exts.org/gallery/


ggplot(data = mpg)+
  geom_point(mapping = aes(x = displ, y = hwy))

#help do dataframe
?mpg

#adiciona uma 3ª variavel e coloca cor
#pode tambem utilizar o ingles britanico e colocar colour
#os parametros esteticos (aes) ficam dentro da funcao aes()
#interpretacao: as cores mostram que os outliers são carros com 2 lugares - 2seater, normalmente esse tipo de carro é esportivo, por isso que consome bastante combustivel
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

#colocando o alpha fora da aes() e passando parametro, é possivel determinar o "grau" de preenchimento
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
  facet_wrap(~ manufacturer, nrow = 2)

#Pg 15: interpetração: 
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

#Pg 15: interpetração:
ggplot(data = mpg)+
  geom_point(mapping = aes(x = displ, y = hwy))+
  facet_wrap(. ~ drv)


# You can facet by multiple variables
#Outro jeito de fazer 
ggplot(mpg, aes(displ, hwy)) +
  geom_point() +
  facet_wrap(vars(cyl, drv))

#Facet: coloa o label de cada variavel
ggplot(mpg, aes(displ, hwy)) +
  geom_point() +
  facet_wrap(c("cyl", "drv"), labeller = "label_both")

#Facet grid (facet_grid) utilizado qdo tem 2 variáveis discretas
ggplot(mpg, aes(x = displ, y = cty)) + 
  geom_point()+
  facet_grid(. ~ cyl)

ggplot(mpg, aes(x = displ, y = cty)) + 
  geom_point()+
  facet_grid(cyl ~ .)



