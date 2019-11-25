install.packages("Hmisc")
require(Hmisc) #para carregar, tambem pode usar o library

#primeira forma de criar um vetor
idade <- c(10,10,10,10,
            30,30,30,30,30,30,30,30,
            50,50,50,50,
            70,70,70,
            90)

#segunda forma de criar um vetor - rep(elemento, qtde de vezes para repetir)
idade2 <- c(rep(10,4), rep(30,8), rep(50,4), rep(70,3),90)

#frequencia simples (count)
idade_frequencia_simples  <-  table(idade2)

#Data frame (visual excel - formato de tabela ou matriz)
data_frame_frequencia_simples <- data.frame(idade_frequencia_simples)
View(data_frame_frequencia_simples)

#frequencia acumulada (funcao cumsum)
idade_frequencia_acumulada <- cumsum(idade_frequencia_simples)
View(idade_frequencia_acumulada)

#Adicionar uma coluna na tabela $nome_da_coluna=nome_da_variavel
data_frame_frequencia_simples$Freq_Acum=idade_frequencia_acumulada

#Frequencia relativa simples (proporcao)
idade_frequencia_relativa_simples <- idade_frequencia_simples/sum(idade_frequencia_simples)

data_frame_frequencia_simples$Freq_Rel_Sim=idade_frequencia_relativa_simples

#Frequencia relativa acumulada 
idade_frequencia_relativa_acumulada <- idade_frequencia_acumulada/sum(idade_frequencia_simples)

data_frame_frequencia_simples$Freq_Rel_Acum=idade_frequencia_relativa_acumulada

#a funcao describe mostra as estatisticas de uma variavel, tais como, frequencia, proporcao, ordenacao
describe(idade)
