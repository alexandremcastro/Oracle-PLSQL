## Requisitos:

Todos os scripts para as criações das tabelas e execução dos comandos estão disponíveis no repositório.

## Questões:

#### Questão 01
No Esquema Locadora, mostre o ranking "top three", ou seja, os 3 profissionais de cinema que mais atuaram. Se houver empates, mostre ambos.

#### Questão 02
Elabore uma tabela contendo nomes de seus ascendentes (até tataravôs - se não souber, invente!).

#### Questão 03
Mostre sua ascendência materna: nomes de sua mãe, avó materna, mãe de sua avó materna e bisavó materna de sua mãe.

#### Questão 04
Mostre os nomes de seus tataravôs e seus filhos. Use uma consulta hierárquica.

#### Questão 05
Acrescente um novo campo na tabela PROFISSIONAL_CINEMA denominado ATUANTE (tipo varchar2, tamanho 30).

#### Questão 06
Faça uma procedure de atribua a classificação ALTA a profissionais de cinema que participaram em filmes alugados mais que 50 vezes e MÉDIA para aqueles alugados entre 30 e 49 vezes. Ao final, mostre quantos registros foram afetados.

#### Questão 07
Aumente em 10% os preços de locação dos filmes, cujo número de locações forem maiores que a média de locações geral, e abata 5% dos preços que forem menores que essa média.

#### Questão 08
Faça uma procedure que exclua um determinado profissional de cinema, mas impeça a operação, caso tenha participado de algum filme (o código gerado por violações de integridade referencial é –2292).

#### Questão 09
Faça uma procedure que insira um novo registro na tabela de papes, mas impeça a operação caso a descrição do papel sendo inserido já exista.

#### Questão 10
Substitua os constraints na tabela PARTICIPACAO por um Trigger de inserção prévia, verificando cada linha. 

#### Questão 11
Crie um Trigger que limite a 20 o número de tabelas presentes no esquema LOCADORA. Elabore uma carga de trabalho que tente violar esta regra.

#### Questão 12
Elabore um package contendo as seguintes rotinas: InsereNovoPapel, EliminaPapel (caso não tenha nenhuma participação), ExibeMelhorPapel (nome do papel que mais se repete).

#### Questão 13
Acrescente tratamento de erros ao Package desenvolvido no exercício anterior.
